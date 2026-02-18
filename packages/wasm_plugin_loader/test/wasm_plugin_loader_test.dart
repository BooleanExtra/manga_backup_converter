import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:test/test.dart';
import 'package:wasm_plugin_loader/wasm_plugin_loader.dart';

/// Tests that invoke [WasmPluginLoader.load] require actual WASM instantiation,
/// which is only supported on web. Skip them on native platforms.
const _wasmSkip = 'Requires web platform (dart:js_interop + browser WebAssembly API).';

Uint8List _buildFakeAix(String id) {
  final archive = Archive();
  final meta = utf8.encode(jsonEncode({
    'id': id,
    'name': 'Test $id',
    'version': 1,
    'language': 'en',
    'url': 'https://example.com',
  }));
  archive.addFile(ArchiveFile('res/source.json', meta.length, meta));
  final wasm = Uint8List.fromList([0x00, 0x61, 0x73, 0x6D, 0x01, 0x00, 0x00, 0x00]);
  archive.addFile(ArchiveFile('$id.wasm', wasm.length, wasm));
  return Uint8List.fromList(ZipEncoder().encode(archive));
}

void main() {
  group('WasmPluginLoader', () {
    test('starts empty', () {
      final loader = WasmPluginLoader();
      expect(loader.loadedSources, isEmpty);
      expect(loader.findBySourceId('multi.mangadex'), isNull);
    });

    test('findBySourceId returns null for unknown id', () {
      final loader = WasmPluginLoader();
      expect(loader.findBySourceId('unknown.source'), isNull);
    });

    test('load() registers plugin by source id', () async {
      final loader = WasmPluginLoader();
      final plugin = await loader.load(_buildFakeAix('en.testsource'));
      expect(plugin.sourceInfo.id, 'en.testsource');
      expect(loader.loadedSources, hasLength(1));
      expect(loader.findBySourceId('en.testsource'), same(plugin));
    }, skip: _wasmSkip);

    test('load() can register multiple plugins', () async {
      final loader = WasmPluginLoader();
      await loader.load(_buildFakeAix('en.source1'));
      await loader.load(_buildFakeAix('en.source2'));
      expect(loader.loadedSources, hasLength(2));
    }, skip: _wasmSkip);

    test('load() replaces plugin with same id', () async {
      final loader = WasmPluginLoader();
      await loader.load(_buildFakeAix('en.source'));
      final second = await loader.load(_buildFakeAix('en.source'));
      expect(loader.loadedSources, hasLength(1));
      expect(loader.findBySourceId('en.source'), same(second));
    }, skip: _wasmSkip);

    test('unload() removes plugin', () async {
      final loader = WasmPluginLoader();
      await loader.load(_buildFakeAix('en.source'));
      loader.unload('en.source');
      expect(loader.loadedSources, isEmpty);
    }, skip: _wasmSkip);
  });
}
