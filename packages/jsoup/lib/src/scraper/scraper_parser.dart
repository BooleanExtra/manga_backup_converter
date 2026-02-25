import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:jsoup/src/html_parser.dart';
import 'package:scraper/scraper.dart';

/// Rust scraper-backed [NativeHtmlParser].
///
/// Uses html5ever (Servo) for parsing and CSS selector evaluation via a
/// compiled Rust `scraper_bridge` dynamic library loaded as a CodeAsset.
class ScraperParser implements NativeHtmlParser {
  // -- String helpers --

  static Pointer<Char> _toNative(String s) => s.toNativeUtf8(allocator: calloc).cast<Char>();

  static String? _readAndFree(Pointer<Char> ptr) {
    if (ptr == nullptr) return null;
    final String s = ptr.cast<Utf8>().toDartString();
    scraper_free_string(ptr);
    return s;
  }

  static List<int> _readHandleArray(
    Pointer<Pointer<Int64>> outHandles,
    Pointer<Int> outLen,
  ) {
    final int len = outLen.value;
    final Pointer<Int64> arr = outHandles.value;
    if (arr == nullptr || len <= 0) {
      calloc.free(outHandles);
      calloc.free(outLen);
      return const <int>[];
    }
    final result = <int>[for (var i = 0; i < len; i++) arr[i]];
    scraper_free_handle_array(arr, len);
    calloc.free(outHandles);
    calloc.free(outLen);
    return result;
  }

  // -- Parsing --

  @override
  int parse(String html, {String baseUri = ''}) {
    final Pointer<Char> nHtml = _toNative(html);
    final Pointer<Char> nBase = _toNative(baseUri);
    final int handle = scraper_parse(nHtml, nBase);
    calloc.free(nHtml);
    calloc.free(nBase);
    return handle;
  }

  @override
  int parseFragment(String html, {String baseUri = ''}) {
    final Pointer<Char> nHtml = _toNative(html);
    final Pointer<Char> nBase = _toNative(baseUri);
    final int handle = scraper_parse_fragment(nHtml, nBase);
    calloc.free(nHtml);
    calloc.free(nBase);
    return handle;
  }

  // -- CSS Selectors --

  @override
  int select(int handle, String selector) {
    final Pointer<Char> nSel = _toNative(selector);
    final int result = scraper_select(handle, nSel);
    calloc.free(nSel);
    return result;
  }

  @override
  int selectFirst(int handle, String selector) {
    final Pointer<Char> nSel = _toNative(selector);
    final int result = scraper_select_first(handle, nSel);
    calloc.free(nSel);
    return result;
  }

  // -- Attributes --

  @override
  String? attr(int handle, String key) {
    final Pointer<Char> nKey = _toNative(key);
    final Pointer<Char> result = scraper_attr(handle, nKey);
    calloc.free(nKey);
    return _readAndFree(result);
  }

  @override
  bool hasAttr(int handle, String key) {
    final Pointer<Char> nKey = _toNative(key);
    final int result = scraper_has_attr(handle, nKey);
    calloc.free(nKey);
    return result != 0;
  }

  // -- Text & HTML --

  @override
  String? text(int handle) => _readAndFree(scraper_text(handle));

  @override
  String? ownText(int handle) => _readAndFree(scraper_own_text(handle));

  @override
  String? innerHtml(int handle) => _readAndFree(scraper_inner_html(handle));

  @override
  String? outerHtml(int handle) => _readAndFree(scraper_outer_html(handle));

  @override
  String? tagName(int handle) => _readAndFree(scraper_tag_name(handle));

  @override
  String? id(int handle) => _readAndFree(scraper_id(handle));

  @override
  String? className(int handle) => _readAndFree(scraper_class_name(handle));

  @override
  bool hasClass(int handle, String name) {
    final Pointer<Char> nName = _toNative(name);
    final int result = scraper_has_class(handle, nName);
    calloc.free(nName);
    return result != 0;
  }

  @override
  String? data(int handle) => _readAndFree(scraper_data(handle));

  // -- Node list operations --

  @override
  int size(int handle) => scraper_list_size(handle);

  @override
  int get(int handle, int index) => scraper_list_get(handle, index);

  @override
  int first(int handle) => scraper_list_first(handle);

  @override
  int last(int handle) => scraper_list_last(handle);

  // -- Navigation --

  @override
  int parent(int handle) => scraper_parent(handle);

  @override
  int children(int handle) => scraper_children(handle);

  @override
  int nextSibling(int handle) => scraper_next_sibling(handle);

  @override
  int prevSibling(int handle) => scraper_prev_sibling(handle);

  @override
  int siblings(int handle) => scraper_siblings(handle);

  // -- Mutation --

  @override
  void setText(int handle, String text) {
    final Pointer<Char> nText = _toNative(text);
    scraper_set_text(handle, nText);
    calloc.free(nText);
  }

