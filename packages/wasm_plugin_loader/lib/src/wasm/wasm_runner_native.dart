// lib/src/wasm/wasm_runner_native.dart
// ignore_for_file: avoid_dynamic_calls
import 'dart:ffi' as ffi;
import 'dart:io';
import 'dart:typed_data' show Uint8List;

import 'package:ffi/ffi.dart' show calloc;

import 'package:wasm_plugin_loader/src/wasm/wasm_bindings_ffi.dart';

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
    Map<String, Map<String, Function>> imports = const {},
  }) async {
    final lib = _openWasmer();
    final bindings = WasmerBindings(lib);

    final engine = bindings.engineNew();
    final store = bindings.storeNew(engine);

    // Copy WASM bytes into native buffer and compile
    final nativeBuf = calloc<ffi.Uint8>(wasmBytes.length);
    for (var i = 0; i < wasmBytes.length; i++) {
      (nativeBuf + i).value = wasmBytes[i];
    }
    final byteVec = calloc<WasmByteVec>();
    bindings.byteVecNew(byteVec, wasmBytes.length, nativeBuf);
    final module = bindings.moduleNew(store, byteVec);
    bindings.byteVecDelete(byteVec);
    calloc
      ..free(byteVec)
      ..free(nativeBuf);

    if (module.address == 0) {
      throw const WasmRuntimeException('wasm_module_new failed — invalid WASM binary');
    }

    // Read export names BEFORE the module is freed
    final exportTypeVec = calloc<WasmExporttypeVec>();
    bindings.exporttypeVecNewEmpty(exportTypeVec);
    bindings.moduleExports(module, exportTypeVec);
    final exportNames = <String>[
      for (var i = 0; i < exportTypeVec.ref.size; i++)
        WasmerBindings.readByteVec(
          bindings.exporttypeName((exportTypeVec.ref.data + i).value),
        ),
    ];
    bindings.exporttypeVecDelete(exportTypeVec);
    calloc.free(exportTypeVec);

    // Build host import externs from import list
    final importTypeVec = calloc<WasmImporttypeVec>();
    bindings.importtypeVecNewEmpty(importTypeVec);
    bindings.moduleImports(module, importTypeVec);

    final nativeCallables = <ffi.NativeCallable<WasmFuncCallbackC>>[];
    final externPtrs = <ffi.Pointer<WasmExternT>>[];

    for (var i = 0; i < importTypeVec.ref.size; i++) {
      final it = (importTypeVec.ref.data + i).value;
      final modName = WasmerBindings.readByteVec(bindings.importtypeModule(it));
      final fnName = WasmerBindings.readByteVec(bindings.importtypeName(it));
      final funcType = bindings.externtypeAsFunctypeConst(bindings.importtypeType(it));

      final dartFn = imports[modName]?[fnName];
      final resultKind = bindings.functypeFirstResultKind(funcType);
      final callable = _makeCallable(dartFn, resultKind: resultKind, debugName: '$modName::$fnName');
      nativeCallables.add(callable);
      externPtrs.add(bindings.funcAsExtern(bindings.funcNew(store, funcType, callable.nativeFunction)));
    }

    bindings.importtypeVecDelete(importTypeVec);
    calloc.free(importTypeVec);

    // Build extern_vec for instantiation
    final externVec = calloc<WasmExternVec>();
    if (externPtrs.isEmpty) {
      bindings.externVecNewEmpty(externVec);
    } else {
      final buf = calloc<ffi.Pointer<WasmExternT>>(externPtrs.length);
      for (var i = 0; i < externPtrs.length; i++) {
        (buf + i).value = externPtrs[i];
      }
      bindings.externVecNew(externVec, externPtrs.length, buf);
      calloc.free(buf);
    }

    final trapOut = calloc<ffi.Pointer<WasmTrapT>>();
    final instance = bindings.instanceNew(store, module, externVec, trapOut);
    bindings.externVecDelete(externVec);
    calloc.free(externVec);
    bindings.moduleDelete(module);

    if (instance.address == 0) {
      final msg = trapOut.value.address != 0 ? _readTrap(bindings, trapOut.value) : 'unknown error';
      calloc.free(trapOut);
      throw WasmRuntimeException('wasm_instance_new failed: $msg');
    }
    calloc.free(trapOut);

    // Get instance exports and build name→extern map
    final exportVec = calloc<WasmExternVec>();
    bindings.externVecNewEmpty(exportVec);
    bindings.instanceExports(instance, exportVec);

    final exportMap = <String, ffi.Pointer<WasmExternT>>{};
    var memory = ffi.nullptr as ffi.Pointer<WasmMemoryT>;
    final count = exportVec.ref.size < exportNames.length ? exportVec.ref.size : exportNames.length;
    for (var i = 0; i < count; i++) {
      final extern = (exportVec.ref.data + i).value;
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
  // Public interface
  // ---------------------------------------------------------------------------

  dynamic call(String name, List<Object?> args) {
    final extern = _exports[name];
    if (extern == null) throw ArgumentError('No WASM export: $name');
    final func = _bindings.externAsFunc(extern);
    if (func.address == 0) throw ArgumentError('Export $name is not a func');

    final argsVec = calloc<WasmValVec>();
    final resultsVec = calloc<WasmValVec>();

    if (args.isEmpty) {
      _bindings.valVecNewEmpty(argsVec);
    } else {
      _bindings.valVecNewUninitialized(argsVec, args.length);
      for (var i = 0; i < args.length; i++) {
        _setVal(argsVec.ref.data + i, args[i]);
      }
    }
    _bindings.valVecNewUninitialized(resultsVec, 1);

    final trap = _bindings.funcCall(func, argsVec, resultsVec);
    _bindings.valVecDelete(argsVec);
    calloc.free(argsVec);

    if (trap.address != 0) {
      final msg = _readTrap(_bindings, trap);
      _bindings.trapDelete(trap);
      _bindings.valVecDelete(resultsVec);
      calloc.free(resultsVec);
      throw WasmTrapException('WASM trap in $name: $msg');
    }

    final result = resultsVec.ref.size > 0 ? _getVal(resultsVec.ref.data) : null;
    _bindings.valVecDelete(resultsVec);
    calloc.free(resultsVec);
    return result;
  }

  Uint8List readMemory(int offset, int length) {
    if (_memory.address == 0) throw StateError('No memory export');
    if (length == 0) return Uint8List(0);
    final size = memorySize;
    if (offset < 0 || length < 0 || offset + length > size) {
      throw RangeError('readMemory($offset, $length): out of WASM memory bounds ($size bytes)');
    }
    final data = _bindings.memoryData(_memory);
    return Uint8List.fromList(List.generate(length, (i) => (data + offset + i).value));
  }

  void writeMemory(int offset, Uint8List bytes) {
    if (_memory.address == 0) throw StateError('No memory export');
    final data = _bindings.memoryData(_memory);
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
    final home = Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'] ?? '';
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
            for (var i = 0; i < args.ref.size; i++) _getVal(args.ref.data + i),
          ];
          final result = Function.apply(dartFn, dartArgs);
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
        } catch (e, st) {
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
    final msgVec = calloc<WasmByteVec>();
    b.trapMessage(trap, msgVec);
    final msg = WasmerBindings.readByteVec(msgVec);
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
