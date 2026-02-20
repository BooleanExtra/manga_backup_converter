import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:wasm_plugin_loader/src/source_list/source_entry.dart';
import 'package:wasm_plugin_loader/src/source_list/source_list.dart';

/// Official Aidoku Community source list URL.
const String kAidokuCommunitySourceListUrl =
    'https://raw.githubusercontent.com/Aidoku-Community/sources/refs/heads/gh-pages/index.json';

const Duration _kTimeout = Duration(seconds: 15);

class SourceListManager {
  SourceListManager({
    List<String> initialUrls = const <String>[],
    http.Client? httpClient,
  }) : _urls = List<String>.of(initialUrls),
       _client = httpClient ?? http.Client();

  final List<String> _urls;
  final http.Client _client;

  List<String> get sourceListUrls => List<String>.unmodifiable(_urls);

  /// Adds [url] to the list. No-op if already present.
  void addSourceList(String url) {
    if (!_urls.contains(url)) _urls.add(url);
  }

  /// Removes [url] from the list. No-op if not present.
  void removeSourceList(String url) => _urls.remove(url);

  /// Fetches and parses a single source list from [url].
  ///
  /// Throws on network or parse errors. Returns a non-200 status as a
  /// [SourceListFetchException].
  Future<RemoteSourceList> fetchRemoteSourceList(String url) async {
    final Uri uri = Uri.parse(url);
    final http.Response response = await _client.get(uri).timeout(_kTimeout);
    if (response.statusCode != 200) {
      throw SourceListFetchException(url: url, statusCode: response.statusCode);
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final String name = json['name'] as String? ?? '';
    final List<dynamic> rawSources = json['sources'] as List<dynamic>? ?? const <dynamic>[];
    final List<SourceEntry> sources = rawSources.map((e) => SourceEntry.fromJson(e as Map<String, dynamic>)).toList();

    return RemoteSourceList(url: url, name: name, sources: sources);
  }

  /// Fetches all configured source lists concurrently.
  ///
  /// Returns a [SourceListFetchResult] with both successful lists and
  /// per-URL failures.
  Future<SourceListFetchResult> fetchAllSourceLists() async {
    final lists = <RemoteSourceList>[];
    final failures = <SourceListFetchFailure>[];

    final List<RemoteSourceList?> results = await Future.wait(
      _urls.map((url) async {
        try {
          return await fetchRemoteSourceList(url);
        } on Object catch (e) {
          failures.add(SourceListFetchFailure(url: url, error: e));
          return null;
        }
      }),
    );

    lists.addAll(results.whereType<RemoteSourceList>());
    return SourceListFetchResult(lists: lists, failures: failures);
  }
}

/// Result of [SourceListManager.fetchAllSourceLists], containing both
/// successful fetches and per-URL failures.
class SourceListFetchResult {
  const SourceListFetchResult({required this.lists, required this.failures});

  final List<RemoteSourceList> lists;
  final List<SourceListFetchFailure> failures;
}

/// A single URL that failed during [SourceListManager.fetchAllSourceLists].
class SourceListFetchFailure {
  const SourceListFetchFailure({required this.url, required this.error});

  final String url;
  final Object error;

  @override
  String toString() => 'SourceListFetchFailure(url: $url, error: $error)';
}

/// Thrown by [SourceListManager.fetchRemoteSourceList] when the server
/// returns a non-200 status code.
class SourceListFetchException implements Exception {
  const SourceListFetchException({required this.url, required this.statusCode});

  final String url;
  final int statusCode;

  @override
  String toString() => 'SourceListFetchException: HTTP $statusCode for $url';
}
