/// A non-trap runtime error from the WASM engine (e.g. invalid binary,
/// export not found, out-of-bounds memory access).
class WasmRuntimeException implements Exception {
  const WasmRuntimeException(this.message);
  final String message;

  @override
  String toString() => 'WasmRuntimeException: $message';
}

/// A WASM trap — an unrecoverable error during execution (e.g. unreachable
/// instruction, stack overflow, division by zero).
class WasmTrapException implements Exception {
  const WasmTrapException(this.message);
  final String message;

  @override
  String toString() => 'WasmTrapException: $message';
}
