// ignore_for_file: prefer_constructors_over_static_methods
import 'dart:js_interop';

@JS('Atomics.wait')
external JSString _atomicsWait(JSObject arr, int index, int expected);

@JS('Atomics.notify')
external int _atomicsNotify(JSObject arr, int index, int count);

@JS('Atomics.store')
external int _atomicsStore(JSObject arr, int index, int value);

extension type _SharedArrayBuffer._(JSObject _) implements JSObject {
  external factory _SharedArrayBuffer(int byteLength);
}

extension type _Int32Array._(JSObject _) implements JSObject {
  external factory _Int32Array(JSObject buffer);
}

/// Web semaphore backed by a `SharedArrayBuffer` + `Atomics.wait()`.
///
/// **Requires** that the page is served with:
///   `Cross-Origin-Opener-Policy: same-origin`
///   `Cross-Origin-Embedder-Policy: require-corp`
///
/// `Atomics.wait()` is blocked on the main browser thread by design; WASM
/// must run inside a Web Worker for [wait] to be usable.
class WasmSemaphore {
  WasmSemaphore._(this._sab, this._arr);

  final _SharedArrayBuffer _sab;
  final _Int32Array _arr;

  int get address => throw UnsupportedError('Use sharedBuffer on web');

  JSObject get sharedBuffer => _sab;

  static WasmSemaphore create() {
    final sab = _SharedArrayBuffer(4);
    final arr = _Int32Array(sab);
    _atomicsStore(arr, 0, 0);
    return WasmSemaphore._(sab, arr);
  }

  static WasmSemaphore fromBuffer(JSObject sab) {
    final arr = _Int32Array(sab);
    return WasmSemaphore._(sab as _SharedArrayBuffer, arr);
  }

  /// Not applicable on web — use [fromBuffer].
  static WasmSemaphore fromAddress(int address) => throw UnsupportedError('Use WasmSemaphore.fromBuffer on web');

  /// Block the calling Worker thread until [signal] is called.
  /// Throws on the main thread (Atomics.wait is disallowed there).
  void wait() {
    while (true) {
      final r = _atomicsWait(_arr, 0, 0);
      final s = r.toDart;
      if (s == 'ok' || s == 'not-equal') break;
    }
    _atomicsStore(_arr, 0, 0);
  }

  /// Wake one waiting Worker thread.
  void signal() {
    _atomicsStore(_arr, 0, 1);
    _atomicsNotify(_arr, 0, 1);
  }

  void dispose() {} // GC handles SharedArrayBuffer
}
