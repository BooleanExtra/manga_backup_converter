// ignore_for_file: lines_longer_than_80_chars

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:jsoup/cheerio.dart';
import 'package:jsoup/src/jsoup_api.dart';
import 'package:jsoup/src/web/jsoup_selector.dart';

/// Whether the Cheerio UMD bundle has been loaded into `globalThis.cheerio`.
bool _cheerioLoaded = false;

/// Load the Cheerio UMD bundle into the global scope if not already present.
///
/// The cheerio source is a trusted, pre-bundled const string shipped with the
/// package (`cheerioJs` from `package:jsoup/cheerio.dart`). We use
/// `importScripts` to execute it, which sets `self.cheerio`.
///
/// **Note**: `importScripts` is only available in Web Worker contexts. If
/// `CheerioParser` is used on the main browser thread, the caller must load
/// cheerio into `globalThis.cheerio` before instantiation (the method checks
/// for an existing global first and skips `importScripts` if found).
void _ensureCheerioLoaded() {
  if (_cheerioLoaded) return;

  // Check if already available (e.g. loaded by the WASM worker host).
  final JSAny? existing = globalContext.getProperty('cheerio'.toJS);
  if (existing != null && !existing.isUndefinedOrNull) {
    _cheerioLoaded = true;
    return;
  }

  // Create a Blob URL from the trusted cheerio const string and use
  // importScripts to load it synchronously (works in Worker contexts).
  // The UMD bundle registers `self.cheerio` when executed.
  final JSArray<JSAny> parts = <JSAny>[cheerioJs.toJS].toJS;
  final blobOptions = JSObject();
  blobOptions.setProperty('type'.toJS, 'application/javascript'.toJS);
  final JSObject blob = _jsBlob(parts, blobOptions);
  final String blobUrl = _jsCreateObjectURL(blob);
  try {
    _jsImportScripts(blobUrl.toJS);
  } finally {
    _jsRevokeObjectURL(blobUrl);
  }

  _cheerioLoaded = true;
}

// JS interop helpers for Blob URL + importScripts.

@JS('Blob')
external JSObject _jsBlobConstructor(JSArray<JSAny> parts, JSObject options);

JSObject _jsBlob(JSArray<JSAny> parts, JSObject options) => _jsBlobConstructor(parts, options);

@JS('URL.createObjectURL')
external String _jsCreateObjectURL(JSObject blob);

@JS('URL.revokeObjectURL')
external void _jsRevokeObjectURL(String url);

@JS('importScripts')
external void _jsImportScripts(JSString url);

/// Get the global `cheerio` object.
JSObject get _cheerio {
  _ensureCheerioLoaded();
  return globalContext.getProperty('cheerio'.toJS)! as JSObject;
}

/// Cheerio-backed [NativeHtmlParser] for web.
///
/// Uses the Cheerio library (loaded as a UMD global) via `dart:js_interop` to
/// implement the same API that `JsoupParser` provides via JNI on native
/// platforms.
///
/// **Worker-only**: Cheerio loading uses `importScripts`, which is only
/// available in Web Worker contexts. On the main thread, ensure
/// `globalThis.cheerio` is set before creating a [CheerioParser].
///
/// Handles are opaque integers backed by `Map<int, JSObject>` (elements,
/// text nodes) or `Map<int, List<JSObject>>` (node lists). Callers must
/// call [free] when handles are no longer needed to avoid unbounded growth.
class CheerioParser implements NativeHtmlParser {
  /// Creates a Cheerio parser, loading the Cheerio bundle if needed.
  CheerioParser() {
    _ensureCheerioLoaded();
  }

  // Handle stores: maps opaque int handles to JS objects.
  final Map<int, JSObject> _elements = <int, JSObject>{};
  final Map<int, JSObject> _textNodes = <int, JSObject>{};
  final Map<int, List<JSObject>> _nodeLists = <int, List<JSObject>>{};

  // Context tracking: each cheerio.load() creates a $ function.
  final Map<int, JSFunction> _contexts = <int, JSFunction>{};
  final Map<int, int> _ctxForHandle = <int, int>{};
  final Map<int, String> _baseUris = <int, String>{};
  int _nextHandle = 1;
  int _nextCtxId = 1;

