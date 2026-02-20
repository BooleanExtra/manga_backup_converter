// lib/src/wasm/wasm_bindings_ffi.dart
//
// Thin Dart-friendly wrapper over the ffigen-generated [NativeWasmerBindings].
// Preserves the original method names used by wasm_runner_native.dart.
//
// Regenerate the generated file with:
//   cd packages/wasm_plugin_loader
//   dart run ffigen --config ffigen.yaml
import 'dart:convert';
import 'dart:ffi' as ffi;

import 'package:wasm_plugin_loader/src/wasm/wasm_bindings_generated.dart';

// ---------------------------------------------------------------------------
// Re-export generated types under the PascalCase aliases used by the runner.
// ---------------------------------------------------------------------------

typedef WasmEngineT = wasm_engine_t;
typedef WasmStoreT = wasm_store_t;
typedef WasmModuleT = wasm_module_t;
typedef WasmInstanceT = wasm_instance_t;
typedef WasmFuncT = wasm_func_t;
typedef WasmMemoryT = wasm_memory_t;
typedef WasmExternT = wasm_extern_t;
typedef WasmTrapT = wasm_trap_t;
typedef WasmFunctypeT = wasm_functype_t;
typedef WasmExterntypeT = wasm_externtype_t;
typedef WasmImporttypeT = wasm_importtype_t;
typedef WasmExporttypeT = wasm_exporttype_t;
typedef WasmByteVec = wasm_byte_vec_t;
typedef WasmVal = wasm_val_t;
typedef WasmValVec = wasm_val_vec_t;
typedef WasmExternVec = wasm_extern_vec_t;
typedef WasmImporttypeVec = wasm_importtype_vec_t;
typedef WasmExporttypeVec = wasm_exporttype_vec_t;

// ---------------------------------------------------------------------------
// Callback typedef used by NativeCallable in wasm_runner_native.dart.
//
// This is the *inner* native function type (not the pointer wrapper).
// wasm_func_callback_t from the generated file is the pointer wrapper:
//   Pointer<NativeFunction<WasmFuncCallbackC>> == wasm_func_callback_t
// ---------------------------------------------------------------------------

typedef WasmFuncCallbackC =
    ffi.Pointer<wasm_trap_t> Function(ffi.Pointer<wasm_val_vec_t> args, ffi.Pointer<wasm_val_vec_t> results);

// ---------------------------------------------------------------------------
// WasmerBindings: thin wrapper preserving the original public API.
// ---------------------------------------------------------------------------

/// Mirror of `wasm_valtype_vec_t` (size_t size + wasm_valtype_t** data).
/// Used only by [WasmerBindings.functypeFirstResultKind].
final class _WasmValtypeVecT extends ffi.Struct {
  @ffi.Size()
  external int size;

  external ffi.Pointer<ffi.Pointer<ffi.Opaque>> data;
}

class WasmerBindings {
  WasmerBindings(ffi.DynamicLibrary lib) : _b = NativeWasmerBindings(lib), _lib = lib;
  final NativeWasmerBindings _b;
  final ffi.DynamicLibrary _lib;

  // Engine / Store
  ffi.Pointer<WasmEngineT> engineNew() => _b.wasm_engine_new();
  ffi.Pointer<WasmStoreT> storeNew(ffi.Pointer<WasmEngineT> e) => _b.wasm_store_new(e);

  // ByteVec
  // wasm_byte_vec_new takes Pointer<Char> — cast from the Uint8 buffer the
  // runner allocates with calloc<Uint8>.
  void byteVecNew(ffi.Pointer<WasmByteVec> out, int size, ffi.Pointer<ffi.Uint8> data) =>
      _b.wasm_byte_vec_new(out, size, data.cast<ffi.Char>());
  void byteVecNewEmpty(ffi.Pointer<WasmByteVec> out) => _b.wasm_byte_vec_new_empty(out);
  void byteVecDelete(ffi.Pointer<WasmByteVec> v) => _b.wasm_byte_vec_delete(v);

  // Module
  ffi.Pointer<WasmModuleT> moduleNew(ffi.Pointer<WasmStoreT> s, ffi.Pointer<WasmByteVec> bytes) =>
      _b.wasm_module_new(s, bytes);
  void moduleDelete(ffi.Pointer<WasmModuleT> m) => _b.wasm_module_delete(m);
  void moduleImports(ffi.Pointer<WasmModuleT> m, ffi.Pointer<WasmImporttypeVec> out) => _b.wasm_module_imports(m, out);
  void moduleExports(ffi.Pointer<WasmModuleT> m, ffi.Pointer<WasmExporttypeVec> out) => _b.wasm_module_exports(m, out);

  // ImportType / ExportType
  ffi.Pointer<WasmByteVec> importtypeModule(ffi.Pointer<WasmImporttypeT> it) => _b.wasm_importtype_module(it);
  ffi.Pointer<WasmByteVec> importtypeName(ffi.Pointer<WasmImporttypeT> it) => _b.wasm_importtype_name(it);
  ffi.Pointer<WasmExterntypeT> importtypeType(ffi.Pointer<WasmImporttypeT> it) => _b.wasm_importtype_type(it);
  void importtypeVecNewEmpty(ffi.Pointer<WasmImporttypeVec> out) => _b.wasm_importtype_vec_new_empty(out);
  void importtypeVecDelete(ffi.Pointer<WasmImporttypeVec> v) => _b.wasm_importtype_vec_delete(v);
  ffi.Pointer<WasmByteVec> exporttypeName(ffi.Pointer<WasmExporttypeT> et) => _b.wasm_exporttype_name(et);
  void exporttypeVecNewEmpty(ffi.Pointer<WasmExporttypeVec> out) => _b.wasm_exporttype_vec_new_empty(out);
  void exporttypeVecDelete(ffi.Pointer<WasmExporttypeVec> v) => _b.wasm_exporttype_vec_delete(v);

