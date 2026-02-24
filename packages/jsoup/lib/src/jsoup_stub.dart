import 'package:jsoup/src/jsoup_api.dart';
import 'package:jsoup/src/web/jsoup_web.dart';

/// Creates a [NativeHtmlParser] for web.
///
/// Returns a [CheerioParser] backed by Cheerio via `dart:js_interop`.
NativeHtmlParser createParser() => CheerioParser();

class JreManager {
  JreManager._();

  /// No-op on web — JVM is not needed.
  static void ensureInitialized() {}
}
