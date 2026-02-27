import 'dart:io';

import 'package:jsoup/src/html_parser.dart';
import 'package:jsoup/src/scraper/scraper_parser.dart';
import 'package:jsoup/src/swift/swift_parser.dart';

/// Creates a [NativeHtmlParser] for the current platform.
///
/// - Windows, Linux, Android: [ScraperParser] (Rust html5ever via FFI)
/// - iOS, macOS: [SwiftSoupParser] (SwiftSoup via Objective-C FFI)
NativeHtmlParser createParser() {
  if (Platform.isIOS || Platform.isMacOS) {
    return SwiftSoupParser();
  }
  return ScraperParser();
}
