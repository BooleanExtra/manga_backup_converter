import 'dart:ffi' as ffi;
import 'dart:typed_data';

import 'package:ffi/ffi.dart' show calloc;

/// Native-heap slots shared between the main isolate and the WASM isolate.
///
/// All fields are calloc-allocated — their addresses (plain ints) can be sent
/// across Dart isolate boundaries and dereferenced from any isolate via FFI.
class WasmSharedState {
  WasmSharedState()
    : _resultSlot = calloc<ffi.Int32>(),
      _statusSlot = calloc<ffi.Int32>(),
      _bufferPtrSlot = calloc<ffi.Int64>(),
      _bufferLenSlot = calloc<ffi.Int64>() {
    _resultSlot.value = 0;
    _statusSlot.value = 0;
    _bufferPtrSlot.value = 0;
    _bufferLenSlot.value = 0;
  }

  final ffi.Pointer<ffi.Int32> _resultSlot; // 0 = ok, -1 = error
  final ffi.Pointer<ffi.Int32> _statusSlot; // HTTP status code
  final ffi.Pointer<ffi.Int64> _bufferPtrSlot; // address of response bytes
  final ffi.Pointer<ffi.Int64> _bufferLenSlot; // byte count

  int get resultSlotAddress => _resultSlot.address;
  int get statusSlotAddress => _statusSlot.address;
  int get bufferPtrSlotAddress => _bufferPtrSlot.address;
  int get bufferLenSlotAddress => _bufferLenSlot.address;

  // ---------------------------------------------------------------------------
  // Written by the main isolate after handling an async request
  // ---------------------------------------------------------------------------

  /// Write HTTP response (called on the main isolate).
  void writeResponse({required int statusCode, required Uint8List body}) {
    _freeBuffer();
    _statusSlot.value = statusCode;
    if (body.isEmpty) {
      _bufferPtrSlot.value = 0;
      _bufferLenSlot.value = 0;
      _resultSlot.value = 0;
      return;
    }
    final buf = calloc<ffi.Uint8>(body.length);
    for (var i = 0; i < body.length; i++) {
      (buf + i).value = body[i];
    }
    _bufferPtrSlot.value = buf.address;
    _bufferLenSlot.value = body.length;
    _resultSlot.value = 0;
  }

  void writeError() {
    _freeBuffer();
    _resultSlot.value = -1;
  }

  // ---------------------------------------------------------------------------
  // Read by the WASM isolate after waking from semaphore
  // ---------------------------------------------------------------------------

  /// Read result flag (called on the WASM isolate via fromAddress).
  static int readResult(int resultSlotAddress) => ffi.Pointer<ffi.Int32>.fromAddress(resultSlotAddress).value;

  static int readStatus(int statusSlotAddress) => ffi.Pointer<ffi.Int32>.fromAddress(statusSlotAddress).value;

  /// Copy response bytes out of native heap into a Dart [Uint8List].
  static Uint8List readResponse(int bufferPtrSlotAddress, int bufferLenSlotAddress) {
    final ptr = ffi.Pointer<ffi.Int64>.fromAddress(bufferPtrSlotAddress).value;
    final len = ffi.Pointer<ffi.Int64>.fromAddress(bufferLenSlotAddress).value;
    if (ptr == 0 || len == 0) return Uint8List(0);
    final nativePtr = ffi.Pointer<ffi.Uint8>.fromAddress(ptr);
    return Uint8List.fromList(List.generate(len, (i) => (nativePtr + i).value));
  }

  void _freeBuffer() {
    final prevPtr = _bufferPtrSlot.value;
    if (prevPtr != 0) {
      calloc.free(ffi.Pointer<ffi.Uint8>.fromAddress(prevPtr));
      _bufferPtrSlot.value = 0;
      _bufferLenSlot.value = 0;
    }
  }

  void dispose() {
    _freeBuffer();
    calloc
      ..free(_resultSlot)
      ..free(_statusSlot)
      ..free(_bufferPtrSlot)
      ..free(_bufferLenSlot);
  }
}
