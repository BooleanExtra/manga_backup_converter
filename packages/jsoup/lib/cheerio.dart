/// Cheerio 1.2.0 standalone UMD bundle for web HTML parsing.
///
/// Provides `cheerioJs`, a JavaScript source string that exposes
/// `self.cheerio` when evaluated in a Web Worker context.
///
/// This is the web backend for the jsoup package, replacing browser DOM's
/// `querySelectorAll` which lacks jsoup-specific pseudo-selectors
/// (`:contains`, `:matches`, `:matchesOwn`, etc.).
library;

export 'src/web/cheerio_bundle.dart';
