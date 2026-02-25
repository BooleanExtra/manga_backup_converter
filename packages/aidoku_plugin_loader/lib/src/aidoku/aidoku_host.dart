import 'package:aidoku_plugin_loader/src/aidoku/imports/canvas_imports.dart';
import 'package:aidoku_plugin_loader/src/aidoku/imports/defaults_imports.dart';
import 'package:aidoku_plugin_loader/src/aidoku/imports/env_imports.dart';
import 'package:aidoku_plugin_loader/src/aidoku/imports/html_imports.dart';
import 'package:aidoku_plugin_loader/src/aidoku/imports/js_imports.dart';
import 'package:aidoku_plugin_loader/src/aidoku/imports/net_imports.dart';
import 'package:aidoku_plugin_loader/src/aidoku/imports/std_imports.dart';
import 'package:aidoku_plugin_loader/src/aidoku/libs/host_store.dart';
import 'package:aidoku_plugin_loader/src/aidoku/libs/import_context.dart';
import 'package:aidoku_plugin_loader/src/wasm/wasm_runner.dart';
import 'package:jsoup/jsoup.dart';

// Re-export typedefs so callers that only import aidoku_host.dart still work.
export 'package:aidoku_plugin_loader/src/aidoku/libs/import_context.dart'
    show AsyncHttpDispatch, AsyncSleepDispatch, RateLimitCallback;

/// Builds the complete map of host import functions for an Aidoku WASM plugin.
///
/// [sourceId] is prepended to all defaults keys to match Swift's behavior.
/// [asyncHttp] and [asyncSleep] are optional async dispatch callbacks. When
/// null (web stub or unit tests) HTTP calls return -1 and sleep is a no-op.
Map<String, Map<String, Function>> buildAidokuHostImports(
  WasmRunner runner,
  HostStore store, {
  required String sourceId,
  AsyncHttpDispatch? asyncHttp,
  AsyncSleepDispatch? asyncSleep,
  RateLimitCallback? onRateLimitSet,
  void Function(String message)? onLog,
  Jsoup? htmlParser,
}) {
  final ctx = ImportContext(
    runner: runner,
    store: store,
    sourceId: sourceId,
    asyncHttp: asyncHttp,
    asyncSleep: asyncSleep,
    onRateLimitSet: onRateLimitSet,
    onLog: onLog,
    htmlParser: htmlParser,
  );

  return <String, Map<String, Function>>{
    'std': buildStdImports(ctx),
    'env': buildEnvImports(ctx),
    'net': buildNetImports(ctx),
    'html': buildHtmlImports(ctx),
    'defaults': buildDefaultsImports(ctx),
    'canvas': buildCanvasImports(ctx),
    'js': buildJsImports(ctx),
  };
}
