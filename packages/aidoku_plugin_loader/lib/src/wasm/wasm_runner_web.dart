// ignore_for_file: avoid_dynamic_calls
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:typed_data';

// ---------------------------------------------------------------------------
// Browser WebAssembly API bindings via dart:js_interop
// ---------------------------------------------------------------------------

@JS('WebAssembly.compile')
external JSPromise<JSObject> _wasmCompile(JSAny bytes);

@JS('WebAssembly.instantiate')
external JSPromise<JSObject> _wasmInstantiateModule(JSObject module, JSObject imports);

@JS('Reflect.apply')
external JSAny? _jsReflectApply(JSFunction target, JSAny? thisArg, JSArray<JSAny?> args);

@JS('eval')
external JSAny _jsEval(JSString code);

@JS()
extension type _WasmInstance._(JSObject _) implements JSObject {
  external JSObject get exports;
}

@JS()
extension type _WasmMemory._(JSObject _) implements JSObject {
  external JSArrayBuffer get buffer;
}

// ---------------------------------------------------------------------------
// Variable-arity JS wrapper factory
// ---------------------------------------------------------------------------

/// A JS function `(bridge) => function() { return bridge(arguments); }`.
///
/// dart2js's `.toJS` creates fixed-arity JS functions matching the Dart
/// function's parameter count. But WASM imports call with their exact declared
/// arity, causing a mismatch when using a 12-param Dart wrapper. This factory
/// creates a variable-arity JS function that captures the Dart bridge and
/// forwards all `arguments` as a JS array.
final JSFunction _varArgsFactory =
    _jsEval(
          '(function(bridge) { return function() { return bridge(Array.prototype.slice.call(arguments)); }; })'.toJS,
        )
        as JSFunction;

// ---------------------------------------------------------------------------
// Helper: convert nested Dart import map to JS object tree
// ---------------------------------------------------------------------------

JSObject _buildImportObject(Map<String, Map<String, Function>> imports) {
  final outer = JSObject();
  for (final MapEntry<String, Map<String, Function>> moduleEntry in imports.entries) {
    final inner = JSObject();
    for (final MapEntry<String, Function> fnEntry in moduleEntry.value.entries) {
      final Function dartFn = fnEntry.value;
      // Create a 1-arg Dart bridge that receives a JS array of args.
      final JSExportedDartFunction dartBridge = (JSArray<JSAny?> jsArgs) {
        final int count = jsArgs.length;
        final dartArgs = <Object?>[
          for (var idx = 0; idx < count; idx++) _jsToValue(jsArgs[idx]),
        ];
        final Object? result = Function.apply(dartFn, dartArgs);
        return _valueToJs(result is Future ? null : result);
      }.toJS;
      // Wrap in a variable-arity JS function via the factory.
      final jsFn = _varArgsFactory.callAsFunction(null, dartBridge)! as JSFunction;
      inner.setProperty(fnEntry.key.toJS, jsFn);
    }
    outer.setProperty(moduleEntry.key.toJS, inner);
  }
  return outer;
}

Object? _jsToValue(JSAny? v) {
  if (v == null) return null;
  if (v.isUndefinedOrNull) return null;
  final Object? dart = v.dartify();
  // JS numbers are always doubles. Convert integer-valued doubles to int
  // because host import functions expect int parameters.
  if (dart is double) {
    final int asInt = dart.toInt();
    if (dart == asInt.toDouble()) return asInt;
  }
  return dart;
}

JSAny? _valueToJs(Object? v) {
  if (v == null) return null;
  if (v is int) return v.toJS;
  if (v is double) return v.toJS;
  if (v is bool) return v.toJS;
  return null;
}

// ---------------------------------------------------------------------------
// WasmRunner implementation
// ---------------------------------------------------------------------------

class WasmRunner {
  WasmRunner._(this._exports, this._memBytes);

  final JSObject _exports;
  Uint8List _memBytes;

  static Future<WasmRunner> fromBytes(
    Uint8List wasmBytes, {
    Map<String, Map<String, Function>> imports = const <String, Map<String, Function>>{},
  }) async {
    final JSArrayBuffer jsBytes = wasmBytes.buffer.toJS;
    final JSObject module = await _wasmCompile(jsBytes).toDart;
    final JSObject importObj = _buildImportObject(imports);
    final JSObject result = await _wasmInstantiateModule(module, importObj).toDart;

    final instance = result as _WasmInstance;
    final JSObject exports = instance.exports;
    final Uint8List memView = _readMemoryView(exports);

    return WasmRunner._(exports, memView);
  }

  static Uint8List _readMemoryView(JSObject exports) {
    final JSAny? memJs = exports.getProperty('memory'.toJS);
    if (memJs == null) return Uint8List(0);
    return Uint8List.view((memJs as _WasmMemory).buffer.toDart);
  }

  void _refreshMemory() {
    _memBytes = _readMemoryView(_exports);
  }

  dynamic call(String name, List<Object?> args) {
    final JSAny? fn = _exports.getProperty(name.toJS);
    if (fn == null) throw ArgumentError('WASM export not found: $name');
    final JSArray<JSAny?> jsArgs = <JSAny?>[
      for (final Object? arg in args) _valueToJs(arg),
    ].toJS;
    // Use Reflect.apply to spread the args array as individual parameters.
    final JSAny? result = _jsReflectApply(fn as JSFunction, null, jsArgs);
    return _jsToValue(result);
  }

  Uint8List readMemory(int offset, int length) {
    _refreshMemory();
    return Uint8List.fromList(_memBytes.sublist(offset, offset + length));
  }

  void writeMemory(int offset, Uint8List bytes) {
    _refreshMemory();
    _memBytes.setRange(offset, offset + bytes.length, bytes);
  }

  int get memorySize {
    _refreshMemory();
    return _memBytes.length;
  }
}
