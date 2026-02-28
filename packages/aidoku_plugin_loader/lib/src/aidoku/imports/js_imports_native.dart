import 'package:aidoku_plugin_loader/src/aidoku/libs/host_store.dart';
import 'package:aidoku_plugin_loader/src/aidoku/libs/import_context.dart';
import 'package:quickjs/quickjs.dart';
// ignore: implementation_imports
import 'package:quickjs/src/native_js_engine.dart';

/// `js` module host imports — native implementation using QuickJS.
Map<String, Function> buildJsImports(ImportContext ctx) {
  NativeEngineManager? manager;
  return <String, Function>{
    'context_create': () {
      try {
        manager ??= NativeEngineManager();
        final NativeEngineManager mgr = manager!;
        final engine = NativeJsEngine();
        return ctx.store.add(
          JsContextResource(
            context: engine,
            onDispose: () {
              engine.dispose();
              // Dispose the runtime when all engines are gone.
              if (mgr.length == 0) {
                mgr.dispose();
                manager = null;
              }
            },
          ),
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
        final JsEvalResult result = (res.context as NativeJsEngine).eval(code);
        if (result.isError) return -1; // MissingResult
        final String value = result.value;
        if (value == 'undefined' || value == 'null') return -1;
        return ctx.storeString(value);
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
        final JsEvalResult result = (res.context as NativeJsEngine).eval(name);
        if (result.isError) return -1; // MissingResult (e.g. ReferenceError)
        final String value = result.value;
        if (value == 'undefined' || value == 'null') return -1;
        return ctx.storeString(value);
      } on Object catch (e) {
        ctx.onLog?.call('[CB] js::context_get failed: $e');
        return -1;
      }
    },
    // Webview functions remain stubbed — no native webview support.
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
}
