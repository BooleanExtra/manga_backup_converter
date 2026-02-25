/// Conditional export: picks the platform-appropriate runner.
export 'package:wasm_runner/wasm_runner.dart';

export 'package:wasm3/wasm3.dart'
    if (dart.library.js_interop) 'package:web_wasm_runner/web_wasm_runner.dart';
