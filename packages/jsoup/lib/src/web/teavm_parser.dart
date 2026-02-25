// ignore_for_file: lines_longer_than_80_chars

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:jsoup/src/html_parser.dart';
import 'package:jsoup/teavm.dart';

/// Whether the TeaVM Jsoup bridge has been loaded into `globalThis`.
bool _teavmLoaded = false;

/// Load the TeaVM Jsoup bridge into the global scope if not already present.
///
/// The bridge source is a trusted, pre-compiled const string shipped with the
/// package (`teavmJsoupJs` from `package:jsoup/teavm.dart`). We use
/// `importScripts` to execute it, which sets `self.parse`, `self.select`, etc.
///
/// **Note**: `importScripts` is only available in Web Worker contexts. If
/// `TeaVMParser` is used on the main browser thread, the caller must load
/// the bridge into `globalThis` before instantiation.
void _ensureTeaVMLoaded() {
  if (_teavmLoaded) return;

  // Check if already available (e.g. loaded by the WASM worker host).
  final JSAny? existing = globalContext.getProperty('parse'.toJS);
  if (existing != null && !existing.isUndefinedOrNull) {
    _teavmLoaded = true;
    return;
  }

  // Create a Blob URL from the trusted TeaVM const string and use
  // importScripts to load it synchronously (works in Worker contexts).
  // The UMD module registers exports on `self` when `typeof self !== 'undefined'`.
  final JSArray<JSAny> parts = <JSAny>[teavmJsoupJs.toJS].toJS;
  final blobOptions = JSObject();
  blobOptions.setProperty('type'.toJS, 'application/javascript'.toJS);
  final JSObject blob = _jsBlobConstructor(parts, blobOptions);
  final String blobUrl = _jsCreateObjectURL(blob);
  try {
    _jsImportScripts(blobUrl.toJS);
  } finally {
    _jsRevokeObjectURL(blobUrl);
  }

  _teavmLoaded = true;
}

// JS interop helpers for Blob URL + importScripts.

@JS('Blob')
external JSObject _jsBlobConstructor(JSArray<JSAny> parts, JSObject options);

@JS('URL.createObjectURL')
external String _jsCreateObjectURL(JSObject blob);

@JS('URL.revokeObjectURL')
external void _jsRevokeObjectURL(String url);

@JS('importScripts')
external void _jsImportScripts(JSString url);

// -- Bridge function accessors --
// TeaVM UMD module sets exports on `self` (the Worker global scope).

int _callInt(String name, [List<JSAny?> args = const <JSAny?>[]]) {
  final fn = globalContext.getProperty(name.toJS)! as JSFunction;
  final JSAny? result = switch (args.length) {
    0 => fn.callAsFunction(),
    1 => fn.callAsFunction(null, args[0]),
    2 => fn.callAsFunction(null, args[0], args[1]),
    3 => fn.callAsFunction(null, args[0], args[1], args[2]),
    _ => throw ArgumentError('Too many arguments: ${args.length}'),
  };
  if (result.isUndefinedOrNull) return -1;
  return (result! as JSNumber).toDartInt;
}

String? _callString(String name, [List<JSAny?> args = const <JSAny?>[]]) {
  final fn = globalContext.getProperty(name.toJS)! as JSFunction;
  final JSAny? result = switch (args.length) {
    0 => fn.callAsFunction(),
    1 => fn.callAsFunction(null, args[0]),
    2 => fn.callAsFunction(null, args[0], args[1]),
    3 => fn.callAsFunction(null, args[0], args[1], args[2]),
    _ => throw ArgumentError('Too many arguments: ${args.length}'),
  };
  if (result.isUndefinedOrNull) return null;
  return (result! as JSString).toDart;
}

bool _callBool(String name, [List<JSAny?> args = const <JSAny?>[]]) {
  final fn = globalContext.getProperty(name.toJS)! as JSFunction;
  final JSAny? result = switch (args.length) {
    0 => fn.callAsFunction(),
    1 => fn.callAsFunction(null, args[0]),
    2 => fn.callAsFunction(null, args[0], args[1]),
    _ => throw ArgumentError('Too many arguments: ${args.length}'),
  };
  if (result.isUndefinedOrNull) return false;
  return (result! as JSBoolean).toDart;
}

