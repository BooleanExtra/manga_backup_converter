import 'package:jsoup/src/element.dart';
import 'package:jsoup/src/jsoup_api.dart';
import 'package:jsoup/src/text_node.dart';
import 'package:meta/meta.dart';

/// Base class for all HTML nodes (elements, text nodes, etc.).
///
/// Mirrors Java Jsoup's `Node` class. [Element] and [TextNode] extend this.
class Node {
  /// Wrap an existing native parser handle.
  @internal
  Node.fromHandle(
    NativeHtmlParser parser,
    int handle,
  ) : _parser = parser,
      _handle = handle;

  final NativeHtmlParser _parser;
  final int _handle;

  /// The base URI for resolving relative URLs.
  /// Queries the native node's baseUri (propagated from the root document).
  String get baseUri => _parser.nodeBaseUri(_handle) ?? '';

  /// Set the base URI on this node.
  set baseUri(String value) => _parser.setNodeBaseUri(_handle, value);

  /// The underlying native handle. Package-internal.
  @internal
  int get handle => _handle;

  /// The underlying native parser. Package-internal.
  @internal
  NativeHtmlParser get parser => _parser;

  /// The node name (e.g. tag name for elements, "#text" for text nodes).
  String get nodeName => _parser.nodeName(_handle) ?? '';

  /// The parent node, or null if this is the root.
  Node? get parentNode {
    final int parentHandle = _parser.parentNode(_handle);
    if (parentHandle < 0) return null;
    if (_parser.isTextNode(parentHandle)) {
      return TextNode.fromHandle(_parser, parentHandle);
    }
    return Element.fromHandle(_parser, parentHandle);
  }

  /// The number of child nodes.
  int get childNodeSize => _parser.childNodeSize(_handle);

  /// Get a child node by its 0-based index.
  Node childNode(int index) {
    final int childHandle = _parser.childNode(_handle, index);
    if (childHandle < 0) {
      throw RangeError.index(index, this, 'index', null, childNodeSize);
    }
    if (_parser.isTextNode(childHandle)) {
      return TextNode.fromHandle(_parser, childHandle);
    }
    return Element.fromHandle(_parser, childHandle);
  }

  /// All child nodes (elements + text nodes), eagerly materialized.
  List<Node> get childNodes {
    final List<int> handles = _parser.childNodeHandles(_handle);
    return <Node>[
      for (final int h in handles)
        if (_parser.isTextNode(h)) TextNode.fromHandle(_parser, h) else Element.fromHandle(_parser, h),
    ];
  }

  /// The outer HTML of this node.
  String get outerHtml => _parser.nodeOuterHtml(_handle) ?? '';

  /// Remove this node from its parent.
  void remove() => _parser.removeNode(_handle);
}
