import 'package:aidoku_plugin_loader/src/aidoku/libs/import_context.dart';

/// `js` module host imports (stub — embedded JS execution not implemented).
Map<String, Function> buildJsImports(ImportContext ctx) => <String, Function>{
  'context_create': () {
    ctx.onLog?.call('[aidoku] js module not implemented');
    return -1;
  },
  'context_eval': (int ctxRid, int strPtr, int len) => -1,
  'context_get': (int ctxRid, int strPtr, int len) => -1,
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