  // ExternType
  ffi.Pointer<WasmFunctypeT> externtypeAsFunctypeConst(ffi.Pointer<WasmExterntypeT> et) =>
      _b.wasm_externtype_as_functype_const(et);

  // Func
  // The third param type ffi.Pointer<ffi.NativeFunction<WasmFuncCallbackC>>
  // is identical to wasm_func_callback_t from the generated file.
  ffi.Pointer<WasmFuncT> funcNew(
    ffi.Pointer<WasmStoreT> s,
    ffi.Pointer<WasmFunctypeT> t,
    ffi.Pointer<ffi.NativeFunction<WasmFuncCallbackC>> cb,
  ) => _b.wasm_func_new(s, t, cb);
  void funcDelete(ffi.Pointer<WasmFuncT> f) => _b.wasm_func_delete(f);
  ffi.Pointer<WasmExternT> funcAsExtern(ffi.Pointer<WasmFuncT> f) => _b.wasm_func_as_extern(f);
  ffi.Pointer<WasmTrapT> funcCall(ffi.Pointer<WasmFuncT> f, ffi.Pointer<WasmValVec> a, ffi.Pointer<WasmValVec> r) =>
      _b.wasm_func_call(f, a, r);

  // ValVec
  void valVecNewEmpty(ffi.Pointer<WasmValVec> out) => _b.wasm_val_vec_new_empty(out);
  void valVecNewUninitialized(ffi.Pointer<WasmValVec> out, int size) => _b.wasm_val_vec_new_uninitialized(out, size);
  void valVecDelete(ffi.Pointer<WasmValVec> v) => _b.wasm_val_vec_delete(v);

  // ExternVec
  void externVecNewEmpty(ffi.Pointer<WasmExternVec> out) => _b.wasm_extern_vec_new_empty(out);
  void externVecNew(ffi.Pointer<WasmExternVec> out, int size, ffi.Pointer<ffi.Pointer<WasmExternT>> data) =>
      _b.wasm_extern_vec_new(out, size, data);
  void externVecDelete(ffi.Pointer<WasmExternVec> v) => _b.wasm_extern_vec_delete(v);

  // Extern
  ffi.Pointer<WasmFuncT> externAsFunc(ffi.Pointer<WasmExternT> e) => _b.wasm_extern_as_func(e);
  ffi.Pointer<WasmMemoryT> externAsMemory(ffi.Pointer<WasmExternT> e) => _b.wasm_extern_as_memory(e);

  // Instance
  ffi.Pointer<WasmInstanceT> instanceNew(
    ffi.Pointer<WasmStoreT> s,
    ffi.Pointer<WasmModuleT> m,
    ffi.Pointer<WasmExternVec> imports,
    ffi.Pointer<ffi.Pointer<WasmTrapT>> trapOut,
  ) => _b.wasm_instance_new(s, m, imports, trapOut);
  void instanceDelete(ffi.Pointer<WasmInstanceT> i) => _b.wasm_instance_delete(i);
  void instanceExports(ffi.Pointer<WasmInstanceT> i, ffi.Pointer<WasmExternVec> out) =>
      _b.wasm_instance_exports(i, out);

  // Memory
  // wasm_memory_data returns Pointer<Char> — cast to Uint8 for the runner.
  ffi.Pointer<ffi.Uint8> memoryData(ffi.Pointer<WasmMemoryT> m) => _b.wasm_memory_data(m).cast<ffi.Uint8>();
  int memoryDataSize(ffi.Pointer<WasmMemoryT> m) => _b.wasm_memory_data_size(m);

  // Trap
  void trapMessage(ffi.Pointer<WasmTrapT> t, ffi.Pointer<WasmByteVec> out) => _b.wasm_trap_message(t, out);
  void trapDelete(ffi.Pointer<WasmTrapT> t) => _b.wasm_trap_delete(t);

  // wasm_functype_results / wasm_valtype_kind — not generated by ffigen because
  // wasm_valtype_t / wasm_valtype_vec_t were omitted from the config.
  late final _functypeResults = _lib
      .lookupFunction<
        ffi.Pointer<_WasmValtypeVecT> Function(ffi.Pointer<WasmFunctypeT>),
        ffi.Pointer<_WasmValtypeVecT> Function(ffi.Pointer<WasmFunctypeT>)
      >(
        'wasm_functype_results',
      );
  late final _valtypeKind = _lib
      .lookupFunction<ffi.Uint8 Function(ffi.Pointer<ffi.Opaque>), int Function(ffi.Pointer<ffi.Opaque>)>(
        'wasm_valtype_kind',
      );

  /// Returns the wasm_valkind (0=I32, 1=I64, 2=F32, 3=F64) of the first
  /// result type declared by [functype], or -1 if the function returns void.
  int functypeFirstResultKind(ffi.Pointer<WasmFunctypeT> functype) {
    final vec = _functypeResults(functype);
    if (vec.address == 0 || vec.ref.size == 0) return -1;
    // vec.ref.data is Pointer<Pointer<Opaque>> — .value dereferences index 0.
    return _valtypeKind(vec.ref.data.value);
  }

  /// Read a [WasmByteVec] / wasm_name_t as a Dart String.
  /// The data field is Pointer<Char> (signed); mask to Uint8 for utf8.decode.
  static String readByteVec(ffi.Pointer<WasmByteVec> vec) {
    final bytes = List<int>.generate(vec.ref.size, (i) => (vec.ref.data + i).value & 0xFF);
    return utf8.decode(bytes);
  }
}
