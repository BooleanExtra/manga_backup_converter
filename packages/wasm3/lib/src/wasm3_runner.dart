// ignore_for_file: avoid_dynamic_calls
import 'dart:convert';
import 'dart:ffi' as ffi;
import 'dart:typed_data' show Uint8List;

import 'package:ffi/ffi.dart' show calloc, malloc;
import 'package:wasm3/src/wasm3_bindings.dart';
import 'package:wasm3/src/wasm3_bindings_generated.dart';

export 'package:wasm3/src/wasm3_bindings.dart'
    show WasmRuntimeException, WasmTrapException;

/// Native WASM runner backed by the wasm3 interpreter.
///
/// wasm3 is a pure C interpreter with **no signal handlers** — traps propagate
/// via return values, making it safe to coexist with JNI (no VEH conflicts).
///
/// The wasm3 library is compiled from vendored source via `native_toolchain_c`
/// (see `hook/build.dart`).
class Wasm3Runner {
  Wasm3Runner._({
    required Wasm3Bindings bindings,
    required ffi.Pointer<M3Environment> environment,
    required ffi.Pointer<M3Runtime> runtime,
    required ffi.Pointer<M3Module> module,
    required ffi.Pointer<ffi.Uint8> wasmBuf,
    required ffi.NativeCallable<M3RawCallFn> callable,
    required Set<int> callbackIds,
  }) : _bindings = bindings,
       _environment = environment,
       _runtime = runtime,
       _module = module,
       _wasmBuf = wasmBuf,
       _callable = callable,
       _callbackIds = callbackIds;

  final Wasm3Bindings _bindings;
  final ffi.Pointer<M3Environment> _environment;
  final ffi.Pointer<M3Runtime> _runtime;
  // Module is owned by the runtime after loading — kept for reference only.
  // ignore: unused_field
  final ffi.Pointer<M3Module> _module;
  // wasm3 requires the WASM bytes to remain valid for the module's lifetime.
  final ffi.Pointer<ffi.Uint8> _wasmBuf;
  // Single NativeCallable shared by all host import callbacks.
  final ffi.NativeCallable<M3RawCallFn> _callable;
  // IDs registered in _callbackMap for this runner instance.
  final Set<int> _callbackIds;

  bool _disposed = false;

  // ---------------------------------------------------------------------------
  // Static callback dispatch
  // ---------------------------------------------------------------------------

  /// Global map of callback ID → Dart function + metadata.
  static final Map<int, _CallbackEntry> _callbackMap = {};
  static int _nextCallbackId = 1;

  /// The shared M3RawCall implementation dispatched via userdata ID.
  static ffi.Pointer<ffi.Void> _rawCallback(
    ffi.Pointer<M3Runtime> runtime,
    ffi.Pointer<M3ImportContext> ctx,
    ffi.Pointer<ffi.Uint64> sp,
    ffi.Pointer<ffi.Void> mem,
  ) {
    final int id = ctx.ref.userdata.address;
    final _CallbackEntry? entry = _callbackMap[id];
    if (entry == null) return ffi.nullptr;

    final ffi.Pointer<M3Function> func = ctx.ref.function;
    final int retCount = m3_GetRetCount(func);
    final int argCount = m3_GetArgCount(func);

    try {
      if (entry.fn == null) {
        // Unregistered import — write type-correct stub.
        if (retCount > 0) {
          _writeDefaultReturn(sp, m3_GetRetType(func, 0));
        }
        return ffi.nullptr;
      }

      // Read arguments from the stack.
      final dartArgs = <Object?>[];
      for (var i = 0; i < argCount; i++) {
        final M3ValueType type = m3_GetArgType(func, i);
        dartArgs.add(_readStackSlot(sp + retCount + i, type));
      }

      final Object? result = Function.apply(entry.fn!, dartArgs);

      // Write return value.
      if (retCount > 0) {
        if (result is int) {
          _writeStackSlot(sp, result, m3_GetRetType(func, 0));
        } else if (result is double) {
          _writeStackSlotDouble(sp, result, m3_GetRetType(func, 0));
        } else {
          // Future (async not supported) or null → type-correct stub.
          _writeDefaultReturn(sp, m3_GetRetType(func, 0));
        }
      }
    } on Object catch (e, st) {
      if (retCount > 0) {
        _writeDefaultReturn(sp, m3_GetRetType(func, 0));
      }
      entry.onLog?.call(
        '[CB] ${e is Error ? 'error' : 'exception'} in host import '
        '${entry.name}: $e\n$st',
      );
    }
    return ffi.nullptr;
  }

