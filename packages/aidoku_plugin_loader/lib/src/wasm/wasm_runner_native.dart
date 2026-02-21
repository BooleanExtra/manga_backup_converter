// lib/src/wasm/wasm_runner_native.dart
// ignore_for_file: avoid_dynamic_calls
import 'dart:ffi' as ffi;
import 'dart:io';
import 'dart:typed_data' show Uint8List;

import 'package:aidoku_plugin_loader/src/wasm/wasm_bindings_ffi.dart';
import 'package:aidoku_plugin_loader/src/wasm/wasm_bindings_generated.dart';
import 'package:ffi/ffi.dart' show calloc;

/// Native WASM runner backed by the wasmer runtime (https://wasmer.io).
///
/// Requires wasmer to be installed. Library is loaded from:
///   Linux:   ~/.wasmer/lib/libwasmer.so
///   macOS:   ~/.wasmer/lib/libwasmer.dylib
///   Windows: %USERPROFILE%\.wasmer\lib\wasmer.dll
///
/// **HTTP limitation**: WASM host imports are synchronous. The net::* imports
/// are stubbed (return -1) because async HTTP cannot run inside a synchronous
/// wasmer callback. Use the web runner for full HTTP support.
class WasmRunner {
  WasmRunner._({
    required WasmerBindings bindings,
    required ffi.Pointer<WasmEngineT> engine,
    required ffi.Pointer<WasmStoreT> store,
    required ffi.Pointer<WasmInstanceT> instance,
    required ffi.Pointer<WasmMemoryT> memory,
    required Map<String, ffi.Pointer<WasmExternT>> exports,
    required List<ffi.NativeCallable<WasmFuncCallbackC>> nativeCallables,
  }) : _bindings = bindings,
       _engine = engine,
       _store = store,
       _instance = instance,
       _memory = memory,
       _exports = exports,
       _nativeCallables = nativeCallables;

  final WasmerBindings _bindings;
  // ignore: unused_field
  final ffi.Pointer<WasmEngineT> _engine;
  // ignore: unused_field
  final ffi.Pointer<WasmStoreT> _store;
  // ignore: unused_field
  final ffi.Pointer<WasmInstanceT> _instance;
  final ffi.Pointer<WasmMemoryT> _memory;
  final Map<String, ffi.Pointer<WasmExternT>> _exports;
  // Keep NativeCallables alive for the lifetime of the runner
  // ignore: unused_field
  final List<ffi.NativeCallable<WasmFuncCallbackC>> _nativeCallables;

  // ---------------------------------------------------------------------------
  // Factory
  // ---------------------------------------------------------------------------

