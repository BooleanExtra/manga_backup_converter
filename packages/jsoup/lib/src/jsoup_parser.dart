// ignore_for_file: invalid_use_of_internal_member, library_prefixes

import 'dart:io';

import 'package:jni/_internal.dart' as jni$_;
import 'package:jni/jni.dart';
import 'package:jsoup/src/bindings/org/jsoup/Jsoup.dart' as jsoup_lib;
import 'package:jsoup/src/bindings/org/jsoup/nodes/Document.dart';
import 'package:jsoup/src/bindings/org/jsoup/nodes/Element.dart' as jsoup_el;
import 'package:jsoup/src/bindings/org/jsoup/nodes/Node.dart' as jsoup_node;
import 'package:jsoup/src/bindings/org/jsoup/nodes/TextNode.dart' as jsoup_tn;
import 'package:jsoup/src/bindings/org/jsoup/select/Elements.dart' as jsoup_els;
import 'package:jsoup/src/jre/jre_manager.dart';
import 'package:jsoup/src/jsoup_api.dart';

/// Jsoup-backed [NativeHtmlParser] using JNI.
///
/// Works on Android (JVM already available), Windows, and Linux (requires
/// bundled JRE + Jsoup JAR from the build hook).
class JsoupParser implements NativeHtmlParser {
  /// Creates a Jsoup parser, initializing the JVM if needed.
  ///
  /// On Android the JVM is already running. On desktop platforms this spawns
  /// a JVM with the bundled JRE and Jsoup JAR on the classpath.
  JsoupParser() {
    if (!Platform.isAndroid) {
      JreManager.ensureInitialized();
    }
  }

  // java.util.List method IDs for Elements (extends ArrayList<Element>).
  // Elements doesn't expose size()/get() in jnigen bindings, so we call
  // java.util.List methods directly via the same FFI pattern jnigen uses.
  static final JClass _listClass = JClass.forName('java/util/List');
  static final JInstanceMethodId _sizeId = _listClass.instanceMethodId('size', '()I');
  static final JInstanceMethodId _getId = _listClass.instanceMethodId('get', '(I)Ljava/lang/Object;');
  static final JInstanceMethodId _addId = _listClass.instanceMethodId('add', '(Ljava/lang/Object;)Z');

  static final jni$_.JniResult Function(jni$_.Pointer<jni$_.Void>, jni$_.JMethodIDPtr) _callIntMethod =
      jni$_.ProtectedJniExtensions.lookup<
            jni$_.NativeFunction<
              jni$_.JniResult Function(
                jni$_.Pointer<jni$_.Void>,
                jni$_.JMethodIDPtr,
              )
            >
          >('globalEnv_CallIntMethod')
          .asFunction<
            jni$_.JniResult Function(
              jni$_.Pointer<jni$_.Void>,
              jni$_.JMethodIDPtr,
            )
          >();

  static final jni$_.JniResult Function(jni$_.Pointer<jni$_.Void>, jni$_.JMethodIDPtr, int) _callObjectMethodWithInt =
      jni$_.ProtectedJniExtensions.lookup<
            jni$_.NativeFunction<
              jni$_.JniResult Function(
                jni$_.Pointer<jni$_.Void>,
                jni$_.JMethodIDPtr,
                jni$_.VarArgs<(jni$_.Int32,)>,
              )
            >
          >('globalEnv_CallObjectMethod')
          .asFunction<
            jni$_.JniResult Function(
              jni$_.Pointer<jni$_.Void>,
              jni$_.JMethodIDPtr,
              int,
            )
          >();

  static final jni$_.JniResult Function(jni$_.Pointer<jni$_.Void>, jni$_.JMethodIDPtr, jni$_.Pointer<jni$_.Void>)
  _callBooleanMethodWithObject =
      jni$_.ProtectedJniExtensions.lookup<
            jni$_.NativeFunction<
              jni$_.JniResult Function(
                jni$_.Pointer<jni$_.Void>,
                jni$_.JMethodIDPtr,
                jni$_.VarArgs<(jni$_.Pointer<jni$_.Void>,)>,
              )
            >
          >('globalEnv_CallBooleanMethod')
          .asFunction<
            jni$_.JniResult Function(
              jni$_.Pointer<jni$_.Void>,
              jni$_.JMethodIDPtr,
              jni$_.Pointer<jni$_.Void>,
            )
          >();

