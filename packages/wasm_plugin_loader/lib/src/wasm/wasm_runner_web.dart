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

@JS()
extension type _WasmInstance._(JSObject _) implements JSObject {
  external JSObject get exports;
}

@JS()
extension type _WasmMemory._(JSObject _) implements JSObject {
  external JSArrayBuffer get buffer;
}

// ---------------------------------------------------------------------------
// Helper: convert nested Dart import map to JS object tree
// ---------------------------------------------------------------------------

JSObject _buildImportObject(Map<String, Map<String, Function>> imports) {
  final JSObject outer = JSObject();
  for (final MapEntry<String, Map<String, Function>> moduleEntry in imports.entries) {
    final JSObject inner = JSObject();
    for (final MapEntry<String, Function> fnEntry in moduleEntry.value.entries) {
      final Function dartFn = fnEntry.value;
      // 4-arg JS wrapper; extra args beyond the function's arity are ignored
      final JSExportedDartFunction jsFn = (JSAny? a, JSAny? b, JSAny? c, JSAny? d) {
        final List<Object?> dartArgs = <JSAny?>[a, b, c, d].where((JSAny? x) => x != null).map(_jsToValue).toList();
        final Object? result = Function.apply(dartFn, dartArgs);
        return _valueToJs(result is Future ? null : result);
      }.toJS;
      inner.setProperty(fnEntry.key.toJS, jsFn);
    }
    outer.setProperty(moduleEntry.key.toJS, inner);
  }
  return outer;
}

Object? _jsToValue(JSAny? v) {
  if (v == null) return null;
  return v.dartify();
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

    final _WasmInstance instance = result as _WasmInstance;
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
    final List<JSAny?> jsArgs = args.map(_valueToJs).toList();
    final JSAny? result = (fn as JSFunction).callAsFunction(
      null,
      jsArgs.jsify()! as JSArray<JSAny?>,
    );
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
