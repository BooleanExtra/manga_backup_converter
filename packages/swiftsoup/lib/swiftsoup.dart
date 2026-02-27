/// SwiftSoup FFI bindings for HTML parsing and CSS selectors on iOS/macOS.
///
/// This package provides the compiled SwiftSoup bridge library via a build hook,
/// and the swiftgen-generated Dart bindings. The higher-level
/// `SwiftSoupParser` (implementing `NativeHtmlParser`) lives in `package:jsoup`.
library;

export 'src/swiftsoup_bindings_generated.dart';
