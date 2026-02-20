import 'dart:convert';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:wasm_plugin_loader/src/aidoku/_aidoku_decode.dart';
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
    required this.sourceId,
    this.initialDefaults = const <String, Object>{},
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

  /// Source ID — prepended to all defaults keys in the host imports.
  final String sourceId;

  /// Pre-seeded defaults from settings.json (int | Uint8List values).
  final Map<String, Object> initialDefaults;
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
    required this.mangaBytes,
    required this.chapterBytes,
    required this.replyPort,
  });
  final Uint8List mangaBytes; // pre-encoded postcard Manga bytes
  final Uint8List chapterBytes; // pre-encoded postcard Chapter bytes
  final SendPort replyPort;
}

class WasmMangaListCmd {
  const WasmMangaListCmd({required this.listingBytes, required this.page, required this.replyPort});
  final Uint8List? listingBytes; // pre-encoded postcard Listing bytes, or null for fallback search
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

// New optional-export commands --------------------------------------------

class WasmAlternateCoversCmd {
  const WasmAlternateCoversCmd({required this.mangaBytes, required this.replyPort});
  final Uint8List mangaBytes;
  final SendPort replyPort;
}

class WasmImageRequestCmd {
  const WasmImageRequestCmd({
    required this.urlBytes,
    required this.contextBytes,
    required this.replyPort,
  });
  final Uint8List urlBytes; // raw UTF-8 URL
  final Uint8List contextBytes; // postcard Option<HashMap<String,String>>
  final SendPort replyPort;
}

class WasmBaseUrlCmd {
  const WasmBaseUrlCmd({required this.replyPort});
  final SendPort replyPort;
}

class WasmPageDescriptionCmd {
  const WasmPageDescriptionCmd({required this.pageBytes, required this.replyPort});
  final Uint8List pageBytes; // postcard Page
  final SendPort replyPort;
}

class WasmProcessPageImageCmd {
  const WasmProcessPageImageCmd({
    required this.imageBytes,
    required this.contextBytes,
    required this.replyPort,
  });
  final Uint8List imageBytes; // postcard Vec<u8>
  final Uint8List contextBytes; // postcard Option<HashMap<String,String>>
  final SendPort replyPort;
}

class WasmNotificationCmd {
  const WasmNotificationCmd({required this.notifBytes, required this.replyPort});
  final Uint8List notifBytes; // raw UTF-8
  final SendPort replyPort;
}

class WasmDeepLinkCmd {
  const WasmDeepLinkCmd({required this.urlBytes, required this.replyPort});
  final Uint8List urlBytes; // raw UTF-8
  final SendPort replyPort;
}

class WasmBasicLoginCmd {
  const WasmBasicLoginCmd({
    required this.keyBytes,
    required this.usernameBytes,
    required this.passwordBytes,
    required this.replyPort,
  });
  final Uint8List keyBytes; // raw UTF-8
  final Uint8List usernameBytes; // raw UTF-8
  final Uint8List passwordBytes; // raw UTF-8
  final SendPort replyPort;
}

class WasmWebLoginCmd {
  const WasmWebLoginCmd({
    required this.keyBytes,
    required this.cookiesBytes,
    required this.replyPort,
  });
  final Uint8List keyBytes; // raw UTF-8
  final Uint8List cookiesBytes; // postcard HashMap<String,String>
  final SendPort replyPort;
}

class WasmMangaMigrationCmd {
  const WasmMangaMigrationCmd({required this.keyBytes, required this.replyPort});
  final Uint8List keyBytes; // raw UTF-8 manga key
  final SendPort replyPort;
}

class WasmChapterMigrationCmd {
  const WasmChapterMigrationCmd({
    required this.mangaKeyBytes,
    required this.chapterKeyBytes,
    required this.replyPort,
  });
  final Uint8List mangaKeyBytes; // raw UTF-8
  final Uint8List chapterKeyBytes; // raw UTF-8
  final SendPort replyPort;
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
/// for printing. Using the existing asyncPort avoids an extra port.
class WasmLogMsg {
  const WasmLogMsg({required this.message, required this.stackTrace});
  final String message;
  final String stackTrace;
}

/// A partial result pushed by `env::_send_partial_result` inside the WASM
/// isolate — forwarded to the main isolate for streaming to callers.
class WasmPartialResultMsg {
  const WasmPartialResultMsg(this.data);
  final Uint8List data;
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

  // Forward partial results from the WASM isolate to the main isolate.
  store.partialResults.listen((Uint8List bytes) => init.asyncPort.send(WasmPartialResultMsg(bytes)));

