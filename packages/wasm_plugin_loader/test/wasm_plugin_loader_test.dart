import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:checks/checks.dart';
import 'package:test/scaffolding.dart';
import 'package:wasm_plugin_loader/wasm_plugin_loader.dart';

/// Tests that invoke [AidokuPluginMemoryStore.loadAixBytes] require actual WASM instantiation,
/// which is only supported on web. Skip them on native platforms.
const String _wasmSkip = 'Requires web platform (dart:js_interop + browser WebAssembly API).';

Uint8List _buildFakeAix(String id) {
  final archive = Archive();
  final Uint8List meta = utf8.encode(
    jsonEncode(<String, Object>{
      'id': id,
      'name': 'Test $id',
      'version': 1,
      'language': 'en',
      'url': 'https://example.com',
    }),
  );
  archive.addFile(ArchiveFile('Payload/source.json', meta.length, meta));
  final wasm = Uint8List.fromList(<int>[0x00, 0x61, 0x73, 0x6D, 0x01, 0x00, 0x00, 0x00]);
  archive.addFile(ArchiveFile('$id.wasm', wasm.length, wasm));
  return Uint8List.fromList(ZipEncoder().encode(archive));
}

void main() {
  test('starts empty', () {
    final loader = AidokuPluginMemoryStore();
    check(loader.loadedSources).isEmpty();
    check(loader.findBySourceId('multi.mangadex')).isNull();
  });

  test('unload() is idempotent for unknown source id', () {
    final loader = AidokuPluginMemoryStore();
    check(() => loader.unload('unknown.source')).returnsNormally();
    check(loader.loadedSources).isEmpty();
  });

  test('findBySourceId returns null for unknown id', () {
    final loader = AidokuPluginMemoryStore();
    check(loader.findBySourceId('unknown.source')).isNull();
  });

  test('loadAixBytes() registers plugin by source id', skip: _wasmSkip, () async {
    final loader = AidokuPluginMemoryStore();
    final AidokuPlugin plugin = await loader.loadAixBytes(_buildFakeAix('en.testsource'));
    check(plugin.sourceInfo.id).equals('en.testsource');
    check(loader.loadedSources).length.equals(1);
    check(loader.findBySourceId('en.testsource')).identicalTo(plugin);
  });

  test('loadAixBytes() can register multiple plugins', skip: _wasmSkip, () async {
    final loader = AidokuPluginMemoryStore();
    await loader.loadAixBytes(_buildFakeAix('en.source1'));
    await loader.loadAixBytes(_buildFakeAix('en.source2'));
    check(loader.loadedSources).length.equals(2);
  });

  test('loadAixBytes() replaces plugin with same id', skip: _wasmSkip, () async {
    final loader = AidokuPluginMemoryStore();
    await loader.loadAixBytes(_buildFakeAix('en.source'));
    final AidokuPlugin second = await loader.loadAixBytes(_buildFakeAix('en.source'));
    check(loader.loadedSources).length.equals(1);
    check(loader.findBySourceId('en.source')).identicalTo(second);
  });

  test('unload() removes plugin', skip: _wasmSkip, () async {
    final loader = AidokuPluginMemoryStore();
    await loader.loadAixBytes(_buildFakeAix('en.source'));
    loader.unload('en.source');
    check(loader.loadedSources).isEmpty();
  });
}
