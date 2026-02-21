import 'dart:async';
import 'dart:typed_data';

import 'package:image/image.dart' as img;

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
  final Map<String, String> headers = <String, String>{};
  Uint8List? body;
  double timeout = 30.0;
  // Populated after send()
  int? statusCode;
  Uint8List? responseBody;
  final Map<String, String> responseHeaders = <String, String>{};
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

class CanvasContextResource extends HostResource {
  CanvasContextResource(this.image);
  final img.Image image;
  // Pending affine transform state
  double tx = 0;
  double ty = 0;
  double sx = 1;
  double sy = 1;
  double angle = 0;
}

class ImageResource extends HostResource {
  ImageResource(this.image);
  final img.Image image;
}

class FontResource extends HostResource {
  FontResource({required this.name, required this.weight});
  final String name;
  final int weight; // FontWeight ordinal 0-8
}

/// Host-side resource registry mapping i32 Rids to resources.
/// WASM reads Dart resources by calling back into host imports.
class HostStore {
  HostStore();

  final Map<int, HostResource> _map = <int, HostResource>{};
  int _nextId = 1;

  /// Per-source preference values managed by `defaults::set` / `defaults::get`.
  /// Values are either [int] (numeric/bool prefs) or [Uint8List] (string/multi-select prefs).
  final Map<String, Object> defaults = <String, Object>{};

  /// Partial results pushed by `env::_send_partial_result`.
  late final StreamController<Uint8List> _partialResultsController = StreamController<Uint8List>.broadcast();

  Stream<Uint8List> get partialResults => _partialResultsController.stream;

  void addPartialResult(Uint8List data) {
    if (!_partialResultsController.isClosed) _partialResultsController.add(data);
  }

  /// Register a resource and return its Rid.
  int add(HostResource resource) {
    final int id = _nextId++;
    _map[id] = resource;
    return id;
  }

  /// Register raw bytes as a resource.
  int addBytes(Uint8List bytes) => add(BytesResource(bytes));

  /// Retrieve a resource by Rid, or null if not found.
  T? get<T extends HostResource>(int rid) {
    final HostResource? r = _map[rid];
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

/// Immutable rate-limit configuration received from a WASM plugin.
class RateLimitConfig {
  const RateLimitConfig({required this.permits, required this.periodMs});

  /// Create from the WASM `set_rate_limit(permits, period, unit)` arguments.
  /// Unit: 0=Seconds, 1=Minutes, 2=Hours.
  factory RateLimitConfig.fromWasm(int permits, int period, int unit) {
    final int ms = switch (unit) {
      1 => period * 60 * 1000,
      2 => period * 60 * 60 * 1000,
      _ => period * 1000, // 0 (seconds) or unknown
    };
    return RateLimitConfig(permits: permits, periodMs: ms);
  }

  final int permits;
  final int periodMs;
}

/// Sliding-window rate limiter that tracks request timestamps.
class RateLimiter {
  RateLimiter(this.config);

  final RateLimitConfig config;
  final List<int> _timestamps = <int>[];

  /// Returns [Duration.zero] if under limit, or the delay needed until the
  /// oldest request in the window expires.
  Duration waitDuration({int? nowMs}) {
    final int now = nowMs ?? DateTime.now().millisecondsSinceEpoch;
    _prune(now);
    if (_timestamps.length < config.permits) return Duration.zero;
    final int oldest = _timestamps.first;
    final int waitMs = oldest + config.periodMs - now;
    return waitMs > 0 ? Duration(milliseconds: waitMs) : Duration.zero;
  }

  /// Records a request timestamp and prunes expired entries.
  void recordRequest({int? nowMs}) {
    final int now = nowMs ?? DateTime.now().millisecondsSinceEpoch;
    _prune(now);
    _timestamps.add(now);
  }

  void _prune(int now) {
    final int cutoff = now - config.periodMs;
    _timestamps.removeWhere((int t) => t <= cutoff);
  }
}
