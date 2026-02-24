# jsoup

Jsoup-compatible HTML parsing and CSS selector engine for Dart, using platform-native backends.

| Platform              | Backend                          |
|-----------------------|----------------------------------|
| Android/Windows/Linux | Java Jsoup via JNI               |
| iOS/macOS             | SwiftSoup (TODO)                 |
| Web                   | TeaVM-compiled Java Jsoup        |

## Getting Started

```dart
import 'package:jsoup/jsoup.dart';

final jsoup = Jsoup();
```

On desktop (Windows/Linux), ensure the JRE is initialized before use:

```dart
JreManager.ensureInitialized();
final jsoup = Jsoup();
```

When you're done, release all native resources. Individual elements and documents do not need to be freed separately:

```dart
jsoup.dispose();
```

## Parsing

Parse a full HTML document:

```dart
final doc = jsoup.parse('<html><body><p>Hello</p></body></html>');
```

Parse an HTML fragment:

```dart
final doc = jsoup.parseFragment('<p>Hello</p><p>World</p>');
```

Both accept an optional `baseUri` for resolving relative URLs:

```dart
final doc = jsoup.parse(html, baseUri: 'https://example.com');
```

`Document` extends `Element`, so all element methods are available on documents.

## CSS Selectors

```dart
// All matching elements
final Elements links = doc.select('a[href]');

// First match, or null
final Element? title = doc.selectFirst('h1');
```

See [Jsoup's selector syntax](https://jsoup.org/cookbook/extracting-data/selector-syntax) for the full reference. Jsoup-specific pseudo-selectors like `:contains()`, `:containsOwn()`, `:matches()`, and `:matchesOwn()` are supported on all backends.

## Working with Elements

### Attributes

```dart
final href = element.attr('href');         // get (empty string if missing)
final bool has = element.hasAttr('href');   // check
element.setAttr('href', '/new');           // set
element.removeAttr('href');                // remove
```

### Text & HTML

```dart
// Reading
final String text = element.text;          // combined text of all descendants
final String own = element.ownText;        // direct text only (not child elements)
final String inner = element.html;         // inner HTML
final String outer = element.outerHtml;    // outer HTML (includes this element's tag)
final String data = element.data;          // data content (e.g. <script>/<style>)

// Writing
element.text = 'New text';
element.html = '<em>New</em> content';
```

### Identity

```dart
final String tag = element.tagName;
final String id = element.id;
final String cls = element.className;

element.hasClass('active');    // bool
element.addClass('active');
element.removeClass('active');
```

## Navigation

### Element-Level

```dart
final Element? p = element.parent;
final Elements kids = element.children;           // child elements only
final Element? next = element.nextElementSibling;
final Element? prev = element.previousElementSibling;
final Elements sibs = element.siblingElements;    // siblings excluding self
```

### Node-Level

```dart
final Node? pNode = element.parentNode;
final List<Node> nodes = element.childNodes;      // mixed Elements and TextNodes
final Node child = element.childNode(0);          // by index
final int count = element.childNodeSize;
final List<TextNode> texts = element.textNodes;   // direct text node children
```

## Mutation

```dart
element.prepend('<em>Before</em>');   // prepend HTML to children
element.append('<em>After</em>');     // append HTML to children
element.remove();                     // remove from parent
```

## Creating Elements

```dart
final el = jsoup.element('div');
el.setAttr('class', 'container');
el.text = 'Hello';

final text = jsoup.textNode('Some text');

final collection = jsoup.elements([el]);
```

## Elements Collection

`Elements` extends `Iterable<Element>` with indexed access:

```dart
final Elements items = doc.select('li');
final int count = items.length;
final Element first = items[0];

for (final item in items) {
  print(item.text);
}

final String uri = items.baseUri;  // base URI from the first element
```

## Node & TextNode

`Node` is the base class for `Element` and `TextNode`.

```dart
final String name = node.nodeName;    // tag name or "#text"
final String html = node.outerHtml;
node.remove();
```

`TextNode` represents text content:

```dart
final String normalized = textNode.text;       // normalized text
textNode.text = 'Updated';                     // set text
final String raw = textNode.wholeText;         // whitespace-preserved
final bool blank = textNode.isBlank;           // empty or whitespace only
```

## Base URI & URL Resolution

When parsing with a `baseUri`, relative URLs can be resolved:

```dart
final doc = jsoup.parse(
  '<a href="/path">Link</a>',
  baseUri: 'https://example.com',
);
final link = doc.selectFirst('a')!;
final url = link.absUrl('href');  // https://example.com/path
```

The base URI propagates from the document through child nodes. You can also read or set it on any node:

```dart
final String uri = node.baseUri;
node.baseUri = 'https://other.com';
```

## Web Support

On web, this package uses TeaVM to AOT-compile the real Java Jsoup library to JavaScript. This provides exact behavioral parity with the JNI backend, including all pseudo-selectors.

`JreManager.ensureInitialized()` is a no-op on web.

To regenerate the TeaVM bundle (requires JDK 17+ and Maven 3.x):

```bash
dart run tool/build_teavm.dart
```
