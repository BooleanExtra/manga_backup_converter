// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:typed_data';

import 'package:html/dom.dart' as html_dom;
import 'package:html/parser.dart' as html_parser;

import 'package:wasm_plugin_loader/src/aidoku/host_store.dart';
import 'package:wasm_plugin_loader/src/codec/postcard_writer.dart';
import 'package:wasm_plugin_loader/src/wasm/wasm_runner.dart';

// ---------------------------------------------------------------------------
// Async dispatch callbacks
// ---------------------------------------------------------------------------

/// Synchronously dispatch an HTTP request and return the response.
/// On native: blocks the WASM isolate thread via a semaphore while the main
/// isolate performs the async HTTP request.
/// On web (stub): returns immediately with a -1 error result.
typedef AsyncHttpDispatch =
    ({int statusCode, Uint8List? body}) Function(
      String url,
      int method,
      Map<String, String> headers,
      Uint8List? body,
      double timeout,
    );

/// Synchronously dispatch a sleep (blocks WASM isolate thread).
typedef AsyncSleepDispatch = void Function(int seconds);

// ---------------------------------------------------------------------------
// Public factory
// ---------------------------------------------------------------------------

/// Builds the complete map of host import functions for an Aidoku WASM plugin.
///
/// [asyncHttp] and [asyncSleep] are optional async dispatch callbacks. When
/// null (web stub or unit tests) HTTP calls return -1 and sleep is a no-op.
Map<String, Map<String, Function>> buildAidokuHostImports(
  WasmRunner runner,
  HostStore store, {
  AsyncHttpDispatch? asyncHttp,
  AsyncSleepDispatch? asyncSleep,
}) {
  return {
    'std': _stdImports(runner, store),
    'env': _envImports(runner, store, asyncSleep),
    'net': _netImports(runner, store, asyncHttp),
    'html': _htmlImports(runner, store),
    'defaults': _defaultsImports(runner, store),
    'canvas': _canvasImports(),
    'js': _jsImports(),
  };
}

// ---------------------------------------------------------------------------
// std module
// ---------------------------------------------------------------------------

Map<String, Function> _stdImports(WasmRunner runner, HostStore store) => {
  'destroy': (int rid) {
    store.remove(rid);
  },
  'buffer_len': (int rid) {
    final r = store.get<BytesResource>(rid);
    if (r == null) return -1;
    return r.bytes.length;
  },
  // ABI canonical name has a leading underscore.
  '_read_buffer': (int rid, int ptr, int len) {
    final r = store.get<BytesResource>(rid);
    if (r == null) return -1;
    final bytes = r.bytes.length <= len ? r.bytes : r.bytes.sublist(0, len);
    runner.writeMemory(ptr, bytes);
    return 0;
  },
  // Alias for older plugins that omit the leading underscore.
  'read_buffer': (int rid, int ptr, int len) {
    final r = store.get<BytesResource>(rid);
    if (r == null) return -1;
    final bytes = r.bytes.length <= len ? r.bytes : r.bytes.sublist(0, len);
    runner.writeMemory(ptr, bytes);
    return 0;
  },
  // Returns UNIX timestamp as f64 seconds (NOT milliseconds).
  '_current_date': () {
    return DateTime.now().millisecondsSinceEpoch / 1000.0;
  },
  'utc_offset': () {
    return DateTime.now().timeZoneOffset.inSeconds;
  },
  '_parse_date':
      (
        int strPtr,
        int strLen,
        int fmtPtr,
        int fmtLen,
        int localePtr,
        int localeLen,
        int tzPtr,
        int tzLen,
      ) {
        try {
          final dateStr = utf8.decode(runner.readMemory(strPtr, strLen));
          final parsed = _tryParseDate(dateStr);
          return parsed != null ? parsed.millisecondsSinceEpoch / 1000.0 : -1.0;
        } catch (_) {
          return -1.0;
        }
      },
};

/// Try to parse a date string using ISO 8601 and common fallback formats.
DateTime? _tryParseDate(String s) {
  final trimmed = s.trim();
  if (trimmed.isEmpty) return null;
  final iso = DateTime.tryParse(trimmed);
  if (iso != null) return iso;
  // Strip trailing timezone abbreviation / extra text and retry.
  final cleaned = trimmed.replaceAll(RegExp(r'\s+\w+$'), '');
  return DateTime.tryParse(cleaned);
}

// ---------------------------------------------------------------------------
// env module
// ---------------------------------------------------------------------------

