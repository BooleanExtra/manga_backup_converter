// ignore_for_file: conditional_uri_does_not_exist
export 'wasm_shared_state_io.dart'
    if (dart.library.js_interop) 'wasm_shared_state_web.dart';
