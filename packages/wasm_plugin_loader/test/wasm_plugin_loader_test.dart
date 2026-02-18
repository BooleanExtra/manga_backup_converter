import 'dart:convert';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:wasm_plugin_loader/wasm_plugin_loader.dart';
import 'package:test/test.dart';

Uint8List _buildFakeAix(String id) {
  final archive = Archive();
  final meta = utf8.encode(jsonEncode({'id': id, 'name': 'Test', 'version': 1, 'language': 'en'}));
  archive.addFile(ArchiveFile('res/source.json', meta.length, meta));
  final wasm = Uint8List.fromList([0x00, 0x61, 0x73, 0x6D, 0x01, 0x00, 0x00, 0x00]);
  archive.addFile(ArchiveFile('$id.wasm', wasm.length, wasm));
  return Uint8List.fromList(ZipEncoder().encode(archive)!);
}

void main() {
  group('WasmPluginLoader', () {
    test('starts empty', () {
      final loader = WasmPluginLoader();
      expect(loader.loadedSources, isEmpty);
      expect(loader.findBySourceId('multi.mangadex'), isNull);
    });

    test('load() registers plugin by source id', () async {
      final loader = WasmPluginLoader();
      final plugin = await loader.load(_buildFakeAix('en.test'));
      expect(plugin.sourceInfo.id, 'en.test');
      expect(loader.loadedSources, hasLength(1));
      expect(loader.loadedSources.first.id, 'en.test');
    });

    test('findBySourceId returns loaded plugin', () async {
      final loader = WasmPluginLoader();
      await loader.load(_buildFakeAix('en.test'));
      expect(loader.findBySourceId('en.test'), isNotNull);
      expect(loader.findBySourceId('not.loaded'), isNull);
    });

    test('load() multiple plugins', () async {
      final loader = WasmPluginLoader();
      await loader.load(_buildFakeAix('en.alpha'));
      await loader.load(_buildFakeAix('ja.beta'));
      expect(loader.loadedSources, hasLength(2));
    });

    test('unload() removes plugin', () async {
      final loader = WasmPluginLoader();
      await loader.load(_buildFakeAix('en.test'));
      expect(loader.findBySourceId('en.test'), isNotNull);
      loader.unload('en.test');
      expect(loader.findBySourceId('en.test'), isNull);
      expect(loader.loadedSources, isEmpty);
    });

    test('loading same id twice replaces the entry', () async {
      final loader = WasmPluginLoader();
      await loader.load(_buildFakeAix('en.test'));
      await loader.load(_buildFakeAix('en.test'));
      expect(loader.loadedSources, hasLength(1));
    });
  });
}
