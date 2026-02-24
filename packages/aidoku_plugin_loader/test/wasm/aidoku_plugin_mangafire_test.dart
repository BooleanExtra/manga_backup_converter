// test/wasm/aidoku_plugin_mangafire_test.dart
//
// Integration tests for AidokuPlugin with the mangafire HTML-scraping plugin.
// Requires the real .aix fixture. Wasmer is bundled via code assets.
//
// Tests make live network requests to mangafire and assert on real data.
//
// Run: dart test packages/aidoku_plugin_loader/test/wasm/aidoku_plugin_mangafire_test.dart --reporter expanded
import 'dart:io';
import 'dart:typed_data';

import 'package:aidoku_plugin_loader/aidoku_plugin_loader.dart';
import 'package:checks/checks.dart';
import 'package:test/scaffolding.dart';

void main() {
  const fixturePath = 'test/aidoku/fixtures/multi.mangafire-v5.aix';
  final fixture = File(fixturePath).existsSync()
      ? File(fixturePath)
      : File('packages/aidoku_plugin_loader/$fixturePath');

  group(
    'AidokuPlugin mangafire',
    skip: !fixture.existsSync() ? 'Missing test/aidoku/fixtures/multi.mangafire-v5.aix' : null,
    () {
      late AidokuPlugin plugin;

      setUpAll(() async {
        plugin = await AidokuPlugin.fromAix(
          Uint8List.fromList(fixture.readAsBytesSync()),
        );
      });

      tearDownAll(() => plugin.dispose());

      tearDown(() {
        final List<String> warnings = plugin.drainWarnings();
        check(because: '[CB] Plugin produced unexpected warnings:\n${warnings.join('\n')}', warnings).isEmpty();
      });

      group('searchManga', () {
        test('empty query returns non-empty results', () async {
          final MangaPageResult result = await plugin.searchManga('', 1);
          // ignore: avoid_print
          print(
            'mangafire search results: ${result.manga.length} manga, '
            'hasNextPage=${result.hasNextPage}',
          );
          for (final Manga m in result.manga.take(5)) {
            // ignore: avoid_print
            print('  key=${m.key}  title=${m.title}');
          }
          check(result.manga).isNotEmpty();
        });

        test('each result has non-empty key and title', () async {
          final MangaPageResult result = await plugin.searchManga('', 1);
          for (final Manga m in result.manga) {
            check(m.key).isNotEmpty();
            check(m.title).isNotEmpty();
          }
        });
      });

      group('getMangaDetails', () {
        late String mangaKey;

        setUpAll(() async {
          final MangaPageResult result = await plugin.searchManga('Onimai', 1);
          mangaKey = result.manga.first.key;
        });

        test('returns populated Manga', () async {
          final Manga? manga = await plugin.getMangaDetails(mangaKey);
          check(manga).isNotNull();
          check(manga!.title).isNotEmpty();
          // ignore: avoid_print
          print('mangafire details: key=${manga.key} title=${manga.title}');
        });

        test('includeChapters returns non-empty chapters', () async {
          final Manga? manga = await plugin.getMangaDetails(
            mangaKey,
            includeChapters: true,
          );
          check(manga).isNotNull();
          check(manga!.chapters).isNotEmpty();
          // ignore: avoid_print
          print('mangafire chapters: ${manga.chapters.length}');
        });
      });
    },
  );
}
