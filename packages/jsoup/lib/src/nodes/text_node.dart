import 'package:jsoup/src/jsoup.dart';
import 'package:jsoup/src/nodes/node.dart';
import 'package:meta/meta.dart';

/// A text node in the HTML DOM.
///
/// Mirrors Java Jsoup's `TextNode`. Contains unencoded text content.
class TextNode extends Node {
  /// Create a new standalone text node with the given [text].
  TextNode(Jsoup jsoup, String text)
    : super.fromHandle(
        jsoup.parser,
        jsoup.parser.createTextNode(text),
      );

  /// Wrap an existing native parser handle.
  @internal
  TextNode.fromHandle(
    super.parser,
    super.handle,
  ) : super.fromHandle();

  /// The normalized text content.
  String get text => parser.textNodeText(handle) ?? '';

  /// Set the text content.
  set text(String value) => parser.setTextNodeText(handle, value);

  /// The unencoded text with whitespace preserved.
  String get wholeText => parser.textNodeWholeText(handle) ?? '';

  /// Whether this text node is blank (empty or whitespace only).
  bool get isBlank => parser.textNodeIsBlank(handle);
}
