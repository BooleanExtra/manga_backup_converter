import 'dart:typed_data';
import 'package:wasm_ffi/ffi.dart';

/// A [ModuleLoader] that serves WASM bytes directly from memory.
///
/// Passed to [DynamicLibrary.open] to avoid a network/file round-trip.
class _BytesModuleLoader extends ModuleLoader {
  const _BytesModuleLoader(this._bytes);

  final Uint8List _bytes;

  @override
  Future<bool> exists(String modulePath) async => true;

  @override
  Future<Uint8List> load(String modulePath) async => _bytes;
}

/// Web implementation of [WasmRunner] backed by [wasm_ffi].
///
/// NOTE: Import binding (host functions the WASM module calls into Dart)
/// requires adjustment after Task 6 ABI discovery. The [imports] map is
/// captured but the mechanism to forward them into [DynamicLibrary.open]
/// depends on the wasm_ffi 2.2.0 API — verify against actual package source.
class WasmRunner {
  WasmRunner._(this._library, this._imports);

  final DynamicLibrary _library;

  /// Host imports captured for reference; actual binding TBD post-ABI-discovery.
  // ignore: unused_field
  final Map<String, Function> _imports;

  /// Load a WASM module from raw bytes with optional host import functions.
  ///
  /// [imports] keys are `'module::name'` matching WASM import declarations.
  static Future<WasmRunner> fromBytes(
    Uint8List wasmBytes, {
    Map<String, Function> imports = const {},
  }) async {
    Memory.init();

    // Use a custom loader to serve raw bytes rather than fetching from URL.
    // 'wasm_module' is an arbitrary name; the loader ignores the path.
    final library = await DynamicLibrary.open(
      'wasm_module',
      moduleLoader: _BytesModuleLoader(wasmBytes),
      wasmType: WasmType.wasm32Standalone,
    );

    // TODO(task7): Forward [imports] as host functions once the WASM ABI is
    // known (see WASM_ABI.md). wasm_ffi may require imports to be JS functions
    // injected before instantiation — revisit after Task 6.

    return WasmRunner._(library, imports);
  }

  /// Call an exported WASM function [name] with [args].
  ///
  /// Signature lookup is based on the ABI discovered in Task 6.
  /// This initial implementation handles the common case of a single i32
  /// return; update after WASM_ABI.md is written.
  dynamic callFunction(String name, List<Object?> args) {
    if (!_library.providesSymbol(name)) {
      throw ArgumentError('WASM export "$name" not found');
    }
    // TODO(task8): Use proper typed lookup based on discovered signatures.
    // For now, call as a zero-arg i32-returning function as a placeholder.
    final fn = _library.lookupFunction<Int32 Function(), int Function()>(name);
    return fn();
  }

  /// Read [length] bytes from WASM linear memory at [offset].
  Uint8List readMemory(int offset, int length) {
    final buffer = _library.allocator.allocate<Uint8>(0);
    final mem = buffer.boundMemory;
    return Uint8List.fromList(
      List.generate(length, (i) => mem.buffer.asByteData().getUint8(offset + i)),
    );
  }

  /// Write [bytes] into WASM linear memory at [offset].
  void writeMemory(int offset, Uint8List bytes) {
    final buffer = _library.allocator.allocate<Uint8>(0);
    final mem = buffer.boundMemory;
    final bd = mem.buffer.asByteData();
    for (var i = 0; i < bytes.length; i++) {
      bd.setUint8(offset + i, bytes[i]);
    }
  }

  /// Allocate [size] bytes via the WASM module's own `malloc` export.
  int malloc(int size) {
    final fn = _library.lookupFunction<Int32 Function(Int32), int Function(int)>('malloc');
    return fn(size);
  }

  /// Free WASM memory at [ptr] via the module's `free` export.
  void free(int ptr) {
    final fn = _library.lookupFunction<Void Function(Int32), void Function(int)>('free');
    fn(ptr);
  }
}