Map<String, Function> _envImports(
  WasmRunner runner,
  HostStore store,
  AsyncSleepDispatch? asyncSleep,
) => {
  '_print': (int ptr, int len) {
    if (len > 0) {
      print('[aidoku] ${utf8.decode(runner.readMemory(ptr, len))}');
    }
  },
  '_sleep': (int seconds) {
    if (asyncSleep != null) {
      asyncSleep(seconds);
    }
    // else: no-op (blocking sleep not supported without async dispatch)
  },
  '_send_partial_result': (int ptr) {
    try {
      // Layout: [u32 length LE][u32 capacity LE][<length> bytes postcard]
      final lenBytes = runner.readMemory(ptr, 4);
      final length = ByteData.sublistView(lenBytes).getUint32(0, Endian.little);
      if (length > 0) {
        final data = runner.readMemory(ptr + 8, length);
        store.addPartialResult(data);
      }
    } catch (_) {}
  },
};

// ---------------------------------------------------------------------------
// net module
// ---------------------------------------------------------------------------

Map<String, Function> _netImports(
  WasmRunner runner,
  HostStore store,
  AsyncHttpDispatch? asyncHttp,
) {
  return {
    'init': (int method) {
      return store.add(HttpRequestResource(method: method));
    },
    'set_url': (int rid, int ptr, int len) {
      final req = store.get<HttpRequestResource>(rid);
      if (req == null) return -1;
      req.url = utf8.decode(runner.readMemory(ptr, len));
      return 0;
    },
    'set_header': (int rid, int keyPtr, int keyLen, int valPtr, int valLen) {
      final req = store.get<HttpRequestResource>(rid);
      if (req == null) return -1;
      final key = utf8.decode(runner.readMemory(keyPtr, keyLen));
      final val = utf8.decode(runner.readMemory(valPtr, valLen));
      req.headers[key] = val;
      return 0;
    },
    'set_body': (int rid, int ptr, int len) {
      final req = store.get<HttpRequestResource>(rid);
      if (req == null) return -1;
      req.body = Uint8List.fromList(runner.readMemory(ptr, len));
      return 0;
    },
    'set_timeout': (int rid, double timeout) {
      final req = store.get<HttpRequestResource>(rid);
      if (req == null) return -1;
      req.timeout = timeout;
      return 0;
    },
    'send': (int rid) {
      final req = store.get<HttpRequestResource>(rid);
      if (req == null || req.url == null) return -1;
      if (asyncHttp == null) return -1;

      final resp = asyncHttp(
        req.url!,
        req.method,
        Map.from(req.headers),
        req.body,
        req.timeout,
      );
      req.statusCode = resp.statusCode;
      req.responseBody = resp.body;
      return rid;
    },
    'send_all': (int ridsPtr, int count) {
      if (asyncHttp == null) return -1;
      for (var i = 0; i < count; i++) {
        final ridBytes = runner.readMemory(ridsPtr + i * 4, 4);
        final rid = ByteData.sublistView(ridBytes).getInt32(0, Endian.little);
        final req = store.get<HttpRequestResource>(rid);
        if (req == null || req.url == null) continue;
        final resp = asyncHttp(
          req.url!,
          req.method,
          Map.from(req.headers),
          req.body,
          req.timeout,
        );
        req.statusCode = resp.statusCode;
        req.responseBody = resp.body;
      }
      return 0;
    },
    'data_len': (int rid) {
      return store.get<HttpRequestResource>(rid)?.responseBody?.length ?? -1;
    },
    'read_data': (int rid, int ptr, int len) {
      final req = store.get<HttpRequestResource>(rid);
      if (req?.responseBody == null) return -1;
      final body = req!.responseBody!;
      final n = len < body.length ? len : body.length;
      runner.writeMemory(ptr, body.sublist(0, n));
      return n;
    },
    'get_status_code': (int rid) {
      return store.get<HttpRequestResource>(rid)?.statusCode ?? -1;
    },
    'get_header': (int rid, int keyPtr, int keyLen) {
      final req = store.get<HttpRequestResource>(rid);
      if (req == null) return -1;
      final key = utf8.decode(runner.readMemory(keyPtr, keyLen)).toLowerCase();
      final val = req.responseHeaders[key];
      if (val == null) return -1;
      return store.addBytes(_encodeString(val));
    },
    'html': (int rid) {
      final req = store.get<HttpRequestResource>(rid);
      if (req?.responseBody == null) return -1;
      final htmlStr = utf8.decode(req!.responseBody!);
      final doc = html_parser.parse(htmlStr);
      return store.add(HtmlDocumentResource(doc));
    },
    'get_image': (int rid) {
      final req = store.get<HttpRequestResource>(rid);
      if (req?.responseBody == null) return -1;
      return store.addBytes(req!.responseBody!);
    },
    'net_set_rate_limit': (int permits, int period, int unit) {
      // Rate limiting stored; enforcement happens at the application layer.
    },
    'set_rate_limit': (int permits, int period, int unit) {
      // Legacy alias without 'net_' prefix.
    },
  };
}

