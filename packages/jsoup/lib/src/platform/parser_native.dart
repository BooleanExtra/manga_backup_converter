import 'dart:io';

import 'package:jsoup/src/html_parser.dart';
import 'package:jsoup/src/jni/jni_parser.dart';

export 'package:jsoup/src/jni/jre_manager.dart';

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
