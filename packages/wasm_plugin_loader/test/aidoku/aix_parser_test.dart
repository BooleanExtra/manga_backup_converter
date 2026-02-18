import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:test/test.dart';
import 'package:wasm_plugin_loader/src/aidoku/aix_parser.dart';

Uint8List buildFakeAix({
  String id = 'en.test',
  String name = 'TestSource',
  String language = 'en',
  String? url = 'https://example.com',
  bool includeWasm = true,
  bool includeSourceJson = true,
}) {
  final archive = Archive();

  if (includeSourceJson) {
    final meta = utf8.encode(jsonEncode({
      'id': id,
      'name': name,
      'version': 1,
      'language': language,
      if (url != null) 'url': url,
    }));
    archive.addFile(ArchiveFile('Payload/source.json', meta.length, meta));
  }

  if (includeWasm) {
    // Minimal valid WASM: magic bytes + version
    final wasm = Uint8List.fromList([0x00, 0x61, 0x73, 0x6D, 0x01, 0x00, 0x00, 0x00]);
    archive.addFile(ArchiveFile('$id.wasm', wasm.length, wasm));
  }

  return Uint8List.fromList(ZipEncoder().encode(archive));
}

void main() {
  group('AixParser', () {
    test('extracts source info and wasm bytes', () {
      final bundle = AixParser.parse(buildFakeAix());
      expect(bundle.sourceInfo.id, 'en.test');
      expect(bundle.sourceInfo.name, 'TestSource');
      expect(bundle.sourceInfo.language, 'en');
      expect(bundle.sourceInfo.url, 'https://example.com');
      expect(bundle.wasmBytes.length, greaterThan(4));
      expect(bundle.wasmBytes[0], 0x00);
      expect(bundle.wasmBytes[1], 0x61); // 'a'
      expect(bundle.wasmBytes[2], 0x73); // 's'
      expect(bundle.wasmBytes[3], 0x6D); // 'm'
    });

    test('handles missing optional url', () {
      final bundle = AixParser.parse(buildFakeAix(url: null));
      expect(bundle.sourceInfo.url, isNull);
    });

    test('throws when source.json is missing', () {
      expect(
        () => AixParser.parse(buildFakeAix(includeSourceJson: false)),
        throwsA(isA<AixParseException>()),
      );
    });

    test('throws when no .wasm file is present', () {
      expect(
        () => AixParser.parse(buildFakeAix(includeWasm: false)),
        throwsA(isA<AixParseException>()),
      );
    });

    test('filtersJson and settingsJson are null when not present', () {
      final bundle = AixParser.parse(buildFakeAix());
      expect(bundle.filtersJson, isNull);
      expect(bundle.settingsJson, isNull);
    });

    test('parses filtersJson when present', () {
      final archive = Archive();
      final meta = utf8.encode(jsonEncode({'id': 'en.test', 'name': 'T', 'version': 1, 'language': 'en'}));
      archive.addFile(ArchiveFile('Payload/source.json', meta.length, meta));
      final wasm = Uint8List.fromList([0x00, 0x61, 0x73, 0x6D, 0x01, 0x00, 0x00, 0x00]);
      archive.addFile(ArchiveFile('en.test.wasm', wasm.length, wasm));
      // filters.json is a top-level JSON array (list of filter descriptor objects)
      final filters = utf8.encode(jsonEncode(<Object>[]));
      archive.addFile(ArchiveFile('Payload/filters.json', filters.length, filters));

      final bundle = AixParser.parse(Uint8List.fromList(ZipEncoder().encode(archive)));
      expect(bundle.filtersJson, isNotNull);
      expect(bundle.filtersJson, isEmpty);
    });
  });
}
