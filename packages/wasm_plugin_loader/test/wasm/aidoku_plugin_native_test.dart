// test/wasm/aidoku_plugin_native_test.dart
//
// Integration tests for AidokuPlugin method calls (searchManga, getMangaDetails).
// Requires wasmer + the real .aix fixture — same prerequisites as
// wasm_runner_native_test.dart.
//
// On native, HTTP host imports are async-stubbed (futures are not awaited inside
// synchronous wasmer callbacks), so all network calls silently return no data.
// The WASM source will return ptr=0, which maps to empty / null results.
// These tests verify the call path (encoding, WASM dispatch, decoding) doesn't
// throw even with stubbed HTTP.
//
// Run: dart test packages/wasm_plugin_loader/test/wasm/aidoku_plugin_native_test.dart -v
import 'dart:io';

import 'package:test/test.dart';
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
  final fixture = File('test/aidoku/fixtures/multi.mangadex-v12.aix');

  group(
    'AidokuPlugin method calls',
    () {
      late AidokuPlugin plugin;

      setUpAll(() async {
        final loader = WasmPluginLoader();
        plugin = await loader.load(fixture.readAsBytesSync());
      });

      group('searchManga', () {
        test('returns a MangaPageResult without throwing', () async {
          final result = await plugin.searchManga('', 1);
          expect(result, isA<MangaPageResult>());
        });

        test('manga field is a List<Manga>', () async {
          final result = await plugin.searchManga('', 1);
          expect(result.manga, isA<List<Manga>>());
        });

        test('hasNextPage is false when HTTP is stubbed', () async {
          final result = await plugin.searchManga('', 1);
          expect(result.hasNextPage, isFalse);
        });

        test('manga list is empty when HTTP is stubbed', () async {
          final result = await plugin.searchManga('', 1);
          expect(result.manga, isEmpty);
        });
      });

      group('getMangaDetails', () {
        test('returns null or Manga without throwing', () async {
          final result = await plugin.getMangaDetails('some-manga-key');
          expect(result, anyOf(isNull, isA<Manga>()));
        });

        test('returns null when HTTP is stubbed', () async {
          final result = await plugin.getMangaDetails('some-manga-key');
          expect(result, isNull);
        });
      });
    },
    skip: !fixture.existsSync()
        ? 'Missing test/aidoku/fixtures/multi.mangadex-v12.aix'
        : !_hasWasmer()
        ? 'wasmer not installed — run: curl https://get.wasmer.io -sSfL | sh'
        : null,
  );
}
