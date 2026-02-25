import 'dart:io';

import 'package:jsoup/src/html_parser.dart';
import 'package:jsoup/src/scraper/scraper_parser.dart';

export 'package:jsoup/src/jni/jre_manager.dart';

/// Creates a [NativeHtmlParser] for the current platform.
///
/// - Windows, Linux, Android: [ScraperParser] (Rust html5ever via FFI)
/// - iOS, macOS: TODO — SwiftSoup
NativeHtmlParser createParser() {
  if (Platform.isIOS || Platform.isMacOS) {
    // TODO: return SwiftSoupParser() once implemented.
    throw UnsupportedError(
      'SwiftSoup parser is not yet implemented for ${Platform.operatingSystem}.',
    );
  }
  return ScraperParser();
}
