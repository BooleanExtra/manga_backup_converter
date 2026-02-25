/// Jsoup-compatible HTML parsing and CSS selector engine.
///
/// Uses platform-native libraries:
/// - Android/Windows/Linux: Jsoup via JNI
/// - iOS/macOS: SwiftSoup (TODO)
/// - Web: TeaVM-compiled Java Jsoup (exact behavioral parity with JNI)
library;

export 'src/jsoup.dart';
export 'src/nodes/document.dart';
export 'src/nodes/element.dart';
export 'src/nodes/elements.dart';
export 'src/nodes/node.dart';
export 'src/nodes/text_node.dart';
export 'src/platform/parser_web.dart' if (dart.library.ffi) 'src/platform/parser_native.dart';
