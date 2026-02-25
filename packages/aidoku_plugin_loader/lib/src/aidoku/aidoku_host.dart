import 'dart:convert';
import 'dart:typed_data';

import 'package:aidoku_plugin_loader/src/aidoku/canvas_host.dart';
import 'package:aidoku_plugin_loader/src/aidoku/host_store.dart';
import 'package:aidoku_plugin_loader/src/wasm/wasm_runner.dart';
import 'package:image/image.dart' as img;
import 'package:jsoup/jsoup.dart';

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

/// Callback fired when a WASM plugin calls `net::set_rate_limit`.
typedef RateLimitCallback = void Function(int permits, int periodMs);

// ---------------------------------------------------------------------------
// Public factory
// ---------------------------------------------------------------------------

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
  return <String, Map<String, Function>>{
    'std': _stdImports(runner, store, onLog),
    'env': _envImports(runner, store, asyncSleep, onLog),
    'net': _netImports(runner, store, asyncHttp, onRateLimitSet, htmlParser),
    'html': _htmlImports(runner, store, onLog, htmlParser),
    'defaults': _defaultsImports(runner, store, sourceId),
    'canvas': _canvasImports(runner, store, onLog),
    'js': _jsImports(onLog),
  };
}

// ---------------------------------------------------------------------------
// std module
// ---------------------------------------------------------------------------

Map<String, Function> _stdImports(WasmRunner runner, HostStore store, void Function(String)? onLog) =>
    <String, Function>{
      'destroy': (int rid) {
        store.remove(rid);
      },
      'buffer_len': (int rid) {
        final BytesResource? r = store.get<BytesResource>(rid);
        if (r == null) return -1;
        return r.bytes.length;
      },
      // ABI canonical name has a leading underscore.
      '_read_buffer': (int rid, int ptr, int len) {
        final BytesResource? r = store.get<BytesResource>(rid);
        if (r == null) return -1;
        final Uint8List bytes = r.bytes.length <= len ? r.bytes : r.bytes.sublist(0, len);
        runner.writeMemory(ptr, bytes);
        return 0;
      },
      // Alias for older plugins that omit the leading underscore.
      'read_buffer': (int rid, int ptr, int len) {
        final BytesResource? r = store.get<BytesResource>(rid);
        if (r == null) return -1;
        final Uint8List bytes = r.bytes.length <= len ? r.bytes : r.bytes.sublist(0, len);
        runner.writeMemory(ptr, bytes);
        return 0;
      },
      // Returns UNIX timestamp as f64 seconds (NOT milliseconds).
      '_current_date': () => DateTime.now().millisecondsSinceEpoch / 1000.0,
      // Alias without leading underscore (some plugins use this name).
      'current_date': () => DateTime.now().millisecondsSinceEpoch / 1000.0,
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
              final String dateStr = utf8.decode(runner.readMemory(strPtr, strLen));
              final DateTime? parsed = _tryParseDate(dateStr);
              return parsed != null ? parsed.millisecondsSinceEpoch / 1000.0 : -1.0;
            } on Exception catch (e) {
              onLog?.call('[aidoku] _parse_date failed: $e');
              return -1.0;
            }
          },
      // Alias without leading underscore (used by newer compiled plugins).
      'parse_date':
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
              final String dateStr = utf8.decode(runner.readMemory(strPtr, strLen));
              final DateTime? parsed = _tryParseDate(dateStr);
              return parsed != null ? parsed.millisecondsSinceEpoch / 1000.0 : -1.0;
            } on Exception catch (e) {
              onLog?.call('[aidoku] parse_date failed: $e');
              return -1.0;
            }
          },
    };

/// Try to parse a date string using ISO 8601 and common fallback formats.
DateTime? _tryParseDate(String s) {
  final String trimmed = s.trim();
  if (trimmed.isEmpty) return null;
  final DateTime? iso = DateTime.tryParse(trimmed);
  if (iso != null) return iso;
  // Strip trailing timezone abbreviation / extra text and retry.
  final String cleaned = trimmed.replaceAll(RegExp(r'\s+\w+$'), '');
  return DateTime.tryParse(cleaned);
}

// ---------------------------------------------------------------------------
// env module
// ---------------------------------------------------------------------------