  int _addElement(JSObject node, int ctxId) {
    final int handle = _nextHandle++;
    _elements[handle] = node;
    _ctxForHandle[handle] = ctxId;
    return handle;
  }

  int _addTextNode(JSObject node, int ctxId) {
    final int handle = _nextHandle++;
    _textNodes[handle] = node;
    _ctxForHandle[handle] = ctxId;
    return handle;
  }

  int _addNodeList(List<JSObject> nodes, int ctxId) {
    final int handle = _nextHandle++;
    _nodeLists[handle] = nodes;
    _ctxForHandle[handle] = ctxId;
    return handle;
  }

  /// Classify a domhandler node and add it to the appropriate map.
  int _addNode(JSObject node, int ctxId) {
    final JSAny? type = node.getProperty('type'.toJS);
    final String typeStr = type.isUndefinedOrNull ? '' : (type! as JSString).toDart;
    if (typeStr == 'text') {
      return _addTextNode(node, ctxId);
    }
    return _addElement(node, ctxId);
  }

  int _ctxOf(int handle) => _ctxForHandle[handle] ?? 0;

  JSFunction? _$of(int handle) => _contexts[_ctxOf(handle)];

  String _baseUriOf(int handle) => _baseUris[_ctxOf(handle)] ?? '';

  // ---------------------------------------------------------------------------
  // Parse
  // ---------------------------------------------------------------------------

  @override
  int parse(String html, {String baseUri = ''}) {
    try {
      final $ = _cheerio.callMethod('load'.toJS, html.toJS)! as JSFunction;
      final int ctxId = _nextCtxId++;
      _contexts[ctxId] = $;
      _baseUris[ctxId] = baseUri;
      // $.root()[0] — the root domhandler node.
      final root$ = $.callMethod('root'.toJS)! as JSObject;
      final rootArr = root$.callMethod('toArray'.toJS)! as JSArray<JSObject>;
      final JSObject rootNode = rootArr.toDart.first;
      return _addElement(rootNode, ctxId);
    } on Object catch (_) {
      return -1;
    }
  }

  @override
  int parseFragment(String html, {String baseUri = ''}) {
    // Cheerio handles fragments the same way — cheerio.load() wraps in a root.
    return parse(html, baseUri: baseUri);
  }

  // ---------------------------------------------------------------------------
  // Select
  // ---------------------------------------------------------------------------

  @override
  int select(int handle, String selector) {
    final JSObject? el = _elements[handle];
    if (el == null) return -1;
    final JSFunction? $ = _$of(handle);
    if ($ == null) return -1;
    try {
      final List<JSObject> results = jsoupSelect($, el, selector);
      return _addNodeList(results, _ctxOf(handle));
    } on Object catch (_) {
      return -1;
    }
  }

  @override
  int selectFirst(int handle, String selector) {
    final JSObject? el = _elements[handle];
    if (el == null) return -1;
    final JSFunction? $ = _$of(handle);
    if ($ == null) return -1;
    try {
      final List<JSObject> results = jsoupSelect($, el, selector);
      if (results.isEmpty) return -1;
      return _addElement(results.first, _ctxOf(handle));
    } on Object catch (_) {
      return -1;
    }
  }

  // ---------------------------------------------------------------------------
  // Attributes
  // ---------------------------------------------------------------------------

  @override
  String? attr(int handle, String key) {
    final JSObject? el = _elements[handle];
    if (el == null) return null;
    final JSFunction? $ = _$of(handle);
    if ($ == null) return null;
    try {
      final wrapped = $.callAsFunction(null, el)! as JSObject;
      final JSAny? val = wrapped.callMethod('attr'.toJS, key.toJS);
      if (val.isUndefinedOrNull) return null;
      return (val! as JSString).toDart;
    } on Object catch (_) {
      return null;
    }
  }

  @override
  bool hasAttr(int handle, String key) {
    final JSObject? el = _elements[handle];
    if (el == null) return false;
    final JSFunction? $ = _$of(handle);
    if ($ == null) return false;
    try {
      final wrapped = $.callAsFunction(null, el)! as JSObject;
      final JSAny? val = wrapped.callMethod('attr'.toJS, key.toJS);
      return !val.isUndefinedOrNull;
    } on Object catch (_) {
      return false;
    }
  }