  // Handle store: maps opaque int handles to JNI object references.
  // Elements (including Documents) go in _elements; TextNodes in _textNodes;
  // Elements (node lists) in _nodeLists.
  final Map<int, jsoup_el.Element> _elements = <int, jsoup_el.Element>{};
  final Map<int, jsoup_tn.TextNode> _textNodes = <int, jsoup_tn.TextNode>{};
  final Map<int, jsoup_els.Elements> _nodeLists = <int, jsoup_els.Elements>{};
  int _nextHandle = 1;

  int _addElement(jsoup_el.Element obj) {
    final int handle = _nextHandle++;
    _elements[handle] = obj;
    return handle;
  }

  int _addTextNode(jsoup_tn.TextNode obj) {
    final int handle = _nextHandle++;
    _textNodes[handle] = obj;
    return handle;
  }

  int _addNodeList(jsoup_els.Elements obj) {
    final int handle = _nextHandle++;
    _nodeLists[handle] = obj;
    return handle;
  }

  /// Classify a JNI Node and add it to the appropriate handle map.
  /// Returns the handle and whether it's a text node.
  int _addNode(jsoup_node.Node node) {
    // Try casting to TextNode first (cheaper check via nodeName).
    final String? name = node.nodeName()?.toDartString();
    if (name == '#text') {
      return _addTextNode(node.as(jsoup_tn.TextNode.type));
    }
    // Default: treat as Element.
    return _addElement(node.as(jsoup_el.Element.type));
  }

  @override
  String? nodeBaseUri(int handle) {
    final jsoup_node.Node? node = _resolveNode(handle);
    if (node == null) return null;
    try {
      return _readAndRelease(node.baseUri());
    } on JniException catch (_) {
      return null;
    }
  }

  @override
  String? nodeAbsUrl(int handle, String key) {
    final jsoup_node.Node? node = _resolveNode(handle);
    if (node == null) return null;
    try {
      final JString jKey = _jstr(key);
      final String? result = _readAndRelease(node.absUrl(jKey));
      jKey.release();
      return result;
    } on JniException catch (_) {
      return null;
    }
  }

  @override
  void setNodeBaseUri(int handle, String value) {
    final jsoup_node.Node? node = _resolveNode(handle);
    if (node == null) return;
    try {
      final JString jValue = _jstr(value);
      node.setBaseUri(jValue);
      jValue.release();
    } on JniException catch (_) {
      // Ignore.
    }
  }

  @override
  int createElement(String tag) {
    try {
      final JString jTag = _jstr(tag);
      final el = jsoup_el.Element.new$1(jTag);
      jTag.release();
      return _addElement(el);
    } on JniException catch (_) {
      return -1;
    }
  }

  /// Convert a Dart string to JString, use it, then release.
  /// Avoids JGlobalReference leaks from [toJString()].
  static JString _jstr(String s) => s.toJString();

  /// Read a JString as Dart string and immediately release the JNI reference.
  static String? _readAndRelease(JString? js) {
    if (js == null) return null;
    final String s = js.toDartString();
    js.release();
    return s;
  }

  @override
  int parse(String html, {String baseUri = ''}) {
    try {
      final JString jHtml = _jstr(html);
      final JString jBaseUri = _jstr(baseUri);
      final Document? doc = jsoup_lib.Jsoup.parse(jHtml, jBaseUri);
      jHtml.release();
      jBaseUri.release();
      if (doc == null) return -1;
      return _addElement(doc);
    } on JniException catch (_) {
      return -1;
    }
  }

  @override
  int parseFragment(String html, {String baseUri = ''}) {
    // Jsoup.parse() handles fragments well — returns a full Document.
    return parse(html, baseUri: baseUri);
  }

