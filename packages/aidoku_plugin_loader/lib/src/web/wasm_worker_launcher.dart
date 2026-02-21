import 'dart:js_interop';

/// JS interop bindings for creating a Web Worker from a Blob URL.

@JS('Worker')
extension type JSWorker._(JSObject _) implements JSObject {
  external factory JSWorker(JSString scriptUrl);

  external JSFunction? get onmessage;
  external set onmessage(JSFunction? handler);
  external JSFunction? get onerror;
  external set onerror(JSFunction? handler);
  external void postMessage(JSAny? message, [JSArray<JSObject>? transfer]);
  external void terminate();
}

@JS('Blob')
extension type JSBlob._(JSObject _) implements JSObject {
  external factory JSBlob(JSArray<JSAny> parts, [JSObject? options]);
}

@JS('URL.createObjectURL')
external JSString _createObjectURL(JSBlob blob);

@JS('URL.revokeObjectURL')
external void revokeObjectURL(JSString url);

/// Creates a Web Worker from inline JavaScript source code.
///
/// Returns the worker and the Blob URL (which must be revoked on dispose).
({JSWorker worker, JSString blobUrl}) createWasmWorker(String jsSource) {
  final options = <String, String>{'type': 'application/javascript'}.jsify()! as JSObject;
  final blob = JSBlob(<JSAny>[jsSource.toJS].toJS, options);
  final JSString blobUrl = _createObjectURL(blob);
  final worker = JSWorker(blobUrl);
  return (worker: worker, blobUrl: blobUrl);
}
