import 'dart:async';

import 'package:checks/checks.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/scaffolding.dart';
import 'package:wasm_plugin_loader/src/source_list/source_entry.dart';
import 'package:wasm_plugin_loader/src/source_list/source_list.dart';
import 'package:wasm_plugin_loader/src/source_list/source_list_manager.dart';

const String _kSampleJson = '''
{
  "name": "Test List",
  "sources": [
    {
      "id": "mangadex",
      "name": "MangaDex",
      "version": 12,
      "iconURL": "https://example.com/icon.png",
      "downloadURL": "https://example.com/mangadex.aix",
      "languages": ["en", "ja"],
      "contentRating": 1,
      "baseURL": "https://mangadex.org",
      "altNames": ["MD"]
    },
    {
      "id": "safe_source",
      "name": "Safe Source",
      "version": 3,
      "iconURL": "https://example.com/safe_icon.png",
      "downloadURL": "https://example.com/safe.aix",
      "languages": ["en"]
    }
  ]
}
''';

http.Client _mockClient(String body, {int statusCode = 200}) {
  return MockClient((_) async => http.Response(body, statusCode));
}

http.Client _timeoutClient() {
  return MockClient((_) => Completer<http.Response>().future); // never completes
}

void main() {
  group('SourceListManager — URL management', () {
    late SourceListManager mgr;

    setUp(() => mgr = SourceListManager());

    test('starts empty', () {
      check(mgr.sourceListUrls).isEmpty();
    });

    test('addSourceList appends URL', () {
      mgr.addSourceList('https://a.example.com');
      check(mgr.sourceListUrls).deepEquals(<Object?>['https://a.example.com']);
    });

    test('addSourceList is no-op for duplicate', () {
      mgr.addSourceList('https://a.example.com');
      mgr.addSourceList('https://a.example.com');
      check(mgr.sourceListUrls).length.equals(1);
    });

    test('removeSourceList removes existing URL', () {
      mgr.addSourceList('https://a.example.com');
      mgr.addSourceList('https://b.example.com');
      mgr.removeSourceList('https://a.example.com');
      check(mgr.sourceListUrls).deepEquals(<Object?>['https://b.example.com']);
    });

    test('removeSourceList is no-op for absent URL', () {
      mgr.addSourceList('https://a.example.com');
      mgr.removeSourceList('https://not-there.example.com');
      check(mgr.sourceListUrls).length.equals(1);
    });

    test('sourceListUrls is unmodifiable', () {
      mgr.addSourceList('https://a.example.com');
      check(() => mgr.sourceListUrls.add('x')).throws<UnsupportedError>();
    });

    test('initialUrls seeded via constructor', () {
      final m = SourceListManager(initialUrls: <String>['https://x.example.com']);
      check(m.sourceListUrls).deepEquals(<Object?>['https://x.example.com']);
    });
  });

  group('SourceListManager.fetchRemoteSourceList', () {
    test('success — parses list name and sources', () async {
      final mgr = SourceListManager(httpClient: _mockClient(_kSampleJson));
      final RemoteSourceList? list = await mgr.fetchRemoteSourceList('https://example.com/index.json');

      check(list).isNotNull();
      if (list == null) throw Exception('list is null');
      check(list.url).equals('https://example.com/index.json');
      check(list.name).equals('Test List');
      check(list.sources).length.equals(2);
    });

    test('success — first source fields parsed correctly', () async {
      final mgr = SourceListManager(httpClient: _mockClient(_kSampleJson));
      final RemoteSourceList? list = await mgr.fetchRemoteSourceList('https://example.com/index.json');

      if (list == null) throw Exception('list is null');
      final SourceEntry entry = list.sources[0];
      check(entry.id).equals('mangadex');
      check(entry.name).equals('MangaDex');
      check(entry.version).equals(12);
      check(entry.iconUrl).equals('https://example.com/icon.png');
      check(entry.downloadUrl).equals('https://example.com/mangadex.aix');
      check(entry.languages).deepEquals(<Object?>['en', 'ja']);
      check(entry.contentRating).equals(1);
      check(entry.baseUrl).equals('https://mangadex.org');
      check(entry.altNames).deepEquals(<Object?>['MD']);
    });

    test('success — optional fields default when absent', () async {
      final mgr = SourceListManager(httpClient: _mockClient(_kSampleJson));
      final RemoteSourceList? list = await mgr.fetchRemoteSourceList('https://example.com/index.json');

      if (list == null) throw Exception('list is null');
      final SourceEntry entry = list.sources[1]; // safe_source — no contentRating/baseURL/altNames
      check(entry.contentRating).equals(0);
      check(entry.baseUrl).isNull();
      check(entry.altNames).isEmpty();
    });

    test('HTTP error status returns null', () async {
      final mgr = SourceListManager(
        httpClient: _mockClient('Not Found', statusCode: 404),
      );
      final RemoteSourceList? list = await mgr.fetchRemoteSourceList('https://example.com/index.json');
      check(list).isNull();
    });

    test('malformed JSON returns null', () async {
      final mgr = SourceListManager(httpClient: _mockClient('{invalid'));
      final RemoteSourceList? list = await mgr.fetchRemoteSourceList('https://example.com/index.json');
      check(list).isNull();
    });

    test('timeout returns null', () async {
      final mgr = SourceListManager(httpClient: _timeoutClient());
      final RemoteSourceList? list = await mgr.fetchRemoteSourceList('https://example.com/index.json');
      check(list).isNull();
    }, timeout: const Timeout(Duration(seconds: 30)));
  });

  group('SourceListManager.fetchAllSourceLists', () {
    test('returns all successful lists', () async {
      final mgr = SourceListManager(
        initialUrls: <String>[
          'https://example.com/a.json',
          'https://example.com/b.json',
        ],
        httpClient: _mockClient(_kSampleJson),
      );
      final List<RemoteSourceList> lists = await mgr.fetchAllSourceLists();
      check(lists).length.equals(2);
    });

    test('drops failing lists, returns successful ones', () async {
      var callCount = 0;
      final client = MockClient((_) async {
        callCount++;
        if (callCount == 1) return http.Response('bad json{', 200);
        return http.Response(_kSampleJson, 200);
      });
      final mgr = SourceListManager(
        initialUrls: <String>[
          'https://example.com/bad.json',
          'https://example.com/good.json',
        ],
        httpClient: client,
      );
      final List<RemoteSourceList> lists = await mgr.fetchAllSourceLists();
      check(lists).length.equals(1);
      check(lists[0].name).equals('Test List');
    });

    test('returns empty list when no URLs configured', () async {
      final mgr = SourceListManager(httpClient: _mockClient(_kSampleJson));
      final List<RemoteSourceList> lists = await mgr.fetchAllSourceLists();
      check(lists).isEmpty();
    });

    test('returns empty list when all URLs fail', () async {
      final mgr = SourceListManager(
        initialUrls: <String>['https://example.com/a.json'],
        httpClient: _mockClient('', statusCode: 500),
      );
      final List<RemoteSourceList> lists = await mgr.fetchAllSourceLists();
      check(lists).isEmpty();
    });
  });
}
