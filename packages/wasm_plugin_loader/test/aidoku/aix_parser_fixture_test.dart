// test/aidoku/aix_parser_fixture_test.dart
//
// Parses the real .aix fixture with AixParser directly — no WASM required.
// Verifies every field of AixBundle against known expected values.
//
// Run: dart test packages/wasm_plugin_loader/test/aidoku/aix_parser_fixture_test.dart -v
import 'dart:io';

import 'package:test/test.dart';
import 'package:wasm_plugin_loader/src/aidoku/aix_parser.dart';

void main() {
  final fixture = File('test/aidoku/fixtures/multi.mangadex-v12.aix');

  group(
    'AixParser with real .aix fixture',
    skip: fixture.existsSync() ? null : 'Missing test/aidoku/fixtures/multi.mangadex-v12.aix',
    () {
      late AixBundle bundle;

      setUpAll(() {
        bundle = AixParser.parse(fixture.readAsBytesSync());
      });

      group('sourceInfo fields', () {
        test('id is multi.mangadex', () {
          expect(bundle.sourceInfo.id, 'multi.mangadex');
        });

        test('name is MangaDex', () {
          expect(bundle.sourceInfo.name, 'MangaDex');
        });

        test('language is en', () {
          expect(bundle.sourceInfo.language, 'en');
        });

        test('url is https://mangadex.org', () {
          expect(bundle.sourceInfo.url, 'https://mangadex.org');
        });
      });

      group('wasmBytes', () {
        test('wasmBytes is non-empty', () {
          expect(bundle.wasmBytes, isNotEmpty);
        });

        test('wasmBytes starts with WASM magic header 00 61 73 6D', () {
          expect(bundle.wasmBytes[0], 0x00);
          expect(bundle.wasmBytes[1], 0x61);
          expect(bundle.wasmBytes[2], 0x73);
          expect(bundle.wasmBytes[3], 0x6D);
        });
      });

      group('filtersJson', () {
        test('filtersJson is non-null', () {
          expect(bundle.filtersJson, isNotNull);
        });

        test('filtersJson is non-empty', () {
          expect(bundle.filtersJson, isNotEmpty);
        });

        test('each filtersJson entry has a String type field', () {
          for (final entry in bundle.filtersJson!) {
            final map = entry as Map<String, dynamic>;
            expect(map['type'], isA<String>());
          }
        });
      });

      group('settingsJson', () {
        test('settingsJson is non-null', () {
          expect(bundle.settingsJson, isNotNull);
        });

        test('settingsJson is non-empty', () {
          expect(bundle.settingsJson, isNotEmpty);
        });

        test('each settingsJson entry has a String type field', () {
          for (final entry in bundle.settingsJson!) {
            final map = entry as Map<String, dynamic>;
            expect(map['type'], isA<String>());
          }
        });
      });
    },
  );
}
