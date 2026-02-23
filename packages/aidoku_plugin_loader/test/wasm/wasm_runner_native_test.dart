// test/wasm/wasm_runner_native_test.dart
//
// Manual integration test — requires a .aix fixture file.
// Wasmer is bundled via code assets (hook/build.dart).
//
// Run: dart test packages/aidoku_plugin_loader/test/wasm/wasm_runner_native_test.dart --reporter expanded
import 'dart:io';
import 'dart:typed_data';

import 'package:aidoku_plugin_loader/aidoku_plugin_loader.dart';
import 'package:checks/checks.dart';
import 'package:test/scaffolding.dart';

void main() {
  const fixturePath = 'test/aidoku/fixtures/multi.mangadex-v12.aix';
  final fixture = File(fixturePath).existsSync()
      ? File(fixturePath)
      : File('packages/aidoku_plugin_loader/$fixturePath');

  group(
    'WasmRunner native integration',
    skip: !fixture.existsSync() ? 'Missing test/aidoku/fixtures/multi.mangadex-v12.aix' : null,
    () {
      test('loads .aix and returns source info', () async {
        final Uint8List aixBytes = fixture.readAsBytesSync();
        final AidokuPlugin plugin = await AidokuPlugin.fromAix(aixBytes);
        check(plugin.sourceInfo.id).equals('multi.mangadex');
        check(plugin.sourceInfo.name).equals('MangaDex');
        check(plugin.sourceInfo.languages).contains('en');
        check(plugin.sourceInfo.url).equals('https://mangadex.org');
        // ignore: avoid_print
        print('Loaded: ${plugin.sourceInfo.id} (${plugin.sourceInfo.name})');
      });
    },
  );
}
