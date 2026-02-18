// ignore_for_file: avoid_dynamic_calls
import 'dart:js_interop';
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
// Helper: convert a nested Dart import map to a JS object tree
// ---------------------------------------------------------------------------

JSObject _buildImportObject(Map<String, Map<String, Function>> imports) {
  final outer = JSObject();
  for (final moduleEntry in imports.entries) {
    final inner = JSObject();
    for (final fnEntry in moduleEntry.value.entries) {
      // Convert Dart function to JS function. We use a 4-arg JS adapter
      // that forwards to the Dart function; callers with fewer args work fine
      // because extra JS args are simply ignored.
      final dartFn = fnEntry.value;
      final jsFn = (JSAny? a, JSAny? b, JSAny? c, JSAny? d) {
        final dartArgs = [a, b, c, d]
            .where((x) => x != null)
            .map(_jsToValue)
            .toList();
        return _valueToJs(Function.apply(dartFn, dartArgs));
      }.toJS;
      inner[fnEntry.key] = jsFn;
    }
    outer[moduleEntry.key] = inner;
  }
  return outer;
}

Object? _jsToValue(JSAny? v) {
  if (v == null) return null;
  // Numbers come back as JSNumber from the browser
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
  WasmRunner._(this._exports, this._memoryView);

  final JSObject _exports;
  Uint8List _memoryView;

  static Future<WasmRunner> fromBytes(
    Uint8List wasmBytes, {
    Map<String, Map<String, Function>> imports = const {},
  }) async {
    final jsBytes = wasmBytes.buffer.toJS;
    final module = await _wasmCompile(jsBytes).toDart;
    final importObj = _buildImportObject(imports);
    final result = await _wasmInstantiateModule(module, importObj).toDart;

    // result is a WebAssembly.Instance
    final instance = result as _WasmInstance;
    final exports = instance.exports;

    // Snapshot the memory view (re-read on each access in case memory grows)
    final memJs = exports['memory'] as _WasmMemory;
    final memView = Uint8List.view(memJs.buffer.toDart);

    return WasmRunner._(exports, memView);
  }

  /// Refresh the memory view (WASM memory can grow, invalidating old views).
  void _refreshMemory() {
    final memJs = _exports['memory'] as _WasmMemory;
    _memoryView = Uint8List.view(memJs.buffer.toDart);
  }

  @override
  dynamic call(String name, List<Object?> args) {
    final fn = _exports[name];
    if (fn == null) throw ArgumentError('WASM export not found: $name');
    // Call via JS interop using jsify on args
    final jsArgs = args.map((a) => _valueToJs(a)).toList();
    final result = (fn as JSFunction).callAsFunction(null, jsArgs.map((a) => a ?? ''.toJS).toList().jsify()!);
    return _jsToValue(result);
  }

  @override
  Uint8List readMemory(int offset, int length) {
    _refreshMemory();
    return Uint8List.fromList(_memoryView.sublist(offset, offset + length));
  }

  @override
  void writeMemory(int offset, Uint8List bytes) {
    _refreshMemory();
    _memoryView.setRange(offset, offset + bytes.length, bytes);
  }

  @override
  int get memorySize {
    _refreshMemory();
    return _memoryView.length;
  }
}