// ---------------------------------------------------------------------------
// html module
// ---------------------------------------------------------------------------

Map<String, Function> _htmlImports(WasmRunner runner, HostStore store) => {
  // ABI: html::parse(ptr: i32, len: i32 [, base_uri_ptr, base_uri_len]) -> rid
  'parse': (int ptr, int len, [int? baseUriPtr, int? baseUriLen]) {
    try {
      final htmlStr = utf8.decode(runner.readMemory(ptr, len));
      final doc = html_parser.parse(htmlStr);
      String baseUri = '';
      if (baseUriPtr != null && baseUriLen != null && baseUriLen > 0) {
        baseUri = utf8.decode(runner.readMemory(baseUriPtr, baseUriLen));
      }
      return store.add(HtmlDocumentResource(doc, baseUri: baseUri));
    } catch (_) {
      return -1;
    }
  },
  'parse_fragment': (int ptr, int len, [int? baseUriPtr, int? baseUriLen]) {
    try {
      final htmlStr = utf8.decode(runner.readMemory(ptr, len));
      final nodes = html_parser.parseFragment(htmlStr);
      final elements = nodes.children.whereType<html_dom.Element>().toList();
      return store.add(HtmlNodeListResource(elements));
    } catch (_) {
      return -1;
    }
  },
  'select': (int rid, int selectorPtr, int selectorLen) {
    final selector = utf8.decode(runner.readMemory(selectorPtr, selectorLen));
    final elements = _querySelectorAll(store, rid, selector);
    if (elements == null) return -1;
    return store.add(HtmlNodeListResource(elements));
  },
  'select_first': (int rid, int selectorPtr, int selectorLen) {
    final selector = utf8.decode(runner.readMemory(selectorPtr, selectorLen));
    final element = _querySelector(store, rid, selector);
    if (element == null) return -1;
    return store.add(HtmlDocumentResource(element));
  },
  'attr': (int rid, int keyPtr, int keyLen) {
    final key = utf8.decode(runner.readMemory(keyPtr, keyLen));
    final el = _asElement(store, rid);
    if (el == null) return -1;
    final val = el.attributes[key];
    if (val == null) return -1;
    return store.addBytes(_encodeString(val));
  },
  'has_attr': (int rid, int keyPtr, int keyLen) {
    final key = utf8.decode(runner.readMemory(keyPtr, keyLen));
    final el = _asElement(store, rid);
    return (el?.attributes.containsKey(key) ?? false) ? 1 : 0;
  },
  'text': (int rid) {
    final el = _asElement(store, rid);
    if (el == null) return -1;
    return store.addBytes(_encodeString(el.text.trim()));
  },
  'own_text': (int rid) {
    final el = _asElement(store, rid);
    if (el == null) return -1;
    final ownText = el.nodes.whereType<html_dom.Text>().map((n) => n.text).join().trim();
    return store.addBytes(_encodeString(ownText));
  },
  'untrimmed_text': (int rid) {
    final el = _asElement(store, rid);
    if (el == null) return -1;
    return store.addBytes(_encodeString(el.text));
  },
  'html': (int rid) {
    final el = _asElement(store, rid);
    if (el == null) return -1;
    return store.addBytes(_encodeString(el.innerHtml));
  },
  'outer_html': (int rid) {
    final el = _asElement(store, rid);
    if (el == null) return -1;
    return store.addBytes(_encodeString(el.outerHtml));
  },
  'tag_name': (int rid) {
    final el = _asElement(store, rid);
    if (el == null) return -1;
    return store.addBytes(_encodeString(el.localName ?? ''));
  },
  'id': (int rid) {
    final el = _asElement(store, rid);
    if (el == null) return -1;
    final id = el.id;
    if (id.isEmpty) return -1;
    return store.addBytes(_encodeString(id));
  },
  'class_name': (int rid) {
    final el = _asElement(store, rid);
    if (el == null) return -1;
    return store.addBytes(_encodeString(el.className));
  },
  'base_uri': (int rid) {
    final r = store.get<HtmlDocumentResource>(rid);
    return store.addBytes(_encodeString(r?.baseUri ?? ''));
  },
  'first': (int rid) {
    final list = store.get<HtmlNodeListResource>(rid);
    if (list == null || list.nodes.isEmpty) return -1;
    return store.add(HtmlDocumentResource(list.nodes.first));
  },
  'last': (int rid) {
    final list = store.get<HtmlNodeListResource>(rid);
    if (list == null || list.nodes.isEmpty) return -1;
    return store.add(HtmlDocumentResource(list.nodes.last));
  },
  'get': (int rid, int index) {
    final list = store.get<HtmlNodeListResource>(rid);
    if (list == null || index < 0 || index >= list.nodes.length) {
      return -1;
    }
    return store.add(HtmlDocumentResource(list.nodes[index]));
  },
  // Alias kept for any legacy WASM binaries compiled with the old name.
  'html_get': (int rid, int index) {
    final list = store.get<HtmlNodeListResource>(rid);
    if (list == null || index < 0 || index >= list.nodes.length) {
      return -1;
    }
    return store.add(HtmlDocumentResource(list.nodes[index]));
  },
  'size': (int rid) {
    return store.get<HtmlNodeListResource>(rid)?.nodes.length ?? -1;
  },
  'parent': (int rid) {
    final el = _asElement(store, rid);
    if (el?.parent == null) return -1;
    return store.add(HtmlDocumentResource(el!.parent!));
  },
  'children': (int rid) {
    final el = _asElement(store, rid);
    if (el == null) return -1;
    return store.add(HtmlNodeListResource(el.children.cast<Object>()));
  },
  'next': (int rid) {
    final el = _asElement(store, rid);
    if (el == null) return -1;
    final siblings = el.parent?.children ?? [];
    final idx = siblings.indexOf(el);
    if (idx < 0 || idx + 1 >= siblings.length) return -1;
    return store.add(HtmlDocumentResource(siblings[idx + 1]));
  },
  'previous': (int rid) {
    final el = _asElement(store, rid);
    if (el == null) return -1;
    final siblings = el.parent?.children ?? [];
    final idx = siblings.indexOf(el);
    if (idx <= 0) return -1;
    return store.add(HtmlDocumentResource(siblings[idx - 1]));
  },
  'siblings': (int rid) {
    final el = _asElement(store, rid);
    if (el?.parent == null) return -1;
    final sibs = el!.parent!.children.where((c) => c != el).toList();
    return store.add(HtmlNodeListResource(sibs.cast<Object>()));
  },
  'set_text': (int rid, int ptr, int len) {
    final el = _asElement(store, rid);
    if (el == null) return -1;
    el.text = utf8.decode(runner.readMemory(ptr, len));
    return 0;
  },
  'set_html': (int rid, int ptr, int len) {
    final el = _asElement(store, rid);
    if (el == null) return -1;
    el.innerHtml = utf8.decode(runner.readMemory(ptr, len));
    return 0;
  },
  'remove': (int rid) {
    _asElement(store, rid)?.remove();
    return 0;
  },
  'escape': (int ptr, int len) {
    final str = utf8.decode(runner.readMemory(ptr, len));
    final escaped = str
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#x27;');
    return store.addBytes(_encodeString(escaped));
  },
  'unescape': (int ptr, int len) {
    final str = utf8.decode(runner.readMemory(ptr, len));
    final unescaped = str
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#x27;', "'")
        .replaceAll('&#39;', "'");
    return store.addBytes(_encodeString(unescaped));
  },
  'has_class': (int rid, int classPtr, int classLen) {
    final className = utf8.decode(runner.readMemory(classPtr, classLen));
    return (_asElement(store, rid)?.classes.contains(className) ?? false) ? 1 : 0;
  },
  'add_class': (int rid, int classPtr, int classLen) {
    final className = utf8.decode(runner.readMemory(classPtr, classLen));
    _asElement(store, rid)?.classes.add(className);
    return 0;
  },
  'remove_class': (int rid, int classPtr, int classLen) {
    final className = utf8.decode(runner.readMemory(classPtr, classLen));
    _asElement(store, rid)?.classes.remove(className);
    return 0;
  },
  'set_attr': (int rid, int keyPtr, int keyLen, int valPtr, int valLen) {
    final key = utf8.decode(runner.readMemory(keyPtr, keyLen));
    final val = utf8.decode(runner.readMemory(valPtr, valLen));
    _asElement(store, rid)?.attributes[key] = val;
    return 0;
  },
  'remove_attr': (int rid, int keyPtr, int keyLen) {
    final key = utf8.decode(runner.readMemory(keyPtr, keyLen));
    _asElement(store, rid)?.attributes.remove(key);
    return 0;
  },
  'prepend': (int rid, int ptr, int len) {
    final el = _asElement(store, rid);
    if (el == null) return -1;
    el.innerHtml = utf8.decode(runner.readMemory(ptr, len)) + el.innerHtml;
    return 0;
  },
  'append': (int rid, int ptr, int len) {
    final el = _asElement(store, rid);
    if (el == null) return -1;
    el.innerHtml = el.innerHtml + utf8.decode(runner.readMemory(ptr, len));
    return 0;
  },
  'data': (int rid) {
    final el = _asElement(store, rid);
    if (el == null) return -1;
    return store.addBytes(_encodeString(el.text));
  },
};

