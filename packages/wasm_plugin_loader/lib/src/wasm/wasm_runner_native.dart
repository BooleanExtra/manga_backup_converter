import 'dart:typed_data';

/// Abstraction over a loaded WASM module instance.
///
/// On web, this is backed by wasm_ffi (WebAssembly JS API).
/// On native platforms, a native WASM runtime is required (not yet implemented).
abstract class WasmRunner {
  /// Load a WASM module from raw bytes, providing host import functions.
  ///
  /// [imports] is a map from `'module::name'` (e.g. `'aidoku::print'`) to
  /// Dart [Function] values that the WASM module will call as host imports.
  ///
  /// The actual import namespace and function names must match what the WASM
  /// binary declares — see WASM_ABI.md after Task 6 discovery.
  static Future<WasmRunner> fromBytes(
    Uint8List wasmBytes, {
    Map<String, Function> imports = const {},
  }) {
    throw UnsupportedError(
      'Native WASM execution is not yet implemented. '
      'Run on web, or integrate a native WASM runtime (e.g. package:wasm / wasmer FFI).',
    );
  }

  /// Call an exported WASM function by name with positional [args].
  ///
  /// [args] must be int or double values (WASM i32/i64/f32/f64).
  /// Returns int, double, or null for void functions.
  dynamic callFunction(String name, List<Object?> args);

  /// Read [length] bytes from WASM linear memory starting at [offset].
  Uint8List readMemory(int offset, int length);

  /// Write [bytes] into WASM linear memory starting at [offset].
  void writeMemory(int offset, Uint8List bytes);

  /// Allocate [size] bytes in WASM linear memory.
  ///
  /// Returns the pointer (byte offset) into WASM memory.
  /// The plugin's own allocator is used (via the `malloc` WASM export).
  int malloc(int size);

  /// Free memory previously allocated with [malloc].
  void free(int ptr);
}
