/// Conditional export: web impl on dart.library.js_interop, native stub otherwise.
export 'wasm_runner_native.dart' if (dart.library.js_interop) 'wasm_runner_web.dart';