void _callVoid(String name, [List<JSAny?> args = const <JSAny?>[]]) {
  final fn = globalContext.getProperty(name.toJS)! as JSFunction;
  switch (args.length) {
    case 0:
      fn.callAsFunction();
    case 1:
      fn.callAsFunction(null, args[0]);
    case 2:
      fn.callAsFunction(null, args[0], args[1]);
    case 3:
      fn.callAsFunction(null, args[0], args[1], args[2]);
    default:
      throw ArgumentError('Too many arguments: ${args.length}');
  }
}

List<int> _callIntArray(String name, List<JSAny?> args) {
  final fn = globalContext.getProperty(name.toJS)! as JSFunction;
  final JSAny? result = switch (args.length) {
    1 => fn.callAsFunction(null, args[0]),
    _ => throw ArgumentError('Expected 1 argument, got ${args.length}'),
  };
  if (result.isUndefinedOrNull) return const <int>[];
  final arr = result! as JSArray<JSNumber>;
  return <int>[for (final JSNumber n in arr.toDart) n.toDartInt];
}

/// TeaVM-backed [NativeHtmlParser] for web.
///
/// Uses the real Java Jsoup library compiled to JavaScript by TeaVM. All
/// Jsoup pseudo-selectors (`:contains`, `:containsOwn`, `:matches`, etc.)
/// work natively — no custom selector engine needed.
///
/// **Worker-only**: Loading uses `importScripts`, which is only available in
/// Web Worker contexts.
class TeaVMParser implements NativeHtmlParser {
  TeaVMParser() {
    _ensureTeaVMLoaded();
  }

  // =========================================================================
  // Parse
  // =========================================================================

  @override
  int parse(String html, {String baseUri = ''}) => _callInt('parse', <JSAny?>[html.toJS, baseUri.toJS]);

  @override
  int parseFragment(String html, {String baseUri = ''}) => _callInt('parseFragment', <JSAny?>[html.toJS, baseUri.toJS]);

  // =========================================================================
  // Select
  // =========================================================================

  @override
  int select(int handle, String selector) => _callInt('select', <JSAny?>[handle.toJS, selector.toJS]);

  @override
  int selectFirst(int handle, String selector) => _callInt('selectFirst', <JSAny?>[handle.toJS, selector.toJS]);

  // =========================================================================
  // Attributes
  // =========================================================================

  @override
  String? attr(int handle, String key) => _callString('attr', <JSAny?>[handle.toJS, key.toJS]);

  @override
  bool hasAttr(int handle, String key) => _callBool('hasAttr', <JSAny?>[handle.toJS, key.toJS]);

  @override
  void setAttr(int handle, String key, String value) =>
      _callVoid('setAttr', <JSAny?>[handle.toJS, key.toJS, value.toJS]);

  @override
  void removeAttr(int handle, String key) => _callVoid('removeAttr', <JSAny?>[handle.toJS, key.toJS]);

  // =========================================================================
  // Text & HTML
  // =========================================================================

  @override
  String? text(int handle) => _callString('text', <JSAny?>[handle.toJS]);

  @override
  String? ownText(int handle) => _callString('ownText', <JSAny?>[handle.toJS]);

  @override
  String? innerHtml(int handle) => _callString('innerHtml', <JSAny?>[handle.toJS]);

  @override
  String? outerHtml(int handle) => _callString('outerHtml', <JSAny?>[handle.toJS]);

  @override
  String? data(int handle) => _callString('data', <JSAny?>[handle.toJS]);

  // =========================================================================
  // Identity
  // =========================================================================

  @override
  String? tagName(int handle) => _callString('tagName', <JSAny?>[handle.toJS]);

  @override
  String? id(int handle) => _callString('elementId', <JSAny?>[handle.toJS]);

  @override
  String? className(int handle) => _callString('className', <JSAny?>[handle.toJS]);

  @override
  bool hasClass(int handle, String name) => _callBool('hasClass', <JSAny?>[handle.toJS, name.toJS]);

  @override
  void addClass(int handle, String name) => _callVoid('addClass', <JSAny?>[handle.toJS, name.toJS]);

  @override
  void removeClass(int handle, String name) => _callVoid('removeClass', <JSAny?>[handle.toJS, name.toJS]);

  // =========================================================================
  // Node list operations
  // =========================================================================

  @override
  int size(int handle) => _callInt('size', <JSAny?>[handle.toJS]);

  @override
  int get(int handle, int index) => _callInt('getAt', <JSAny?>[handle.toJS, index.toJS]);

  @override
  int first(int handle) => _callInt('first', <JSAny?>[handle.toJS]);

  @override
  int last(int handle) => _callInt('last', <JSAny?>[handle.toJS]);

