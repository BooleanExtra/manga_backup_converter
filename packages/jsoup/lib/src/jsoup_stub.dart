import 'package:jsoup/src/jsoup_api.dart';

/// Creates a [NativeHtmlParser] for the current platform.
///
/// On web, this throws [UnsupportedError] because the browser DOM is used
/// directly by the WASM worker instead.
NativeHtmlParser createParser() {
  throw UnsupportedError(
    'NativeHtmlParser is not available on web. '
    'Use browser DOM APIs instead.',
  );
}

class JreManager {
  JreManager._();
  static void ensureInitialized() {
    throw UnsupportedError(
      'JreManager is not available on web.',
    );
  }
}