  static Future<WasmRunner> fromBytes(
    Uint8List wasmBytes, {
    Map<String, Map<String, Function>> imports = const <String, Map<String, Function>>{},
  }) async {
    final ffi.DynamicLibrary lib = _openWasmer();
    final bindings = WasmerBindings(lib);

    final ffi.Pointer<WasmEngineT> engine = bindings.engineNew();
    final ffi.Pointer<WasmStoreT> store = bindings.storeNew(engine);

    // Copy WASM bytes into native buffer and compile
    final ffi.Pointer<ffi.Uint8> nativeBuf = calloc<ffi.Uint8>(wasmBytes.length);
    for (var i = 0; i < wasmBytes.length; i++) {
      (nativeBuf + i).value = wasmBytes[i];
    }
    final ffi.Pointer<WasmByteVec> byteVec = calloc<WasmByteVec>();
    bindings.byteVecNew(byteVec, wasmBytes.length, nativeBuf);
    final ffi.Pointer<WasmModuleT> module = bindings.moduleNew(store, byteVec);
    bindings.byteVecDelete(byteVec);
    calloc
      ..free(byteVec)
      ..free(nativeBuf);

    if (module.address == 0) {
      throw const WasmRuntimeException('wasm_module_new failed — invalid WASM binary');
    }

    // Read export names BEFORE the module is freed
    final ffi.Pointer<WasmExporttypeVec> exportTypeVec = calloc<WasmExporttypeVec>();
    bindings.exporttypeVecNewEmpty(exportTypeVec);
    bindings.moduleExports(module, exportTypeVec);
    final exportNames = <String>[
      for (int i = 0; i < exportTypeVec.ref.size; i++)
        WasmerBindings.readByteVec(
          bindings.exporttypeName((exportTypeVec.ref.data + i).value),
        ),
    ];
    bindings.exporttypeVecDelete(exportTypeVec);
    calloc.free(exportTypeVec);

    // Build host import externs from import list
    final ffi.Pointer<WasmImporttypeVec> importTypeVec = calloc<WasmImporttypeVec>();
    bindings.importtypeVecNewEmpty(importTypeVec);
    bindings.moduleImports(module, importTypeVec);

    final nativeCallables = <ffi.NativeCallable<WasmFuncCallbackC>>[];
    final externPtrs = <ffi.Pointer<WasmExternT>>[];

    for (var i = 0; i < importTypeVec.ref.size; i++) {
      final ffi.Pointer<wasm_importtype_t> it = (importTypeVec.ref.data + i).value;
      final String modName = WasmerBindings.readByteVec(bindings.importtypeModule(it));
      final String fnName = WasmerBindings.readByteVec(bindings.importtypeName(it));
      final ffi.Pointer<WasmFunctypeT> funcType = bindings.externtypeAsFunctypeConst(bindings.importtypeType(it));

      final Function? dartFn = imports[modName]?[fnName];
      final int resultKind = bindings.functypeFirstResultKind(funcType);
      final ffi.NativeCallable<WasmFuncCallbackC> callable = _makeCallable(
        dartFn,
        resultKind: resultKind,
        debugName: '$modName::$fnName',
      );
      nativeCallables.add(callable);
      externPtrs.add(bindings.funcAsExtern(bindings.funcNew(store, funcType, callable.nativeFunction)));
    }

    bindings.importtypeVecDelete(importTypeVec);
    calloc.free(importTypeVec);

    // Build extern_vec for instantiation
    final ffi.Pointer<WasmExternVec> externVec = calloc<WasmExternVec>();
    if (externPtrs.isEmpty) {
      bindings.externVecNewEmpty(externVec);
    } else {
      final ffi.Pointer<ffi.Pointer<WasmExternT>> buf = calloc<ffi.Pointer<WasmExternT>>(externPtrs.length);
      for (var i = 0; i < externPtrs.length; i++) {
        (buf + i).value = externPtrs[i];
      }
      bindings.externVecNew(externVec, externPtrs.length, buf);
      calloc.free(buf);
    }

    final ffi.Pointer<ffi.Pointer<WasmTrapT>> trapOut = calloc<ffi.Pointer<WasmTrapT>>();
    final ffi.Pointer<WasmInstanceT> instance = bindings.instanceNew(store, module, externVec, trapOut);
    bindings.externVecDelete(externVec);
    calloc.free(externVec);
    bindings.moduleDelete(module);

    if (instance.address == 0) {
      final String msg = trapOut.value.address != 0 ? _readTrap(bindings, trapOut.value) : 'unknown error';
      calloc.free(trapOut);
      throw WasmRuntimeException('wasm_instance_new failed: $msg');
    }
    calloc.free(trapOut);

    // Get instance exports and build name→extern map
    final ffi.Pointer<WasmExternVec> exportVec = calloc<WasmExternVec>();
    bindings.externVecNewEmpty(exportVec);
    bindings.instanceExports(instance, exportVec);

    final exportMap = <String, ffi.Pointer<WasmExternT>>{};
    var memory = ffi.nullptr as ffi.Pointer<WasmMemoryT>;
    final int count = exportVec.ref.size < exportNames.length ? exportVec.ref.size : exportNames.length;
    for (var i = 0; i < count; i++) {
      final ffi.Pointer<wasm_extern_t> extern = (exportVec.ref.data + i).value;
      exportMap[exportNames[i]] = extern;
      if (exportNames[i] == 'memory') {
        memory = bindings.externAsMemory(extern);
      }
    }
    // exportVec data is owned by instance — don't delete the vec contents

    return WasmRunner._(
      bindings: bindings,
      engine: engine,
      store: store,
      instance: instance,
      memory: memory,
      exports: exportMap,
      nativeCallables: nativeCallables,
    );
  }

  // ---------------------------------------------------------------------------
  // Static utility — import enumeration (no instantiation)
  // ---------------------------------------------------------------------------