Map<String, Function> _envImports(
  WasmRunner runner,
  HostStore store,
  AsyncSleepDispatch? asyncSleep,
  void Function(String)? onLog,
) => <String, Function>{
  '_print': (int ptr, int len) {
    if (len > 0) {
      onLog?.call('[aidoku] ${utf8.decode(runner.readMemory(ptr, len))}');
    }
  },
  // Alias without leading underscore (used by newer compiled plugins).
  'print': (int ptr, int len) {
    if (len > 0) {
      onLog?.call('[aidoku] ${utf8.decode(runner.readMemory(ptr, len))}');
    }
  },
  '_sleep': (int seconds) {
    if (asyncSleep != null) {
      asyncSleep(seconds);
    }
    // else: no-op (blocking sleep not supported without async dispatch)
  },
  // Rust panic/abort — called when the WASM module panics.
  // Log and return; the host will see a corrupt result and handle it gracefully.
  'abort': () {
    onLog?.call('[aidoku] WASM abort called (plugin panic)');
  },
  '_send_partial_result': (int ptr) {
    try {
      // Layout: [u32 length LE][u32 capacity LE][<length> bytes postcard]
      final Uint8List lenBytes = runner.readMemory(ptr, 4);
      final int length = ByteData.sublistView(lenBytes).getUint32(0, Endian.little);
      if (length > 0) {
        final Uint8List data = runner.readMemory(ptr + 8, length);
        store.addPartialResult(data);
      }
    } on Exception catch (e) {
      onLog?.call('[aidoku] _send_partial_result failed: $e');
    }
  },
  // Alias without leading underscore (used by newer compiled plugins).
  'send_partial_result': (int ptr) {
    try {
      final Uint8List lenBytes = runner.readMemory(ptr, 4);
      final int length = ByteData.sublistView(lenBytes).getUint32(0, Endian.little);
      if (length > 0) {
        final Uint8List data = runner.readMemory(ptr + 8, length);
        store.addPartialResult(data);
      }
    } on Exception catch (e) {
      onLog?.call('[aidoku] send_partial_result failed: $e');
    }
  },
};

// ---------------------------------------------------------------------------
// net module
// ---------------------------------------------------------------------------

