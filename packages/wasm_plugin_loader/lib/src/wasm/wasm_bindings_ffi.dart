// lib/src/wasm/wasm_bindings_ffi.dart
import 'dart:convert';
import 'dart:ffi' as ffi;

// ---------------------------------------------------------------------------
// Opaque types — only used as Pointer<X>
// ---------------------------------------------------------------------------

final class WasmEngineT extends ffi.Opaque {}

final class WasmStoreT extends ffi.Opaque {}

final class WasmModuleT extends ffi.Opaque {}

final class WasmInstanceT extends ffi.Opaque {}

final class WasmFuncT extends ffi.Opaque {}

final class WasmMemoryT extends ffi.Opaque {}

final class WasmExternT extends ffi.Opaque {}

final class WasmTrapT extends ffi.Opaque {}

final class WasmFunctypeT extends ffi.Opaque {}

final class WasmExterntypeT extends ffi.Opaque {}

final class WasmImporttypeT extends ffi.Opaque {}

final class WasmExporttypeT extends ffi.Opaque {}

// ---------------------------------------------------------------------------
// Structs
// ---------------------------------------------------------------------------

// wasm_byte_vec_t / wasm_name_t: { size_t size; uint8_t* data; }
final class WasmByteVec extends ffi.Struct {
  @ffi.Size()
  external int size;
  external ffi.Pointer<ffi.Uint8> data;
}

// wasm_val_t layout on 64-bit: kind(1) + padding(7) + union_value(8) = 16 bytes
// kind: 0=i32, 1=i64, 2=f32, 3=f64
// The union is represented as a single Int64 (rawValue) covering all variants.
//
// IMPORTANT: wasmer reads/writes this layout for wasm_func_call args/results and
// callback args (kind at byte 0). However, wasmer reads callback *results* with the
// value union at byte 0 and kind at byte 8 — see _setCallbackResult in wasm_runner_native.dart.
final class WasmVal extends ffi.Struct {
  @ffi.Uint8()
  external int kind;
  @ffi.Uint8()
  external int _pad0; // ignore: unused_field
  @ffi.Uint8()
  external int _pad1; // ignore: unused_field
  @ffi.Uint8()
  external int _pad2; // ignore: unused_field
  @ffi.Uint8()
  external int _pad3; // ignore: unused_field
  @ffi.Uint8()
  external int _pad4; // ignore: unused_field
  @ffi.Uint8()
  external int _pad5; // ignore: unused_field
  @ffi.Uint8()
  external int _pad6; // ignore: unused_field
  @ffi.Int64()
  external int rawValue; // read bits as i32/i64/f32/f64 per kind
}

// wasm_val_vec_t: { size_t size; wasm_val_t* data; }
final class WasmValVec extends ffi.Struct {
  @ffi.Size()
  external int size;
  external ffi.Pointer<WasmVal> data;
}

// wasm_extern_vec_t: { size_t size; wasm_extern_t** data; }
final class WasmExternVec extends ffi.Struct {
  @ffi.Size()
  external int size;
  external ffi.Pointer<ffi.Pointer<WasmExternT>> data;
}

// wasm_importtype_vec_t: { size_t size; wasm_importtype_t** data; }
final class WasmImporttypeVec extends ffi.Struct {
  @ffi.Size()
  external int size;
  external ffi.Pointer<ffi.Pointer<WasmImporttypeT>> data;
}

// wasm_exporttype_vec_t: { size_t size; wasm_exporttype_t** data; }
final class WasmExporttypeVec extends ffi.Struct {
  @ffi.Size()
  external int size;
  external ffi.Pointer<ffi.Pointer<WasmExporttypeT>> data;
}

// ---------------------------------------------------------------------------
// Callback typedef for host import functions.
// All WASM host imports share one signature:
//   wasm_trap_t* fn(const wasm_val_vec_t* args, wasm_val_vec_t* results)
// ---------------------------------------------------------------------------