// ---------------------------------------------------------------------------
// defaults module
// ---------------------------------------------------------------------------

Map<String, Function> _defaultsImports(WasmRunner runner, HostStore store) => {
  'get': (int keyPtr, int keyLen) {
    final key = utf8.decode(runner.readMemory(keyPtr, keyLen));
    return store.defaults[key] ?? 0;
  },
  'set': (int keyPtr, int keyLen, int kind, int value) {
    final key = utf8.decode(runner.readMemory(keyPtr, keyLen));
    store.defaults[key] = value;
    return 0;
  },
};

// ---------------------------------------------------------------------------
// canvas module (stub — canvas rendering not implemented)
// ---------------------------------------------------------------------------

// TODO: implement canvas rendering
Map<String, Function> _canvasImports() => {
  'new_context': (double width, double height) => -1,
  'set_transform':
      (
        int ctx,
        double tx,
        double ty,
        double sx,
        double sy,
        double angle,
      ) => -1,
  'draw_image':
      (
        int ctx,
        int img,
        double dx,
        double dy,
        double dw,
        double dh,
      ) => -1,
  'copy_image':
      (
        int ctx,
        int img,
        double sx,
        double sy,
        double sw,
        double sh,
        double dx,
        double dy,
        double dw,
        double dh,
      ) => -1,
  'fill': (int ctx, int path, double r, double g, double b, double a) => -1,
  'stroke': (int ctx, int path, int style) => -1,
  'draw_text':
      (
        int ctx,
        int textPtr,
        int textLen,
        double size,
        double x,
        double y,
        int font,
        double r,
        double g,
        double b,
        double a,
      ) => -1,
  'get_image': (int ctx) => -1,
  'new_font': (int namePtr, int nameLen) => -1,
  'system_font': (int weight) => -1,
  'load_font': (int urlPtr, int urlLen) => -1,
  'new_image': (int dataPtr, int dataLen) => -1,
  'get_image_data': (int image) => -1,
  'get_image_width': (int image) => 0.0,
  'get_image_height': (int image) => 0.0,
};

