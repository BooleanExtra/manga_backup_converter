/// Jsoup-compatible HTML parsing and CSS selector engine.
///
/// Uses platform-native libraries:
/// - Windows/Linux/Android: Rust scraper (html5ever via FFI)
/// - iOS/macOS: SwiftSoup (TODO)
/// - Web: TeaVM-compiled Java Jsoup
library;

export 'src/jsoup.dart';
export 'src/nodes/document.dart';
export 'src/nodes/element.dart';
export 'src/nodes/elements.dart';
export 'src/nodes/node.dart';
export 'src/nodes/text_node.dart';