  /// Returns all imports declared by [wasmBytes] without instantiating the module.
  ///
  /// Each entry is a record:
  /// - `module`: import module name (e.g. `'std'`, `'net'`)
  /// - `name`: function name within that module
  /// - `resultKind`: wasm_valkind of the first result type
  ///   (0=i32, 1=i64, 2=f32, 3=f64, -1=void or non-function import)
  ///
  /// Safe to call with no import implementations — compiles but never instantiates.
  static List<({String module, String name, int resultKind})> listImports(
    Uint8List wasmBytes,
  ) {
    final ffi.DynamicLibrary lib = _openWasmer();
    final bindings = WasmerBindings(lib);
    final ffi.Pointer<WasmEngineT> engine = bindings.engineNew();
    final ffi.Pointer<WasmStoreT> store = bindings.storeNew(engine);

    final ffi.Pointer<ffi.Uint8> nativeBuf = calloc<ffi.Uint8>(wasmBytes.length);
    for (var i = 0; i < wasmBytes.length; i++) {
      (nativeBuf + i).value = wasmBytes[i];
    }
    final ffi.Pointer<WasmByteVec> byteVec = calloc<WasmByteVec>();
    bindings.byteVecNew(byteVec, wasmBytes.length, nativeBuf);
    final ffi.Pointer<WasmModuleT> module = bindings.moduleNew(store, byteVec);
    bindings.byteVecDelete(byteVec);
    calloc
      ..free(byteVec)
      ..free(nativeBuf);

    if (module.address == 0) {
      throw const WasmRuntimeException('wasm_module_new failed — invalid WASM binary');
    }

    final ffi.Pointer<WasmImporttypeVec> importTypeVec = calloc<WasmImporttypeVec>();
    bindings.importtypeVecNewEmpty(importTypeVec);
    bindings.moduleImports(module, importTypeVec);

    final result = <({String module, String name, int resultKind})>[];
    for (var i = 0; i < importTypeVec.ref.size; i++) {
      final ffi.Pointer<wasm_importtype_t> it = (importTypeVec.ref.data + i).value;
      final String mod = WasmerBindings.readByteVec(bindings.importtypeModule(it));
      final String nm = WasmerBindings.readByteVec(bindings.importtypeName(it));
      final ffi.Pointer<WasmExterntypeT> extType = bindings.importtypeType(it);
      final ffi.Pointer<WasmFunctypeT> fn = bindings.externtypeAsFunctypeConst(extType);
      final int rk = fn == ffi.nullptr ? -1 : bindings.functypeFirstResultKind(fn);
      result.add((module: mod, name: nm, resultKind: rk));
    }

    bindings.importtypeVecDelete(importTypeVec);
    calloc.free(importTypeVec);
    bindings.moduleDelete(module);

    return result;
  }

  // ---------------------------------------------------------------------------
  // Public interface
  // ---------------------------------------------------------------------------

  dynamic call(String name, List<Object?> args) {
    final ffi.Pointer<WasmExternT>? extern = _exports[name];
    if (extern == null) throw ArgumentError('No WASM export: $name');
    final ffi.Pointer<WasmFuncT> func = _bindings.externAsFunc(extern);
    if (func.address == 0) throw ArgumentError('Export $name is not a func');

    final ffi.Pointer<WasmValVec> argsVec = calloc<WasmValVec>();
    final ffi.Pointer<WasmValVec> resultsVec = calloc<WasmValVec>();

    if (args.isEmpty) {
      _bindings.valVecNewEmpty(argsVec);
    } else {
      _bindings.valVecNewUninitialized(argsVec, args.length);
      for (var i = 0; i < args.length; i++) {
        _setVal(argsVec.ref.data + i, args[i]);
      }
    }
    _bindings.valVecNewUninitialized(resultsVec, 1);

    final ffi.Pointer<WasmTrapT> trap = _bindings.funcCall(func, argsVec, resultsVec);
    _bindings.valVecDelete(argsVec);
    calloc.free(argsVec);

    if (trap.address != 0) {
      final String msg = _readTrap(_bindings, trap);
      _bindings.trapDelete(trap);
      _bindings.valVecDelete(resultsVec);
      calloc.free(resultsVec);
      throw WasmTrapException('WASM trap in $name: $msg');
    }

    final Object? result = resultsVec.ref.size > 0 ? _getVal(resultsVec.ref.data) : null;
    _bindings.valVecDelete(resultsVec);
    calloc.free(resultsVec);
    return result;
  }

  Uint8List readMemory(int offset, int length) {
    if (_memory.address == 0) throw StateError('No memory export');
    if (length == 0) return Uint8List(0);
    final int size = memorySize;
    if (offset < 0 || length < 0 || offset + length > size) {
      throw RangeError('readMemory($offset, $length): out of WASM memory bounds ($size bytes)');
    }
    final ffi.Pointer<ffi.Uint8> data = _bindings.memoryData(_memory);
    return Uint8List.fromList(List<int>.generate(length, (int i) => (data + offset + i).value));
  }

  void writeMemory(int offset, Uint8List bytes) {
    if (_memory.address == 0) throw StateError('No memory export');
    final ffi.Pointer<ffi.Uint8> data = _bindings.memoryData(_memory);
    for (var i = 0; i < bytes.length; i++) {
      (data + offset + i).value = bytes[i];
    }
  }

