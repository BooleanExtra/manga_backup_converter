/// Abstract interface for a Jsoup-compatible HTML parser.
///
/// Implementations manage opaque integer handles to parsed documents and
/// elements. Handles must be freed via [free] when no longer needed.
/// Returns `-1` for errors or not-found results.
abstract class NativeHtmlParser {
  /// Parse a full HTML document.
  int parse(String html, {String baseUri = ''});

  /// Parse an HTML fragment (returns a document handle, not a node list).
  int parseFragment(String html, {String baseUri = ''});

  /// Select all elements matching [selector] under the element at [handle].
  /// Returns a node list handle.
  int select(int handle, String selector);

  /// Select the first element matching [selector] under [handle].
  /// Returns an element handle, or `-1` if not found.
  int selectFirst(int handle, String selector);

  /// Get the value of attribute [key] on the element at [handle].
  String? attr(int handle, String key);

  /// Whether the element at [handle] has attribute [key].
  bool hasAttr(int handle, String key);

  /// Get the combined text of all descendant text nodes, trimmed.
  String? text(int handle);

  /// Get only the direct text nodes of the element (not nested elements).
  String? ownText(int handle);

  /// Get the inner HTML of the element.
  String? innerHtml(int handle);

  /// Get the outer HTML of the element (including the element itself).
  String? outerHtml(int handle);

  /// Get the tag name of the element.
  String? tagName(int handle);

  /// Get the `id` attribute of the element.
  String? id(int handle);

  /// Get the `class` attribute value of the element.
  String? className(int handle);

  /// Whether the element has CSS class [name].
  bool hasClass(int handle, String name);

  /// Get the number of elements in a node list handle.
  int size(int handle);

  /// Get the element at [index] in a node list. Returns an element handle.
  int get(int handle, int index);

  /// Get the first element in a node list. Returns an element handle.
  int first(int handle);

  /// Get the last element in a node list. Returns an element handle.
  int last(int handle);

  /// Get the parent element. Returns an element handle.
  int parent(int handle);

  /// Get all child elements. Returns a node list handle.
  int children(int handle);

  /// Get the next sibling element. Returns an element handle.
  int nextSibling(int handle);

  /// Get the previous sibling element. Returns an element handle.
  int prevSibling(int handle);

  /// Get all sibling elements (excluding self). Returns a node list handle.
  int siblings(int handle);

  /// Set the text content of the element.
  void setText(int handle, String text);

  /// Set the inner HTML of the element.
  void setHtml(int handle, String html);

  /// Remove the element from its parent.
  void remove(int handle);

  /// Prepend HTML to the element's children.
  void prepend(int handle, String html);

  /// Append HTML to the element's children.
  void append(int handle, String html);

  /// Set an attribute on the element.
  void setAttr(int handle, String key, String value);

  /// Remove an attribute from the element.
  void removeAttr(int handle, String key);

  /// Add a CSS class to the element.
  void addClass(int handle, String name);

  /// Remove a CSS class from the element.
  void removeClass(int handle, String name);

  /// Get the `data` / text content (alias for text in most impls).
  String? data(int handle);

  /// Get the base URI of the node at [handle].
  String? nodeBaseUri(int handle);

  /// Resolve a relative URL attribute [key] against the node's base URI.
  /// Returns the absolute URL, or empty string if it cannot be resolved.
  String? nodeAbsUrl(int handle, String key);

  /// Set the base URI on the node at [handle].
  void setNodeBaseUri(int handle, String value);

  /// Create a new standalone element with the given [tag].
  /// Returns an element handle.
  int createElement(String tag);

  /// Create a new standalone text node with the given [text].
  /// Returns a text node handle.
  int createTextNode(String text);

  /// Create an Elements (node list) from a list of element handles.
  /// Returns a node list handle.
  int createElements(List<int> elementHandles);

  // -- Node-level methods --

  /// Get the node name (e.g. "#text" for TextNode, tag name for Element).
  String? nodeName(int handle);

  /// Get the number of child nodes (including text nodes).
  int childNodeSize(int handle);

  /// Get a child node by index. Returns a node handle (element or text node).
  /// Returns `-1` if out of bounds.
  int childNode(int handle, int index);

  /// Get all child node handles (elements + text nodes) eagerly.
  List<int> childNodeHandles(int handle);

  /// Whether the handle refers to a text node.
  bool isTextNode(int handle);

  /// Get the parent node handle. Returns `-1` if no parent.
  int parentNode(int handle);

  /// Get the outer HTML of a node (works for both elements and text nodes).
  String? nodeOuterHtml(int handle);

  /// Remove a node from its parent (works for both elements and text nodes).
  void removeNode(int handle);

  // -- Element-level (new) --

  /// Get the text node children of an element.
  /// Returns a list of text node handles.
  List<int> textNodeHandles(int handle);

  // -- TextNode-level --

  /// Get the normalized text content of a text node.
  String? textNodeText(int handle);

  /// Set the text content of a text node.
  void setTextNodeText(int handle, String text);

  /// Get the whole (unencoded, whitespace-preserved) text of a text node.
  String? textNodeWholeText(int handle);

  /// Whether the text node is blank (empty or whitespace only).
  bool textNodeIsBlank(int handle);

  /// Free a handle (element or node list). Must be called when done.
  void free(int handle);

  /// Release all handles and reset internal state, but keep the parser alive.
  ///
  /// Unlike [dispose], this does not shut down the underlying engine (e.g. JVM).
  /// Call between WASM export invocations to free accumulated JNI/JS handles.
  void releaseAll();

  /// Dispose the parser and release all resources (e.g. JVM shutdown).
  void dispose();
}