  // =========================================================================
  // Navigation
  // =========================================================================

  @override
  int parent(int handle) => _callInt('parent', <JSAny?>[handle.toJS]);

  @override
  int children(int handle) => _callInt('children', <JSAny?>[handle.toJS]);

  @override
  int nextSibling(int handle) => _callInt('nextSibling', <JSAny?>[handle.toJS]);

  @override
  int prevSibling(int handle) => _callInt('prevSibling', <JSAny?>[handle.toJS]);

  @override
  int siblings(int handle) => _callInt('siblings', <JSAny?>[handle.toJS]);

  // =========================================================================
  // Mutation
  // =========================================================================

  @override
  void setText(int handle, String text) => _callVoid('setText', <JSAny?>[handle.toJS, text.toJS]);

  @override
  void setHtml(int handle, String html) => _callVoid('setHtml', <JSAny?>[handle.toJS, html.toJS]);

  @override
  void remove(int handle) => _callVoid('removeElement', <JSAny?>[handle.toJS]);

  @override
  void prepend(int handle, String html) => _callVoid('prepend', <JSAny?>[handle.toJS, html.toJS]);

  @override
  void append(int handle, String html) => _callVoid('append', <JSAny?>[handle.toJS, html.toJS]);

  // =========================================================================
  // Base URI
  // =========================================================================

  @override
  String? nodeBaseUri(int handle) => _callString('nodeBaseUri', <JSAny?>[handle.toJS]);

  @override
  String? nodeAbsUrl(int handle, String key) => _callString('nodeAbsUrl', <JSAny?>[handle.toJS, key.toJS]);

  @override
  void setNodeBaseUri(int handle, String value) => _callVoid('setNodeBaseUri', <JSAny?>[handle.toJS, value.toJS]);

  // =========================================================================
  // Create
  // =========================================================================

  @override
  int createElement(String tag) => _callInt('createElement', <JSAny?>[tag.toJS]);

  @override
  int createTextNode(String text) => _callInt('createTextNode', <JSAny?>[text.toJS]);

  @override
  int createElements(List<int> elementHandles) {
    final JSArray<JSNumber> jsHandles = <JSNumber>[for (final int h in elementHandles) h.toJS].toJS;
    return _callInt('createElements', <JSAny?>[jsHandles]);
  }

  // =========================================================================
  // Node-level methods
  // =========================================================================

  @override
  String? nodeName(int handle) => _callString('nodeName', <JSAny?>[handle.toJS]);

  @override
  int childNodeSize(int handle) => _callInt('childNodeSize', <JSAny?>[handle.toJS]);

  @override
  int childNode(int handle, int index) => _callInt('childNode', <JSAny?>[handle.toJS, index.toJS]);

  @override
  List<int> childNodeHandles(int handle) => _callIntArray('childNodeHandles', <JSAny?>[handle.toJS]);

  @override
  bool isTextNode(int handle) => _callBool('isTextNode', <JSAny?>[handle.toJS]);

  @override
  int parentNode(int handle) => _callInt('parentNode', <JSAny?>[handle.toJS]);

  @override
  String? nodeOuterHtml(int handle) => _callString('nodeOuterHtml', <JSAny?>[handle.toJS]);

  @override
  void removeNode(int handle) => _callVoid('removeNode', <JSAny?>[handle.toJS]);

  // =========================================================================
  // Element-level: textNodes
  // =========================================================================

  @override
  List<int> textNodeHandles(int handle) => _callIntArray('textNodeHandles', <JSAny?>[handle.toJS]);

  // =========================================================================
  // TextNode-level methods
  // =========================================================================

  @override
  String? textNodeText(int handle) => _callString('textNodeText', <JSAny?>[handle.toJS]);

  @override
  void setTextNodeText(int handle, String text) => _callVoid('setTextNodeText', <JSAny?>[handle.toJS, text.toJS]);

  @override
  String? textNodeWholeText(int handle) => _callString('textNodeWholeText', <JSAny?>[handle.toJS]);

  @override
  bool textNodeIsBlank(int handle) => _callBool('textNodeIsBlank', <JSAny?>[handle.toJS]);

  // =========================================================================
  // Cleanup
  // =========================================================================

  @override
  void free(int handle) => _callVoid('free', <JSAny?>[handle.toJS]);

  @override
  void releaseAll() => _callVoid('disposeAll');

  @override
  void dispose() => _callVoid('disposeAll');
}