// ---------------------------------------------------------------------------
// js module (stub — embedded JS execution not implemented)
// ---------------------------------------------------------------------------

Map<String, Function> _jsImports() => {
  'context_create': () {
    print('[aidoku] js module not implemented');
    return -1;
  },
  'context_eval': (int ctx, int strPtr, int len) => -1,
  'context_get': (int ctx, int strPtr, int len) => -1,
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
// Internal helpers
// ---------------------------------------------------------------------------

html_dom.Element? _asElement(HostStore store, int rid) {
  final r = store.get<HtmlDocumentResource>(rid);
  if (r == null) return null;
  final doc = r.document;
  if (doc is html_dom.Element) return doc;
  if (doc is html_dom.Document) return doc.documentElement;
  return null;
}

List<html_dom.Element>? _querySelectorAll(HostStore store, int rid, String selector) {
  final r = store.get<HtmlDocumentResource>(rid);
  if (r == null) return null;
  final doc = r.document;
  try {
    if (doc is html_dom.Element) return doc.querySelectorAll(selector);
    if (doc is html_dom.Document) return doc.querySelectorAll(selector);
  } catch (_) {}
  return null;
}

html_dom.Element? _querySelector(HostStore store, int rid, String selector) {
  final r = store.get<HtmlDocumentResource>(rid);
  if (r == null) return null;
  final doc = r.document;
  try {
    if (doc is html_dom.Element) return doc.querySelector(selector);
    if (doc is html_dom.Document) return doc.querySelector(selector);
  } catch (_) {}
  return null;
}

/// Encode a Dart string as Postcard bytes (varint length + UTF-8).
Uint8List _encodeString(String s) => (PostcardWriter()..writeString(s)).bytes;