  @override
  void setAttr(int handle, String key, String value) {
    final JSObject? el = _elements[handle];
    if (el == null) return;
    final JSFunction? $ = _$of(handle);
    if ($ == null) return;
    try {
      final wrapped = $.callAsFunction(null, el)! as JSObject;
      wrapped.callMethod('attr'.toJS, key.toJS, value.toJS);
    } on Object catch (_) {
      // Ignore.
    }
  }

  @override
  void removeAttr(int handle, String key) {
    final JSObject? el = _elements[handle];
    if (el == null) return;
    final JSFunction? $ = _$of(handle);
    if ($ == null) return;
    try {
      final wrapped = $.callAsFunction(null, el)! as JSObject;
      wrapped.callMethod('removeAttr'.toJS, key.toJS);
    } on Object catch (_) {
      // Ignore.
    }
  }

  // ---------------------------------------------------------------------------
  // Text & HTML
  // ---------------------------------------------------------------------------

  @override
  String? text(int handle) {
    final JSObject? el = _elements[handle];
    if (el == null) return null;
    final JSFunction? $ = _$of(handle);
    if ($ == null) return null;
    try {
      final wrapped = $.callAsFunction(null, el)! as JSObject;
      final JSAny? val = wrapped.callMethod('text'.toJS);
      if (val.isUndefinedOrNull) return null;
      return (val! as JSString).toDart.trim();
    } on Object catch (_) {
      return null;
    }
  }

  @override
  String? ownText(int handle) {
    final JSObject? el = _elements[handle];
    if (el == null) return null;
    final JSFunction? $ = _$of(handle);
    if ($ == null) return null;
    try {
      return getOwnText($, el);
    } on Object catch (_) {
      return null;
    }
  }

  @override
  String? innerHtml(int handle) {
    final JSObject? el = _elements[handle];
    if (el == null) return null;
    final JSFunction? $ = _$of(handle);
    if ($ == null) return null;
    try {
      final wrapped = $.callAsFunction(null, el)! as JSObject;
      final JSAny? val = wrapped.callMethod('html'.toJS);
      if (val.isUndefinedOrNull) return null;
      return (val! as JSString).toDart;
    } on Object catch (_) {
      return null;
    }
  }

  @override
  String? outerHtml(int handle) {
    final JSObject? el = _elements[handle];
    if (el == null) return null;
    final JSFunction? $ = _$of(handle);
    if ($ == null) return null;
    try {
      // $.html(el) — Cheerio static method that returns outer HTML.
      // JSFunction extends JSObject in dart:js_interop, so the cast is safe.
      // We call it as a method on $ rather than wrapping el first because
      // Cheerio's $(el).html() returns inner HTML, not outer HTML.
      final JSAny? html = ($ as JSObject).callMethod('html'.toJS, el);
      if (html.isUndefinedOrNull) return null;
      return (html! as JSString).toDart;
    } on Object catch (_) {
      return null;
    }
  }

