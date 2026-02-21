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
// Run: dart test packages/aidoku_plugin_loader/test/wasm/aidoku_plugin_native_test.dart --reporter expanded
import 'dart:io';
import 'dart:typed_data';

import 'package:aidoku_plugin_loader/aidoku_plugin_loader.dart';
import 'package:checks/checks.dart';
import 'package:test/scaffolding.dart';

bool _hasWasmer() {
  final String home = Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'] ?? '';
  final lib = Platform.isWindows
      ? '$home\\.wasmer\\lib\\wasmer.dll'
      : Platform.isMacOS
      ? '$home/.wasmer/lib/libwasmer.dylib'
      : '$home/.wasmer/lib/libwasmer.so';
  return File(lib).existsSync();
}

void main() {
  const fixturePath = 'test/aidoku/fixtures/multi.mangadex-v12.aix';
  final fixture = File(fixturePath).existsSync() ? File(fixturePath) : File('packages/aidoku_plugin_loader/$fixturePath');

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
        final loader = AidokuPluginMemoryStore();
        // MangaDex's is_logged_in() calls defaults_get_json::<TokenResponse>("login").
        // The SDK reads stored bytes as postcard<String> (the JSON text), then
        // serde_json::from_str::<TokenResponse>. TokenResponse has Option<String> fields,
        // so any valid JSON object works — even {} deserializes to Ok(TokenResponse{..}).
        // Postcard-encode the JSON string "{}": varint(2) + '{' + '}'
        const loginJson = '{}';
        final List<int> jsonBytes = loginJson.codeUnits;
        final loginPostcard = Uint8List(1 + jsonBytes.length)
          ..[0] = jsonBytes.length
          ..setAll(1, jsonBytes);
        plugin = await loader.loadAixBytes(
          fixture.readAsBytesSync(),
          defaults: <String, dynamic>{'login': loginPostcard},
        );
      });

      tearDownAll(() => plugin.dispose());

      group('searchManga', () {
        test('empty query returns non-empty results', () async {
          final MangaPageResult result = await plugin.searchManga('', 1);
          check(result.manga).isNotEmpty();
          check(result.hasNextPage).isA<bool>();
        });

        test('searching "Onimai" returns the expected manga', () async {
          final MangaPageResult result = await plugin.searchManga('Onimai', 1);
          check(result.manga).isNotEmpty();
          check(result.manga.map((Manga m) => m.key)).contains(mangaId);
        });

        test('each result has non-empty key and title', () async {
          final MangaPageResult result = await plugin.searchManga('Onimai', 1);
          for (final Manga m in result.manga) {
            check(m.key).isNotEmpty();
            check(m.title).isNotEmpty();
          }
        });
      });

      group('getMangaDetails', () {
        test('returns populated Manga for known ID', () async {
          final Manga? manga = await plugin.getMangaDetails(mangaId);
          if (manga == null) {
            throw Exception('manga is null');
          }
          check(manga).isNotNull();
          check(manga.key).equals(mangaId);
        });

        test('title is non-empty', () async {
          final Manga? manga = await plugin.getMangaDetails(mangaId);
          if (manga == null) {
            throw Exception('manga is null');
          }
          check(manga.title).isNotEmpty();
        });

        test('description is non-empty', () async {
          final Manga? manga = await plugin.getMangaDetails(mangaId);
          if (manga == null) {
            throw Exception('manga is null');
          }
          check(manga.description).isNotNull();
          check(manga.description!).isNotEmpty();
        });

        test('contentRating is suggestive', () async {
          final Manga? manga = await plugin.getMangaDetails(mangaId);
          if (manga == null) {
            throw Exception('manga is null');
          }
          check(manga.contentRating).equals(ContentRating.suggestive);
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
          final List<Page> pages = await plugin.getPageList(manga, chapter);
          check(pages).length.equals(14);
        });

        test('pages are indexed sequentially from 0', () async {
          final List<Page> pages = await plugin.getPageList(manga, chapter);
          check(pages).isNotEmpty();
          for (var i = 0; i < pages.length; i++) {
            check(pages[i].index).equals(i);
          }
        });

        test('each page has a non-empty URL', () async {
          final List<Page> pages = await plugin.getPageList(manga, chapter);
          check(pages).isNotEmpty();
          for (final page in pages) {
            check(page.url).isNotNull();
            check(page.url!).isNotEmpty();
          }
        });
      });

      group('getMangaList', () {
        test('returns a MangaPageResult without throwing', () async {
          final SourceListing listing = plugin.sourceInfo.listings[1];
          final MangaPageResult result = await plugin.getMangaList(1, listing: listing);
          check(result).isA<MangaPageResult>();
          check(result.manga).isNotEmpty();
        });

        test('each result has non-empty key and title', () async {
          final SourceListing listing = plugin.sourceInfo.listings[1];
          final MangaPageResult result = await plugin.getMangaList(1, listing: listing);
          for (final Manga m in result.manga) {
            check(m.key).isNotEmpty();
            check(m.title).isNotEmpty();
          }
        });
      });

      group('getListings', () {
        test('returns a list (may be empty if plugin does not implement it)', () async {
          final List<AidokuListing> listings = await plugin.getListings();
          check(listings).isA<List<AidokuListing>>();
          // get_dynamic_listings returns ["Library"] when is_logged_in() is true.
          check(listings).isNotEmpty();
        });

        test('each listing has non-empty id and name', () async {
          final List<AidokuListing> listings = await plugin.getListings();
          for (final l in listings) {
            check(l.id).isNotEmpty();
            check(l.name).isNotEmpty();
          }
        });
      });

      group('getHome', () {
        test(
          'returns HomeLayout or null (null is acceptable if plugin does not implement it)',
          () async {
            final HomeLayout? home = await plugin.getHome();
            // Acceptable: null (not implemented) or a valid HomeLayout.
            if (home != null) {
              check(home.components).isA<List<HomeComponent>>();
            }
          },
        );
      });
    },
  );
}
