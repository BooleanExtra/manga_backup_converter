// test/wasm/aidoku_plugin_native_test.dart
//
// Integration tests for AidokuPlugin method calls.
// Requires wasmer + the real .aix fixture — same prerequisites as
// wasm_runner_native_test.dart.
//
// Tests make live network requests to MangaDex and assert on real data.
// Verified live data (2026-02-19):
//   Manga  : ed996855-70de-449f-bba2-e8e24224c14d — "Onii-chan wa Oshimai!" (safe)
//   Chapter: 6eb2f8ea-3b6c-4bce-a0d0-d9224fad5b64 — Ch. 108 "Mahiro and Bodyguards" (14 pages)
//
// Run: dart test packages/wasm_plugin_loader/test/wasm/aidoku_plugin_native_test.dart --reporter expanded
import 'dart:io';

import 'package:checks/checks.dart';
import 'package:test/scaffolding.dart';
import 'package:wasm_plugin_loader/wasm_plugin_loader.dart';

bool _hasWasmer() {
  final home = Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'] ?? '';
  final lib = Platform.isWindows
      ? '$home\\.wasmer\\lib\\wasmer.dll'
      : Platform.isMacOS
      ? '$home/.wasmer/lib/libwasmer.dylib'
      : '$home/.wasmer/lib/libwasmer.so';
  return File(lib).existsSync();
}

void main() {
  const fixturePath = 'test/aidoku/fixtures/multi.mangadex-v12.aix';
  final fixture = File(fixturePath).existsSync() ? File(fixturePath) : File('packages/wasm_plugin_loader/$fixturePath');

  const mangaId = 'ed996855-70de-449f-bba2-e8e24224c14d'; // Onii-chan wa Oshimai!
  const chapterId = '6eb2f8ea-3b6c-4bce-a0d0-d9224fad5b64'; // Ch. 108 — 14 pages

  group(
    'AidokuPlugin method calls',
    skip: !fixture.existsSync()
        ? 'Missing test/aidoku/fixtures/multi.mangadex-v12.aix'
        : !_hasWasmer()
        ? 'wasmer not installed — run: curl https://get.wasmer.io -sSfL | sh'
        : null,
    () {
      late AidokuPlugin plugin;

      setUpAll(() async {
        final loader = WasmPluginLoader();
        plugin = await loader.load(fixture.readAsBytesSync());
      });

      tearDownAll(() => plugin.dispose());

      group('searchManga', () {
        test('empty query returns non-empty results', () async {
          final result = await plugin.searchManga('', 1);
          check(result.manga).isNotEmpty();
          check(result.hasNextPage).isA<bool>();
        });

        test('searching "Onimai" returns the expected manga', () async {
          final result = await plugin.searchManga('Onimai', 1);
          check(result.manga).isNotEmpty();
          check(result.manga.map((m) => m.key)).contains(mangaId);
        });

        test('each result has non-empty key and title', () async {
          final result = await plugin.searchManga('Onimai', 1);
          for (final m in result.manga) {
            check(m.key).isNotEmpty();
            check(m.title).isNotEmpty();
          }
        });
      });

      group('getMangaDetails', () {
        test('returns populated Manga for known ID', () async {
          final manga = await plugin.getMangaDetails(mangaId);
          check(manga).isNotNull();
          check(manga!.key).equals(mangaId);
        });

        test('title is non-empty', () async {
          final manga = await plugin.getMangaDetails(mangaId);
          check(manga!.title).isNotEmpty();
        });

        test('description is non-empty', () async {
          final manga = await plugin.getMangaDetails(mangaId);
          check(manga!.description).isNotNull();
          check(manga.description!).isNotEmpty();
        });

        test('contentRating is suggestive', () async {
          final manga = await plugin.getMangaDetails(mangaId);
          check(manga!.contentRating).equals(ContentRating.suggestive);
        });
      });

      group('getPageList', () {
        late Manga manga;
        late Chapter chapter;

        setUpAll(() async {
          manga = (await plugin.getMangaDetails(mangaId))!;
          chapter = const Chapter(key: chapterId);
        });

        test('Ch. 108 returns exactly 14 pages', () async {
          final pages = await plugin.getPageList(manga, chapter);
          check(pages).length.equals(14);
        });

        test('pages are indexed sequentially from 0', () async {
          final pages = await plugin.getPageList(manga, chapter);
          check(pages).isNotEmpty();
          for (var i = 0; i < pages.length; i++) {
            check(pages[i].index).equals(i);
          }
        });

        test('each page has a non-empty URL', () async {
          final pages = await plugin.getPageList(manga, chapter);
          check(pages).isNotEmpty();
          for (final page in pages) {
            check(page.url).isNotNull();
            check(page.url!).isNotEmpty();
          }
        });
      });

      group('getMangaList', () {
        test('returns a MangaPageResult without throwing', () async {
          final listing = plugin.sourceInfo.listings[1];
          final result = await plugin.getMangaList(1, listing: listing);
          check(result).isA<MangaPageResult>();
          check(result.manga).isNotEmpty();
        });

        test('each result has non-empty key and title', () async {
          final listing = plugin.sourceInfo.listings[1];
          final result = await plugin.getMangaList(1, listing: listing);
          for (final m in result.manga) {
            check(m.key).isNotEmpty();
            check(m.title).isNotEmpty();
          }
        });
      });
    },
  );
}
