import 'package:jsoup/src/html_parser.dart';
import 'package:jsoup/src/nodes/document.dart';
import 'package:jsoup/src/nodes/element.dart';
import 'package:jsoup/src/nodes/elements.dart';
import 'package:jsoup/src/nodes/text_node.dart';
import 'package:jsoup/src/platform/parser_web.dart'
    if (dart.library.ffi) 'package:jsoup/src/platform/parser_native.dart';
import 'package:meta/meta.dart';

/// Entry point for Jsoup HTML parsing.
///
/// Creates a platform-appropriate HTML parser backend and provides
/// [parse] / [parseFragment] methods that return [Document] objects.
class Jsoup {
  /// Create a Jsoup instance using the platform backend.
  Jsoup() : parser = createParser();

  /// Create a Jsoup instance from a specific parser implementation.
  @internal
  Jsoup.fromParser(this.parser);

  /// The underlying native parser. Package-internal.
  @internal
  final NativeHtmlParser parser;

  /// Parse a full HTML document.
  Document parse(String html, {String baseUri = ''}) => Document(this, html, baseUri: baseUri);

  /// Parse an HTML fragment into a Document.
  Document parseFragment(String html, {String baseUri = ''}) => Document.fragment(this, html, baseUri: baseUri);

  /// Create a standalone [Element] with the given [tag].
  Element element(String tag) => Element(this, tag);

  /// Create a standalone [TextNode] with the given [text].
  TextNode textNode(String text) => TextNode(this, text);

  /// Create an [Elements] collection from a list of [Element] objects.
  Elements elements(List<Element> elements) => Elements(this, elements);

  /// Release all resources held by the parser.
  void dispose() => parser.dispose();
}
