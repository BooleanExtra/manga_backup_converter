// test/aidoku/aix_parser_fixture_test.dart
//
// Parses the real .aix fixture with AixParser directly — no WASM required.
// Verifies every field of AixBundle against known expected values.
//
// Run: dart test packages/wasm_plugin_loader/test/aidoku/aix_parser_fixture_test.dart -v
import 'dart:io';

import 'package:test/test.dart';
import 'package:wasm_plugin_loader/src/aidoku/aix_parser.dart';
import 'package:wasm_plugin_loader/src/models/filter_info.dart';
import 'package:wasm_plugin_loader/src/models/setting_item.dart';

void main() {
  const fixturePath = 'test/aidoku/fixtures/multi.mangadex-v12.aix';
  final fixture = File(fixturePath).existsSync() ? File(fixturePath) : File('packages/wasm_plugin_loader/$fixturePath');

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

      group('filters', () {
        test('filters is non-null', () {
          expect(bundle.filters, isNotNull);
        });

        test('filters is non-empty', () {
          expect(bundle.filters, isNotEmpty);
        });

        test('each filter is a FilterInfo with a non-empty type', () {
          for (final fi in bundle.filters!) {
            expect(fi, isA<FilterInfo>());
            expect(fi.type, isA<String>());
            expect(fi.type, isNotEmpty);
          }
        });
      });

      group('settings', () {
        test('settings is non-null', () {
          expect(bundle.settings, isNotNull);
        });

        test('settings is non-empty', () {
          expect(bundle.settings, isNotEmpty);
        });

        test('each setting is a SettingItem subtype', () {
          for (final s in bundle.settings!) {
            expect(s, isA<SettingItem>());
          }
        });
      });
    },
  );
}
