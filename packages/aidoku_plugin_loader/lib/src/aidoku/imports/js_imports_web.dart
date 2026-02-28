import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:aidoku_plugin_loader/src/aidoku/libs/host_store.dart';
import 'package:aidoku_plugin_loader/src/aidoku/libs/import_context.dart';

/// `js` module host imports — web implementation using JS Function constructor.
///
/// Runs inside a Web Worker isolate. Each "context" is a JS object used as a
/// scope for variable storage; code execution uses the Function constructor.
///
/// Security note: This is intentionally sandboxed within the Web Worker — the
/// js module's entire purpose is executing arbitrary JavaScript provided by
/// WASM plugins, which is required for plugins that need to decode obfuscated
/// content (e.g. encrypted manga chapter data). The code comes from the plugin
/// author, not from untrusted user input.
Map<String, Function> buildJsImports(ImportContext ctx) => <String, Function>{
  'context_create': () {
    try {
      // Create a plain JS object to serve as the variable scope.
      final JSObject scope = _newObject();
      return ctx.store.add(
        JsContextResource(context: scope, onDispose: () {}),
      );
    } on Object catch (e) {
      ctx.onLog?.call('[CB] js::context_create failed: $e');
      return -1;
    }
  },
  'context_eval': (int ctxRid, int strPtr, int len) {
    final JsContextResource? res = ctx.store.get<JsContextResource>(ctxRid);
    if (res == null) return -2; // InvalidContext
    try {
      final String code = ctx.readString(strPtr, len);
      final String? result = _execInScope(res.context as JSObject, code);
      if (result == null) return -1; // MissingResult
      return ctx.storeString(result);
    } on Object catch (e) {
      ctx.onLog?.call('[CB] js::context_eval failed: $e');
      return -1;
    }
  },
  'context_get': (int ctxRid, int namePtr, int nameLen) {
    final JsContextResource? res = ctx.store.get<JsContextResource>(ctxRid);
    if (res == null) return -2; // InvalidContext
    try {
      final String name = ctx.readString(namePtr, nameLen);
      final String? result = _getFromScope(res.context as JSObject, name);
      if (result == null) return -1; // MissingResult
      return ctx.storeString(result);
    } on Object catch (e) {
      ctx.onLog?.call('[CB] js::context_get failed: $e');
      return -1;
    }
  },
  // Webview functions remain stubbed.
  'webview_create': () => -1,
  'webview_load': (int webview, int request) => -1,
  'webview_load_html':
      (
        int webview,
        int htmlPtr,
        int htmlLen,
        int basePtr,
        int baseLen,
      ) => -1,
  'webview_wait_for_load': (int webview) => -1,
  'webview_eval': (int webview, int strPtr, int len) => -1,
};

// ---------------------------------------------------------------------------
// JS interop helpers
// ---------------------------------------------------------------------------

@JS('Object')
external JSObject _newObject();

/// Execute JS code using the Function constructor, with `scope` as the
/// persistent variable store.
///
/// The code is wrapped so assignments land on the scope object, providing
/// state persistence across calls. This is required by the aidoku plugin ABI
/// for decoding obfuscated content — the code comes from plugin authors,
/// not from untrusted user input.
String? _execInScope(JSObject scope, String code) {
  // Store the code on the scope to avoid string interpolation issues with
  // the Function constructor body.
  scope.setProperty('__code__'.toJS, code.toJS);
  final JSObject fn = _createFunction(
    'scope'.toJS,
    'with(scope){return eval(scope.__code__)}'.toJS,
  );
  final JSAny? result = (fn as JSFunction).callAsFunction(null, scope);
  // Clean up the temporary code property.
  _deleteProperty(scope, '__code__'.toJS);
  return _jsToString(result);
}

/// Read a named property from the scope object.
String? _getFromScope(JSObject scope, String name) {
  final JSAny? val = scope.getProperty(name.toJS);
  return _jsToString(val);
}

/// Convert a JS value to a Dart string. Returns null for undefined/null.
String? _jsToString(JSAny? val) {
  if (val == null || val.isUndefinedOrNull) return null;
  if (val.isA<JSString>()) return (val as JSString).toDart;
  // For objects/arrays, use JSON.stringify; for numbers/booleans, toString.
  final JSString? json = _jsonStringify(val);
  if (json == null) return null;
  return json.toDart;
}

@JS('Function')
external JSObject _createFunction(JSString arg, JSString body);

@JS('JSON.stringify')
external JSString? _jsonStringify(JSAny? value);

@JS('Reflect.deleteProperty')
external bool _deleteProperty(JSObject target, JSAny key);
