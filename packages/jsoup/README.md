# Jsoup HTML Plugin

This package provides a Jsoup-compatible HTML parsing and CSS selector engine.

It uses platform-native libraries:

- Android/Windows/Linux: Jsoup via JNI
- iOS/macOS: SwiftSoup (TODO)
- Web: TeaVM-compiled Java Jsoup (exact behavioral parity with JNI)

## Usage

### Parsing HTML

```dart
import 'package:jsoup/jsoup.dart';

final jsoup = Jsoup();
final document = jsoup.parse('<html><body><h1>Hello, World!</h1></body></html>');
```

### Selecting Elements

See [Jsoup's CSS Selector documentation](https://jsoup.org/cookbook/extracting-data/selector-syntax) for the syntax.

```dart
import 'package:jsoup/jsoup.dart';
final jsoup = Jsoup();
final document = jsoup.parse('<html><body><h1>Hello, World!</h1></body></html>');
final element = document.selectFirst('h1');
print(element?.text()); // Hello, World!
```

### Creating Elements

```dart
import 'package:jsoup/jsoup.dart';
final jsoup = Jsoup();
final element = jsoup.element('h1');
element.text('Hello, World!');
print(element.outerHtml()); // <h1>Hello, World!</h1>
```

## Web Support

This package supports the web platform via TeaVM — the real Java Jsoup library is AOT-compiled to JavaScript, providing exact behavioral parity with the JNI backend (including all pseudo-selectors like `:contains`, `:matchesOwn`, etc.).
