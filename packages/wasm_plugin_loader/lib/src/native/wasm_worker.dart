// Web Worker stub for Aidoku WASM async execution.
//
// Full implementation requires:
//   1. The page to be served with COOP+COEP headers:
//        Cross-Origin-Opener-Policy: same-origin
//        Cross-Origin-Embedder-Policy: require-corp
//   2. SharedArrayBuffer support in the browser.
//
// For now this file is a placeholder. The web runner falls back to running
// WASM on the main thread with synchronous (stub) HTTP imports.
//
// See wasm_runner_web.dart for the current web implementation.
