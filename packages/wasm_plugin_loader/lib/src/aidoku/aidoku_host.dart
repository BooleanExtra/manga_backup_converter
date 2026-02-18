import 'dart:convert';
import 'dart:typed_data';

import 'package:html/dom.dart' as html_dom;
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;

import '../codec/postcard_writer.dart';
import '../wasm/wasm_runner.dart';
import 'host_store.dart';

/// Builds the complete map of host import functions for an Aidoku WASM plugin.
///
/// Keys: outer = module name, inner = function name.
/// Values: Dart functions matching the WASM import signature.
///
/// ABI source: packages/wasm_plugin_loader/WASM_ABI.md
Map<String, Map<String, Function>> buildAidokuHostImports(
  WasmRunner runner,
  HostStore store,
) {
  return {
    'std': _stdImports(runner, store),
    'env': _envImports(runner),
    'net': _netImports(runner, store),
    'html': _htmlImports(runner, store),
    'defaults': _defaultsImports(runner),
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
      '_read_buffer': (int rid, int ptr, int len) {
        final r = store.get<BytesResource>(rid);
        if (r == null) return -1;
        final bytes = r.bytes.length <= len ? r.bytes : r.bytes.sublist(0, len);
        runner.writeMemory(ptr, bytes);
        return 0;
      },
      '_current_date': () {
        return DateTime.now().millisecondsSinceEpoch.toDouble();
      },
      'utc_offset': () {
        return DateTime.now().timeZoneOffset.inSeconds;
      },
      '_parse_date': (
        int strPtr,
        int strLen,
        int fmtPtr,
        int fmtLen,
        int localePtr,
        int localeLen,
        int tzPtr,
        int tzLen,
      ) {
        // Best-effort date parsing — return -1 on failure
        try {
          final dateStr = utf8.decode(runner.readMemory(strPtr, strLen));
          final parsed = DateTime.tryParse(dateStr);
          return parsed?.millisecondsSinceEpoch.toDouble() ?? -1.0;
        } catch (_) {
          return -1.0;
        }
      },
    };

// ---------------------------------------------------------------------------
// env module
// ---------------------------------------------------------------------------

Map<String, Function> _envImports(WasmRunner runner) => {
      '_print': (int ptr, int len) {
        if (len > 0) {
          // ignore: avoid_print
          print('[aidoku] ${utf8.decode(runner.readMemory(ptr, len))}');
        }
      },
      '_sleep': (int seconds) {
        // Intentional no-op — blocking sleep is incompatible with async Dart.
      },
      '_send_partial_result': (int ptr) {
        // Partial results are not used for backup conversion; stub.
      },
    };

// ---------------------------------------------------------------------------
// net module
// ---------------------------------------------------------------------------

/// HTTP method constants matching Aidoku's HttpMethod enum.
const _httpMethods = ['GET', 'POST', 'PUT', 'DELETE', 'HEAD'];

Map<String, Function> _netImports(WasmRunner runner, HostStore store) => {
      'init': (int method) {
        final req = HttpRequestResource(method: method);
        return store.add(req);
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
      'send': (int rid) async {
        final req = store.get<HttpRequestResource>(rid);
        if (req == null) return -1;
        if (req.url == null) return -1;
        return _executeRequest(req);
      },
      'send_all': (int ridsPtr, int count) async {
        // Read array of i32 Rids from WASM memory
        final futures = <Future<int>>[];
        for (var i = 0; i < count; i++) {
          final ridBytes = runner.readMemory(ridsPtr + i * 4, 4);
          final rid = ByteData.sublistView(ridBytes).getInt32(0, Endian.little);
          final req = store.get<HttpRequestResource>(rid);
          if (req != null) futures.add(_executeRequest(req));
        }
        await Future.wait(futures);
        return 0;
      },
      'data_len': (int rid) {
        final req = store.get<HttpRequestResource>(rid);
        return req?.responseBody?.length ?? -1;
      },
      'read_data': (int rid, int ptr, int len) {
        final req = store.get<HttpRequestResource>(rid);
        if (req?.responseBody == null) return -1;
        final body = req!.responseBody!;
        final bytesToCopy = len < body.length ? len : body.length;
        runner.writeMemory(ptr, body.sublist(0, bytesToCopy));
        return bytesToCopy;
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
        final encoded = _encodeString(val);
        return store.addBytes(encoded);
      },
      'html': (int rid) {
        final req = store.get<HttpRequestResource>(rid);
        if (req?.responseBody == null) return -1;
        final htmlStr = utf8.decode(req!.responseBody!);
        final doc = html_parser.parse(htmlStr);
        return store.add(HtmlDocumentResource(doc));
      },
      'get_image': (int rid) {
        // Image data passthrough — return the response bytes as a resource
        final req = store.get<HttpRequestResource>(rid);
        if (req?.responseBody == null) return -1;
        return store.addBytes(req!.responseBody!);
      },
      'set_rate_limit': (int permits, int period, int unit) {
        // Rate limiting is managed by the app layer; stub here.
      },
    };

Future<int> _executeRequest(HttpRequestResource req) async {
  try {
    final uri = Uri.parse(req.url!);
    final methodName = req.method < _httpMethods.length ? _httpMethods[req.method] : 'GET';
    final request = http.Request(methodName, uri);
    request.headers.addAll(req.headers);
    if (req.body != null) request.bodyBytes = req.body!;

    final response = await http.Client()
        .send(request)
        .timeout(Duration(seconds: req.timeout.toInt()));
    final bodyBytes = await response.stream.toBytes();

    req.statusCode = response.statusCode;
    req.responseBody = bodyBytes;
    response.headers.forEach((k, v) => req.responseHeaders[k.toLowerCase()] = v);
    return 0;
  } catch (_) {
    return -1;
  }
}

// ---------------------------------------------------------------------------
// html module
// ---------------------------------------------------------------------------

Map<String, Function> _htmlImports(WasmRunner runner, HostStore store) => {
      'parse': (int contentRid, int baseUrlPtr, int baseUrlLen) {
        // contentRid is a resource with HTML bytes, or -1 for direct WASM memory
        Uint8List? htmlBytes;
        if (store.contains(contentRid)) {
          htmlBytes = store.get<BytesResource>(contentRid)?.bytes;
        }
        if (htmlBytes == null) return -1;
        final htmlStr = utf8.decode(htmlBytes);
        final doc = html_parser.parse(htmlStr);
        return store.add(HtmlDocumentResource(doc));
      },
      'parse_fragment': (int contentRid, int baseUrlPtr, int baseUrlLen) {
        final htmlBytes = store.get<BytesResource>(contentRid)?.bytes;
        if (htmlBytes == null) return -1;
        final htmlStr = utf8.decode(htmlBytes);
        final nodes = html_parser.parseFragment(htmlStr);
        final elements = nodes.children.whereType<html_dom.Element>().toList();
        return store.add(HtmlNodeListResource(elements));
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
        // Own text: text nodes that are direct children (not inside child elements)
        final ownText = el.nodes
            .whereType<html_dom.Text>()
            .map((n) => n.text)
            .join()
            .trim();
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
        // html package doesn't track base URI; return empty
        return store.addBytes(_encodeString(''));
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
      'html_get': (int rid, int index) {
        final list = store.get<HtmlNodeListResource>(rid);
        if (list == null || index < 0 || index >= list.nodes.length) return -1;
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
        final html = utf8.decode(runner.readMemory(ptr, len));
        el.innerHtml = html + el.innerHtml;
        return 0;
      },
      'append': (int rid, int ptr, int len) {
        final el = _asElement(store, rid);
        if (el == null) return -1;
        final html = utf8.decode(runner.readMemory(ptr, len));
        el.innerHtml = el.innerHtml + html;
        return 0;
      },
      'data': (int rid) {
        // Script/comment data; return text content as fallback
        final el = _asElement(store, rid);
        if (el == null) return -1;
        return store.addBytes(_encodeString(el.text));
      },
    };

// ---------------------------------------------------------------------------
// defaults module
// ---------------------------------------------------------------------------

Map<String, Function> _defaultsImports(WasmRunner runner) => {
      'get': (int keyPtr, int keyLen) {
        // Return -1 for all preferences — plugin uses its built-in defaults.
        return -1;
      },
      'set': (int keyPtr, int keyLen, int kind, int value) {
        // Ignore preference writes during backup conversion.
        return 0;
      },
    };

// ---------------------------------------------------------------------------
// Helpers
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
Uint8List _encodeString(String s) {
  final w = PostcardWriter()..writeString(s);
  return w.bytes;
}
