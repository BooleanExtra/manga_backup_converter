import 'dart:typed_data';

/// Abstraction over a loaded WASM module instance.
///
/// Imports are structured as `module -> name -> Dart Function`. The web
/// implementation converts them to JSFunction; the native stub throws.
abstract class WasmRunner {
  /// Load a WASM module from raw bytes, providing host imports.
  ///
  /// [imports] keys are module names (outer) and function names (inner).
  static Future<WasmRunner> fromBytes(
    Uint8List wasmBytes, {
    Map<String, Map<String, Function>> imports = const {},
  }) {
    throw UnsupportedError(
      'Native WASM execution is not yet implemented. '
      'Run on web (browser), or integrate a native WASM runtime.',
    );
  }

  /// Call an exported WASM function by name with positional arguments.
  ///
  /// Arguments must be JS-compatible types (int, double, BigInt).
  /// Returns the function result (int, double, BigInt, or null for void).
  dynamic call(String name, List<Object?> args);

  /// Read [length] bytes from WASM linear memory starting at [offset].
  Uint8List readMemory(int offset, int length);

  /// Write [bytes] into WASM linear memory at [offset].
  void writeMemory(int offset, Uint8List bytes);

  /// Current size of WASM linear memory in bytes.
  int get memorySize;
}