  int get memorySize {
    if (_memory.address == 0) return 0;
    return _bindings.memoryDataSize(_memory);
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  static ffi.DynamicLibrary _openWasmer() {
    final String home = Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'] ?? '';
    final String path;
    if (Platform.isLinux || Platform.isAndroid) {
      path = '$home/.wasmer/lib/libwasmer.so';
    } else if (Platform.isMacOS || Platform.isIOS) {
      path = '$home/.wasmer/lib/libwasmer.dylib';
    } else if (Platform.isWindows) {
      path = r'$home\.wasmer\lib\wasmer.dll'.replaceFirst(r'$home', home);
    } else {
      throw UnsupportedError('Native WASM not supported on ${Platform.operatingSystem}');
    }
    try {
      return ffi.DynamicLibrary.open(path);
    } catch (e) {
      throw WasmRuntimeException(
        'Cannot load wasmer from $path.\n'
        'Install wasmer: curl https://get.wasmer.io -sSfL | sh\n'
        'Error: $e',
      );
    }
  }

  /// Create a NativeCallable for a single host import.
  /// All WASM imports share the same C callback type:
  ///   wasm_trap_t* fn(const wasm_val_vec_t* args, wasm_val_vec_t* results)
  ///
  /// [resultKind] is the wasm_valkind of the first result type (0=I32, 1=I64,
  /// 2=F32, 3=F64, -1=void).  It is used to write a type-correct stub value
  /// when the Dart function is null, async, or throws.
  ///
  /// **Async limitation**: wasmer callbacks are synchronous. If the Dart
  /// function returns a Future (e.g. net::send), it cannot be awaited here.
  /// In that case a type-correct -1 stub is written instead.
  static ffi.NativeCallable<WasmFuncCallbackC> _makeCallable(
    Function? dartFn, {
    int resultKind = -1,
    String debugName = '',
  }) {
    return ffi.NativeCallable<WasmFuncCallbackC>.isolateLocal(
      (ffi.Pointer<WasmValVec> args, ffi.Pointer<WasmValVec> results) {
        try {
          if (dartFn == null) {
            // Unregistered import: write type-correct -1 stub.
            if (results.ref.size > 0) _setDefaultVal(results.ref.data, resultKind);
            return ffi.nullptr;
          }
          final dartArgs = <Object?>[
            for (int i = 0; i < args.ref.size; i++) _getVal(args.ref.data + i),
          ];
          final Object? result = Function.apply(dartFn, dartArgs);
          if (results.ref.size > 0) {
            if (result is int) {
              _setVal(results.ref.data, result);
            } else if (result is double) {
              _setVal(results.ref.data, result);
            } else {
              // Future (async not supported) or null: write type-correct stub.
              _setDefaultVal(results.ref.data, resultKind);
            }
          }
        } on Exception catch (e, st) {
          if (results.ref.size > 0) _setDefaultVal(results.ref.data, resultKind);
          // ignore: avoid_print
          print('[CB] exception in host import $debugName: $e\n$st');
        }
        return ffi.nullptr;
      },
    );
  }

  /// Write a type-correct stub value (-1 or -1.0) into a result slot.
  /// [kind] is the wasm_valkind: 0=I32, 1=I64, 2=F32, 3=F64.
  static void _setDefaultVal(ffi.Pointer<WasmVal> val, int kind) {
    switch (kind) {
      case 1: // I64
        val.ref.kind = 1;
        val.ref.of.i64 = -1;
      case 2: // F32
        val.ref.kind = 2;
        val.ref.of.f32 = -1.0;
      case 3: // F64
        val.ref.kind = 3;
        val.ref.of.f64 = -1.0;
      default: // I32 (0) and void/unknown (-1)
        val.ref.kind = 0;
        val.ref.of.i32 = -1;
    }
  }

  static void _setVal(ffi.Pointer<WasmVal> val, Object? v) {
    if (v is int) {
      val.ref.kind = 0; // WASM_I32
      val.ref.of.i32 = v;
    } else if (v is double) {
      val.ref.kind = 3; // WASM_F64
      val.ref.of.f64 = v;
    }
  }

  static Object? _getVal(ffi.Pointer<WasmVal> val) {
    switch (val.ref.kind) {
      case 0: // i32 — signed 32-bit
        return val.ref.of.i32;
      case 1: // i64
        return val.ref.of.i64;
      case 2: // f32
        return val.ref.of.f32;
      case 3: // f64
        return val.ref.of.f64;
      default:
        return null;
    }
  }

  static String _readTrap(WasmerBindings b, ffi.Pointer<WasmTrapT> trap) {
    final ffi.Pointer<WasmByteVec> msgVec = calloc<WasmByteVec>();
    b.trapMessage(trap, msgVec);
    final String msg = WasmerBindings.readByteVec(msgVec);
    b.byteVecDelete(msgVec);
    calloc.free(msgVec);
    return msg;
  }
}

class WasmRuntimeException implements Exception {
  const WasmRuntimeException(this.message);
  final String message;
  @override
  String toString() => 'WasmRuntimeException: $message';
}

class WasmTrapException implements Exception {
  const WasmTrapException(this.message);
  final String message;
  @override
  String toString() => 'WasmTrapException: $message';
}
