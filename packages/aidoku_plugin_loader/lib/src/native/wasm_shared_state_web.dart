import 'dart:typed_data';

/// Web stub — on web, shared state is communicated via Worker postMessage.
///
/// The web AidokuPlugin implementation (aidoku_plugin_web.dart) does not use
/// WasmSharedState. All WASM ↔ main-thread communication goes through the
/// Web Worker's postMessage/onmessage channel. This stub exists only to
/// satisfy conditional imports on web.
class WasmSharedState {
  WasmSharedState();

  int get resultSlotAddress => 0;
  int get statusSlotAddress => 0;
  int get bufferPtrSlotAddress => 0;
  int get bufferLenSlotAddress => 0;

  void writeResponse({required int statusCode, required Uint8List body}) {}
  void writeError() {}

  static int readResult(int ignored) => -1;
  static int readStatus(int ignored) => 0;
  static Uint8List readResponse(int ignoredA, int ignoredB) => Uint8List(0);

  void dispose() {}
}