typedef WasmFuncCallbackC = ffi.Pointer<WasmTrapT> Function(
    ffi.Pointer<WasmValVec> args, ffi.Pointer<WasmValVec> results);

// ---------------------------------------------------------------------------
// WasmerBindings: wraps all needed C function pointers
// ---------------------------------------------------------------------------

class WasmerBindings {
  WasmerBindings(ffi.DynamicLibrary lib) {
    _engineNew = lib.lookupFunction<ffi.Pointer<WasmEngineT> Function(),
        ffi.Pointer<WasmEngineT> Function()>('wasm_engine_new');
    _engineDelete = lib.lookupFunction<
        ffi.Void Function(ffi.Pointer<WasmEngineT>),
        void Function(ffi.Pointer<WasmEngineT>)>('wasm_engine_delete');
    _storeNew = lib.lookupFunction<
        ffi.Pointer<WasmStoreT> Function(ffi.Pointer<WasmEngineT>),
        ffi.Pointer<WasmStoreT> Function(
            ffi.Pointer<WasmEngineT>)>('wasm_store_new');
    _storeDelete = lib.lookupFunction<
        ffi.Void Function(ffi.Pointer<WasmStoreT>),
        void Function(ffi.Pointer<WasmStoreT>)>('wasm_store_delete');
    _byteVecNew = lib.lookupFunction<
        ffi.Void Function(
            ffi.Pointer<WasmByteVec>, ffi.Size, ffi.Pointer<ffi.Uint8>),
        void Function(ffi.Pointer<WasmByteVec>, int,
            ffi.Pointer<ffi.Uint8>)>('wasm_byte_vec_new');
    _byteVecNewEmpty = lib.lookupFunction<
        ffi.Void Function(ffi.Pointer<WasmByteVec>),
        void Function(ffi.Pointer<WasmByteVec>)>('wasm_byte_vec_new_empty');
    _byteVecDelete = lib.lookupFunction<
        ffi.Void Function(ffi.Pointer<WasmByteVec>),
        void Function(ffi.Pointer<WasmByteVec>)>('wasm_byte_vec_delete');
    _moduleNew = lib.lookupFunction<
        ffi.Pointer<WasmModuleT> Function(
            ffi.Pointer<WasmStoreT>, ffi.Pointer<WasmByteVec>),
        ffi.Pointer<WasmModuleT> Function(ffi.Pointer<WasmStoreT>,
            ffi.Pointer<WasmByteVec>)>('wasm_module_new');
    _moduleDelete = lib.lookupFunction<
        ffi.Void Function(ffi.Pointer<WasmModuleT>),
        void Function(ffi.Pointer<WasmModuleT>)>('wasm_module_delete');
    _moduleImports = lib.lookupFunction<
        ffi.Void Function(
            ffi.Pointer<WasmModuleT>, ffi.Pointer<WasmImporttypeVec>),
        void Function(ffi.Pointer<WasmModuleT>,
            ffi.Pointer<WasmImporttypeVec>)>('wasm_module_imports');
    _moduleExports = lib.lookupFunction<
        ffi.Void Function(
            ffi.Pointer<WasmModuleT>, ffi.Pointer<WasmExporttypeVec>),
        void Function(ffi.Pointer<WasmModuleT>,
            ffi.Pointer<WasmExporttypeVec>)>('wasm_module_exports');
    _importtypeModule = lib.lookupFunction<
        ffi.Pointer<WasmByteVec> Function(ffi.Pointer<WasmImporttypeT>),
        ffi.Pointer<WasmByteVec> Function(
            ffi.Pointer<WasmImporttypeT>)>('wasm_importtype_module');
    _importtypeName = lib.lookupFunction<
        ffi.Pointer<WasmByteVec> Function(ffi.Pointer<WasmImporttypeT>),
        ffi.Pointer<WasmByteVec> Function(
            ffi.Pointer<WasmImporttypeT>)>('wasm_importtype_name');
    _importtypeType = lib.lookupFunction<
        ffi.Pointer<WasmExterntypeT> Function(ffi.Pointer<WasmImporttypeT>),
        ffi.Pointer<WasmExterntypeT> Function(
            ffi.Pointer<WasmImporttypeT>)>('wasm_importtype_type');
    _importtypeVecNewEmpty = lib.lookupFunction<
        ffi.Void Function(ffi.Pointer<WasmImporttypeVec>),
        void Function(
            ffi.Pointer<WasmImporttypeVec>)>('wasm_importtype_vec_new_empty');
    _importtypeVecDelete = lib.lookupFunction<
        ffi.Void Function(ffi.Pointer<WasmImporttypeVec>),
        void Function(
            ffi.Pointer<WasmImporttypeVec>)>('wasm_importtype_vec_delete');
    _exporttypeName = lib.lookupFunction<
        ffi.Pointer<WasmByteVec> Function(ffi.Pointer<WasmExporttypeT>),
        ffi.Pointer<WasmByteVec> Function(
            ffi.Pointer<WasmExporttypeT>)>('wasm_exporttype_name');
    _exporttypeVecNewEmpty = lib.lookupFunction<
        ffi.Void Function(ffi.Pointer<WasmExporttypeVec>),
        void Function(ffi.Pointer<WasmExporttypeVec>)>(
        'wasm_exporttype_vec_new_empty');
    _exporttypeVecDelete = lib.lookupFunction<
        ffi.Void Function(ffi.Pointer<WasmExporttypeVec>),
        void Function(
            ffi.Pointer<WasmExporttypeVec>)>('wasm_exporttype_vec_delete');
    _externtypeAsFunctypeConst = lib.lookupFunction<
        ffi.Pointer<WasmFunctypeT> Function(ffi.Pointer<WasmExterntypeT>),
        ffi.Pointer<WasmFunctypeT> Function(ffi.Pointer<WasmExterntypeT>)>(
        'wasm_externtype_as_functype_const');
    _funcNew = lib.lookupFunction<
        ffi.Pointer<WasmFuncT> Function(
            ffi.Pointer<WasmStoreT>,
            ffi.Pointer<WasmFunctypeT>,
            ffi.Pointer<ffi.NativeFunction<WasmFuncCallbackC>>),
        ffi.Pointer<WasmFuncT> Function(
            ffi.Pointer<WasmStoreT>,
            ffi.Pointer<WasmFunctypeT>,
            ffi.Pointer<
                ffi.NativeFunction<WasmFuncCallbackC>>)>('wasm_func_new');
    _funcDelete = lib.lookupFunction<ffi.Void Function(ffi.Pointer<WasmFuncT>),
        void Function(ffi.Pointer<WasmFuncT>)>('wasm_func_delete');
    _funcAsExtern = lib.lookupFunction<
        ffi.Pointer<WasmExternT> Function(ffi.Pointer<WasmFuncT>),
        ffi.Pointer<WasmExternT> Function(
            ffi.Pointer<WasmFuncT>)>('wasm_func_as_extern');
    _funcCall = lib.lookupFunction<
        ffi.Pointer<WasmTrapT> Function(ffi.Pointer<WasmFuncT>,
            ffi.Pointer<WasmValVec>, ffi.Pointer<WasmValVec>),
        ffi.Pointer<WasmTrapT> Function(
            ffi.Pointer<WasmFuncT>,
            ffi.Pointer<WasmValVec>,
            ffi.Pointer<WasmValVec>)>('wasm_func_call');
    _valVecNewEmpty = lib.lookupFunction<
        ffi.Void Function(ffi.Pointer<WasmValVec>),
        void Function(ffi.Pointer<WasmValVec>)>('wasm_val_vec_new_empty');
    _valVecNewUninitialized = lib.lookupFunction<
        ffi.Void Function(ffi.Pointer<WasmValVec>, ffi.Size),
        void Function(ffi.Pointer<WasmValVec>,
            int)>('wasm_val_vec_new_uninitialized');
    _valVecDelete = lib.lookupFunction<
        ffi.Void Function(ffi.Pointer<WasmValVec>),
        void Function(ffi.Pointer<WasmValVec>)>('wasm_val_vec_delete');
    _externVecNewEmpty = lib.lookupFunction<
        ffi.Void Function(ffi.Pointer<WasmExternVec>),
        void Function(
            ffi.Pointer<WasmExternVec>)>('wasm_extern_vec_new_empty');
    _externVecNew = lib.lookupFunction<
        ffi.Void Function(ffi.Pointer<WasmExternVec>, ffi.Size,
            ffi.Pointer<ffi.Pointer<WasmExternT>>),
        void Function(ffi.Pointer<WasmExternVec>, int,
            ffi.Pointer<ffi.Pointer<WasmExternT>>)>('wasm_extern_vec_new');
    _externVecDelete = lib.lookupFunction<
        ffi.Void Function(ffi.Pointer<WasmExternVec>),
        void Function(ffi.Pointer<WasmExternVec>)>('wasm_extern_vec_delete');
    _externAsFunc = lib.lookupFunction<
        ffi.Pointer<WasmFuncT> Function(ffi.Pointer<WasmExternT>),
        ffi.Pointer<WasmFuncT> Function(
            ffi.Pointer<WasmExternT>)>('wasm_extern_as_func');
    _externAsMemory = lib.lookupFunction<
        ffi.Pointer<WasmMemoryT> Function(ffi.Pointer<WasmExternT>),
        ffi.Pointer<WasmMemoryT> Function(
            ffi.Pointer<WasmExternT>)>('wasm_extern_as_memory');
    _instanceNew = lib.lookupFunction<
        ffi.Pointer<WasmInstanceT> Function(
            ffi.Pointer<WasmStoreT>,
            ffi.Pointer<WasmModuleT>,
            ffi.Pointer<WasmExternVec>,
            ffi.Pointer<ffi.Pointer<WasmTrapT>>),
        ffi.Pointer<WasmInstanceT> Function(
            ffi.Pointer<WasmStoreT>,
            ffi.Pointer<WasmModuleT>,
            ffi.Pointer<WasmExternVec>,
            ffi.Pointer<ffi.Pointer<WasmTrapT>>)>('wasm_instance_new');
    _instanceDelete = lib.lookupFunction<
        ffi.Void Function(ffi.Pointer<WasmInstanceT>),
        void Function(ffi.Pointer<WasmInstanceT>)>('wasm_instance_delete');
    _instanceExports = lib.lookupFunction<
        ffi.Void Function(
            ffi.Pointer<WasmInstanceT>, ffi.Pointer<WasmExternVec>),
        void Function(ffi.Pointer<WasmInstanceT>,
            ffi.Pointer<WasmExternVec>)>('wasm_instance_exports');
    _memoryData = lib.lookupFunction<
        ffi.Pointer<ffi.Uint8> Function(ffi.Pointer<WasmMemoryT>),
        ffi.Pointer<ffi.Uint8> Function(
            ffi.Pointer<WasmMemoryT>)>('wasm_memory_data');
    _memoryDataSize = lib.lookupFunction<
        ffi.Size Function(ffi.Pointer<WasmMemoryT>),
        int Function(ffi.Pointer<WasmMemoryT>)>('wasm_memory_data_size');
    _memoryDelete = lib.lookupFunction<
        ffi.Void Function(ffi.Pointer<WasmMemoryT>),
        void Function(ffi.Pointer<WasmMemoryT>)>('wasm_memory_delete');
    _trapMessage = lib.lookupFunction<
        ffi.Void Function(ffi.Pointer<WasmTrapT>, ffi.Pointer<WasmByteVec>),
        void Function(ffi.Pointer<WasmTrapT>,
            ffi.Pointer<WasmByteVec>)>('wasm_trap_message');
    _trapDelete = lib.lookupFunction<ffi.Void Function(ffi.Pointer<WasmTrapT>),
        void Function(ffi.Pointer<WasmTrapT>)>('wasm_trap_delete');
  }

