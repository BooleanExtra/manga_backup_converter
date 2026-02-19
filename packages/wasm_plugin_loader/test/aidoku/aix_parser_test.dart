import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:checks/checks.dart';
import 'package:test/scaffolding.dart';
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
  test('extracts source info and wasm bytes', () {
    final bundle = AixParser.parse(buildFakeAix());
    check(bundle.sourceInfo.id).equals('en.test');
    check(bundle.sourceInfo.name).equals('TestSource');
    check(bundle.sourceInfo.language).equals('en');
    check(bundle.sourceInfo.url).equals('https://example.com');
    check(bundle.wasmBytes.length).isGreaterThan(4);
    check(bundle.wasmBytes[0]).equals(0x00);
    check(bundle.wasmBytes[1]).equals(0x61); // 'a'
    check(bundle.wasmBytes[2]).equals(0x73); // 's'
    check(bundle.wasmBytes[3]).equals(0x6D); // 'm'
  });

  test('handles missing optional url', () {
    final bundle = AixParser.parse(buildFakeAix(url: null));
    check(bundle.sourceInfo.url).isNull();
  });

  test('throws when source.json is missing', () {
    check(() => AixParser.parse(buildFakeAix(includeSourceJson: false))).throws<AixParseException>();
  });

  test('throws when no .wasm file is present', () {
    check(() => AixParser.parse(buildFakeAix(includeWasm: false))).throws<AixParseException>();
  });

  test('filtersJson and settingsJson are null when not present', () {
    final bundle = AixParser.parse(buildFakeAix());
    check(bundle.filtersJson).isNull();
    check(bundle.settingsJson).isNull();
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
    check(bundle.filtersJson).isNotNull().isEmpty();
  });

  test('parses settingsJson when present', () {
    final archive = Archive();
    final meta = utf8.encode(jsonEncode({'id': 'en.test', 'name': 'T', 'version': 1, 'language': 'en'}));
    archive.addFile(ArchiveFile('Payload/source.json', meta.length, meta));
    final wasm = Uint8List.fromList([0x00, 0x61, 0x73, 0x6D, 0x01, 0x00, 0x00, 0x00]);
    archive.addFile(ArchiveFile('en.test.wasm', wasm.length, wasm));
    final settings = utf8.encode(jsonEncode([
      {'type': 'toggle', 'key': 'nsfw'},
    ]));
    archive.addFile(ArchiveFile('Payload/settings.json', settings.length, settings));

    final bundle = AixParser.parse(Uint8List.fromList(ZipEncoder().encode(archive)));
    check(bundle.settingsJson).isNotNull();
    check(bundle.settingsJson!).length.equals(1);
    check((bundle.settingsJson![0] as Map<String, dynamic>)['type']).equals('toggle');
  });

  test('parses nested info format (info.id + info.languages[0])', () {
    final archive = Archive();
    final meta = utf8.encode(jsonEncode({
      'info': {
        'id': 'en.nested',
        'name': 'Nested Source',
        'languages': ['en'],
        'url': 'https://nested.com',
      },
    }));
    archive.addFile(ArchiveFile('Payload/source.json', meta.length, meta));
    final wasm = Uint8List.fromList([0x00, 0x61, 0x73, 0x6D, 0x01, 0x00, 0x00, 0x00]);
    archive.addFile(ArchiveFile('en.nested.wasm', wasm.length, wasm));

    final bundle = AixParser.parse(Uint8List.fromList(ZipEncoder().encode(archive)));
    check(bundle.sourceInfo.id).equals('en.nested');
    check(bundle.sourceInfo.name).equals('Nested Source');
    check(bundle.sourceInfo.language).equals('en');
    check(bundle.sourceInfo.url).equals('https://nested.com');
  });

  test('throws when source.json contains invalid JSON', () {
    final archive = Archive();
    final badJson = utf8.encode('not valid json {{{');
    archive.addFile(ArchiveFile('Payload/source.json', badJson.length, badJson));
    final wasm = Uint8List.fromList([0x00, 0x61, 0x73, 0x6D, 0x01, 0x00, 0x00, 0x00]);
    archive.addFile(ArchiveFile('en.test.wasm', wasm.length, wasm));

    check(() => AixParser.parse(Uint8List.fromList(ZipEncoder().encode(archive)))).throws<Object>();
  });

  test('AixParseException toString includes the message', () {
    const ex = AixParseException('test error message');
    check(ex.toString()).contains('AixParseException');
    check(ex.toString()).contains('test error message');
  });
}