  @override
  int select(int handle, String selector) {
    final jsoup_el.Element? el = _elements[handle];
    if (el == null) return -1;
    try {
      final JString jSel = _jstr(selector);
      final jsoup_els.Elements? elements = el.select(jSel);
      jSel.release();
      if (elements == null) return -1;
      return _addNodeList(elements);
    } on JniException catch (_) {
      return -1;
    }
  }

  @override
  int selectFirst(int handle, String selector) {
    final jsoup_el.Element? el = _elements[handle];
    if (el == null) return -1;
    try {
      final JString jSel = _jstr(selector);
      final jsoup_el.Element? result = el.selectFirst(jSel);
      jSel.release();
      if (result == null) return -1;
      return _addElement(result);
    } on JniException catch (_) {
      return -1;
    }
  }

  @override
  String? attr(int handle, String key) {
    final jsoup_el.Element? el = _elements[handle];
    if (el == null) return null;
    try {
      final JString jKey = _jstr(key);
      final JString? result = el.attr(jKey);
      jKey.release();
      if (result == null) return null;
      final String val = result.toDartString();
      result.release();
      // Jsoup returns empty string for missing attributes.
      if (val.isEmpty && !hasAttr(handle, key)) return null;
      return val;
    } on JniException catch (_) {
      return null;
    }
  }

  @override
  bool hasAttr(int handle, String key) {
    final jsoup_el.Element? el = _elements[handle];
    if (el == null) return false;
    try {
      final JString jKey = _jstr(key);
      final bool result = el.hasAttr(jKey);
      jKey.release();
      return result;
    } on JniException catch (_) {
      return false;
    }
  }

  @override
  String? text(int handle) {
    final jsoup_el.Element? el = _elements[handle];
    if (el == null) return null;
    try {
      return _readAndRelease(el.text());
    } on JniException catch (_) {
      return null;
    }
  }

  @override
  String? ownText(int handle) {
    final jsoup_el.Element? el = _elements[handle];
    if (el == null) return null;
    try {
      return _readAndRelease(el.ownText());
    } on JniException catch (_) {
      return null;
    }
  }

  @override
  String? innerHtml(int handle) {
    final jsoup_el.Element? el = _elements[handle];
    if (el == null) return null;
    try {
      // Element.html() returns inner HTML.
      return _readAndRelease(el.html$1());
    } on JniException catch (_) {
      return null;
    }
  }

  @override
  String? outerHtml(int handle) {
    final jsoup_el.Element? el = _elements[handle];
    if (el == null) return null;
    try {
      return _readAndRelease(el.outerHtml());
    } on JniException catch (_) {
      return null;
    }
  }

  @override
  String? tagName(int handle) {
    final jsoup_el.Element? el = _elements[handle];
    if (el == null) return null;
    try {
      return _readAndRelease(el.tagName());
    } on JniException catch (_) {
      return null;
    }
  }

  @override
  String? id(int handle) {
    final jsoup_el.Element? el = _elements[handle];
    if (el == null) return null;
    try {
      final String? result = _readAndRelease(el.id());
      if (result != null && result.isEmpty) return null;
      return result;
    } on JniException catch (_) {
      return null;
    }
  }

  @override
  String? className(int handle) {
    final jsoup_el.Element? el = _elements[handle];
    if (el == null) return null;
    try {
      return _readAndRelease(el.className());
    } on JniException catch (_) {
      return null;
    }
  }

  @override
  bool hasClass(int handle, String name) {
    final jsoup_el.Element? el = _elements[handle];
    if (el == null) return false;
    try {
      final JString jName = _jstr(name);
      final bool result = el.hasClass(jName);
      jName.release();
      return result;
    } on JniException catch (_) {
      return false;
    }
  }

  @override
  int size(int handle) {
    final jsoup_els.Elements? list = _nodeLists[handle];
    if (list == null) return -1;
    try {
      return _callIntMethod(
        list.reference.pointer,
        _sizeId as jni$_.JMethodIDPtr,
      ).integer;
    } on JniException catch (_) {
      return -1;
    }
  }

