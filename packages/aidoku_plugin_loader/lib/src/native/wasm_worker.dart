// Web Worker stub for Aidoku WASM async execution.
//
// Full implementation requires:
//   1. The page to be served with COOP+COEP headers:
//        Cross-Origin-Opener-Policy: same-origin
//        Cross-Origin-Embedder-Policy: require-corp
//   2. SharedArrayBuffer support in the browser.
//
// TODO: implement Web Worker WASM execution with SharedArrayBuffer for async
// HTTP on web. The web runner currently falls back to running WASM on the main
// thread with synchronous (stub) HTTP imports.
//
// See wasm_runner_web.dart for the current web implementation.
