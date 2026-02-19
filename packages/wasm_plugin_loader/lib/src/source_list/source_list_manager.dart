import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:wasm_plugin_loader/src/source_list/source_entry.dart';
import 'package:wasm_plugin_loader/src/source_list/source_list.dart';

/// Official Aidoku Community source list URL.
const kAidokuCommunitySourceListUrl =
    'https://raw.githubusercontent.com/Aidoku-Community/sources/refs/heads/gh-pages/index.json';

const _kTimeout = Duration(seconds: 15);

class SourceListManager {
  SourceListManager({
    List<String> initialUrls = const [],
    http.Client? httpClient,
  }) : _urls = List.of(initialUrls),
       _client = httpClient ?? http.Client();

  final List<String> _urls;
  final http.Client _client;

  List<String> get sourceListUrls => List.unmodifiable(_urls);

  /// Adds [url] to the list. No-op if already present.
  void addSourceList(String url) {
    if (!_urls.contains(url)) _urls.add(url);
  }

  /// Removes [url] from the list. No-op if not present.
  void removeSourceList(String url) => _urls.remove(url);

  /// Fetches and parses a single source list from [url].
  /// Returns `null` on any network or parse error.
  Future<RemoteSourceList?> fetchSourceList(String url) async {
    try {
      final uri = Uri.parse(url);
      final response = await _client.get(uri).timeout(_kTimeout);
      if (response.statusCode != 200) return null;

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final name = json['name'] as String? ?? '';
      final rawSources = json['sources'] as List? ?? const [];
      final sources = rawSources.cast<Map<String, dynamic>>().map(SourceEntry.fromJson).toList();

      return RemoteSourceList(url: url, name: name, sources: sources);
    } on Object {
      return null;
    }
  }

  /// Fetches all configured source lists concurrently.
  /// Failed lists are silently dropped.
  Future<List<RemoteSourceList>> fetchAllSourceLists() async {
    final results = await Future.wait(_urls.map(fetchSourceList));
    return results.whereType<RemoteSourceList>().toList();
  }
}