  @override
  void setHtml(int handle, String html) {
    final Pointer<Char> nHtml = _toNative(html);
    scraper_set_html(handle, nHtml);
    calloc.free(nHtml);
  }

  @override
  void remove(int handle) => scraper_remove_element(handle);

  @override
  void prepend(int handle, String html) {
    final Pointer<Char> nHtml = _toNative(html);
    scraper_prepend(handle, nHtml);
    calloc.free(nHtml);
  }

  @override
  void append(int handle, String html) {
    final Pointer<Char> nHtml = _toNative(html);
    scraper_append(handle, nHtml);
    calloc.free(nHtml);
  }

  @override
  void setAttr(int handle, String key, String value) {
    final Pointer<Char> nKey = _toNative(key);
    final Pointer<Char> nVal = _toNative(value);
    scraper_set_attr(handle, nKey, nVal);
    calloc.free(nKey);
    calloc.free(nVal);
  }

  @override
  void removeAttr(int handle, String key) {
    final Pointer<Char> nKey = _toNative(key);
    scraper_remove_attr(handle, nKey);
    calloc.free(nKey);
  }

  @override
  void addClass(int handle, String name) {
    final Pointer<Char> nName = _toNative(name);
    scraper_add_class(handle, nName);
    calloc.free(nName);
  }

  @override
  void removeClass(int handle, String name) {
    final Pointer<Char> nName = _toNative(name);
    scraper_remove_class(handle, nName);
    calloc.free(nName);
  }

  // -- Base URI --

  @override
  String? nodeBaseUri(int handle) => _readAndFree(scraper_node_base_uri(handle));

  @override
  String? nodeAbsUrl(int handle, String key) {
    final Pointer<Char> nKey = _toNative(key);
    final Pointer<Char> result = scraper_node_abs_url(handle, nKey);
    calloc.free(nKey);
    return _readAndFree(result);
  }

  @override
  void setNodeBaseUri(int handle, String value) {
    final Pointer<Char> nVal = _toNative(value);
    scraper_set_node_base_uri(handle, nVal);
    calloc.free(nVal);
  }

  // -- Element/TextNode creation --

  @override
  int createElement(String tag) {
    final Pointer<Char> nTag = _toNative(tag);
    final int handle = scraper_create_element(nTag);
    calloc.free(nTag);
    return handle;
  }

  @override
  int createTextNode(String text) {
    final Pointer<Char> nText = _toNative(text);
    final int handle = scraper_create_text_node(nText);
    calloc.free(nText);
    return handle;
  }

  @override
  int createElements(List<int> elementHandles) {
    if (elementHandles.isEmpty) {
      return scraper_create_elements(nullptr, 0);
    }
    final Pointer<Int64> arr = calloc<Int64>(elementHandles.length);
    for (var i = 0; i < elementHandles.length; i++) {
      arr[i] = elementHandles[i];
    }
    final int handle = scraper_create_elements(arr, elementHandles.length);
    calloc.free(arr);
    return handle;
  }

  // -- Node-level methods --

  @override
  String? nodeName(int handle) => _readAndFree(scraper_node_name(handle));

  @override
  int childNodeSize(int handle) => scraper_child_node_size(handle);

  @override
  int childNode(int handle, int index) => scraper_child_node(handle, index);

  @override
  List<int> childNodeHandles(int handle) {
    final Pointer<Pointer<Int64>> outHandles = calloc<Pointer<Int64>>();
    final Pointer<Int> outLen = calloc<Int>();
    scraper_child_node_handles(handle, outHandles, outLen);
    return _readHandleArray(outHandles, outLen);
  }

  @override
  bool isTextNode(int handle) => scraper_is_text_node(handle) != 0;

  @override
  int parentNode(int handle) => scraper_parent_node(handle);

  @override
  String? nodeOuterHtml(int handle) => _readAndFree(scraper_node_outer_html(handle));

  @override
  void removeNode(int handle) => scraper_remove_node(handle);

  // -- Element-level --

  @override
  List<int> textNodeHandles(int handle) {
    final Pointer<Pointer<Int64>> outHandles = calloc<Pointer<Int64>>();
    final Pointer<Int> outLen = calloc<Int>();
    scraper_text_node_handles(handle, outHandles, outLen);
    return _readHandleArray(outHandles, outLen);
  }

  // -- TextNode-level --

  @override
  String? textNodeText(int handle) => _readAndFree(scraper_text_node_text(handle));

  @override
  void setTextNodeText(int handle, String text) {
    final Pointer<Char> nText = _toNative(text);
    scraper_set_text_node_text(handle, nText);
    calloc.free(nText);
  }

  @override
  String? textNodeWholeText(int handle) => _readAndFree(scraper_text_node_whole_text(handle));

  @override
  bool textNodeIsBlank(int handle) => scraper_text_node_is_blank(handle) != 0;

  // -- Lifecycle --

  @override
  void free(int handle) => scraper_free(handle);

  @override
  void releaseAll() => scraper_release_all();

  @override
  void dispose() => scraper_dispose();
}
