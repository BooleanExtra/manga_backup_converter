import 'dart:isolate';
import 'dart:typed_data';

import 'package:wasm_plugin_loader/src/aidoku/aidoku_host.dart';
import 'package:wasm_plugin_loader/src/aidoku/host_store.dart';
import 'package:wasm_plugin_loader/src/native/wasm_semaphore_io.dart';
import 'package:wasm_plugin_loader/src/native/wasm_shared_state_io.dart';
import 'package:wasm_plugin_loader/src/wasm/wasm_runner.dart';

// ---------------------------------------------------------------------------
// Init data (sent to the isolate at spawn time)
// ---------------------------------------------------------------------------

/// Initialization data for the background WASM isolate.
/// All fields are primitive-only — safe to send across isolate boundaries.
class WasmIsolateInit {
  const WasmIsolateInit({
    required this.handshakePort,
    required this.asyncPort,
    required this.wasmBytes,
    required this.semaphoreAddress,
    required this.resultSlotAddress,
    required this.statusSlotAddress,
    required this.bufferPtrSlotAddress,
    required this.bufferLenSlotAddress,
  });

  /// The isolate sends its own command [SendPort] back on this port.
  final SendPort handshakePort;

  /// Main isolate's port for receiving async HTTP / sleep requests.
  final SendPort asyncPort;

  final Uint8List wasmBytes;

  // Native memory addresses for semaphore and shared response slots.
  final int semaphoreAddress;
  final int resultSlotAddress;
  final int statusSlotAddress;
  final int bufferPtrSlotAddress;
  final int bufferLenSlotAddress;
}

// ---------------------------------------------------------------------------
// Commands from main isolate --> WASM isolate
// ---------------------------------------------------------------------------

class WasmSearchCmd {
  const WasmSearchCmd({
    required this.queryBytes,
    required this.page,
    required this.filtersBytes,
    required this.replyPort,
  });
  final Uint8List queryBytes;
  final int page;
  final Uint8List filtersBytes;
  final SendPort replyPort; // replies with Uint8List? (postcard) or null
}

class WasmMangaDetailsCmd {
  const WasmMangaDetailsCmd({
    required this.keyBytes,
    required this.replyPort,
  });
  final Uint8List keyBytes;
  final SendPort replyPort;
}

class WasmPageListCmd {
  const WasmPageListCmd({
    required this.keyBytes,
    required this.replyPort,
  });
  final Uint8List keyBytes;
  final SendPort replyPort;
}

class WasmMangaListCmd {
  const WasmMangaListCmd({required this.page, required this.replyPort});
  final int page;
  final SendPort replyPort;
}

class WasmRawGetCmd {
  const WasmRawGetCmd({required this.funcName, required this.replyPort});
  final String funcName; // e.g. 'get_filters'
  final SendPort replyPort;
}

class WasmShutdownCmd {
  const WasmShutdownCmd();
}

// ---------------------------------------------------------------------------
// Async messages from WASM isolate --> main isolate
// ---------------------------------------------------------------------------

class WasmHttpMsg {
  const WasmHttpMsg({
    required this.url,
    required this.method,
    required this.headers,
    required this.timeout,
    required this.semaphoreAddress,
    required this.resultSlotAddress,
    required this.statusSlotAddress,
    required this.bufferPtrSlotAddress,
    required this.bufferLenSlotAddress,
    this.body,
  });

  final String url;
  final int method;
  final Map<String, String> headers;
  final List<int>? body;
  final double timeout;
  final int semaphoreAddress;
  final int resultSlotAddress;
  final int statusSlotAddress;
  final int bufferPtrSlotAddress;
  final int bufferLenSlotAddress;
}

class WasmSleepMsg {
  const WasmSleepMsg({
    required this.seconds,
    required this.semaphoreAddress,
  });
  final int seconds;
  final int semaphoreAddress;
}