  // ---------------------------------------------------------------------------
  // Factory
  // ---------------------------------------------------------------------------

  /// Create a runner from raw WASM bytes.
  ///
  /// [imports] maps `module → name → Dart function`. Functions receive
  /// positional `int`/`double` args matching the WASM signature and should
  /// return `int`, `double`, or `null`.
  ///
  /// [stackSize] is the wasm3 interpreter stack size in bytes (default 64 KB).
  static Future<Wasm3Runner> fromBytes(
    Uint8List wasmBytes, {
    Map<String, Map<String, Function>> imports =
        const <String, Map<String, Function>>{},
    void Function(String message)? onLog,
    int stackSize = 64 * 1024,
  }) async {
    final bindings = Wasm3Bindings();
    final ffi.Pointer<M3Environment> env = bindings.newEnvironment();
    final ffi.Pointer<M3Runtime> rt = bindings.newRuntime(env, stackSize);

    // Copy WASM bytes into a native buffer. wasm3 requires the buffer to
    // remain valid for the lifetime of the module.
    final ffi.Pointer<ffi.Uint8> wasmBuf = Wasm3Bindings.allocBytes(wasmBytes);

    // Parse module.
    final ffi.Pointer<ffi.Pointer<M3Module>> moduleOut =
        calloc<ffi.Pointer<M3Module>>();
    try {
      Wasm3Bindings.checkResult(
        bindings.parseModule(env, moduleOut, wasmBuf, wasmBytes.length),
        context: 'm3_ParseModule',
      );
    } on Object {
      calloc.free(moduleOut);
      malloc.free(wasmBuf);
      bindings.freeRuntime(rt);
      bindings.freeEnvironment(env);
      rethrow;
    }
    final ffi.Pointer<M3Module> mod = moduleOut.value;
    calloc.free(moduleOut);

    // Load module into runtime (transfers ownership).
    try {
      Wasm3Bindings.checkResult(
        bindings.loadModule(rt, mod),
        context: 'm3_LoadModule',
      );
    } on Object {
      bindings.freeModule(mod);
      malloc.free(wasmBuf);
      bindings.freeRuntime(rt);
      bindings.freeEnvironment(env);
      rethrow;
    }

    // Create the shared NativeCallable for all host import callbacks.
    final callable = ffi.NativeCallable<M3RawCallFn>.isolateLocal(
      _rawCallback,
    );
    final callbackIds = <int>{};

    // Link host imports. wasm3 doesn't support wildcard linking, so we parse
    // the WASM import section to enumerate all (module, function) pairs, then
    // link stubs for unmatched ones and Dart functions for matched ones.
    final List<({String module, String name})> wasmImports =
        _parseImportSection(wasmBytes);

    for (final (:String module, :String name) in wasmImports) {
      final Function? dartFn = imports[module]?[name];
      final int id = _nextCallbackId++;
      _callbackMap[id] = _CallbackEntry(
        fn: dartFn,
        onLog: onLog,
        name: '$module::$name',
      );
      callbackIds.add(id);

      final ffi.Pointer<ffi.Char> modNamePtr = Wasm3Bindings.allocString(
        module,
      );
      final ffi.Pointer<ffi.Char> fnNamePtr = Wasm3Bindings.allocString(name);
      bindings.linkRawFunctionEx(
        mod,
        modNamePtr,
        fnNamePtr,
        ffi.nullptr.cast(), // wildcard signature
        callable.nativeFunction,
        ffi.Pointer<ffi.Void>.fromAddress(id),
      );
      calloc
        ..free(modNamePtr)
        ..free(fnNamePtr);
    }

    return Wasm3Runner._(
      bindings: bindings,
      environment: env,
      runtime: rt,
      module: mod,
      wasmBuf: wasmBuf,
      callable: callable,
      callbackIds: callbackIds,
    );
  }

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Call a WASM export function by name.
  ///
  /// Returns `int`, `double`, or `null` depending on the function's return
  /// type.
  dynamic call(String name, List<Object?> args) {
    _checkNotDisposed();
    final ffi.Pointer<ffi.Pointer<M3Function>> funcOut =
        calloc<ffi.Pointer<M3Function>>();
    final ffi.Pointer<ffi.Char> namePtr = Wasm3Bindings.allocString(name);

    try {
      Wasm3Bindings.checkResult(
        _bindings.findFunction(funcOut, _runtime, namePtr),
        context: 'finding export "$name"',
      );
    } on Object {
      calloc
        ..free(funcOut)
        ..free(namePtr);
      rethrow;
    }
    final ffi.Pointer<M3Function> func = funcOut.value;
    calloc
      ..free(funcOut)
      ..free(namePtr);

    // m3_Call takes an array of pointers-to-values.
    // Allocate a native slot per argument.
    final ffi.Pointer<ffi.Pointer<ffi.Void>> argPtrs =
        calloc<ffi.Pointer<ffi.Void>>(args.isEmpty ? 1 : args.length);
    final argSlots = <ffi.Pointer<ffi.Void>>[];

    for (var i = 0; i < args.length; i++) {
      final Object? arg = args[i];
      if (arg is int) {
        // Determine arg type to choose correct native width.
        final M3ValueType type = _bindings.getArgType(func, i);
        if (type == M3ValueType.c_m3Type_i64) {
          final ffi.Pointer<ffi.Int64> slot = calloc<ffi.Int64>();
          slot.value = arg;
          (argPtrs + i).value = slot.cast();
          argSlots.add(slot.cast());
        } else {
          // Default to i32.
          final ffi.Pointer<ffi.Int32> slot = calloc<ffi.Int32>();
          slot.value = arg;
          (argPtrs + i).value = slot.cast();
          argSlots.add(slot.cast());
        }
      } else if (arg is double) {
        final M3ValueType type = _bindings.getArgType(func, i);
        if (type == M3ValueType.c_m3Type_f32) {
          final ffi.Pointer<ffi.Float> slot = calloc<ffi.Float>();
          slot.value = arg;
          (argPtrs + i).value = slot.cast();
          argSlots.add(slot.cast());
        } else {
          final ffi.Pointer<ffi.Double> slot = calloc<ffi.Double>();
          slot.value = arg;
          (argPtrs + i).value = slot.cast();
          argSlots.add(slot.cast());
        }
      }
    }

    try {
      Wasm3Bindings.checkResult(
        _bindings.call(func, args.length, argPtrs),
        context: 'calling "$name"',
      );
    } on Object {
      for (final slot in argSlots) {
        calloc.free(slot);
      }
      calloc.free(argPtrs);
      rethrow;
    }

    for (final slot in argSlots) {
      calloc.free(slot);
    }
    calloc.free(argPtrs);

    // Read return value.
    final int retCount = _bindings.getRetCount(func);
    if (retCount == 0) return null;

    final M3ValueType retType = _bindings.getRetType(func, 0);
    return _readResult(func, retType);
  }