  // Seed defaults from settings.json before WASM starts.
  store.defaults.addAll(init.initialDefaults);

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
        body: body != null ? List<int>.from(body) : null,
      ),
    );
    // 2. Block this thread until the main isolate signals.
    WasmSemaphore.fromAddress(init.semaphoreAddress).wait();
    // 3. Read result from shared native memory.
    final int result = WasmSharedState.readResult(init.resultSlotAddress);
    if (result != 0) {
      return (statusCode: -1, body: null);
    }
    final int statusCode = WasmSharedState.readStatus(init.statusSlotAddress);
    final Uint8List respBody = WasmSharedState.readResponse(init.bufferPtrSlotAddress, init.bufferLenSlotAddress);
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
  final Map<String, Map<String, Function>> imports = buildAidokuHostImports(
    lazyRunner,
    store,
    sourceId: init.sourceId,
    asyncHttp: asyncHttp,
    asyncSleep: asyncSleep,
  );

  late final WasmRunner runner;
  try {
    runner = await WasmRunner.fromBytes(init.wasmBytes, imports: imports);
  } on Exception catch (e) {
    init.handshakePort.send('error:$e');
    cmdPort.close();
    return;
  }
  lazyRunner.delegate = runner;

  // Initialize the source.
  try {
    runner.call('start', <Object?>[]);
  } on Exception catch (_) {
    // start should always exist (core export), but catch defensively.
  }

