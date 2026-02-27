/// TeaVM-compiled Jsoup 1.18.3 bridge (UMD module, minified).
///
/// Provides `teavmJsoupJs`, a JavaScript source string that exposes
/// the real Java Jsoup library when evaluated in a Web Worker context
/// via TeaVM's AOT JavaScript compilation.
///
/// This replaces the Cheerio-based web backend with exact behavioral
/// parity to the JNI backend (Android/Windows/Linux).
library;

export 'src/web/teavm_bundle.dart';