/// An error or warning logged by the WASM isolate, sent to the main isolate
/// for printing. Using the existing [asyncPort] avoids an extra port.
class WasmLogMsg {
  const WasmLogMsg({required this.message, required this.stackTrace});
  final String message;
  final String stackTrace;
}

// ---------------------------------------------------------------------------
// Isolate entry point
// ---------------------------------------------------------------------------

/// Long-running background isolate that executes WASM.
///
/// The isolate owns the [WasmRunner] + [HostStore]. It processes commands
/// sent from the main isolate. When a WASM host import needs async work
/// (HTTP, sleep), it sends a [WasmHttpMsg] / [WasmSleepMsg] to the main
/// isolate's async port and then blocks the current thread via the
/// POSIX/Win32 semaphore. The main isolate handles the async work, writes
/// results to shared native memory, and signals the semaphore to wake this
/// isolate's thread.
Future<void> wasmIsolateMain(WasmIsolateInit init) async {
  final cmdPort = ReceivePort();
  // Let the main isolate know where to send commands.
  init.handshakePort.send(cmdPort.sendPort);

  final store = HostStore();

  // Build the synchronous async-dispatch closures.
  // These are called from within NativeCallable callbacks (synchronous from
  // WASM's perspective) and block this thread via the OS semaphore while the
  // main isolate handles the actual async work.

  ({int statusCode, Uint8List? body}) asyncHttp(
    String url,
    int method,
    Map<String, String> headers,
    Uint8List? body,
    double timeout,
  ) {
    // 1. Send the request to the main isolate (non-blocking).
    init.asyncPort.send(
      WasmHttpMsg(
        url: url,
        method: method,
        headers: headers,
        timeout: timeout,
        semaphoreAddress: init.semaphoreAddress,
        resultSlotAddress: init.resultSlotAddress,
        statusSlotAddress: init.statusSlotAddress,
        bufferPtrSlotAddress: init.bufferPtrSlotAddress,
        bufferLenSlotAddress: init.bufferLenSlotAddress,
        body: body != null ? List.from(body) : null,
      ),
    );
    // 2. Block this thread until the main isolate signals.
    WasmSemaphore.fromAddress(init.semaphoreAddress).wait();
    // 3. Read result from shared native memory.
    final result = WasmSharedState.readResult(init.resultSlotAddress);
    if (result != 0) {
      return (statusCode: -1, body: null);
    }
    final statusCode = WasmSharedState.readStatus(init.statusSlotAddress);
    final respBody = WasmSharedState.readResponse(init.bufferPtrSlotAddress, init.bufferLenSlotAddress);
    return (statusCode: statusCode, body: respBody);
  }

  void asyncSleep(int seconds) {
    init.asyncPort.send(
      WasmSleepMsg(
        seconds: seconds,
        semaphoreAddress: init.semaphoreAddress,
      ),
    );
    WasmSemaphore.fromAddress(init.semaphoreAddress).wait();
  }

  // Lazy runner proxy (breaks circular dep between imports and runner).
  final lazyRunner = _LazyRunner();
  final imports = buildAidokuHostImports(
    lazyRunner,
    store,
    asyncHttp: asyncHttp,
    asyncSleep: asyncSleep,
  );

  late final WasmRunner runner;
  try {
    runner = await WasmRunner.fromBytes(init.wasmBytes, imports: imports);
  } catch (e) {
    init.handshakePort.send('error:$e');
    cmdPort.close();
    return;
  }
  lazyRunner.delegate = runner;

  // Initialize the source.
  try {
    runner.call('start', []);
  } catch (_) {
    // Some sources may not export start.
  }

  // Process commands until shutdown.
  await for (final cmd in cmdPort) {
    if (cmd is WasmShutdownCmd) break;
    _processCmd(cmd as Object, runner, store, init.asyncPort);
  }

  store.dispose();
  cmdPort.close();
}

// ---------------------------------------------------------------------------
// Command dispatch
// ---------------------------------------------------------------------------