  /// Read [length] bytes from WASM linear memory starting at [offset].
  Uint8List readMemory(int offset, int length) {
    _checkNotDisposed();
    if (length == 0) return Uint8List(0);
    final int size = memorySize;
    if (offset < 0 || length < 0 || offset + length > size) {
      throw WasmRuntimeException(
        'readMemory($offset, $length): out of bounds ($size bytes)',
      );
    }
    final ffi.Pointer<ffi.Uint32> sizeOut = calloc<ffi.Uint32>();
    final ffi.Pointer<ffi.Uint8> mem = _bindings.getMemory(_runtime, sizeOut);
    calloc.free(sizeOut);
    return Uint8List.fromList(
      List<int>.generate(length, (int i) => (mem + offset + i).value),
    );
  }

  /// Write [bytes] to WASM linear memory at [offset].
  void writeMemory(int offset, Uint8List bytes) {
    _checkNotDisposed();
    if (bytes.isEmpty) return;
    final int size = memorySize;
    if (offset < 0 || offset + bytes.length > size) {
      throw WasmRuntimeException(
        'writeMemory($offset, ${bytes.length}): out of bounds ($size bytes)',
      );
    }
    final ffi.Pointer<ffi.Uint32> sizeOut = calloc<ffi.Uint32>();
    final ffi.Pointer<ffi.Uint8> mem = _bindings.getMemory(_runtime, sizeOut);
    calloc.free(sizeOut);
    for (var i = 0; i < bytes.length; i++) {
      (mem + offset + i).value = bytes[i];
    }
  }