Map<String, Function> _netImports(
  WasmRunner runner,
  HostStore store,
  AsyncHttpDispatch? asyncHttp,
  RateLimitCallback? onRateLimitSet,
  Jsoup? htmlParser,
) {
  return <String, Function>{
    'init': (int method) {
      return store.add(HttpRequestResource(method: method));
    },
    'set_url': (int rid, int ptr, int len) {
      final HttpRequestResource? req = store.get<HttpRequestResource>(rid);
      if (req == null) return -1;
      req.url = utf8.decode(runner.readMemory(ptr, len));
      return 0;
    },
    'set_header': (int rid, int keyPtr, int keyLen, int valPtr, int valLen) {
      final HttpRequestResource? req = store.get<HttpRequestResource>(rid);
      if (req == null) return -1;
      final String key = utf8.decode(runner.readMemory(keyPtr, keyLen));
      final String val = utf8.decode(runner.readMemory(valPtr, valLen));
      req.headers[key] = val;
      return 0;
    },
    'set_body': (int rid, int ptr, int len) {
      final HttpRequestResource? req = store.get<HttpRequestResource>(rid);
      if (req == null) return -1;
      req.body = Uint8List.fromList(runner.readMemory(ptr, len));
      return 0;
    },
    'set_timeout': (int rid, double timeout) {
      final HttpRequestResource? req = store.get<HttpRequestResource>(rid);
      if (req == null) return -1;
      req.timeout = timeout;
      return 0;
    },
    'send': (int rid) {
      final HttpRequestResource? req = store.get<HttpRequestResource>(rid);
      if (req == null || req.url == null) return -1;
      if (asyncHttp == null) return -1;

      final ({Uint8List? body, int statusCode}) resp = asyncHttp(
        req.url!,
        req.method,
        Map<String, String>.from(req.headers),
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
        final Uint8List ridBytes = runner.readMemory(ridsPtr + i * 4, 4);
        final int rid = ByteData.sublistView(ridBytes).getInt32(0, Endian.little);
        final HttpRequestResource? req = store.get<HttpRequestResource>(rid);
        if (req == null || req.url == null) continue;
        final ({Uint8List? body, int statusCode}) resp = asyncHttp(
          req.url!,
          req.method,
          Map<String, String>.from(req.headers),
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
      final HttpRequestResource? req = store.get<HttpRequestResource>(rid);
      final Uint8List? body = req?.responseBody;
      if (body == null) return -1;
      final int n = len < body.length ? len : body.length;
      runner.writeMemory(ptr, body.sublist(0, n));
      return n;
    },
    'get_status_code': (int rid) {
      return store.get<HttpRequestResource>(rid)?.statusCode ?? -1;
    },
    'get_header': (int rid, int keyPtr, int keyLen) {
      final HttpRequestResource? req = store.get<HttpRequestResource>(rid);
      if (req == null) return -1;
      final String key = utf8.decode(runner.readMemory(keyPtr, keyLen)).toLowerCase();
      final String? val = req.responseHeaders[key];
      if (val == null) return -1;
      return store.addBytes(_encodeString(val));
    },
    'html': (int rid) {
      if (htmlParser == null) return -1;
      final HttpRequestResource? req = store.get<HttpRequestResource>(rid);
      final Uint8List? body = req?.responseBody;
      if (body == null) return -1;
      try {
        final String html = utf8.decode(body, allowMalformed: true);
        final Document doc = htmlParser.parse(html, baseUri: req!.url ?? '');
        return store.add(HtmlElementResource(doc));
      } on Object {
        return -1;
      }
    },
    'get_image': (int rid) {
      final HttpRequestResource? req = store.get<HttpRequestResource>(rid);
      final Uint8List? body = req?.responseBody;
      if (body == null) return -1;
      return store.addBytes(body);
    },
    'net_set_rate_limit': (int permits, int period, int unit) {
      final config = RateLimitConfig.fromWasm(permits, period, unit);
      onRateLimitSet?.call(config.permits, config.periodMs);
    },
    'set_rate_limit': (int permits, int period, int unit) {
      final config = RateLimitConfig.fromWasm(permits, period, unit);
      onRateLimitSet?.call(config.permits, config.periodMs);
    },
  };
}

// ---------------------------------------------------------------------------
// html module
// ---------------------------------------------------------------------------

Map<String, Function> _htmlImports(
  WasmRunner runner,
  HostStore store,
  void Function(String)? onLog,
  Jsoup? htmlParser,
) => <String, Function>{
  'parse': (int ptr, int len, [int? baseUriPtr, int? baseUriLen]) {
    if (htmlParser == null) return -1;
    try {
      final String html = utf8.decode(runner.readMemory(ptr, len));
      final String baseUri =
          baseUriPtr != null && baseUriLen != null && baseUriLen > 0
              ? utf8.decode(runner.readMemory(baseUriPtr, baseUriLen))
              : '';
      final Document doc = htmlParser.parse(html, baseUri: baseUri);
      return store.add(HtmlElementResource(doc));
    } on Object catch (e) {
      onLog?.call('[CB] html::parse failed: $e');
      return -1;
    }
  },
  'parse_fragment': (int ptr, int len, [int? baseUriPtr, int? baseUriLen]) {
    if (htmlParser == null) return -1;
    try {
      final String html = utf8.decode(runner.readMemory(ptr, len));
      final String baseUri =
          baseUriPtr != null && baseUriLen != null && baseUriLen > 0
              ? utf8.decode(runner.readMemory(baseUriPtr, baseUriLen))
              : '';
      final Document doc = htmlParser.parseFragment(html, baseUri: baseUri);
      return store.add(HtmlElementResource(doc));
    } on Object catch (e) {
      onLog?.call('[CB] html::parse_fragment failed: $e');
      return -1;
    }
  },
  'select': (int rid, int selectorPtr, int selectorLen) {
    if (htmlParser == null) return -1;
    try {
      final String selector = utf8.decode(runner.readMemory(selectorPtr, selectorLen));
      final HtmlElementResource? res = store.get<HtmlElementResource>(rid);
      if (res != null) {
        return store.add(HtmlElementsResource(res.element.select(selector)));
      }
      final HtmlElementsResource? listRes = store.get<HtmlElementsResource>(rid);
      if (listRes == null) return -1;
      // Select on Elements: select on first element as fallback.
      if (listRes.elements.isEmpty) return -1;
      return store.add(HtmlElementsResource(listRes.elements.first.select(selector)));
    } on Object catch (e) {
      onLog?.call('[CB] html::select failed: $e');
      return -1;
    }
  },
  'select_first': (int rid, int selectorPtr, int selectorLen) {
    if (htmlParser == null) return -1;
    try {
      final String selector = utf8.decode(runner.readMemory(selectorPtr, selectorLen));
      final HtmlElementResource? res = store.get<HtmlElementResource>(rid);
      if (res != null) {
        final Element? el = res.element.selectFirst(selector);
        if (el == null) return -1;
        return store.add(HtmlElementResource(el));
      }
      final HtmlElementsResource? listRes = store.get<HtmlElementsResource>(rid);
      if (listRes == null || listRes.elements.isEmpty) return -1;
      final Element? el = listRes.elements.first.selectFirst(selector);
      if (el == null) return -1;
      return store.add(HtmlElementResource(el));
    } on Object catch (e) {
      onLog?.call('[CB] html::select_first failed: $e');
      return -1;
    }
  },
  'attr': (int rid, int keyPtr, int keyLen) {
    if (htmlParser == null) return -1;
    try {
      final HtmlElementResource? res = store.get<HtmlElementResource>(rid);
      if (res == null) return -1;
      final String key = utf8.decode(runner.readMemory(keyPtr, keyLen));
      final String value;
      if (key.startsWith('abs:')) {
        value = res.element.absUrl(key.substring(4));
      } else {
        value = res.element.attr(key);
      }
      return store.addBytes(_encodeString(value));
    } on Object catch (e) {
      onLog?.call('[CB] html::attr failed: $e');
      return -1;
    }
  },
  'has_attr': (int rid, int keyPtr, int keyLen) {
    if (htmlParser == null) return 0;
    try {
      final HtmlElementResource? res = store.get<HtmlElementResource>(rid);
      if (res == null) return 0;
      final String key = utf8.decode(runner.readMemory(keyPtr, keyLen));
      return res.element.hasAttr(key) ? 1 : 0;
    } on Object {
      return 0;
    }
  },
  'text': (int rid) {
    if (htmlParser == null) return -1;
    try {
      final HtmlElementResource? res = store.get<HtmlElementResource>(rid);
      if (res == null) return -1;
      return store.addBytes(_encodeString(res.element.text));
    } on Object catch (e) {
      onLog?.call('[CB] html::text failed: $e');
      return -1;
    }
  },
  'own_text': (int rid) {
    if (htmlParser == null) return -1;
    try {
      final HtmlElementResource? res = store.get<HtmlElementResource>(rid);
      if (res == null) return -1;
      return store.addBytes(_encodeString(res.element.ownText));
    } on Object catch (e) {
      onLog?.call('[CB] html::own_text failed: $e');
      return -1;
    }
  },
  // untrimmed_text maps to Element.wholeText() in Java Jsoup; our OO API
  // only exposes wholeText on TextNode, so we fall back to Element.text.
  'untrimmed_text': (int rid) {
    if (htmlParser == null) return -1;
    try {
      final HtmlElementResource? res = store.get<HtmlElementResource>(rid);
      if (res == null) return -1;
      return store.addBytes(_encodeString(res.element.text));
    } on Object catch (e) {
      onLog?.call('[CB] html::untrimmed_text failed: $e');
      return -1;
    }
  },
  'html': (int rid) {
    if (htmlParser == null) return -1;
    try {
      final HtmlElementResource? res = store.get<HtmlElementResource>(rid);
      if (res == null) return -1;
      return store.addBytes(_encodeString(res.element.html));
    } on Object catch (e) {
      onLog?.call('[CB] html::html failed: $e');
      return -1;
    }
  },
  'outer_html': (int rid) {
    if (htmlParser == null) return -1;
    try {
      final HtmlElementResource? res = store.get<HtmlElementResource>(rid);
      if (res == null) return -1;
      return store.addBytes(_encodeString(res.element.outerHtml));
    } on Object catch (e) {
      onLog?.call('[CB] html::outer_html failed: $e');
      return -1;
    }
  },
  'tag_name': (int rid) {
    if (htmlParser == null) return -1;
    try {
      final HtmlElementResource? res = store.get<HtmlElementResource>(rid);
      if (res == null) return -1;
      return store.addBytes(_encodeString(res.element.tagName));
    } on Object catch (e) {
      onLog?.call('[CB] html::tag_name failed: $e');
      return -1;
    }
  },
  'id': (int rid) {
    if (htmlParser == null) return -1;
    try {
      final HtmlElementResource? res = store.get<HtmlElementResource>(rid);
      if (res == null) return -1;
      return store.addBytes(_encodeString(res.element.id));
    } on Object catch (e) {
      onLog?.call('[CB] html::id failed: $e');
      return -1;
    }
  },
  'class_name': (int rid) {
    if (htmlParser == null) return -1;
    try {
      final HtmlElementResource? res = store.get<HtmlElementResource>(rid);
      if (res == null) return -1;
      return store.addBytes(_encodeString(res.element.className));
    } on Object catch (e) {
      onLog?.call('[CB] html::class_name failed: $e');
      return -1;
    }
  },
  'base_uri': (int rid) {
    if (htmlParser == null) return -1;
    try {
      final HtmlElementResource? res = store.get<HtmlElementResource>(rid);
      if (res == null) return -1;
      return store.addBytes(_encodeString(res.element.baseUri));
    } on Object catch (e) {
      onLog?.call('[CB] html::base_uri failed: $e');
      return -1;
    }
  },
  'first': (int rid) {
    if (htmlParser == null) return -1;
    try {
      final HtmlElementsResource? res = store.get<HtmlElementsResource>(rid);
      if (res == null || res.elements.isEmpty) return -1;
      return store.add(HtmlElementResource(res.elements.first));
    } on Object catch (e) {
      onLog?.call('[CB] html::first failed: $e');
      return -1;
    }
  },
  'last': (int rid) {
    if (htmlParser == null) return -1;
    try {
      final HtmlElementsResource? res = store.get<HtmlElementsResource>(rid);
      if (res == null || res.elements.isEmpty) return -1;
      return store.add(HtmlElementResource(res.elements.last));
    } on Object catch (e) {
      onLog?.call('[CB] html::last failed: $e');
      return -1;
    }
  },
  'get': (int rid, int index) {
    if (htmlParser == null) return -1;
    try {
      final HtmlElementsResource? res = store.get<HtmlElementsResource>(rid);
      if (res == null || index < 0 || index >= res.elements.length) return -1;
      return store.add(HtmlElementResource(res.elements[index]));
    } on Object catch (e) {
      onLog?.call('[CB] html::get failed: $e');
      return -1;
    }
  },
  'html_get': (int rid, int index) {
    if (htmlParser == null) return -1;
    try {
      final HtmlElementsResource? res = store.get<HtmlElementsResource>(rid);
      if (res == null || index < 0 || index >= res.elements.length) return -1;
      return store.add(HtmlElementResource(res.elements[index]));
    } on Object catch (e) {
      onLog?.call('[CB] html::html_get failed: $e');
      return -1;
    }
  },
  'size': (int rid) {
    if (htmlParser == null) return -1;
    try {
      final HtmlElementsResource? res = store.get<HtmlElementsResource>(rid);
      if (res == null) return -1;
      return res.elements.length;
    } on Object catch (e) {
      onLog?.call('[CB] html::size failed: $e');
      return -1;
    }
  },
  'parent': (int rid) {
    if (htmlParser == null) return -1;
    try {
      final HtmlElementResource? res = store.get<HtmlElementResource>(rid);
      if (res == null) return -1;
      final Element? p = res.element.parent;
      if (p == null) return -1;
      return store.add(HtmlElementResource(p));
    } on Object catch (e) {
      onLog?.call('[CB] html::parent failed: $e');
      return -1;
    }
  },
  'children': (int rid) {
    if (htmlParser == null) return -1;
    try {
      final HtmlElementResource? res = store.get<HtmlElementResource>(rid);
      if (res == null) return -1;
      return store.add(HtmlElementsResource(res.element.children));
    } on Object catch (e) {
      onLog?.call('[CB] html::children failed: $e');
      return -1;
    }
  },
  'next': (int rid) {
    if (htmlParser == null) return -1;
    try {
      final HtmlElementResource? res = store.get<HtmlElementResource>(rid);
      if (res == null) return -1;
      final Element? el = res.element.nextElementSibling;
      if (el == null) return -1;
      return store.add(HtmlElementResource(el));
    } on Object catch (e) {
      onLog?.call('[CB] html::next failed: $e');
      return -1;
    }
  },
  'previous': (int rid) {
    if (htmlParser == null) return -1;
    try {
      final HtmlElementResource? res = store.get<HtmlElementResource>(rid);
      if (res == null) return -1;
      final Element? el = res.element.previousElementSibling;
      if (el == null) return -1;
      return store.add(HtmlElementResource(el));
    } on Object catch (e) {
      onLog?.call('[CB] html::previous failed: $e');
      return -1;
    }
  },
  'siblings': (int rid) {
    if (htmlParser == null) return -1;
    try {
      final HtmlElementResource? res = store.get<HtmlElementResource>(rid);
      if (res == null) return -1;
      return store.add(HtmlElementsResource(res.element.siblingElements));
    } on Object catch (e) {
      onLog?.call('[CB] html::siblings failed: $e');
      return -1;
    }
  },
  'set_text': (int rid, int ptr, int len) {
    if (htmlParser == null) return 0;
    try {
      final HtmlElementResource? res = store.get<HtmlElementResource>(rid);
      if (res == null) return 0;
      res.element.text = utf8.decode(runner.readMemory(ptr, len));
    } on Object catch (e) {
      onLog?.call('[CB] html::set_text failed: $e');
    }
    return 0;
  },
  'set_html': (int rid, int ptr, int len) {
    if (htmlParser == null) return 0;
    try {
      final HtmlElementResource? res = store.get<HtmlElementResource>(rid);
      if (res == null) return 0;
      res.element.html = utf8.decode(runner.readMemory(ptr, len));
    } on Object catch (e) {
      onLog?.call('[CB] html::set_html failed: $e');
    }
    return 0;
  },
  'remove': (int rid) {
    if (htmlParser == null) return 0;
    try {
      final HtmlElementResource? res = store.get<HtmlElementResource>(rid);
      if (res == null) return 0;
      res.element.remove();
    } on Object catch (e) {
      onLog?.call('[CB] html::remove failed: $e');
    }
    return 0;
  },
  'escape': (int ptr, int len) {
    final String str = utf8.decode(runner.readMemory(ptr, len));
    final String escaped = str
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#x27;');
    return store.addBytes(_encodeString(escaped));
  },
  'unescape': (int ptr, int len) {
    final String str = utf8.decode(runner.readMemory(ptr, len));
    final String unescaped = str
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#x27;', "'")
        .replaceAll('&#39;', "'");
    return store.addBytes(_encodeString(unescaped));
  },
  'has_class': (int rid, int classPtr, int classLen) {
    if (htmlParser == null) return 0;
    try {
      final HtmlElementResource? res = store.get<HtmlElementResource>(rid);
      if (res == null) return 0;
      final String name = utf8.decode(runner.readMemory(classPtr, classLen));
      return res.element.hasClass(name) ? 1 : 0;
    } on Object {
      return 0;
    }
  },
  'add_class': (int rid, int classPtr, int classLen) {
    if (htmlParser == null) return 0;
    try {
      final HtmlElementResource? res = store.get<HtmlElementResource>(rid);
      if (res == null) return 0;
      final String name = utf8.decode(runner.readMemory(classPtr, classLen));
      res.element.addClass(name);
    } on Object catch (e) {
      onLog?.call('[CB] html::add_class failed: $e');
    }
    return 0;
  },
  'remove_class': (int rid, int classPtr, int classLen) {
    if (htmlParser == null) return 0;
    try {
      final HtmlElementResource? res = store.get<HtmlElementResource>(rid);
      if (res == null) return 0;
      final String name = utf8.decode(runner.readMemory(classPtr, classLen));
      res.element.removeClass(name);
    } on Object catch (e) {
      onLog?.call('[CB] html::remove_class failed: $e');
    }
    return 0;
  },
  'set_attr': (int rid, int keyPtr, int keyLen, int valPtr, int valLen) {
    if (htmlParser == null) return 0;
    try {
      final HtmlElementResource? res = store.get<HtmlElementResource>(rid);
      if (res == null) return 0;
      final String key = utf8.decode(runner.readMemory(keyPtr, keyLen));
      final String val = utf8.decode(runner.readMemory(valPtr, valLen));
      res.element.setAttr(key, val);
    } on Object catch (e) {
      onLog?.call('[CB] html::set_attr failed: $e');
    }
    return 0;
  },
  'remove_attr': (int rid, int keyPtr, int keyLen) {
    if (htmlParser == null) return 0;
    try {
      final HtmlElementResource? res = store.get<HtmlElementResource>(rid);
      if (res == null) return 0;
      final String key = utf8.decode(runner.readMemory(keyPtr, keyLen));
      res.element.removeAttr(key);
    } on Object catch (e) {
      onLog?.call('[CB] html::remove_attr failed: $e');
    }
    return 0;
  },
  'prepend': (int rid, int ptr, int len) {
    if (htmlParser == null) return 0;
    try {
      final HtmlElementResource? res = store.get<HtmlElementResource>(rid);
      if (res == null) return 0;
      res.element.prepend(utf8.decode(runner.readMemory(ptr, len)));
    } on Object catch (e) {
      onLog?.call('[CB] html::prepend failed: $e');
    }
    return 0;
  },
  'append': (int rid, int ptr, int len) {
    if (htmlParser == null) return 0;
    try {
      final HtmlElementResource? res = store.get<HtmlElementResource>(rid);
      if (res == null) return 0;
      res.element.append(utf8.decode(runner.readMemory(ptr, len)));
    } on Object catch (e) {
      onLog?.call('[CB] html::append failed: $e');
    }
    return 0;
  },
  'data': (int rid) {
    if (htmlParser == null) return -1;
    try {
      final HtmlElementResource? res = store.get<HtmlElementResource>(rid);
      if (res == null) return -1;
      return store.addBytes(_encodeString(res.element.data));
    } on Object catch (e) {
      onLog?.call('[CB] html::data failed: $e');
      return -1;
    }
  },
};

// ---------------------------------------------------------------------------
// defaults module
// ---------------------------------------------------------------------------

Map<String, Function> _defaultsImports(
  WasmRunner runner,
  HostStore store,
  String sourceId,
) => <String, Function>{
  'get': (int keyPtr, int keyLen) {
    final key = '$sourceId.${utf8.decode(runner.readMemory(keyPtr, keyLen))}';
    final Object? stored = store.defaults[key];
    if (stored == null) return 0;
    if (stored is int) return stored;
    if (stored is Uint8List) return store.addBytes(stored);
    return 0;
  },
  // Aidoku SDK DefaultValue kinds: 1=Bool, 2=Int, 3=Float, 4=String, 5=StringArray, 6=Null.
  // For all non-null kinds, `value` is an RID pointing to postcard-encoded bytes.
  'set': (int keyPtr, int keyLen, int kind, int value) {
    final key = '$sourceId.${utf8.decode(runner.readMemory(keyPtr, keyLen))}';
    if (kind == 6 || value == 0) {
      // DefaultValue::Null → clear the stored value.
      store.defaults.remove(key);
    } else {
      // All other kinds: value is an RID with postcard-encoded bytes. Read and cache them.
      final BytesResource? res = store.get<BytesResource>(value);
      if (res != null) store.defaults[key] = Uint8List.fromList(res.bytes);
    }
    return 0;
  },
};

// ---------------------------------------------------------------------------
// canvas module
// ---------------------------------------------------------------------------

Map<String, Function> _canvasImports(WasmRunner runner, HostStore store, void Function(String)? onLog) =>
    <String, Function>{
      'new_context': (double width, double height) {
        try {
          final image = img.Image(
            width: width.toInt(),
            height: height.toInt(),
            numChannels: 4,
          );
          return store.add(CanvasContextResource(image));
        } on Exception catch (e) {
          onLog?.call('[aidoku] canvas::new_context: $e');
          return -1;
        }
      },
      'set_transform':
          (
            int ctx,
            double tx,
            double ty,
            double sx,
            double sy,
            double angle,
          ) {
            final CanvasContextResource? c = store.get<CanvasContextResource>(ctx);
            if (c == null) return -1;
            // TODO: apply affine transform during compositing (package:image lacks
            // affine transform support for compositeImage)
            c.tx = tx;
            c.ty = ty;
            c.sx = sx;
            c.sy = sy;
            c.angle = angle;
            return 0;
          },
      'draw_image':
          (
            int ctx,
            int imgRid,
            double dx,
            double dy,
            double dw,
            double dh,
          ) {
            try {
              final CanvasContextResource? c = store.get<CanvasContextResource>(ctx);
              final ImageResource? src = store.get<ImageResource>(imgRid);
              if (c == null || src == null) return -1;
              img.compositeImage(
                c.image,
                src.image,
                dstX: dx.toInt(),
                dstY: dy.toInt(),
                dstW: dw.toInt(),
                dstH: dh.toInt(),
                blend: img.BlendMode.direct,
              );
              return 0;
            } on Exception catch (e) {
              onLog?.call('[aidoku] canvas::draw_image: $e');
              return -1;
            }
          },
      'copy_image':
          (
            int ctx,
            int imgRid,
            double sx,
            double sy,
            double sw,
            double sh,
            double dx,
            double dy,
            double dw,
            double dh,
          ) {
            try {
              final CanvasContextResource? c = store.get<CanvasContextResource>(ctx);
              final ImageResource? src = store.get<ImageResource>(imgRid);
              if (c == null || src == null) return -1;
              img.compositeImage(
                c.image,
                src.image,
                srcX: sx.toInt(),
                srcY: sy.toInt(),
                srcW: sw.toInt(),
                srcH: sh.toInt(),
                dstX: dx.toInt(),
                dstY: dy.toInt(),
                dstW: dw.toInt(),
                dstH: dh.toInt(),
                blend: img.BlendMode.direct,
              );
              return 0;
            } on Exception catch (e) {
              onLog?.call('[aidoku] canvas::copy_image: $e');
              return -1;
            }
          },
      'fill': (int ctx, int pathPtr, double r, double g, double b, double a) {
        try {
          final CanvasContextResource? c = store.get<CanvasContextResource>(ctx);
          if (c == null) return -1;
          final Uint8List postcard = readEncodedPostcard(runner, pathPtr);
          if (postcard.isEmpty) return -1;
          final List<PathOp> ops = deserializePathOps(postcard);
          fillPath(c.image, ops, r, g, b, a);
          return 0;
        } on Exception catch (e) {
          onLog?.call('[aidoku] canvas::fill: $e');
          return -1;
        }
      },
      'stroke': (int ctx, int pathPtr, int stylePtr) {
        try {
          final CanvasContextResource? c = store.get<CanvasContextResource>(ctx);
          if (c == null) return -1;
          final Uint8List pathPostcard = readEncodedPostcard(runner, pathPtr);
          final Uint8List stylePostcard = readEncodedPostcard(runner, stylePtr);
          if (pathPostcard.isEmpty || stylePostcard.isEmpty) return -1;
          final List<PathOp> ops = deserializePathOps(pathPostcard);
          final StrokeStyleData style = deserializeStrokeStyle(stylePostcard);
          strokePath(c.image, ops, style);
          return 0;
        } on Exception catch (e) {
          onLog?.call('[aidoku] canvas::stroke: $e');
          return -1;
        }
      },
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
          ) {
            try {
              final CanvasContextResource? c = store.get<CanvasContextResource>(ctx);
              if (c == null) return -1;
              final String text = utf8.decode(runner.readMemory(textPtr, textLen));
              final color = img.ColorRgba8(
                (r * 255).round().clamp(0, 255),
                (g * 255).round().clamp(0, 255),
                (b * 255).round().clamp(0, 255),
                (a * 255).round().clamp(0, 255),
              );
              // TODO: support custom fonts and font sizes (package:image only
              // provides bitmap fonts, no TTF rendering)
              img.drawString(c.image, text, font: img.arial14, x: x.toInt(), y: y.toInt(), color: color);
              return 0;
            } on Exception catch (e) {
              onLog?.call('[aidoku] canvas::draw_text: $e');
              return -1;
            }
          },
      'get_image': (int ctx) {
        try {
          final CanvasContextResource? c = store.get<CanvasContextResource>(ctx);
          if (c == null) return -1;
          return store.add(ImageResource(c.image.clone()));
        } on Exception catch (e) {
          onLog?.call('[aidoku] canvas::get_image: $e');
          return -1;
        }
      },
      // TODO: implement real font loading (currently returns placeholder RID)
      'new_font': (int namePtr, int nameLen) {
        try {
          final String name = utf8.decode(runner.readMemory(namePtr, nameLen));
          return store.add(FontResource(name: name, weight: 4));
        } on Exception catch (e) {
          onLog?.call('[aidoku] canvas::new_font: $e');
          return -1;
        }
      },
      // TODO: implement real font loading (currently returns placeholder RID)
      'system_font': (int weight) {
        return store.add(FontResource(name: 'system', weight: weight));
      },
      // TODO: implement remote font loading (currently returns placeholder RID)
      'load_font': (int urlPtr, int urlLen) {
        try {
          final String url = utf8.decode(runner.readMemory(urlPtr, urlLen));
          onLog?.call('[aidoku] canvas::load_font: font loading not supported (url=$url)');
          return store.add(FontResource(name: 'loaded', weight: 4));
        } on Exception catch (e) {
          onLog?.call('[aidoku] canvas::load_font: $e');
          return -1;
        }
      },
      'new_image': (int dataPtr, int dataLen) {
        try {
          final Uint8List bytes = runner.readMemory(dataPtr, dataLen);
          final img.Image? decoded = img.decodeImage(bytes);
          if (decoded == null) return -1;
          return store.add(ImageResource(decoded));
        } on Exception catch (e) {
          onLog?.call('[aidoku] canvas::new_image: $e');
          return -1;
        }
      },
      'get_image_data': (int imgRid) {
        try {
          final ImageResource? r = store.get<ImageResource>(imgRid);
          if (r == null) return -1;
          final Uint8List pngBytes = img.encodePng(r.image);
          return store.addBytes(pngBytes);
        } on Exception catch (e) {
          onLog?.call('[aidoku] canvas::get_image_data: $e');
          return -1;
        }
      },
      'get_image_width': (int imgRid) {
        final ImageResource? r = store.get<ImageResource>(imgRid);
        if (r == null) return 0.0;
        return r.image.width.toDouble();
      },
      'get_image_height': (int imgRid) {
        final ImageResource? r = store.get<ImageResource>(imgRid);
        if (r == null) return 0.0;
        return r.image.height.toDouble();
      },
    };

// ---------------------------------------------------------------------------
// js module (stub — embedded JS execution not implemented)
// ---------------------------------------------------------------------------

// TODO: implement JS/webview execution (requires embedding a JS engine)
Map<String, Function> _jsImports(void Function(String)? onLog) => <String, Function>{
  'context_create': () {
    onLog?.call('[aidoku] js module not implemented');
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

/// Encode a Dart string as raw UTF-8 bytes for aidoku-rs `read_string_and_destroy`.
///
/// The SDK reads host-buffered strings via `String::from_utf8(buffer)` — raw
/// UTF-8, no postcard framing. Postcard is only used for structured results
/// returned from WASM exports, not for individual string-valued host imports.
Uint8List _encodeString(String s) => Uint8List.fromList(utf8.encode(s));
