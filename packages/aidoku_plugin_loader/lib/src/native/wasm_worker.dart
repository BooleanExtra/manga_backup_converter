// Native stub — Web Worker WASM execution is web-only.
//
// The web implementation lives in lib/src/web/:
//   - wasm_worker_isolate.dart — Dart isolate entry point for the web worker
//
// On native platforms, WASM runs in a background Isolate instead
// (see wasm_isolate.dart).