  @override
  int get(int handle, int index) {
    final jsoup_els.Elements? list = _nodeLists[handle];
    if (list == null) return -1;
    try {
      final jsoup_el.Element? el = _callObjectMethodWithInt(
        list.reference.pointer,
        _getId as jni$_.JMethodIDPtr,
        index,
      ).object<jsoup_el.Element?>(const jsoup_el.$Element$NullableType$());
      if (el == null) return -1;
      return _addElement(el);
    } on JniException catch (_) {
      return -1;
    }
  }

  @override
  int first(int handle) {
    final jsoup_els.Elements? list = _nodeLists[handle];
    if (list == null) return -1;
    try {
      final jsoup_el.Element? el = list.first();
      if (el == null) return -1;
      return _addElement(el);
    } on JniException catch (_) {
      return -1;
    }
  }

  @override
  int last(int handle) {
    final jsoup_els.Elements? list = _nodeLists[handle];
    if (list == null) return -1;
    try {
      final jsoup_el.Element? el = list.last();
      if (el == null) return -1;
      return _addElement(el);
    } on JniException catch (_) {
      return -1;
    }
  }

  @override
  int parent(int handle) {
    final jsoup_el.Element? el = _elements[handle];
    if (el == null) return -1;
    try {
      final jsoup_el.Element? p = el.parent$1();
      if (p == null) return -1;
      // parent() returns Node?, cast to Element
      return _addElement(p.as(jsoup_el.Element.type));
    } on JniException catch (_) {
      return -1;
    }
  }

  @override
  int children(int handle) {
    final jsoup_el.Element? el = _elements[handle];
    if (el == null) return -1;
    try {
      final jsoup_els.Elements? kids = el.children();
      if (kids == null) return -1;
      return _addNodeList(kids);
    } on JniException catch (_) {
      return -1;
    }
  }

  @override
  int nextSibling(int handle) {
    final jsoup_el.Element? el = _elements[handle];
    if (el == null) return -1;
    try {
      final jsoup_el.Element? sib = el.nextElementSibling();
      if (sib == null) return -1;
      return _addElement(sib);
    } on JniException catch (_) {
      return -1;
    }
  }

  @override
  int prevSibling(int handle) {
    final jsoup_el.Element? el = _elements[handle];
    if (el == null) return -1;
    try {
      final jsoup_el.Element? sib = el.previousElementSibling();
      if (sib == null) return -1;
      return _addElement(sib);
    } on JniException catch (_) {
      return -1;
    }
  }

  @override
  int siblings(int handle) {
    final jsoup_el.Element? el = _elements[handle];
    if (el == null) return -1;
    try {
      final jsoup_els.Elements? sibs = el.siblingElements();
      if (sibs == null) return -1;
      return _addNodeList(sibs);
    } on JniException catch (_) {
      return -1;
    }
  }

  @override
  void setText(int handle, String text) {
    final jsoup_el.Element? el = _elements[handle];
    if (el == null) return;
    try {
      final JString jText = _jstr(text);
      el.text$1(jText);
      jText.release();
    } on JniException catch (_) {
      // Ignore.
    }
  }

  @override
  void setHtml(int handle, String html) {
    final jsoup_el.Element? el = _elements[handle];
    if (el == null) return;
    try {
      final JString jHtml = _jstr(html);
      el.html$2(jHtml);
      jHtml.release();
    } on JniException catch (_) {
      // Ignore.
    }
  }

  @override
  void remove(int handle) {
    final jsoup_el.Element? el = _elements[handle];
    if (el == null) return;
    try {
      el.remove();
    } on JniException catch (_) {
      // Ignore.
    }
  }

  @override
  void prepend(int handle, String html) {
    final jsoup_el.Element? el = _elements[handle];
    if (el == null) return;
    try {
      final JString jHtml = _jstr(html);
      el.prepend(jHtml);
      jHtml.release();
    } on JniException catch (_) {
      // Ignore.
    }
  }

