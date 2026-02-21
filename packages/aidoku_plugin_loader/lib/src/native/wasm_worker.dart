// Native stub — Web Worker WASM execution is web-only.
//
// The web implementation lives in lib/src/web/:
//   - wasm_worker_js.dart — embedded JavaScript worker source
//   - wasm_worker_launcher.dart — JS interop bindings for Worker/Blob
//
// On native platforms, WASM runs in a background Isolate instead
// (see wasm_isolate.dart).
