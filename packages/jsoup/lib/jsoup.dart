/// Jsoup-compatible HTML parsing and CSS selector engine.
///
/// Uses platform-native libraries:
/// - Android/Windows/Linux: Jsoup via JNI
/// - iOS/macOS: SwiftSoup (TODO)
/// - Web: Stub (browser DOM used directly by WASM worker)
library;

export 'src/document.dart';
export 'src/element.dart';
export 'src/elements.dart';
export 'src/jsoup_class.dart';
export 'src/jsoup_stub.dart' if (dart.library.ffi) 'src/jsoup_native.dart';
export 'src/node.dart';
export 'src/text_node.dart';
