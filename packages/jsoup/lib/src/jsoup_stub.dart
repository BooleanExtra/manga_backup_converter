import 'package:jsoup/src/jsoup_api.dart';
import 'package:jsoup/src/web/jsoup_teavm.dart';

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