  late final ffi.Pointer<WasmEngineT> Function() _engineNew;
  late final void Function(ffi.Pointer<WasmEngineT>) _engineDelete;
  late final ffi.Pointer<WasmStoreT> Function(ffi.Pointer<WasmEngineT>)
      _storeNew;
  late final void Function(ffi.Pointer<WasmStoreT>) _storeDelete;
  late final void Function(
      ffi.Pointer<WasmByteVec>, int, ffi.Pointer<ffi.Uint8>) _byteVecNew;
  late final void Function(ffi.Pointer<WasmByteVec>) _byteVecNewEmpty;
  late final void Function(ffi.Pointer<WasmByteVec>) _byteVecDelete;
  late final ffi.Pointer<WasmModuleT> Function(
      ffi.Pointer<WasmStoreT>, ffi.Pointer<WasmByteVec>) _moduleNew;
  late final void Function(ffi.Pointer<WasmModuleT>) _moduleDelete;
  late final void Function(
          ffi.Pointer<WasmModuleT>, ffi.Pointer<WasmImporttypeVec>)
      _moduleImports;
  late final void Function(
          ffi.Pointer<WasmModuleT>, ffi.Pointer<WasmExporttypeVec>)
      _moduleExports;
  late final ffi.Pointer<WasmByteVec> Function(ffi.Pointer<WasmImporttypeT>)
      _importtypeModule;
  late final ffi.Pointer<WasmByteVec> Function(ffi.Pointer<WasmImporttypeT>)
      _importtypeName;
  late final ffi.Pointer<WasmExterntypeT> Function(
      ffi.Pointer<WasmImporttypeT>) _importtypeType;
  late final void Function(ffi.Pointer<WasmImporttypeVec>)
      _importtypeVecNewEmpty;
  late final void Function(ffi.Pointer<WasmImporttypeVec>)
      _importtypeVecDelete;
  late final ffi.Pointer<WasmByteVec> Function(ffi.Pointer<WasmExporttypeT>)
      _exporttypeName;
  late final void Function(ffi.Pointer<WasmExporttypeVec>)
      _exporttypeVecNewEmpty;
  late final void Function(ffi.Pointer<WasmExporttypeVec>)
      _exporttypeVecDelete;
  late final ffi.Pointer<WasmFunctypeT> Function(ffi.Pointer<WasmExterntypeT>)
      _externtypeAsFunctypeConst;
  late final ffi.Pointer<WasmFuncT> Function(
      ffi.Pointer<WasmStoreT>,
      ffi.Pointer<WasmFunctypeT>,
      ffi.Pointer<ffi.NativeFunction<WasmFuncCallbackC>>) _funcNew;
  late final void Function(ffi.Pointer<WasmFuncT>) _funcDelete;
  late final ffi.Pointer<WasmExternT> Function(ffi.Pointer<WasmFuncT>)
      _funcAsExtern;
  late final ffi.Pointer<WasmTrapT> Function(ffi.Pointer<WasmFuncT>,
      ffi.Pointer<WasmValVec>, ffi.Pointer<WasmValVec>) _funcCall;
  late final void Function(ffi.Pointer<WasmValVec>) _valVecNewEmpty;
  late final void Function(ffi.Pointer<WasmValVec>, int)
      _valVecNewUninitialized;
  late final void Function(ffi.Pointer<WasmValVec>) _valVecDelete;
  late final void Function(ffi.Pointer<WasmExternVec>) _externVecNewEmpty;
  late final void Function(ffi.Pointer<WasmExternVec>, int,
      ffi.Pointer<ffi.Pointer<WasmExternT>>) _externVecNew;
  late final void Function(ffi.Pointer<WasmExternVec>) _externVecDelete;
  late final ffi.Pointer<WasmFuncT> Function(ffi.Pointer<WasmExternT>)
      _externAsFunc;
  late final ffi.Pointer<WasmMemoryT> Function(ffi.Pointer<WasmExternT>)
      _externAsMemory;
  late final ffi.Pointer<WasmInstanceT> Function(
      ffi.Pointer<WasmStoreT>,
      ffi.Pointer<WasmModuleT>,
      ffi.Pointer<WasmExternVec>,
      ffi.Pointer<ffi.Pointer<WasmTrapT>>) _instanceNew;
  late final void Function(ffi.Pointer<WasmInstanceT>) _instanceDelete;
  late final void Function(
          ffi.Pointer<WasmInstanceT>, ffi.Pointer<WasmExternVec>)
      _instanceExports;
  late final ffi.Pointer<ffi.Uint8> Function(ffi.Pointer<WasmMemoryT>)
      _memoryData;
  late final int Function(ffi.Pointer<WasmMemoryT>) _memoryDataSize;
  late final void Function(ffi.Pointer<WasmMemoryT>) _memoryDelete;
  late final void Function(ffi.Pointer<WasmTrapT>, ffi.Pointer<WasmByteVec>)
      _trapMessage;
  late final void Function(ffi.Pointer<WasmTrapT>) _trapDelete;

