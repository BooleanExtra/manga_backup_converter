import 'dart:convert';
import 'dart:typed_data';

import 'package:aidoku_plugin_loader/src/aidoku/libs/host_store.dart';
import 'package:aidoku_plugin_loader/src/wasm/wasm_runner.dart';
import 'package:jsoup/jsoup.dart';

/// Shared context for all host import modules (analogous to aidoku-rs `WasmEnv`).
class ImportContext {
  ImportContext({
    required this.runner,
    required this.store,
    required this.sourceId,
    this.asyncHttp,
    this.asyncSleep,
    this.onRateLimitSet,
    this.onLog,
    this.joup,
  });

  final WasmRunner runner;
  final HostStore store;
  final String sourceId;
  final AsyncHttpDispatch? asyncHttp;
  final AsyncSleepDispatch? asyncSleep;
  final RateLimitCallback? onRateLimitSet;
  final void Function(String)? onLog;
  final Jsoup? joup;

  // ---------------------------------------------------------------------------
  // String helpers (analogous to WasmEnv::read_string / write_bytes)
  // ---------------------------------------------------------------------------

  /// Read a UTF-8 string from WASM linear memory.
  String readString(int ptr, int len) => utf8.decode(runner.readMemory(ptr, len));

  /// Store a raw UTF-8 string in the host store and return its RID.
  int storeString(String s) => store.addBytes(Uint8List.fromList(utf8.encode(s)));

  // ---------------------------------------------------------------------------
  // HTML pattern helpers — cover ~30 of the 38 html:: imports
  // ---------------------------------------------------------------------------

  /// Element → String property → store as bytes RID.
  int elementStringProp(int rid, String op, String Function(Element) getter) {
    if (joup == null) return -1;
    try {
      final HtmlElementResource? res = store.get<HtmlElementResource>(rid);
      if (res == null) return -1;
      return storeString(getter(res.element));
    } on Object catch (e) {
      onLog?.call('[CB] html::$op failed: $e');
      return -1;
    }
  }

  /// Element → Element? navigation → store new Element RID.
  int elementNav(int rid, String op, Element? Function(Element) nav) {
    if (joup == null) return -1;
    try {
      final HtmlElementResource? res = store.get<HtmlElementResource>(rid);
      if (res == null) return -1;
      final Element? el = nav(res.element);
      if (el == null) return -1;
      return store.add(HtmlElementResource(el));
    } on Object catch (e) {
      onLog?.call('[CB] html::$op failed: $e');
      return -1;
    }
  }

  /// Elements[index] → store Element RID.
  int elementsAt(int rid, int index, String op) {
    if (joup == null) return -1;
    try {
      final HtmlElementsResource? res = store.get<HtmlElementsResource>(rid);
      if (res == null || index < 0 || index >= res.elements.length) return -1;
      return store.add(HtmlElementResource(res.elements[index]));
    } on Object catch (e) {
      onLog?.call('[CB] html::$op failed: $e');
      return -1;
    }
  }

  /// Element mutation → return 0.
  int elementMutate(int rid, String op, void Function(Element) mutate) {
    if (joup == null) return 0;
    try {
      final HtmlElementResource? res = store.get<HtmlElementResource>(rid);
      if (res == null) return 0;
      mutate(res.element);
    } on Object catch (e) {
      onLog?.call('[CB] html::$op failed: $e');
    }
    return 0;
  }
}

// ---------------------------------------------------------------------------
// Alias helper — registers both `_name` and `name` for the same function
// ---------------------------------------------------------------------------

/// Add both underscore-prefixed and plain aliases for a host import.
void addAlias(Map<String, Function> map, String name, Function fn) {
  map['_$name'] = fn;
  map[name] = fn;
}

// ---------------------------------------------------------------------------
// Async dispatch typedefs
// ---------------------------------------------------------------------------

/// Synchronously dispatch an HTTP request and return the response.
typedef AsyncHttpDispatch =
    ({int statusCode, Uint8List? body, Map<String, String> headers}) Function(
      String url,
      int method,
      Map<String, String> headers,
      Uint8List? body,
      double timeout,
    );

/// Synchronously dispatch a sleep (blocks WASM isolate thread).
typedef AsyncSleepDispatch = void Function(int seconds);

/// Callback fired when a WASM plugin calls `net::set_rate_limit`.
typedef RateLimitCallback = void Function(int permits, int periodMs);