  @override
  void append(int handle, String html) {
    final jsoup_el.Element? el = _elements[handle];
    if (el == null) return;
    try {
      final JString jHtml = _jstr(html);
      el.append(jHtml);
      jHtml.release();
    } on JniException catch (_) {
      // Ignore.
    }
  }

  @override
  void setAttr(int handle, String key, String value) {
    final jsoup_el.Element? el = _elements[handle];
    if (el == null) return;
    try {
      final JString jKey = _jstr(key);
      final JString jValue = _jstr(value);
      el.attr$1(jKey, jValue);
      jKey.release();
      jValue.release();
    } on JniException catch (_) {
      // Ignore.
    }
  }

  @override
  void removeAttr(int handle, String key) {
    final jsoup_el.Element? el = _elements[handle];
    if (el == null) return;
    try {
      final JString jKey = _jstr(key);
      el.removeAttr(jKey);
      jKey.release();
    } on JniException catch (_) {
      // Ignore.
    }
  }

  @override
  void addClass(int handle, String name) {
    final jsoup_el.Element? el = _elements[handle];
    if (el == null) return;
    try {
      final JString jName = _jstr(name);
      el.addClass(jName);
      jName.release();
    } on JniException catch (_) {
      // Ignore.
    }
  }

  @override
  void removeClass(int handle, String name) {
    final jsoup_el.Element? el = _elements[handle];
    if (el == null) return;
    try {
      final JString jName = _jstr(name);
      el.removeClass(jName);
      jName.release();
    } on JniException catch (_) {
      // Ignore.
    }
  }

  @override
  String? data(int handle) {
    final jsoup_el.Element? el = _elements[handle];
    if (el == null) return null;
    try {
      return _readAndRelease(el.data());
    } on JniException catch (_) {
      return null;
    }
  }

  // -- TextNode creation --

  @override
  int createTextNode(String text) {
    try {
      final JString jText = _jstr(text);
      final tn = jsoup_tn.TextNode(jText);
      jText.release();
      return _addTextNode(tn);
    } on JniException catch (_) {
      return -1;
    }
  }

  // -- Elements creation --

  @override
  int createElements(List<int> elementHandles) {
    try {
      // Create an empty Jsoup Elements (extends ArrayList<Element>).
      final jElements = jsoup_els.Elements();
      // Add each element via java.util.List.add(Object).
      for (final h in elementHandles) {
        final jsoup_el.Element? el = _elements[h];
        if (el == null) continue;
        _callBooleanMethodWithObject(
          jElements.reference.pointer,
          _addId as jni$_.JMethodIDPtr,
          el.reference.pointer,
        );
      }
      return _addNodeList(jElements);
    } on JniException catch (_) {
      return -1;
    }
  }

  // -- Node-level methods --

  @override
  String? nodeName(int handle) {
    // Check elements first, then text nodes.
    final jsoup_el.Element? el = _elements[handle];
    if (el != null) {
      try {
        return _readAndRelease(el.nodeName());
      } on JniException catch (_) {
        return null;
      }
    }
    final jsoup_tn.TextNode? tn = _textNodes[handle];
    if (tn != null) {
      try {
        return _readAndRelease(tn.nodeName());
      } on JniException catch (_) {
        return null;
      }
    }
    return null;
  }

  jsoup_node.Node? _resolveNode(int handle) {
    final jsoup_el.Element? el = _elements[handle];
    if (el != null) return el.as(jsoup_node.Node.type);
    final jsoup_tn.TextNode? tn = _textNodes[handle];
    if (tn != null) return tn.as(jsoup_node.Node.type);
    return null;
  }

  @override
  int childNodeSize(int handle) {
    final jsoup_node.Node? node = _resolveNode(handle);
    if (node == null) return 0;
    try {
      return node.childNodeSize();
    } on JniException catch (_) {
      return 0;
    }
  }

  @override
  int childNode(int handle, int index) {
    final jsoup_node.Node? node = _resolveNode(handle);
    if (node == null) return -1;
    try {
      final jsoup_node.Node? child = node.childNode(index);
      if (child == null) return -1;
      return _addNode(child);
    } on JniException catch (_) {
      return -1;
    }
  }

