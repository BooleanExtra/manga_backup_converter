import 'dart:convert';
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
      _bufferLenSlot = calloc<ffi.Int64>(),
      _headersPtrSlot = calloc<ffi.Int64>(),
      _headersLenSlot = calloc<ffi.Int64>() {
    _resultSlot.value = 0;
    _statusSlot.value = 0;
    _bufferPtrSlot.value = 0;
    _bufferLenSlot.value = 0;
    _headersPtrSlot.value = 0;
    _headersLenSlot.value = 0;
  }

  final ffi.Pointer<ffi.Int32> _resultSlot; // 0 = ok, -1 = error
  final ffi.Pointer<ffi.Int32> _statusSlot; // HTTP status code
  final ffi.Pointer<ffi.Int64> _bufferPtrSlot; // address of response bytes
  final ffi.Pointer<ffi.Int64> _bufferLenSlot; // byte count
  final ffi.Pointer<ffi.Int64> _headersPtrSlot; // address of headers JSON bytes
  final ffi.Pointer<ffi.Int64> _headersLenSlot; // headers byte count

  int get resultSlotAddress => _resultSlot.address;
  int get statusSlotAddress => _statusSlot.address;
  int get bufferPtrSlotAddress => _bufferPtrSlot.address;
  int get bufferLenSlotAddress => _bufferLenSlot.address;
  int get headersPtrSlotAddress => _headersPtrSlot.address;
  int get headersLenSlotAddress => _headersLenSlot.address;

  // ---------------------------------------------------------------------------
  // Written by the main isolate after handling an async request
  // ---------------------------------------------------------------------------

  /// Write HTTP response (called on the main isolate).
  void writeResponse({
    required int statusCode,
    required Uint8List body,
    Map<String, String>? headers,
  }) {
    _freeBuffer();
    _freeHeaders();
    _statusSlot.value = statusCode;
    if (body.isEmpty) {
      _bufferPtrSlot.value = 0;
      _bufferLenSlot.value = 0;
    } else {
      final ffi.Pointer<ffi.Uint8> buf = calloc<ffi.Uint8>(body.length);
      for (var i = 0; i < body.length; i++) {
        (buf + i).value = body[i];
      }
      _bufferPtrSlot.value = buf.address;
      _bufferLenSlot.value = body.length;
    }
    if (headers != null && headers.isNotEmpty) {
      final headersBytes = Uint8List.fromList(utf8.encode(jsonEncode(headers)));
      final ffi.Pointer<ffi.Uint8> hBuf = calloc<ffi.Uint8>(headersBytes.length);
      for (var i = 0; i < headersBytes.length; i++) {
        (hBuf + i).value = headersBytes[i];
      }
      _headersPtrSlot.value = hBuf.address;
      _headersLenSlot.value = headersBytes.length;
    } else {
      _headersPtrSlot.value = 0;
      _headersLenSlot.value = 0;
    }
    _resultSlot.value = 0;
  }

  void writeError() {
    _freeBuffer();
    _freeHeaders();
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
    final int ptr = ffi.Pointer<ffi.Int64>.fromAddress(bufferPtrSlotAddress).value;
    final int len = ffi.Pointer<ffi.Int64>.fromAddress(bufferLenSlotAddress).value;
    if (ptr == 0 || len == 0) return Uint8List(0);
    final nativePtr = ffi.Pointer<ffi.Uint8>.fromAddress(ptr);
    return Uint8List.fromList(List<int>.generate(len, (int i) => (nativePtr + i).value));
  }

  /// Read response headers from native heap as a Map.
  static Map<String, String> readHeaders(int headersPtrSlotAddress, int headersLenSlotAddress) {
    final int ptr = ffi.Pointer<ffi.Int64>.fromAddress(headersPtrSlotAddress).value;
    final int len = ffi.Pointer<ffi.Int64>.fromAddress(headersLenSlotAddress).value;
    if (ptr == 0 || len == 0) return const <String, String>{};
    final nativePtr = ffi.Pointer<ffi.Uint8>.fromAddress(ptr);
    final bytes = Uint8List.fromList(List<int>.generate(len, (int i) => (nativePtr + i).value));
    try {
      final Object? decoded = jsonDecode(utf8.decode(bytes));
      if (decoded is Map) return decoded.cast<String, String>();
    } on Object {
      // Malformed JSON — return empty.
    }
    return const <String, String>{};
  }

  void _freeBuffer() {
    final int prevPtr = _bufferPtrSlot.value;
    if (prevPtr != 0) {
      calloc.free(ffi.Pointer<ffi.Uint8>.fromAddress(prevPtr));
      _bufferPtrSlot.value = 0;
      _bufferLenSlot.value = 0;
    }
  }

  void _freeHeaders() {
    final int prevPtr = _headersPtrSlot.value;
    if (prevPtr != 0) {
      calloc.free(ffi.Pointer<ffi.Uint8>.fromAddress(prevPtr));
      _headersPtrSlot.value = 0;
      _headersLenSlot.value = 0;
    }
  }

  void dispose() {
    _freeBuffer();
    _freeHeaders();
    calloc
      ..free(_resultSlot)
      ..free(_statusSlot)
      ..free(_bufferPtrSlot)
      ..free(_bufferLenSlot)
      ..free(_headersPtrSlot)
      ..free(_headersLenSlot);
  }
}
