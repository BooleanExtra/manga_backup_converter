import 'package:jsoup/src/jsoup.dart';
import 'package:jsoup/src/nodes/element.dart';
import 'package:meta/meta.dart';

/// An HTML document, extending [Element] with parse constructors.
class Document extends Element {
  /// Parse an HTML string into a Document.
  Document(Jsoup jsoup, String html, {String baseUri = ''})
    : super.fromHandle(
        jsoup.parser,
        jsoup.parser.parse(html, baseUri: baseUri),
      );

  /// Parse an HTML fragment into a Document.
  Document.fragment(Jsoup jsoup, String html, {String baseUri = ''})
    : super.fromHandle(
        jsoup.parser,
        jsoup.parser.parseFragment(html, baseUri: baseUri),
      );

  /// Wrap an existing native parser handle as a Document.
  @internal
  Document.fromHandle(
    super.parser,
    super.handle,
  ) : super.fromHandle();
}