  @override
  String? data(int handle) {
    final JSObject? el = _elements[handle];
    if (el == null) return null;
    final JSFunction? $ = _$of(handle);
    if ($ == null) return null;
    try {
      // For script/style elements, return inner HTML. Otherwise return text.
      final JSAny? nameVal = el.getProperty('name'.toJS);
      final String tag = nameVal.isUndefinedOrNull ? '' : (nameVal! as JSString).toDart.toLowerCase();
      if (tag == 'script' || tag == 'style') {
        final wrapped = $.callAsFunction(null, el)! as JSObject;
        final JSAny? html = wrapped.callMethod('html'.toJS);
        return html.isUndefinedOrNull ? '' : (html! as JSString).toDart;
      }
      final wrapped = $.callAsFunction(null, el)! as JSObject;
      final JSAny? val = wrapped.callMethod('text'.toJS);
      return val.isUndefinedOrNull ? '' : (val! as JSString).toDart;
    } on Object catch (_) {
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // Identity
  // ---------------------------------------------------------------------------

  @override
  String? tagName(int handle) {
    final JSObject? el = _elements[handle];
    if (el == null) return null;
    final JSAny? name = el.getProperty('name'.toJS);
    if (name.isUndefinedOrNull) return null;
    return (name! as JSString).toDart.toLowerCase();
  }

  @override
  String? id(int handle) {
    final String? val = attr(handle, 'id');
    if (val != null && val.isEmpty) return null;
    return val;
  }

  @override
  String? className(int handle) => attr(handle, 'class');

  @override
  bool hasClass(int handle, String name) {
    final JSObject? el = _elements[handle];
    if (el == null) return false;
    final JSFunction? $ = _$of(handle);
    if ($ == null) return false;
    try {
      final wrapped = $.callAsFunction(null, el)! as JSObject;
      final JSAny? val = wrapped.callMethod('hasClass'.toJS, name.toJS);
      if (val.isUndefinedOrNull) return false;
      return (val! as JSBoolean).toDart;
    } on Object catch (_) {
      return false;
    }
  }

  @override
  void addClass(int handle, String name) {
    final JSObject? el = _elements[handle];
    if (el == null) return;
    final JSFunction? $ = _$of(handle);
    if ($ == null) return;
    try {
      final wrapped = $.callAsFunction(null, el)! as JSObject;
      wrapped.callMethod('addClass'.toJS, name.toJS);
    } on Object catch (_) {
      // Ignore.
    }
  }

  @override
  void removeClass(int handle, String name) {
    final JSObject? el = _elements[handle];
    if (el == null) return;
    final JSFunction? $ = _$of(handle);
    if ($ == null) return;
    try {
      final wrapped = $.callAsFunction(null, el)! as JSObject;
      wrapped.callMethod('removeClass'.toJS, name.toJS);
    } on Object catch (_) {
      // Ignore.
    }
  }

  // ---------------------------------------------------------------------------
  // Node list operations
  // ---------------------------------------------------------------------------

  @override
  int size(int handle) {
    final List<JSObject>? list = _nodeLists[handle];
    if (list == null) return -1;
    return list.length;
  }

  @override
  int get(int handle, int index) {
    final List<JSObject>? list = _nodeLists[handle];
    if (list == null || index < 0 || index >= list.length) return -1;
    return _addElement(list[index], _ctxOf(handle));
  }

  @override
  int first(int handle) {
    final List<JSObject>? list = _nodeLists[handle];
    if (list == null || list.isEmpty) return -1;
    return _addElement(list.first, _ctxOf(handle));
  }

  @override
  int last(int handle) {
    final List<JSObject>? list = _nodeLists[handle];
    if (list == null || list.isEmpty) return -1;
    return _addElement(list.last, _ctxOf(handle));
  }

  // ---------------------------------------------------------------------------
  // Navigation
  // ---------------------------------------------------------------------------

  @override
  int parent(int handle) {
    final JSObject? el = _elements[handle];
    if (el == null) return -1;
    final JSAny? p = el.getProperty('parent'.toJS);
    if (p.isUndefinedOrNull) return -1;
    return _addElement(p! as JSObject, _ctxOf(handle));
  }

  @override
  int children(int handle) {
    final JSObject? el = _elements[handle];
    if (el == null) return -1;
    final JSFunction? $ = _$of(handle);
    if ($ == null) return -1;
    try {
      final wrapped = $.callAsFunction(null, el)! as JSObject;
      final kids = wrapped.callMethod('children'.toJS)! as JSObject;
      final arr = kids.callMethod('toArray'.toJS)! as JSArray<JSObject>;
      return _addNodeList(arr.toDart, _ctxOf(handle));
    } on Object catch (_) {
      return -1;
    }
  }

  @override
  int nextSibling(int handle) {
    final JSObject? el = _elements[handle];
    if (el == null) return -1;
    final JSFunction? $ = _$of(handle);
    if ($ == null) return -1;
    try {
      final wrapped = $.callAsFunction(null, el)! as JSObject;
      final next = wrapped.callMethod('next'.toJS)! as JSObject;
      // next() returns a Cheerio wrapper; check length.
      final JSAny? len = next.getProperty('length'.toJS);
      if (len.isUndefinedOrNull || (len! as JSNumber).toDartInt == 0) return -1;
      final node = next.callMethod('get'.toJS, 0.toJS)! as JSObject;
      return _addElement(node, _ctxOf(handle));
    } on Object catch (_) {
      return -1;
    }
  }

  @override
  int prevSibling(int handle) {
    final JSObject? el = _elements[handle];
    if (el == null) return -1;
    final JSFunction? $ = _$of(handle);
    if ($ == null) return -1;
    try {
      final wrapped = $.callAsFunction(null, el)! as JSObject;
      final prev = wrapped.callMethod('prev'.toJS)! as JSObject;
      final JSAny? len = prev.getProperty('length'.toJS);
      if (len.isUndefinedOrNull || (len! as JSNumber).toDartInt == 0) return -1;
      final node = prev.callMethod('get'.toJS, 0.toJS)! as JSObject;
      return _addElement(node, _ctxOf(handle));
    } on Object catch (_) {
      return -1;
    }
  }

  @override
  int siblings(int handle) {
    final JSObject? el = _elements[handle];
    if (el == null) return -1;
    final JSFunction? $ = _$of(handle);
    if ($ == null) return -1;
    try {
      final wrapped = $.callAsFunction(null, el)! as JSObject;
      final sibs = wrapped.callMethod('siblings'.toJS)! as JSObject;
      final arr = sibs.callMethod('toArray'.toJS)! as JSArray<JSObject>;
      return _addNodeList(arr.toDart, _ctxOf(handle));
    } on Object catch (_) {
      return -1;
    }
  }

  // ---------------------------------------------------------------------------
  // Mutation
  // ---------------------------------------------------------------------------

  @override
  void setText(int handle, String text) {
    final JSObject? el = _elements[handle];
    if (el == null) return;
    final JSFunction? $ = _$of(handle);
    if ($ == null) return;
    try {
      final wrapped = $.callAsFunction(null, el)! as JSObject;
      wrapped.callMethod('text'.toJS, text.toJS);
    } on Object catch (_) {
      // Ignore.
    }
  }

  @override
  void setHtml(int handle, String html) {
    final JSObject? el = _elements[handle];
    if (el == null) return;
    final JSFunction? $ = _$of(handle);
    if ($ == null) return;
    try {
      final wrapped = $.callAsFunction(null, el)! as JSObject;
      wrapped.callMethod('html'.toJS, html.toJS);
    } on Object catch (_) {
      // Ignore.
    }
  }

  @override
  void remove(int handle) {
    final JSObject? el = _elements[handle];
    if (el == null) return;
    final JSFunction? $ = _$of(handle);
    if ($ == null) return;
    try {
      final wrapped = $.callAsFunction(null, el)! as JSObject;
      wrapped.callMethod('remove'.toJS);
    } on Object catch (_) {
      // Ignore.
    }
  }

  @override
  void prepend(int handle, String html) {
    final JSObject? el = _elements[handle];
    if (el == null) return;
    final JSFunction? $ = _$of(handle);
    if ($ == null) return;
    try {
      final wrapped = $.callAsFunction(null, el)! as JSObject;
      wrapped.callMethod('prepend'.toJS, html.toJS);
    } on Object catch (_) {
      // Ignore.
    }
  }

  @override
  void append(int handle, String html) {
    final JSObject? el = _elements[handle];
    if (el == null) return;
    final JSFunction? $ = _$of(handle);
    if ($ == null) return;
    try {
      final wrapped = $.callAsFunction(null, el)! as JSObject;
      wrapped.callMethod('append'.toJS, html.toJS);
    } on Object catch (_) {
      // Ignore.
    }
  }

  // ---------------------------------------------------------------------------
  // Base URI
  // ---------------------------------------------------------------------------

  @override
  String? nodeBaseUri(int handle) => _baseUriOf(handle);

  @override
  String? nodeAbsUrl(int handle, String key) {
    // Get the raw attribute value.
    final String? raw = attr(handle, key);
    if (raw == null || raw.isEmpty) return '';
    final String base = _baseUriOf(handle);
    if (base.isEmpty) return raw;
    try {
      return Uri.parse(base).resolve(raw).toString();
    } on Object catch (_) {
      return raw;
    }
  }

  @override
  void setNodeBaseUri(int handle, String value) {
    final int ctxId = _ctxOf(handle);
    if (ctxId > 0) _baseUris[ctxId] = value;
  }

  // ---------------------------------------------------------------------------
  // Create
  // ---------------------------------------------------------------------------

  @override
  int createElement(String tag) {
    try {
      // Use cheerio.load to create a temporary element.
      final $ = _cheerio.callMethod('load'.toJS, '<$tag></$tag>'.toJS)! as JSFunction;
      final int ctxId = _nextCtxId++;
      _contexts[ctxId] = $;
      _baseUris[ctxId] = '';
      final wrapped = $.callAsFunction(null, tag.toJS)! as JSObject;
      final node = wrapped.callMethod('get'.toJS, 0.toJS)! as JSObject;
      return _addElement(node, ctxId);
    } on Object catch (_) {
      return -1;
    }
  }

  @override
  int createTextNode(String text) {
    try {
      // Create a plain JS object matching domhandler TextNode shape.
      final node = JSObject();
      node.setProperty('type'.toJS, 'text'.toJS);
      node.setProperty('data'.toJS, text.toJS);
      // Context 0 has no $ function. This is safe because all TextNode
      // methods (textNodeText, setTextNodeText, textNodeWholeText,
      // textNodeIsBlank) read/write the JS `data` property directly without
      // needing a Cheerio $ context.
      return _addTextNode(node, 0);
    } on Object catch (_) {
      return -1;
    }
  }

  @override
  int createElements(List<int> elementHandles) {
    final nodes = <JSObject>[];
    for (final h in elementHandles) {
      final JSObject? el = _elements[h];
      if (el != null) nodes.add(el);
    }
    // Use the context of the first element, or 0 if empty.
    final int ctxId = elementHandles.isEmpty ? 0 : _ctxOf(elementHandles.first);
    return _addNodeList(nodes, ctxId);
  }

  // ---------------------------------------------------------------------------
  // Node-level methods
  // ---------------------------------------------------------------------------

  @override
  String? nodeName(int handle) {
    // Elements: use domhandler .name property.
    final JSObject? el = _elements[handle];
    if (el != null) {
      final JSAny? name = el.getProperty('name'.toJS);
      if (name.isUndefinedOrNull) return null;
      return (name! as JSString).toDart;
    }
    // Text nodes always have nodeName '#text'.
    if (_textNodes.containsKey(handle)) return '#text';
    return null;
  }

  @override
  int childNodeSize(int handle) {
    final JSObject? el = _elements[handle];
    if (el == null) return 0;
    // domhandler: el.children is the child node array (elements + text).
    final JSAny? children = el.getProperty('children'.toJS);
    if (children.isUndefinedOrNull) return 0;
    final JSAny? len = (children! as JSObject).getProperty('length'.toJS);
    if (len.isUndefinedOrNull) return 0;
    return (len! as JSNumber).toDartInt;
  }

  @override
  int childNode(int handle, int index) {
    final JSObject? el = _elements[handle];
    if (el == null) return -1;
    final JSAny? children = el.getProperty('children'.toJS);
    if (children.isUndefinedOrNull) return -1;
    final JSAny? child = (children! as JSObject).getProperty(index.toJS);
    if (child.isUndefinedOrNull) return -1;
    return _addNode(child! as JSObject, _ctxOf(handle));
  }

  @override
  List<int> childNodeHandles(int handle) {
    final JSObject? el = _elements[handle];
    if (el == null) return const <int>[];
    final JSAny? children = el.getProperty('children'.toJS);
    if (children.isUndefinedOrNull) return const <int>[];
    final arr = children! as JSArray<JSObject>;
    final int ctxId = _ctxOf(handle);
    final handles = <int>[];
    for (final JSObject child in arr.toDart) {
      handles.add(_addNode(child, ctxId));
    }
    return handles;
  }

  @override
  bool isTextNode(int handle) => _textNodes.containsKey(handle);

  @override
  int parentNode(int handle) {
    // Try elements first, then text nodes.
    final JSObject? node = _elements[handle] ?? _textNodes[handle];
    if (node == null) return -1;
    final JSAny? p = node.getProperty('parent'.toJS);
    if (p.isUndefinedOrNull) return -1;
    return _addNode(p! as JSObject, _ctxOf(handle));
  }

  @override
  String? nodeOuterHtml(int handle) {
    // For elements, use outerHtml.
    final JSObject? el = _elements[handle];
    if (el != null) return outerHtml(handle);
    // For text nodes, return the raw text data.
    final JSObject? tn = _textNodes[handle];
    if (tn == null) return null;
    final JSAny? data = tn.getProperty('data'.toJS);
    return data.isUndefinedOrNull ? '' : (data! as JSString).toDart;
  }

  @override
  void removeNode(int handle) {
    // Elements: use Cheerio's remove.
    if (_elements.containsKey(handle)) {
      remove(handle);
      return;
    }
    // Text nodes: remove from parent's children array.
    final JSObject? tn = _textNodes[handle];
    if (tn == null) return;
    final JSAny? parentVal = tn.getProperty('parent'.toJS);
    if (parentVal.isUndefinedOrNull) return;
    final parentObj = parentVal! as JSObject;
    final JSAny? childrenVal = parentObj.getProperty('children'.toJS);
    if (childrenVal.isUndefinedOrNull) return;
    // Filter out the text node from parent's children.
    final arr = childrenVal! as JSArray<JSObject>;
    final List<JSObject> filtered = arr.toDart.where((JSObject n) => n != tn).toList();
    parentObj.setProperty(
      'children'.toJS,
      filtered.toJS,
    );
  }

  // ---------------------------------------------------------------------------
  // Element-level: textNodes
  // ---------------------------------------------------------------------------

  @override
  List<int> textNodeHandles(int handle) {
    final JSObject? el = _elements[handle];
    if (el == null) return const <int>[];
    final JSAny? children = el.getProperty('children'.toJS);
    if (children.isUndefinedOrNull) return const <int>[];
    final arr = children! as JSArray<JSObject>;
    final int ctxId = _ctxOf(handle);
    final handles = <int>[];
    for (final JSObject child in arr.toDart) {
      final JSAny? type = child.getProperty('type'.toJS);
      final String typeStr = type.isUndefinedOrNull ? '' : (type! as JSString).toDart;
      if (typeStr == 'text') {
        handles.add(_addTextNode(child, ctxId));
      }
    }
    return handles;
  }

  // ---------------------------------------------------------------------------
  // TextNode-level methods
  // ---------------------------------------------------------------------------

  @override
  String? textNodeText(int handle) {
    final JSObject? tn = _textNodes[handle];
    if (tn == null) return null;
    final JSAny? data = tn.getProperty('data'.toJS);
    if (data.isUndefinedOrNull) return '';
    // Normalize whitespace (matching Jsoup's TextNode.text()).
    return (data! as JSString).toDart.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  @override
  void setTextNodeText(int handle, String text) {
    final JSObject? tn = _textNodes[handle];
    if (tn == null) return;
    tn.setProperty('data'.toJS, text.toJS);
  }

  @override
  String? textNodeWholeText(int handle) {
    final JSObject? tn = _textNodes[handle];
    if (tn == null) return null;
    final JSAny? data = tn.getProperty('data'.toJS);
    return data.isUndefinedOrNull ? '' : (data! as JSString).toDart;
  }

  @override
  bool textNodeIsBlank(int handle) {
    final JSObject? tn = _textNodes[handle];
    if (tn == null) return true;
    final JSAny? data = tn.getProperty('data'.toJS);
    if (data.isUndefinedOrNull) return true;
    return (data! as JSString).toDart.trim().isEmpty;
  }

  // ---------------------------------------------------------------------------
  // Cleanup
  // ---------------------------------------------------------------------------

  @override
  void free(int handle) {
    _elements.remove(handle);
    _textNodes.remove(handle);
    _nodeLists.remove(handle);
    final int? ctxId = _ctxForHandle.remove(handle);
    // Clean up context if no other handles reference it.
    if (ctxId != null && ctxId > 0) {
      final bool inUse = _ctxForHandle.values.any((int id) => id == ctxId);
      if (!inUse) {
        _contexts.remove(ctxId);
        _baseUris.remove(ctxId);
      }
    }
  }

  @override
  void dispose() {
    _elements.clear();
    _textNodes.clear();
    _nodeLists.clear();
    _contexts.clear();
    _ctxForHandle.clear();
    _baseUris.clear();
  }
}
