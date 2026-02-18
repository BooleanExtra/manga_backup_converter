/// Conditional export: web implementation on web, native stub otherwise.
export 'wasm_runner_native.dart' if (dart.library.js_interop) 'wasm_runner_web.dart';
