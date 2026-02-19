import 'dart:async';
import 'dart:typed_data';

/// Resource types held in the host-side store.
sealed class HostResource {}

class BytesResource extends HostResource {
  BytesResource(this.bytes);
  final Uint8List bytes;
}

class HttpRequestResource extends HostResource {
  HttpRequestResource({required this.method});
  final int method; // HttpMethod enum value
  String? url;
  final Map<String, String> headers = {};
  Uint8List? body;
  double timeout = 30.0;
  // Populated after send()
  int? statusCode;
  Uint8List? responseBody;
  final Map<String, String> responseHeaders = {};
}

class HtmlDocumentResource extends HostResource {
  HtmlDocumentResource(this.document, {this.baseUri = ''});
  final Object document; // html.Document or html.Element
  /// The base URI provided when this document was parsed (html::parse).
  final String baseUri;
}

class HtmlNodeListResource extends HostResource {
  HtmlNodeListResource(this.nodes);
  final List<Object> nodes; // List of html.Element
}

/// Host-side resource registry mapping i32 Rids to resources.
/// WASM reads Dart resources by calling back into host imports.
class HostStore {
  HostStore();

  final _map = <int, HostResource>{};
  int _nextId = 1;

  /// Per-source preference values managed by `defaults::set` / `defaults::get`.
  /// Values are either [int] (numeric/bool prefs) or [Uint8List] (string/multi-select prefs).
  final defaults = <String, Object>{};

  /// Partial results pushed by `env::_send_partial_result`.
  late final _partialResultsController = StreamController<Uint8List>.broadcast();

  Stream<Uint8List> get partialResults => _partialResultsController.stream;

  void addPartialResult(Uint8List data) {
    if (!_partialResultsController.isClosed) _partialResultsController.add(data);
  }

  /// Register a resource and return its Rid.
  int add(HostResource resource) {
    final id = _nextId++;
    _map[id] = resource;
    return id;
  }

  /// Register raw bytes as a resource.
  int addBytes(Uint8List bytes) => add(BytesResource(bytes));

  /// Retrieve a resource by Rid, or null if not found.
  T? get<T extends HostResource>(int rid) {
    final r = _map[rid];
    return r is T ? r : null;
  }

  /// Remove a resource by Rid.
  void remove(int rid) {
    _map.remove(rid);
    if (_map.isEmpty) _nextId = 1;
  }

  bool contains(int rid) => _map.containsKey(rid);

  void dispose() {
    _map.clear();
    _partialResultsController.close();
  }
}
