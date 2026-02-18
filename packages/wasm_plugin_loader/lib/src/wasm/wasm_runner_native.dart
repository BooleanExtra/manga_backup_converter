import 'dart:typed_data';

/// Abstraction over a loaded WASM module instance.
///
/// Imports are structured as `{ module: { functionName: DartFunction } }`.
/// The web implementation converts them to JSFunction; the native stub throws.
abstract class WasmRunner {
  /// Load a WASM module from raw bytes, providing host imports.
  ///
  /// [imports] outer key = WASM import module name (e.g. 'net', 'html').
  /// Inner key = function name. Value = Dart function matching the signature.
  static Future<WasmRunner> fromBytes(
    Uint8List wasmBytes, {
    Map<String, Map<String, Function>> imports = const {},
  }) {
    throw UnsupportedError(
      'Native WASM execution is not yet implemented. '
      'Run on web (browser), or integrate a native WASM runtime.',
    );
  }

  /// Call an exported WASM function by [name] with positional [args].
  ///
  /// Arguments must be JS-compatible types (int, double).
  /// Returns the result (int, double, or null for void exports).
  dynamic call(String name, List<Object?> args);

  /// Read [length] bytes from WASM linear memory starting at [offset].
  Uint8List readMemory(int offset, int length);

  /// Write [bytes] into WASM linear memory at [offset].
  void writeMemory(int offset, Uint8List bytes);

  /// Current size of WASM linear memory in bytes.
  int get memorySize;
}
