import 'dart:typed_data';

import 'package:aidoku_plugin_loader/src/wasm/wasm_runner.dart';

/// Lazy proxy for [WasmRunner] that breaks circular dependencies between
/// host imports and the runner itself. Set [delegate] once the real runner
/// is ready.
class LazyWasmRunner implements WasmRunner {
  WasmRunner? delegate;
  WasmRunner get _r => delegate ?? (throw StateError('WasmRunner not yet initialized'));

  @override
  dynamic call(String name, List<Object?> args) => _r.call(name, args);

  @override
  Uint8List readMemory(int offset, int length) => _r.readMemory(offset, length);

  @override
  void writeMemory(int offset, Uint8List bytes) => _r.writeMemory(offset, bytes);

  @override
  int get memorySize => _r.memorySize;
}
