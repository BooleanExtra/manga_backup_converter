/// Rust scraper crate FFI bindings for HTML parsing and CSS selectors.
///
/// This package provides the compiled Rust bridge library via a build hook,
/// and the ffigen-generated `@Native` Dart bindings. The higher-level
/// `ScraperParser` (implementing `NativeHtmlParser`) lives in `package:jsoup`.
library;

export 'src/scraper_bindings_generated.dart';
