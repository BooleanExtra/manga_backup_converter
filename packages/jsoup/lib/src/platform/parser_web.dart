import 'package:jsoup/src/html_parser.dart';
import 'package:jsoup/src/web/teavm_parser.dart';

/// Creates a [NativeHtmlParser] for web.
///
/// Returns a [TeaVMParser] backed by the real Java Jsoup library compiled to
/// JavaScript by TeaVM.
NativeHtmlParser createParser() => TeaVMParser();

class JreManager {
  JreManager._();

  /// No-op on web — JVM is not needed.
  static void ensureInitialized() {}
}