void _processCmd(
  Object cmd,
  WasmRunner runner,
  HostStore store,
  SendPort logPort,
) {
  if (cmd is WasmSearchCmd) {
    Uint8List? result;
    final queryRid = store.addBytes(cmd.queryBytes);
    final filtersRid = store.addBytes(cmd.filtersBytes);
    try {
      final ptr = (runner.call('get_search_manga_list', [queryRid, cmd.page, filtersRid]) as num).toInt();
      if (ptr > 0) result = _readResult(runner, ptr);
    } catch (e, st) {
      result = null;
      logPort.send(WasmLogMsg(message: 'get_search_manga_list: $e', stackTrace: st.toString()));
    } finally {
      store.remove(queryRid);
      store.remove(filtersRid);
    }
    cmd.replyPort.send(result);
    return;
  }

  if (cmd is WasmMangaDetailsCmd) {
    Uint8List? result;
    final keyRid = store.addBytes(cmd.keyBytes);
    try {
      final ptr = (runner.call('get_manga_update', [keyRid]) as num).toInt();
      if (ptr > 0) result = _readResult(runner, ptr);
    } catch (e, st) {
      result = null;
      logPort.send(WasmLogMsg(message: 'get_manga_update: $e', stackTrace: st.toString()));
    } finally {
      store.remove(keyRid);
    }
    cmd.replyPort.send(result);
    return;
  }

  if (cmd is WasmPageListCmd) {
    Uint8List? result;
    final keyRid = store.addBytes(cmd.keyBytes);
    try {
      final ptr = (runner.call('get_page_list', [keyRid]) as num).toInt();
      if (ptr > 0) result = _readResult(runner, ptr);
    } catch (e, st) {
      result = null;
      logPort.send(WasmLogMsg(message: 'get_page_list: $e', stackTrace: st.toString()));
    } finally {
      store.remove(keyRid);
    }
    cmd.replyPort.send(result);
    return;
  }

  if (cmd is WasmMangaListCmd) {
    Uint8List? result;
    try {
      final ptr = (runner.call('get_manga_list', [cmd.page]) as num).toInt();
      if (ptr > 0) result = _readResult(runner, ptr);
    } catch (e, st) {
      result = null;
      logPort.send(WasmLogMsg(message: 'get_manga_list: $e', stackTrace: st.toString()));
    }
    cmd.replyPort.send(result);
    return;
  }

  if (cmd is WasmRawGetCmd) {
    Uint8List? result;
    try {
      final ptr = (runner.call(cmd.funcName, []) as num).toInt();
      if (ptr > 0) result = _readResult(runner, ptr);
    } catch (e, st) {
      result = null;
      logPort.send(WasmLogMsg(message: '${cmd.funcName}: $e', stackTrace: st.toString()));
    }
    cmd.replyPort.send(result);
    return;
  }
}

/// Read a length-prefixed result buffer and free it.
/// Layout: [u32 length LE][u32 capacity LE][payload bytes]
Uint8List _readResult(WasmRunner runner, int ptr) {
  final lenBytes = runner.readMemory(ptr, 4);
  final length = ByteData.sublistView(lenBytes).getUint32(0, Endian.little);
  final data = runner.readMemory(ptr + 8, length);
  try {
    runner.call('free_result', [ptr]);
  } catch (_) {}
  return data;
}

// ---------------------------------------------------------------------------
// Lazy WasmRunner proxy (identical to the one in aidoku_plugin.dart)
// ---------------------------------------------------------------------------

class _LazyRunner implements WasmRunner {
  WasmRunner? delegate;
  WasmRunner get _r => delegate ?? (throw StateError('WasmRunner not yet initialized'));

  @override
  dynamic call(String name, List<Object?> args) => _r.call(name, args);

  @override
  Uint8List readMemory(int offset, int length) => _r.readMemory(offset, length);

  @override
  void writeMemory(int offset, Uint8List bytes) => _r.writeMemory(offset, bytes);

  @override
  int get memorySize => _r.memorySize;
}
