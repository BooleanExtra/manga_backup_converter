// ignore_for_file: avoid_dynamic_calls, avoid_print
import 'dart:convert';
import 'dart:isolate';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:aidoku_plugin_loader/src/aidoku/aidoku_host.dart';
import 'package:aidoku_plugin_loader/src/aidoku/host_store.dart';
import 'package:aidoku_plugin_loader/src/wasm/lazy_wasm_runner.dart';
import 'package:jsoup/jsoup.dart';
import 'package:web_wasm_runner/web_wasm_runner.dart';

// ---------------------------------------------------------------------------
// Sync XHR bindings (only allowed in Web Workers, not the main thread)
// ---------------------------------------------------------------------------

@JS('XMLHttpRequest')
extension type _JSXMLHttpRequest._(JSObject _) implements JSObject {
  external factory _JSXMLHttpRequest();
  external void open(JSString method, JSString url, JSBoolean async_);
  external void setRequestHeader(JSString name, JSString value);
  external void send([JSAny? body]);
  external JSNumber get status;
  external JSAny? get response;
  external JSString getAllResponseHeaders();
  external JSString get responseType;
  external set responseType(JSString type);
}

const List<String> _httpMethods = <String>['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'HEAD'];

/// Synchronous XHR — blocks the worker thread. This is fine in a Web Worker
/// and is required because WASM host imports must return synchronously.
({int statusCode, Uint8List? body}) _syncXhr(
  String url,
  int method,
  Map<String, String> headers,
  Uint8List? body,
  double timeout,
) {
  try {
    final String methodStr = method < _httpMethods.length ? _httpMethods[method] : 'GET';
    final xhr = _JSXMLHttpRequest();
    xhr.open(methodStr.toJS, url.toJS, false.toJS);
    xhr.responseType = 'arraybuffer'.toJS;
    for (final MapEntry<String, String> entry in headers.entries) {
      try {
        xhr.setRequestHeader(entry.key.toJS, entry.value.toJS);
      } on Object {
        // Forbidden header — skip.
      }
    }
    if (body != null) {
      xhr.send(body.buffer.toJS);
    } else {
      xhr.send();
    }
    final int statusCode = xhr.status.toDartInt;
    final JSAny? resp = xhr.response;
    Uint8List? responseBody;
    if (resp != null && !resp.isUndefinedOrNull) {
      responseBody = (resp as JSArrayBuffer).toDart.asUint8List();
    }
    return (statusCode: statusCode, body: responseBody ?? Uint8List(0));
  } on Object catch (e) {
    print('[aidoku/net] XHR error: $e');
    return (statusCode: -1, body: null);
  }
}

/// Busy-wait sleep — blocks the worker thread.
void _busyWaitSleep(int seconds) {
  _busyWaitMs(seconds * 1000);
}

/// Busy-wait for [ms] milliseconds — blocks the worker thread.
void _busyWaitMs(int ms) {
  final int endMs = DateTime.now().millisecondsSinceEpoch + ms;
  while (DateTime.now().millisecondsSinceEpoch < endMs) {
    // spin
  }
}

// ---------------------------------------------------------------------------
// Isolate entry point
// ---------------------------------------------------------------------------

/// Entry point for the web worker isolate that executes WASM.
///
/// Communication with the main isolate uses [SendPort]/[ReceivePort] with
/// [Map]-based messages (structured-cloneable for web `postMessage`).
Future<void> wasmWorkerMain(Map<String, Object?> init) async {
  final mainPort = init['mainPort']! as SendPort;
  final wasmBytes = init['wasmBytes']! as Uint8List;
  final sourceId = init['sourceId']! as String;
  final initialDefaults = init['defaults']! as Map<String, Object>;

  final store = HostStore();
  store.defaults.addAll(initialDefaults);

  final lazyRunner = LazyWasmRunner();
  final callErrors = <String>[];

  void sendLog(String message) {
    mainPort.send(<String, Object?>{'type': 'log', 'message': message});
    if (message.startsWith('[CB]')) callErrors.add(message);
  }

  // Forward partial results to the main isolate.
  store.partialResults.listen((Uint8List bytes) {
    mainPort.send(<String, Object?>{'type': 'partial_result', 'data': bytes});
  });

  // In-worker rate limiter — on web, HTTP is synchronous (XHR) so the limiter
  // must live in-worker rather than on the main isolate.
  RateLimiter? rateLimiter;

  ({int statusCode, Uint8List? body}) rateLimitedXhr(
    String url,
    int method,
    Map<String, String> headers,
    Uint8List? body,
    double timeout,
  ) {
    final limiter = rateLimiter;
    if (limiter != null) {
      final Duration wait = limiter.waitDuration();
      if (wait > Duration.zero) _busyWaitMs(wait.inMilliseconds);
      limiter.recordRequest();
    }
    return _syncXhr(url, method, headers, body, timeout);
  }

  // Create jsoup HTML parser for this web worker isolate.
  Jsoup? htmlParser;
  try {
    htmlParser = Jsoup();
  } on Object catch (e) {
    sendLog('[aidoku] failed to create HTML parser: $e');
  }

  final Map<String, Map<String, Function>> imports = buildAidokuHostImports(
    lazyRunner,
    store,
    sourceId: sourceId,
    asyncHttp: rateLimitedXhr,
    asyncSleep: _busyWaitSleep,
    onRateLimitSet: (int permits, int periodMs) {
      rateLimiter = RateLimiter(RateLimitConfig(permits: permits, periodMs: periodMs));
    },
    onLog: sendLog,
    htmlParser: htmlParser,
  );

  late final WasmRunner runner;
  try {
    runner = await WebWasmRunner.fromBytes(wasmBytes, imports: imports);
  } on Exception catch (e) {
    mainPort.send(<String, Object?>{'type': 'error', 'id': -1, 'message': 'WASM init failed: $e'});
    return;
  }
  lazyRunner.delegate = runner;

  // Initialize the source.
  try {
    runner.call('start', <Object?>[]);
  } on Exception catch (e) {
    sendLog('[aidoku] start() failed: $e');
  }

  // Create command port and send it to the main isolate.
  final cmdPort = ReceivePort();
  mainPort.send(<String, Object?>{'type': 'ready', 'cmdPort': cmdPort.sendPort});

  // Process commands until shutdown.
  await for (final Object? rawCmd in cmdPort) {
    final cmd = rawCmd! as Map<String, Object?>;
    final type = cmd['type']! as String;

    if (type == 'shutdown') break;

    if (type == 'call') {
      _processCall(cmd, runner, store, mainPort, callErrors);
    }
  }

  htmlParser?.dispose();
  store.dispose();
  cmdPort.close();
}

// ---------------------------------------------------------------------------
// Command processing
// ---------------------------------------------------------------------------

void _processCall(
  Map<String, Object?> cmd,
  WasmRunner runner,
  HostStore store,
  SendPort mainPort,
  List<String> callErrors,
) {
  final id = cmd['id']! as int;
  final exportName = cmd['export']! as String;
  final List<Uint8List> rids = (cmd['rids']! as List<Object?>).cast<Uint8List>();
  final args = cmd['args']! as List<Object?>;
  final returnType = cmd['returnType'] as String?;

  // Add resource bytes to the store, tracking assigned RIDs.
  final assignedRids = <int>[
    for (final Uint8List bytes in rids) store.addBytes(bytes),
  ];

  // Build args: substitute null entries with next assigned RID.
  var ridIdx = 0;
  final resolvedArgs = <Object?>[
    for (final Object? a in args) a ?? assignedRids[ridIdx++],
  ];

  callErrors.clear();

  try {
    Object? ptr;
    try {
      ptr = runner.call(exportName, resolvedArgs);
    } on Object catch (e) {
      if (e is! ArgumentError) rethrow;
      // Export not found — return null result.
      mainPort.send(<String, Object?>{
        'type': 'result',
        'id': id,
        'data': null,
        'returnValue': 0,
        'warnings': const <String>[],
      });
      return;
    }

    // For void-return exports, ptr may be null.
    if (ptr == null) {
      mainPort.send(<String, Object?>{
        'type': 'result',
        'id': id,
        'data': null,
        'returnValue': 0,
        'warnings': List<String>.of(callErrors),
      });
      return;
    }

    final int ptrInt = (ptr as num).toInt();

    // For bool-return exports (handle_basic_login, handle_web_login).
    if (returnType == 'bool') {
      mainPort.send(<String, Object?>{
        'type': 'result',
        'id': id,
        'data': null,
        'returnValue': ptrInt,
        'warnings': List<String>.of(callErrors),
      });
      return;
    }

    // For void-return exports.
    if (returnType == 'void') {
      mainPort.send(<String, Object?>{
        'type': 'result',
        'id': id,
        'data': null,
        'returnValue': 0,
        'warnings': List<String>.of(callErrors),
      });
      return;
    }

    if (ptrInt <= 0) {
      mainPort.send(<String, Object?>{
        'type': 'result',
        'id': id,
        'data': null,
        'returnValue': 0,
        'warnings': List<String>.of(callErrors),
      });
      return;
    }

    // Read result buffer.
    final Uint8List data = _readResult(runner, ptrInt, mainPort);
    mainPort.send(<String, Object?>{
      'type': 'result',
      'id': id,
      'data': data,
      'returnValue': 0,
      'warnings': List<String>.of(callErrors),
    });
  } on Exception catch (e) {
    mainPort.send(<String, Object?>{
      'type': 'result',
      'id': id,
      'data': null,
      'returnValue': 0,
      'warnings': List<String>.of(callErrors),
    });
    mainPort.send(<String, Object?>{'type': 'log', 'message': '[aidoku] call $exportName failed: $e'});
  } finally {
    callErrors.clear();
    for (final rid in assignedRids) {
      store.remove(rid);
    }
  }
}

// ---------------------------------------------------------------------------
// Result buffer reader
// ---------------------------------------------------------------------------

/// Read a length-prefixed result buffer and free it.
///
/// Layout written by Rust `__handle_result`:
///   bytes[0..4] = (8 + payload_len) as i32 LE
///   bytes[4..8] = capacity as i32 LE
///   bytes[8..]  = postcard payload
Uint8List _readResult(WasmRunner runner, int ptr, SendPort logPort) {
  final Uint8List lenBytes = runner.readMemory(ptr, 4);
  final int totalLen = ByteData.sublistView(lenBytes).getInt32(0, Endian.little);
  if (totalLen < 0) {
    // AidokuError::Message — extract message, free buffer, throw (matches native).
    var message = 'AidokuError from WASM result buffer';
    try {
      final Uint8List msgLenBytes = runner.readMemory(ptr + 8, 4);
      final int msgBufLen = ByteData.sublistView(msgLenBytes).getInt32(0, Endian.little);
      if (msgBufLen > 12) {
        final Uint8List msgBytes = runner.readMemory(ptr + 12, msgBufLen - 12);
        message = 'AidokuError: ${utf8.decode(msgBytes, allowMalformed: true)}';
      }
    } on Exception catch (e) {
      logPort.send(<String, Object?>{
        'type': 'log',
        'message': '[aidoku] failed to extract error message: $e',
      });
    }
    try {
      runner.call('free_result', <Object?>[ptr]);
    } on Exception catch (e) {
      logPort.send(<String, Object?>{
        'type': 'log',
        'message': '[aidoku] free_result failed after error result: $e',
      });
    }
    throw FormatException(message);
  }
  final int payloadLen = totalLen - 8;
  final Uint8List data = runner.readMemory(ptr + 8, payloadLen);
  try {
    runner.call('free_result', <Object?>[ptr]);
  } on Exception catch (e) {
    logPort.send(<String, Object?>{'type': 'log', 'message': '[aidoku] free_result failed: $e'});
  }
  return data;
}