  @override
  List<int> childNodeHandles(int handle) {
    final jsoup_node.Node? node = _resolveNode(handle);
    if (node == null) return const <int>[];
    try {
      final JList<jsoup_node.Node?>? children = node.childNodes();
      if (children == null) return const <int>[];
      final int count = children.length;
      final handles = <int>[];
      for (var i = 0; i < count; i++) {
        final jsoup_node.Node? child = children[i];
        if (child == null) continue;
        handles.add(_addNode(child));
      }
      return handles;
    } on JniException catch (_) {
      return const <int>[];
    }
  }

  @override
  bool isTextNode(int handle) => _textNodes.containsKey(handle);

  @override
  int parentNode(int handle) {
    final jsoup_node.Node? node = _resolveNode(handle);
    if (node == null) return -1;
    try {
      final jsoup_node.Node? p = node.parent();
      if (p == null) return -1;
      return _addNode(p);
    } on JniException catch (_) {
      return -1;
    }
  }

  @override
  String? nodeOuterHtml(int handle) {
    final jsoup_node.Node? node = _resolveNode(handle);
    if (node == null) return null;
    try {
      return _readAndRelease(node.outerHtml());
    } on JniException catch (_) {
      return null;
    }
  }

  @override
  void removeNode(int handle) {
    final jsoup_node.Node? node = _resolveNode(handle);
    if (node == null) return;
    try {
      node.remove();
    } on JniException catch (_) {
      // Ignore.
    }
  }

  // -- Element-level: textNodes --

  @override
  List<int> textNodeHandles(int handle) {
    final jsoup_el.Element? el = _elements[handle];
    if (el == null) return const <int>[];
    try {
      final JList<jsoup_tn.TextNode?>? tnList = el.textNodes();
      if (tnList == null) return const <int>[];
      final int count = tnList.length;
      final handles = <int>[];
      for (var i = 0; i < count; i++) {
        final jsoup_tn.TextNode? tn = tnList[i];
        if (tn == null) continue;
        handles.add(_addTextNode(tn));
      }
      return handles;
    } on JniException catch (_) {
      return const <int>[];
    }
  }

  // -- TextNode-level methods --

  @override
  String? textNodeText(int handle) {
    final jsoup_tn.TextNode? tn = _textNodes[handle];
    if (tn == null) return null;
    try {
      return _readAndRelease(tn.text());
    } on JniException catch (_) {
      return null;
    }
  }

  @override
  void setTextNodeText(int handle, String text) {
    final jsoup_tn.TextNode? tn = _textNodes[handle];
    if (tn == null) return;
    try {
      final JString jText = _jstr(text);
      tn.text$1(jText);
      jText.release();
    } on JniException catch (_) {
      // Ignore.
    }
  }

  @override
  String? textNodeWholeText(int handle) {
    final jsoup_tn.TextNode? tn = _textNodes[handle];
    if (tn == null) return null;
    try {
      return _readAndRelease(tn.getWholeText());
    } on JniException catch (_) {
      return null;
    }
  }

  @override
  bool textNodeIsBlank(int handle) {
    final jsoup_tn.TextNode? tn = _textNodes[handle];
    if (tn == null) return true;
    try {
      return tn.isBlank();
    } on JniException catch (_) {
      return true;
    }
  }

  @override
  void free(int handle) {
    _elements.remove(handle)?.release();
    _textNodes.remove(handle)?.release();
    _nodeLists.remove(handle)?.release();
  }

  @override
  void releaseAll() {
    for (final jsoup_el.Element obj in _elements.values) {
      obj.release();
    }
    _elements.clear();
    for (final jsoup_tn.TextNode obj in _textNodes.values) {
      obj.release();
    }
    _textNodes.clear();
    for (final jsoup_els.Elements obj in _nodeLists.values) {
      obj.release();
    }
    _nodeLists.clear();
    _nextHandle = 1;
  }

  @override
  void dispose() {
    releaseAll();
  }
}
