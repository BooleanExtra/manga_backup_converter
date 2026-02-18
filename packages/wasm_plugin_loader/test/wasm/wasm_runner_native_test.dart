// test/wasm/wasm_runner_native_test.dart
//
// Manual integration test — requires:
//   1. wasmer installed
//         Windows: iwr https://win.wasmer.io -useb | iex
//         Linux: curl https://get.wasmer.io -sSfL | sh
//   2. A .aix file at test/aidoku/fixtures/test.aix
//      (download from https://github.com/Aidoku-Community/sources/tree/gh-pages)
//
// Run: dart test packages/wasm_plugin_loader/test/wasm/wasm_runner_native_test.dart -v
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
    'WasmRunner native integration',
    () {
      test('loads .aix and returns source info', () async {
        final aixBytes = fixture.readAsBytesSync();
        final loader = WasmPluginLoader();
        final plugin = await loader.load(aixBytes);
        expect(plugin.sourceInfo.id, 'multi.mangadex');
        expect(plugin.sourceInfo.name, 'MangaDex');
        expect(plugin.sourceInfo.language, 'en');
        expect(plugin.sourceInfo.url, 'https://mangadex.org');
        // ignore: avoid_print
        print('Loaded: ${plugin.sourceInfo.id} (${plugin.sourceInfo.name})');
      });
    },
    skip: !fixture.existsSync()
        ? 'Missing test/aidoku/fixtures/multi.mangadex-v12.aix'
        : !_hasWasmer()
        ? 'wasmer not installed — run: curl https://get.wasmer.io -sSfL | sh'
        : null,
  );
}
