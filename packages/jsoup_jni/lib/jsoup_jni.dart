/// Java Jsoup JNI backend for the jsoup package.
///
/// Provides `JsoupParser` (JNI-based NativeHtmlParser) and `JreManager` for
/// desktop/Android platforms.
library;

export 'src/jni_parser.dart' show JsoupParser;
export 'src/jre_manager.dart' show JreManager;
