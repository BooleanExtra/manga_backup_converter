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
  final outer = JSObject();
  for (final moduleEntry in imports.entries) {
    final inner = JSObject();
    for (final fnEntry in moduleEntry.value.entries) {
      final dartFn = fnEntry.value;
      // 4-arg JS wrapper; extra args beyond the function's arity are ignored
      final jsFn = (JSAny? a, JSAny? b, JSAny? c, JSAny? d) {
        final dartArgs = [a, b, c, d].where((x) => x != null).map(_jsToValue).toList();
        final result = Function.apply(dartFn, dartArgs);
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
    Map<String, Map<String, Function>> imports = const {},
  }) async {
    final jsBytes = wasmBytes.buffer.toJS;
    final module = await _wasmCompile(jsBytes).toDart;
    final importObj = _buildImportObject(imports);
    final result = await _wasmInstantiateModule(module, importObj).toDart;

    final instance = result as _WasmInstance;
    final exports = instance.exports;
    final memView = _readMemoryView(exports);

    return WasmRunner._(exports, memView);
  }

  static Uint8List _readMemoryView(JSObject exports) {
    final memJs = exports.getProperty('memory'.toJS);
    if (memJs == null) return Uint8List(0);
    return Uint8List.view((memJs as _WasmMemory).buffer.toDart);
  }

  void _refreshMemory() {
    _memBytes = _readMemoryView(_exports);
  }

  dynamic call(String name, List<Object?> args) {
    final fn = _exports.getProperty(name.toJS);
    if (fn == null) throw ArgumentError('WASM export not found: $name');
    final jsArgs = args.map(_valueToJs).toList();
    final result = (fn as JSFunction).callAsFunction(
      null,
      jsArgs.jsify()! as JSArray,
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
