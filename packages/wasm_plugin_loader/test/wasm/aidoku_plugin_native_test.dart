// test/wasm/aidoku_plugin_native_test.dart
//
// Integration tests for AidokuPlugin method calls.
// Requires wasmer + the real .aix fixture — same prerequisites as
// wasm_runner_native_test.dart.
//
// With the WASM isolate + semaphore architecture, HTTP now works on native.
// However in CI environments without network access the source returns empty
// results. Tests are written to pass either way (real data OR empty results).
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
        test('returns a MangaPageResult without throwing', () async {
          final result = await plugin.searchManga('', 1);
          check(result).isA<MangaPageResult>();
        });

        test('manga field is a List<Manga>', () async {
          final result = await plugin.searchManga('', 1);
          check(result.manga).isA<List<Manga>>();
        });

        test('hasNextPage is bool', () async {
          final result = await plugin.searchManga('', 1);
          check(result.hasNextPage).isA<bool>();
        });
      });

      group('getMangaDetails', () {
        test('returns Manga? without throwing', () async {
          final result = await plugin.getMangaDetails('some-manga-key');
          check(result).isA<Manga?>();
        });
      });

      group('getPageList', () {
        test('returns a List<Page> without throwing', () async {
          final result = await plugin.getPageList('some-chapter-key');
          check(result).isA<List<Page>>();
        });

        test('each page has a non-negative index', () async {
          final pages = await plugin.getPageList('some-chapter-key');
          for (final page in pages) {
            check(page.index).isGreaterThan(-1);
          }
        });
      });

      group('getMangaList', () {
        test('returns a MangaPageResult without throwing', () async {
          final result = await plugin.getMangaList(1, listingIndex: 1);
          check(result).isA<MangaPageResult>();
          check(result.manga).isNotEmpty();
        });
      });
    },
  );
}
