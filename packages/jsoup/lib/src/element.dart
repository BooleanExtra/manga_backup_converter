import 'package:jsoup/src/elements.dart';
import 'package:jsoup/src/jsoup_api.dart';
import 'package:jsoup/src/jsoup_class.dart';
import 'package:jsoup/src/node.dart';
import 'package:jsoup/src/text_node.dart';
import 'package:meta/meta.dart';

/// A single HTML element, wrapping a native handle from [NativeHtmlParser].
class Element extends Node {
  /// Create a new standalone element with the given [tag].
  Element(Jsoup jsoup, String tag)
    : super.fromHandle(
        jsoup.parser,
        jsoup.parser.createElement(tag),
      );

  /// Wrap an existing native parser handle.
  @internal
  Element.fromHandle(
    super.parser,
    super.handle,
  ) : super.fromHandle();

  // -- Selectors --

  /// Select all elements matching [selector].
  Elements select(String selector) {
    final int listHandle = parser.select(handle, selector);
    if (listHandle < 0) return Elements.fromHandle(parser, parser.createElements(const <int>[]));
    return Elements.fromHandle(parser, listHandle);
  }

  /// Select the first element matching [selector], or null.
  Element? selectFirst(String selector) {
    final int elHandle = parser.selectFirst(handle, selector);
    if (elHandle < 0) return null;
    return Element.fromHandle(parser, elHandle);
  }

  // -- Attributes --

  /// Get the value of attribute [key]. Returns empty string if missing
  /// (matching Java Jsoup convention).
  String attr(String key) => parser.attr(handle, key) ?? '';

  /// Resolve a relative URL attribute [key] against this node's base URI.
  /// Delegates to Java Jsoup's `Node.absUrl(key)`.
  String absUrl(String key) => parser.nodeAbsUrl(handle, key) ?? '';

  /// Whether this element has attribute [key].
  bool hasAttr(String key) => parser.hasAttr(handle, key);

  /// Set an attribute value.
  void setAttr(String key, String value) => parser.setAttr(handle, key, value);

  /// Remove an attribute.
  void removeAttr(String key) => parser.removeAttr(handle, key);

  // -- Text & HTML --

  /// The combined text of all descendant text nodes.
  String get text => parser.text(handle) ?? '';

  set text(String value) => parser.setText(handle, value);

  /// Only the direct text of this element (not child elements).
  String get ownText => parser.ownText(handle) ?? '';

  /// The inner HTML.
  String get html => parser.innerHtml(handle) ?? '';

  set html(String value) => parser.setHtml(handle, value);

  @override
  String get outerHtml => parser.outerHtml(handle) ?? '';

  /// The data content of this element (e.g. script/style text).
  String get data => parser.data(handle) ?? '';

  // -- Identity --

  /// The tag name.
  String get tagName => parser.tagName(handle) ?? '';

  /// The `id` attribute value.
  String get id => parser.id(handle) ?? '';

  /// The `class` attribute value.
  String get className => parser.className(handle) ?? '';

  /// Whether this element has CSS class [name].
  bool hasClass(String name) => parser.hasClass(handle, name);

  /// Add a CSS class.
  void addClass(String name) => parser.addClass(handle, name);

  /// Remove a CSS class.
  void removeClass(String name) => parser.removeClass(handle, name);

  // -- Navigation --

  /// The parent element, or null if this is the root.
  Element? get parent {
    final int parentHandle = parser.parent(handle);
    if (parentHandle < 0) return null;
    return Element.fromHandle(parser, parentHandle);
  }

  /// All child elements (not text nodes).
  Elements get children {
    final int childrenHandle = parser.children(handle);
    if (childrenHandle < 0) return Elements.fromHandle(parser, parser.createElements(const <int>[]));
    return Elements.fromHandle(parser, childrenHandle);
  }

  /// The next sibling element, or null.
  Element? get nextElementSibling {
    final int sibHandle = parser.nextSibling(handle);
    if (sibHandle < 0) return null;
    return Element.fromHandle(parser, sibHandle);
  }

  /// The previous sibling element, or null.
  Element? get previousElementSibling {
    final int sibHandle = parser.prevSibling(handle);
    if (sibHandle < 0) return null;
    return Element.fromHandle(parser, sibHandle);
  }

  /// All sibling elements (excluding this one).
  Elements get siblingElements {
    final int sibsHandle = parser.siblings(handle);
    if (sibsHandle < 0) return Elements.fromHandle(parser, parser.createElements(const <int>[]));
    return Elements.fromHandle(parser, sibsHandle);
  }

  /// The direct text node children of this element.
  List<TextNode> get textNodes {
    final List<int> handles = parser.textNodeHandles(handle);
    return <TextNode>[
      for (final int h in handles) TextNode.fromHandle(parser, h),
    ];
  }

  @override
  List<Node> get childNodes {
    final List<int> handles = parser.childNodeHandles(handle);
    return <Node>[
      for (final int h in handles)
        if (parser.isTextNode(h)) TextNode.fromHandle(parser, h) else Element.fromHandle(parser, h),
    ];
  }

  // -- Mutation --

  @override
  void remove() => parser.remove(handle);

  /// Prepend HTML to this element's children.
  void prepend(String html) => parser.prepend(handle, html);

  /// Append HTML to this element's children.
  void append(String html) => parser.append(handle, html);
}