  // Clean Dart wrappers
  ffi.Pointer<WasmEngineT> engineNew() => _engineNew();
  void engineDelete(ffi.Pointer<WasmEngineT> e) => _engineDelete(e);
  ffi.Pointer<WasmStoreT> storeNew(ffi.Pointer<WasmEngineT> e) => _storeNew(e);
  void storeDelete(ffi.Pointer<WasmStoreT> s) => _storeDelete(s);
  void byteVecNew(ffi.Pointer<WasmByteVec> out, int size,
          ffi.Pointer<ffi.Uint8> data) =>
      _byteVecNew(out, size, data);
  void byteVecNewEmpty(ffi.Pointer<WasmByteVec> out) => _byteVecNewEmpty(out);
  void byteVecDelete(ffi.Pointer<WasmByteVec> v) => _byteVecDelete(v);
  ffi.Pointer<WasmModuleT> moduleNew(
          ffi.Pointer<WasmStoreT> s, ffi.Pointer<WasmByteVec> b) =>
      _moduleNew(s, b);
  void moduleDelete(ffi.Pointer<WasmModuleT> m) => _moduleDelete(m);
  void moduleImports(
          ffi.Pointer<WasmModuleT> m, ffi.Pointer<WasmImporttypeVec> out) =>
      _moduleImports(m, out);
  void moduleExports(
          ffi.Pointer<WasmModuleT> m, ffi.Pointer<WasmExporttypeVec> out) =>
      _moduleExports(m, out);
  ffi.Pointer<WasmByteVec> importtypeModule(ffi.Pointer<WasmImporttypeT> t) =>
      _importtypeModule(t);
  ffi.Pointer<WasmByteVec> importtypeName(ffi.Pointer<WasmImporttypeT> t) =>
      _importtypeName(t);
  ffi.Pointer<WasmExterntypeT> importtypeType(
          ffi.Pointer<WasmImporttypeT> t) =>
      _importtypeType(t);
  void importtypeVecNewEmpty(ffi.Pointer<WasmImporttypeVec> out) =>
      _importtypeVecNewEmpty(out);
  void importtypeVecDelete(ffi.Pointer<WasmImporttypeVec> v) =>
      _importtypeVecDelete(v);
  ffi.Pointer<WasmByteVec> exporttypeName(ffi.Pointer<WasmExporttypeT> t) =>
      _exporttypeName(t);
  void exporttypeVecNewEmpty(ffi.Pointer<WasmExporttypeVec> out) =>
      _exporttypeVecNewEmpty(out);
  void exporttypeVecDelete(ffi.Pointer<WasmExporttypeVec> v) =>
      _exporttypeVecDelete(v);
  ffi.Pointer<WasmFunctypeT> externtypeAsFunctypeConst(
          ffi.Pointer<WasmExterntypeT> t) =>
      _externtypeAsFunctypeConst(t);
  ffi.Pointer<WasmFuncT> funcNew(
          ffi.Pointer<WasmStoreT> s,
          ffi.Pointer<WasmFunctypeT> t,
          ffi.Pointer<ffi.NativeFunction<WasmFuncCallbackC>> cb) =>
      _funcNew(s, t, cb);
  void funcDelete(ffi.Pointer<WasmFuncT> f) => _funcDelete(f);
  ffi.Pointer<WasmExternT> funcAsExtern(ffi.Pointer<WasmFuncT> f) =>
      _funcAsExtern(f);
  ffi.Pointer<WasmTrapT> funcCall(ffi.Pointer<WasmFuncT> f,
          ffi.Pointer<WasmValVec> a, ffi.Pointer<WasmValVec> r) =>
      _funcCall(f, a, r);
  void valVecNewEmpty(ffi.Pointer<WasmValVec> out) => _valVecNewEmpty(out);
  void valVecNewUninitialized(ffi.Pointer<WasmValVec> out, int size) =>
      _valVecNewUninitialized(out, size);
  void valVecDelete(ffi.Pointer<WasmValVec> v) => _valVecDelete(v);
  void externVecNewEmpty(ffi.Pointer<WasmExternVec> out) =>
      _externVecNewEmpty(out);
  void externVecNew(ffi.Pointer<WasmExternVec> out, int size,
          ffi.Pointer<ffi.Pointer<WasmExternT>> data) =>
      _externVecNew(out, size, data);
  void externVecDelete(ffi.Pointer<WasmExternVec> v) => _externVecDelete(v);
  ffi.Pointer<WasmFuncT> externAsFunc(ffi.Pointer<WasmExternT> e) =>
      _externAsFunc(e);
  ffi.Pointer<WasmMemoryT> externAsMemory(ffi.Pointer<WasmExternT> e) =>
      _externAsMemory(e);
  ffi.Pointer<WasmInstanceT> instanceNew(
          ffi.Pointer<WasmStoreT> s,
          ffi.Pointer<WasmModuleT> m,
          ffi.Pointer<WasmExternVec> i,
          ffi.Pointer<ffi.Pointer<WasmTrapT>> t) =>
      _instanceNew(s, m, i, t);
  void instanceDelete(ffi.Pointer<WasmInstanceT> i) => _instanceDelete(i);
  void instanceExports(
          ffi.Pointer<WasmInstanceT> i, ffi.Pointer<WasmExternVec> out) =>
      _instanceExports(i, out);
  ffi.Pointer<ffi.Uint8> memoryData(ffi.Pointer<WasmMemoryT> m) =>
      _memoryData(m);
  int memoryDataSize(ffi.Pointer<WasmMemoryT> m) => _memoryDataSize(m);
  void memoryDelete(ffi.Pointer<WasmMemoryT> m) => _memoryDelete(m);
  void trapMessage(
          ffi.Pointer<WasmTrapT> t, ffi.Pointer<WasmByteVec> out) =>
      _trapMessage(t, out);
  void trapDelete(ffi.Pointer<WasmTrapT> t) => _trapDelete(t);

  /// Read a wasm_byte_vec_t / wasm_name_t as a Dart String.
  static String readByteVec(ffi.Pointer<WasmByteVec> vec) {
    final bytes = List<int>.generate(
        vec.ref.size, (i) => (vec.ref.data + i).value);
    return utf8.decode(bytes);
  }
}
