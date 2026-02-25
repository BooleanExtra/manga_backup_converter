import 'dart:typed_data';

/// Abstract interface for executing WASM modules.
///
/// Implementations include wasmer (native JIT), wasm3 (native interpreter),
/// and browser WebAssembly.
abstract class WasmRunner {
  /// Call a WASM export function by name.
  ///
  /// Returns `int`, `double`, or `null` depending on the function's return
  /// type.
  dynamic call(String name, List<Object?> args);

  /// Read [length] bytes from WASM linear memory starting at [offset].
  Uint8List readMemory(int offset, int length);

  /// Write [bytes] to WASM linear memory at [offset].
  void writeMemory(int offset, Uint8List bytes);

  /// Total WASM linear memory size in bytes.
  int get memorySize;

  /// Release all native resources held by this runner.
  void dispose();
}