  // Process commands until shutdown.
  await for (final Object? cmd in cmdPort) {
    if (cmd is WasmShutdownCmd) break;
    _processCmd(cmd!, runner, store, init.asyncPort);
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
    final int queryRid = store.addBytes(cmd.queryBytes);
    final int filtersRid = store.addBytes(cmd.filtersBytes);
    try {
      final int ptr = (runner.call('get_search_manga_list', <Object?>[queryRid, cmd.page, filtersRid]) as num).toInt();
      if (ptr > 0) result = _readResult(runner, ptr);
    } on Exception catch (e, st) {
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
    // v2 ABI: get_manga_update(manga_descriptor_rid, needs_details, needs_chapters)
    // manga_descriptor is postcard-encoded Manga struct with the key set.
    final int mangaRid = store.addBytes(encodeMangaKey(utf8.decode(cmd.keyBytes)));
    try {
      final int ptr = (runner.call('get_manga_update', <Object?>[mangaRid, 1, 0]) as num).toInt();
      if (ptr > 0) result = _readResult(runner, ptr);
    } on Exception catch (e, st) {
      result = null;
      logPort.send(WasmLogMsg(message: 'get_manga_update: $e', stackTrace: st.toString()));
    } finally {
      store.remove(mangaRid);
    }
    cmd.replyPort.send(result);
    return;
  }

  if (cmd is WasmPageListCmd) {
    Uint8List? result;
    // ABI: get_page_list(manga_descriptor_rid, chapter_descriptor_rid)
    // Note: manga comes FIRST, chapter comes SECOND.
    final int mangaRid = store.addBytes(cmd.mangaBytes);
    final int chapterRid = store.addBytes(cmd.chapterBytes);
    try {
      final int ptr = (runner.call('get_page_list', <Object?>[mangaRid, chapterRid]) as num).toInt();
      if (ptr > 0) result = _readResult(runner, ptr);
    } on Exception catch (e, st) {
      result = null;
      logPort.send(WasmLogMsg(message: 'get_page_list: $e', stackTrace: st.toString()));
    } finally {
      store.remove(mangaRid);
      store.remove(chapterRid);
    }
    cmd.replyPort.send(result);
    return;
  }

  if (cmd is WasmMangaListCmd) {
    Uint8List? result;

    // Call get_manga_list with the pre-encoded Listing descriptor RID from the manifest.
    if (cmd.listingBytes != null) {
      final int listingRid = store.addBytes(cmd.listingBytes!);
      try {
        final int ptr = (runner.call('get_manga_list', <Object?>[listingRid, cmd.page]) as num).toInt();
        if (ptr > 0) result = _readResult(runner, ptr);
      } on Exception catch (e, st) {
        logPort.send(WasmLogMsg(message: 'get_manga_list: $e', stackTrace: st.toString()));
      } finally {
        store.remove(listingRid);
      }
    }

    if (result == null) {
      // No listing provided or get_manga_list failed — fall back to empty-query search.
      final int queryRid = store.addBytes(Uint8List(0)); // empty UTF-8 string
      final int filtersRid = store.addBytes(Uint8List.fromList(<int>[0])); // postcard empty list
      try {
        final int ptr = (runner.call('get_search_manga_list', <Object?>[queryRid, cmd.page, filtersRid]) as num)
            .toInt();
        if (ptr > 0) result = _readResult(runner, ptr);
      } on Exception catch (e, st) {
        logPort.send(WasmLogMsg(message: 'get_search_manga_list (fallback): $e', stackTrace: st.toString()));
      } finally {
        store.remove(queryRid);
        store.remove(filtersRid);
      }
    }

    cmd.replyPort.send(result);
    return;
  }

  if (cmd is WasmRawGetCmd) {
    Uint8List? result;
    try {
      final int ptr = (runner.call(cmd.funcName, <Object?>[]) as num).toInt();
      if (ptr > 0) result = _readResult(runner, ptr);
    } on Exception catch (e, st) {
      result = null;
      logPort.send(WasmLogMsg(message: '${cmd.funcName}: $e', stackTrace: st.toString()));
    }
    cmd.replyPort.send(result);
    return;
  }

  if (cmd is WasmAlternateCoversCmd) {
    Uint8List? result;
    final int mangaRid = store.addBytes(cmd.mangaBytes);
    try {
      final int ptr = (runner.call('get_alternate_covers', <Object?>[mangaRid]) as num).toInt();
      if (ptr > 0) result = _readResult(runner, ptr);
    } on Exception catch (e, st) {
      logPort.send(WasmLogMsg(message: 'get_alternate_covers: $e', stackTrace: st.toString()));
    } finally {
      store.remove(mangaRid);
    }
    cmd.replyPort.send(result);
    return;
  }

  if (cmd is WasmImageRequestCmd) {
    Uint8List? result;
    final int urlRid = store.addBytes(cmd.urlBytes);
    final int contextRid = store.addBytes(cmd.contextBytes);
    try {
      final int ptr = (runner.call('get_image_request', <Object?>[urlRid, contextRid]) as num).toInt();
      if (ptr > 0) result = _readResult(runner, ptr);
    } on Exception catch (e, st) {
      logPort.send(WasmLogMsg(message: 'get_image_request: $e', stackTrace: st.toString()));
    } finally {
      store.remove(urlRid);
      store.remove(contextRid);
    }
    cmd.replyPort.send(result);
    return;
  }

  if (cmd is WasmBaseUrlCmd) {
    Uint8List? result;
    try {
      final int ptr = (runner.call('get_base_url', <Object?>[]) as num).toInt();
      if (ptr > 0) result = _readResult(runner, ptr);
    } on Exception catch (e, st) {
      logPort.send(WasmLogMsg(message: 'get_base_url: $e', stackTrace: st.toString()));
    }
    cmd.replyPort.send(result);
    return;
  }

  if (cmd is WasmPageDescriptionCmd) {
    Uint8List? result;
    final int pageRid = store.addBytes(cmd.pageBytes);
    try {
      final int ptr = (runner.call('get_page_description', <Object?>[pageRid]) as num).toInt();
      if (ptr > 0) result = _readResult(runner, ptr);
    } on Exception catch (e, st) {
      logPort.send(WasmLogMsg(message: 'get_page_description: $e', stackTrace: st.toString()));
    } finally {
      store.remove(pageRid);
    }
    cmd.replyPort.send(result);
    return;
  }

  if (cmd is WasmProcessPageImageCmd) {
    Uint8List? result;
    final int imageRid = store.addBytes(cmd.imageBytes);
    final int contextRid = store.addBytes(cmd.contextBytes);
    try {
      final int ptr = (runner.call('process_page_image', <Object?>[imageRid, contextRid]) as num).toInt();
      if (ptr > 0) result = _readResult(runner, ptr);
    } on Exception catch (e, st) {
      logPort.send(WasmLogMsg(message: 'process_page_image: $e', stackTrace: st.toString()));
    } finally {
      store.remove(imageRid);
      store.remove(contextRid);
    }
    cmd.replyPort.send(result);
    return;
  }

  if (cmd is WasmNotificationCmd) {
    final int rid = store.addBytes(cmd.notifBytes);
    try {
      runner.call('handle_notification', <Object?>[rid]);
    } on Exception catch (e, st) {
      logPort.send(WasmLogMsg(message: 'handle_notification: $e', stackTrace: st.toString()));
    } finally {
      store.remove(rid);
    }
    cmd.replyPort.send(null); // void return
    return;
  }

  if (cmd is WasmDeepLinkCmd) {
    Uint8List? result;
    final int rid = store.addBytes(cmd.urlBytes);
    try {
      final int ptr = (runner.call('handle_deep_link', <Object?>[rid]) as num).toInt();
      if (ptr > 0) result = _readResult(runner, ptr);
    } on Exception catch (e, st) {
      logPort.send(WasmLogMsg(message: 'handle_deep_link: $e', stackTrace: st.toString()));
    } finally {
      store.remove(rid);
    }
    cmd.replyPort.send(result);
    return;
  }

  if (cmd is WasmBasicLoginCmd) {
    final int keyRid = store.addBytes(cmd.keyBytes);
    final int userRid = store.addBytes(cmd.usernameBytes);
    final int passRid = store.addBytes(cmd.passwordBytes);
    var success = false;
    try {
      final int result = (runner.call('handle_basic_login', <Object?>[keyRid, userRid, passRid]) as num).toInt();
      success = result >= 0;
    } on Exception catch (e, st) {
      logPort.send(WasmLogMsg(message: 'handle_basic_login: $e', stackTrace: st.toString()));
    } finally {
      store.remove(keyRid);
      store.remove(userRid);
      store.remove(passRid);
    }
    cmd.replyPort.send(success);
    return;
  }

  if (cmd is WasmWebLoginCmd) {
    final int keyRid = store.addBytes(cmd.keyBytes);
    final int cookiesRid = store.addBytes(cmd.cookiesBytes);
    var success = false;
    try {
      final int result = (runner.call('handle_web_login', <Object?>[keyRid, cookiesRid]) as num).toInt();
      success = result >= 0;
    } on Exception catch (e, st) {
      logPort.send(WasmLogMsg(message: 'handle_web_login: $e', stackTrace: st.toString()));
    } finally {
      store.remove(keyRid);
      store.remove(cookiesRid);
    }
    cmd.replyPort.send(success);
    return;
  }

  if (cmd is WasmMangaMigrationCmd) {
    Uint8List? result;
    final int keyRid = store.addBytes(cmd.keyBytes);
    try {
      final int ptr = (runner.call('handle_key_migration', <Object?>[keyRid, -1]) as num).toInt();
      if (ptr > 0) result = _readResult(runner, ptr);
    } on Exception catch (e, st) {
      logPort.send(WasmLogMsg(message: 'handle_key_migration (manga): $e', stackTrace: st.toString()));
    } finally {
      store.remove(keyRid);
    }
    cmd.replyPort.send(result);
    return;
  }

  if (cmd is WasmChapterMigrationCmd) {
    Uint8List? result;
    final int mangaRid = store.addBytes(cmd.mangaKeyBytes);
    final int chapterRid = store.addBytes(cmd.chapterKeyBytes);
    try {
      final int ptr = (runner.call('handle_key_migration', <Object?>[mangaRid, chapterRid]) as num).toInt();
      if (ptr > 0) result = _readResult(runner, ptr);
    } on Exception catch (e, st) {
      logPort.send(WasmLogMsg(message: 'handle_key_migration (chapter): $e', stackTrace: st.toString()));
    } finally {
      store.remove(mangaRid);
      store.remove(chapterRid);
    }
    cmd.replyPort.send(result);
    return;
  }
}

/// Read a length-prefixed result buffer and free it.
///
/// Layout written by Rust `__handle_result`:
///   bytes[0..4] = (8 + payload_len) as i32 LE  ← total buffer size, signed
///   bytes[4..8] = capacity as i32 LE
///   bytes[8..]  = postcard payload
///
/// AidokuError::Message returns a positive ptr where bytes[0..4] = -1_i32 LE.
/// All other negative return codes (−1, −2, −3) arrive as a negative i32
/// ptr directly (not as a buffer), so they never reach this function.
Uint8List _readResult(WasmRunner runner, int ptr) {
  final Uint8List lenBytes = runner.readMemory(ptr, 4);
  final int totalLen = ByteData.sublistView(lenBytes).getInt32(0, Endian.little);
  if (totalLen < 0) {
    // AidokuError::Message: bytes[8..12] = total buffer length, bytes[12+] = UTF-8 message.
    var message = 'AidokuError from WASM result buffer';
    try {
      final Uint8List msgLenBytes = runner.readMemory(ptr + 8, 4);
      final int msgBufLen = ByteData.sublistView(msgLenBytes).getInt32(0, Endian.little);
      if (msgBufLen > 12) {
        final Uint8List msgBytes = runner.readMemory(ptr + 12, msgBufLen - 12);
        message = 'AidokuError: ${utf8.decode(msgBytes, allowMalformed: true)}';
      }
    } on Exception catch (_) {}
    try {
      runner.call('free_result', <Object?>[ptr]);
    } on Exception catch (_) {}
    throw FormatException(message);
  }
  final int payloadLen = totalLen - 8;
  final Uint8List data = runner.readMemory(ptr + 8, payloadLen);
  try {
    runner.call('free_result', <Object?>[ptr]);
  } on Exception catch (_) {}
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