  /// Total WASM linear memory size in bytes.
  int get memorySize {
    _checkNotDisposed();
    return _bindings.getMemorySize(_runtime);
  }

  /// Release all native resources.
  void dispose() {
    if (_disposed) return;
    _disposed = true;

    // Remove callback entries for this runner.
    for (final int id in _callbackIds) {
      _callbackMap.remove(id);
    }

    _callable.close();
    // Runtime owns the module — freeRuntime frees both.
    _bindings.freeRuntime(_runtime);
    _bindings.freeEnvironment(_environment);
    malloc.free(_wasmBuf);
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  void _checkNotDisposed() {
    if (_disposed) throw const WasmRuntimeException('Runner is disposed');
  }

  /// Read a single return value from a function after m3_Call.
  Object? _readResult(ffi.Pointer<M3Function> func, M3ValueType retType) {
    switch (retType) {
      case M3ValueType.c_m3Type_i32:
        final ffi.Pointer<ffi.Int32> slot = calloc<ffi.Int32>();
        final ffi.Pointer<ffi.Pointer<ffi.Void>> retPtrs =
            calloc<ffi.Pointer<ffi.Void>>();
        retPtrs.value = slot.cast();
        _bindings.getResults(func, 1, retPtrs);
        final int value = slot.value;
        calloc
          ..free(slot)
          ..free(retPtrs);
        return value;
      case M3ValueType.c_m3Type_i64:
        final ffi.Pointer<ffi.Int64> slot = calloc<ffi.Int64>();
        final ffi.Pointer<ffi.Pointer<ffi.Void>> retPtrs =
            calloc<ffi.Pointer<ffi.Void>>();
        retPtrs.value = slot.cast();
        _bindings.getResults(func, 1, retPtrs);
        final int value = slot.value;
        calloc
          ..free(slot)
          ..free(retPtrs);
        return value;
      case M3ValueType.c_m3Type_f32:
        final ffi.Pointer<ffi.Float> slot = calloc<ffi.Float>();
        final ffi.Pointer<ffi.Pointer<ffi.Void>> retPtrs =
            calloc<ffi.Pointer<ffi.Void>>();
        retPtrs.value = slot.cast();
        _bindings.getResults(func, 1, retPtrs);
        final double value = slot.value;
        calloc
          ..free(slot)
          ..free(retPtrs);
        return value;
      case M3ValueType.c_m3Type_f64:
        final ffi.Pointer<ffi.Double> slot = calloc<ffi.Double>();
        final ffi.Pointer<ffi.Pointer<ffi.Void>> retPtrs =
            calloc<ffi.Pointer<ffi.Void>>();
        retPtrs.value = slot.cast();
        _bindings.getResults(func, 1, retPtrs);
        final double value = slot.value;
        calloc
          ..free(slot)
          ..free(retPtrs);
        return value;
      default:
        return null;
    }
  }

  // ---------------------------------------------------------------------------
  // Stack slot helpers (used in M3RawCall callback)
  // ---------------------------------------------------------------------------

  /// Read a value from a uint64_t stack slot based on its M3ValueType.
  static Object? _readStackSlot(
    ffi.Pointer<ffi.Uint64> slot,
    M3ValueType type,
  ) {
    switch (type) {
      case M3ValueType.c_m3Type_i32:
        return slot.cast<ffi.Int32>().value;
      case M3ValueType.c_m3Type_i64:
        return slot.cast<ffi.Int64>().value;
      case M3ValueType.c_m3Type_f32:
        return slot.cast<ffi.Float>().value;
      case M3ValueType.c_m3Type_f64:
        return slot.cast<ffi.Double>().value;
      default:
        return null;
    }
  }

  /// Write an int value into a uint64_t return slot.
  static void _writeStackSlot(
    ffi.Pointer<ffi.Uint64> slot,
    int value,
    M3ValueType type,
  ) {
    switch (type) {
      case M3ValueType.c_m3Type_i64:
        slot.cast<ffi.Int64>().value = value;
      case M3ValueType.c_m3Type_f32:
        slot.cast<ffi.Float>().value = value.toDouble();
      case M3ValueType.c_m3Type_f64:
        slot.cast<ffi.Double>().value = value.toDouble();
      default: // i32
        slot.cast<ffi.Int32>().value = value;
    }
  }

  /// Write a double value into a uint64_t return slot.
  static void _writeStackSlotDouble(
    ffi.Pointer<ffi.Uint64> slot,
    double value,
    M3ValueType type,
  ) {
    switch (type) {
      case M3ValueType.c_m3Type_f32:
        slot.cast<ffi.Float>().value = value;
      case M3ValueType.c_m3Type_i32:
        slot.cast<ffi.Int32>().value = value.toInt();
      case M3ValueType.c_m3Type_i64:
        slot.cast<ffi.Int64>().value = value.toInt();
      default: // f64
        slot.cast<ffi.Double>().value = value;
    }
  }

  /// Write a type-correct default (-1 / -1.0) into a return slot.
  static void _writeDefaultReturn(
    ffi.Pointer<ffi.Uint64> sp,
    M3ValueType type,
  ) {
    switch (type) {
      case M3ValueType.c_m3Type_i64:
        sp.cast<ffi.Int64>().value = -1;
      case M3ValueType.c_m3Type_f32:
        sp.cast<ffi.Float>().value = -1.0;
      case M3ValueType.c_m3Type_f64:
        sp.cast<ffi.Double>().value = -1.0;
      default: // i32
        sp.cast<ffi.Int32>().value = -1;
    }
  }
}

// ---------------------------------------------------------------------------
// Internal types
// ---------------------------------------------------------------------------

/// Parse the WASM binary import section to enumerate all imports.
///
/// Returns a list of (module, name) pairs for all function imports declared
/// in the binary. wasm3 requires exact (module, function) pairs for linking —
/// wildcard names are not supported.
List<({String module, String name})> _parseImportSection(Uint8List bytes) {
  var offset = 8; // Skip WASM magic + version header.

  int readByte() => bytes[offset++];

  /// Read an unsigned LEB128 varint.
  int readLeb128() {
    var result = 0;
    var shift = 0;
    while (true) {
      final int byte = readByte();
      result |= (byte & 0x7f) << shift;
      if (byte & 0x80 == 0) break;
      shift += 7;
    }
    return result;
  }

  String readString() {
    final int len = readLeb128();
    final String s = utf8.decode(bytes.sublist(offset, offset + len));
    offset += len;
    return s;
  }

  while (offset < bytes.length) {
    final int sectionId = readByte();
    final int sectionSize = readLeb128();
    final int sectionEnd = offset + sectionSize;

    if (sectionId != 2) {
      // Not the import section — skip.
      offset = sectionEnd;
      continue;
    }

    // Parse the import section.
    final int count = readLeb128();
    final imports = <({String module, String name})>[];

    for (var i = 0; i < count; i++) {
      final String module = readString();
      final String name = readString();
      final int kind = readByte();
      // Skip the import descriptor based on kind.
      switch (kind) {
        case 0x00: // func — type index (varint)
          readLeb128();
        case 0x01: // table — elemtype (byte) + limits
          readByte(); // elemtype
          final int hasMax = readByte();
          readLeb128(); // min
          if (hasMax == 1) readLeb128(); // max
        case 0x02: // memory — limits
          final int hasMax = readByte();
          readLeb128(); // min
          if (hasMax == 1) readLeb128(); // max
        case 0x03: // global — valtype (byte) + mutability (byte)
          readByte(); // valtype
          readByte(); // mut
      }
      imports.add((module: module, name: name));
    }

    return imports;
  }

  return const [];
}

class _CallbackEntry {
  const _CallbackEntry({
    required this.fn,
    required this.onLog,
    required this.name,
  });

  final Function? fn;
  final void Function(String message)? onLog;
  final String name;
}
