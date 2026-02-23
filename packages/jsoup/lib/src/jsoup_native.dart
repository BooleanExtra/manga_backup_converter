import 'dart:io';

import 'package:jsoup/src/jsoup_api.dart';
import 'package:jsoup/src/jsoup_parser.dart';

export 'jre/jre_manager.dart';

/// Creates a [NativeHtmlParser] for the current platform.
///
/// - Android, Windows, Linux: [JsoupParser] (Jsoup via JNI)
/// - iOS, macOS: TODO — SwiftSoup
NativeHtmlParser createParser() {
  if (Platform.isIOS || Platform.isMacOS) {
    // TODO: return SwiftSoupParser() once implemented.
    throw UnsupportedError(
      'SwiftSoup parser is not yet implemented for ${Platform.operatingSystem}.',
    );
  }
  return JsoupParser();
}
