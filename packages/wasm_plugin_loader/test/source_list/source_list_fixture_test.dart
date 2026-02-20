@TestOn('vm')
library;

import 'dart:convert';
import 'dart:io';
import 'package:checks/checks.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';
import 'package:wasm_plugin_loader/src/source_list/source_list_manager.dart';

void main() {
  late String fixtureJson;

  setUpAll(() {
    const fixturePath = 'test/aidoku/fixtures/index.json';
    final file = File(fixturePath).existsSync() ? File(fixturePath) : File('packages/wasm_plugin_loader/$fixturePath');
    fixtureJson = file.readAsStringSync();
  });

  group('SourceEntry — real index.json fixture', () {
    late SourceListManager mgr;

    setUp(() {
      mgr = SourceListManager(
        httpClient: MockClient(
          (_) async => http.Response.bytes(
            utf8.encode(fixtureJson),
            200,
            headers: {'content-type': 'application/json; charset=utf-8'},
          ),
        ),
      );
    });

    test('parses list name', () async {
      final list = await mgr.fetchSourceList('https://example.com');
      check(list!.name).equals('Aidoku Community Sources');
    });

    test('parses all 96 sources', () async {
      final list = await mgr.fetchSourceList('https://example.com');
      check(list!.sources).length.equals(96);
    });

    test('multi.mangadex entry is fully parsed', () async {
      final list = await mgr.fetchSourceList('https://example.com');
      final mdx = list!.sources.firstWhere((s) => s.id == 'multi.mangadex');
      check(mdx.name).equals('MangaDex');
      check(mdx.version).equals(12);
      check(mdx.iconUrl).equals('icons/multi.mangadex-v12.png');
      check(mdx.downloadUrl).equals('sources/multi.mangadex-v12.aix');
      check(mdx.contentRating).equals(1);
      check(mdx.baseUrl).equals('https://mangadex.org');
      check(mdx.languages).contains('en');
      check(mdx.languages).contains('ja');
      check(mdx.languages).length.isGreaterThan(10);
    });

    test('altNames parsed — ja.comicdays', () async {
      final list = await mgr.fetchSourceList('https://example.com');
      final e = list!.sources.firstWhere((s) => s.id == 'ja.comicdays');
      check(e.altNames).deepEquals(['Comic Days']);
    });

    test('altNames parsed — ja.shonenjumpplus', () async {
      final list = await mgr.fetchSourceList('https://example.com');
      final e = list!.sources.firstWhere((s) => s.id == 'ja.shonenjumpplus');
      check(e.altNames).deepEquals(['Shonen Jump+']);
    });

    test('sources with no altNames have empty list', () async {
      final list = await mgr.fetchSourceList('https://example.com');
      final e = list!.sources.firstWhere((s) => s.id == 'en.asurascans');
      check(e.altNames).isEmpty();
    });

    test('url field set to fetch URL, not fixture path', () async {
      final list = await mgr.fetchSourceList('https://example.com/index.json');
      check(list!.url).equals('https://example.com/index.json');
    });
  });
}
