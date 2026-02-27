// Thin Dart-friendly wrapper over the @Native FFI bindings for wasm3.
//
// Provides PascalCase type aliases and a [Wasm3Bindings] class that delegates
// to the top-level @Native functions in wasm3_bindings_generated.dart.

import 'dart:convert';
import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart';
import 'package:wasm3/src/wasm3_bindings_generated.dart';
import 'package:wasm_runner/wasm_runner.dart';

export 'package:wasm3/src/wasm3_bindings_generated.dart'
    show M3ErrorInfo, M3ImportContext, M3RawCall, M3ValueType;
export 'package:wasm_runner/wasm_runner.dart'
    show WasmRuntimeException, WasmTrapException;

/// The native function signature inside [M3RawCall].
///
/// [M3RawCall] is `Pointer<NativeFunction<M3RawCallFn>>`, so this is the
/// actual function type needed for `NativeCallable`.
typedef M3RawCallFn =
    ffi.Pointer<ffi.Void> Function(
      ffi.Pointer<M3Runtime>,
      ffi.Pointer<M3ImportContext>,
      ffi.Pointer<ffi.Uint64>,
      ffi.Pointer<ffi.Void>,
    );

// ---------------------------------------------------------------------------
// Type aliases
// ---------------------------------------------------------------------------

typedef IM3Environment = ffi.Pointer<M3Environment>;
typedef IM3Runtime = ffi.Pointer<M3Runtime>;
typedef IM3Module = ffi.Pointer<M3Module>;
typedef IM3Function = ffi.Pointer<M3Function>;

/// `M3Result` is `const char*` — null pointer means success.
typedef M3Result = ffi.Pointer<ffi.Char>;

// ---------------------------------------------------------------------------
// Wasm3Bindings
// ---------------------------------------------------------------------------

class Wasm3Bindings {
  Wasm3Bindings();

  // -- Environment -----------------------------------------------------------

  IM3Environment newEnvironment() => m3_NewEnvironment();

  void freeEnvironment(IM3Environment env) => m3_FreeEnvironment(env);

  // -- Runtime ---------------------------------------------------------------

  IM3Runtime newRuntime(IM3Environment env, int stackSize) =>
      m3_NewRuntime(env, stackSize, ffi.nullptr);

  void freeRuntime(IM3Runtime rt) => m3_FreeRuntime(rt);

  ffi.Pointer<ffi.Uint8> getMemory(
    IM3Runtime rt,
    ffi.Pointer<ffi.Uint32> outSize,
  ) => m3_GetMemory(rt, outSize, 0);

  int getMemorySize(IM3Runtime rt) => m3_GetMemorySize(rt);

  // -- Module ----------------------------------------------------------------

  /// Parse a WASM binary into a module. The [wasmBytes] buffer must remain
  /// valid for the lifetime of the module.
  M3Result parseModule(
    IM3Environment env,
    ffi.Pointer<ffi.Pointer<M3Module>> outModule,
    ffi.Pointer<ffi.Uint8> wasmBytes,
    int length,
  ) => m3_ParseModule(env, outModule, wasmBytes, length);

  void freeModule(IM3Module mod) => m3_FreeModule(mod);

  /// Load a module into a runtime. Ownership transfers to the runtime on
  /// success — do NOT call [freeModule] after a successful load.
  M3Result loadModule(IM3Runtime rt, IM3Module mod) => m3_LoadModule(rt, mod);

  M3Result runStart(IM3Module mod) => m3_RunStart(mod);

  // -- Linking ---------------------------------------------------------------

  M3Result linkRawFunctionEx(
    IM3Module mod,
    ffi.Pointer<ffi.Char> moduleName,
    ffi.Pointer<ffi.Char> functionName,
    ffi.Pointer<ffi.Char> signature,
    M3RawCall rawCall,
    ffi.Pointer<ffi.Void> userdata,
  ) => m3_LinkRawFunctionEx(
    mod,
    moduleName,
    functionName,
    signature,
    rawCall,
    userdata,
  );

  // -- Function invocation ---------------------------------------------------

  M3Result findFunction(
    ffi.Pointer<ffi.Pointer<M3Function>> outFunc,
    IM3Runtime rt,
    ffi.Pointer<ffi.Char> name,
  ) => m3_FindFunction(outFunc, rt, name);

  M3Result call(
    IM3Function func,
    int argc,
    ffi.Pointer<ffi.Pointer<ffi.Void>> argPtrs,
  ) => m3_Call(func, argc, argPtrs);

  M3Result getResults(
    IM3Function func,
    int retc,
    ffi.Pointer<ffi.Pointer<ffi.Void>> retPtrs,
  ) => m3_GetResults(func, retc, retPtrs);

  int getArgCount(IM3Function func) => m3_GetArgCount(func);

  int getRetCount(IM3Function func) => m3_GetRetCount(func);

  M3ValueType getRetType(IM3Function func, int index) =>
      m3_GetRetType(func, index);

  M3ValueType getArgType(IM3Function func, int index) =>
      m3_GetArgType(func, index);

  String getFunctionName(IM3Function func) {
    final ffi.Pointer<ffi.Char> name = m3_GetFunctionName(func);
    if (name == ffi.nullptr) return '';
    return name.cast<Utf8>().toDartString();
  }

  // -- Error info ------------------------------------------------------------

  void getErrorInfo(IM3Runtime rt, ffi.Pointer<M3ErrorInfo> outInfo) =>
      m3_GetErrorInfo(rt, outInfo);

  void resetErrorInfo(IM3Runtime rt) => m3_ResetErrorInfo(rt);

  // -- Helpers ---------------------------------------------------------------

  /// Check an M3Result — null pointer means success, non-null is an error
  /// string.
  static void checkResult(M3Result result, {String? context}) {
    if (result != ffi.nullptr) {
      final String msg = result.cast<Utf8>().toDartString();
      final prefix = context != null ? '$context: ' : '';
      if (msg.startsWith('[trap]')) {
        throw WasmTrapException('$prefix$msg');
      }
      throw WasmRuntimeException('$prefix$msg');
    }
  }

  /// Allocate a native UTF-8 string. Caller must free with `calloc.free()`.
  static ffi.Pointer<ffi.Char> allocString(String s) {
    final List<int> encoded = utf8.encode(s);
    final ffi.Pointer<ffi.Uint8> buf = calloc<ffi.Uint8>(encoded.length + 1);
    for (var i = 0; i < encoded.length; i++) {
      (buf + i).value = encoded[i];
    }
    (buf + encoded.length).value = 0; // null terminator
    return buf.cast<ffi.Char>();
  }

  /// Allocate a native buffer and copy [bytes] into it. Caller must free with
  /// `malloc.free()`.
  static ffi.Pointer<ffi.Uint8> allocBytes(List<int> bytes) {
    final ffi.Pointer<ffi.Uint8> buf = malloc<ffi.Uint8>(bytes.length);
    for (var i = 0; i < bytes.length; i++) {
      (buf + i).value = bytes[i];
    }
    return buf;
  }
}
