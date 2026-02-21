// test/wasm/wasm_runner_native_test.dart
//
// Manual integration test — requires:
//   1. wasmer installed
//         Windows: iwr https://win.wasmer.io -useb | iex
//         Linux: curl https://get.wasmer.io -sSfL | sh
//   2. A .aix file at test/aidoku/fixtures/test.aix
//      (download from https://github.com/Aidoku-Community/sources/tree/gh-pages)
//
// Run: dart test packages/aidoku_plugin_loader/test/wasm/wasm_runner_native_test.dart -v
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

  group(
    'WasmRunner native integration',
    skip: !fixture.existsSync()
        ? 'Missing test/aidoku/fixtures/multi.mangadex-v12.aix'
        : !_hasWasmer()
        ? 'wasmer not installed — run: curl https://get.wasmer.io -sSfL | sh'
        : null,
    () {
      test('loads .aix and returns source info', () async {
        final Uint8List aixBytes = fixture.readAsBytesSync();
        final loader = AidokuPluginMemoryStore();
        final AidokuPlugin plugin = await loader.loadAixBytes(aixBytes);
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
