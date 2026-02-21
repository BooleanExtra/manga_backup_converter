import 'dart:convert';
import 'dart:typed_data';

import 'package:aidoku_plugin_loader/src/aidoku/aix_parser.dart';
import 'package:aidoku_plugin_loader/src/models/filter_info.dart';
import 'package:aidoku_plugin_loader/src/models/language_info.dart';
import 'package:aidoku_plugin_loader/src/models/setting_item.dart';
import 'package:archive/archive.dart';
import 'package:checks/checks.dart';
import 'package:test/scaffolding.dart';

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
    final Uint8List meta = utf8.encode(
      jsonEncode(<String, Object>{
        'id': id,
        'name': name,
        'version': 1,
        'language': language,
        if (url != null) 'url': url,
      }),
    );
    archive.addFile(ArchiveFile('Payload/source.json', meta.length, meta));
  }

  if (includeWasm) {
    // Minimal valid WASM: magic bytes + version
    final wasm = Uint8List.fromList(<int>[0x00, 0x61, 0x73, 0x6D, 0x01, 0x00, 0x00, 0x00]);
    archive.addFile(ArchiveFile('$id.wasm', wasm.length, wasm));
  }

  return Uint8List.fromList(ZipEncoder().encode(archive));
}

void main() {
  test('extracts source info and wasm bytes', () {
    final AixBundle bundle = AixParser.parse(buildFakeAix());
    check(bundle.sourceInfo.id).equals('en.test');
    check(bundle.sourceInfo.name).equals('TestSource');
    check(bundle.sourceInfo.languages).deepEquals(<Object?>['en']);
    check(bundle.sourceInfo.url).equals('https://example.com');
    check(bundle.sourceInfo.version).equals(1);
    check(bundle.sourceInfo.contentRating).equals(0);
    check(bundle.wasmBytes.length).isGreaterThan(4);
    check(bundle.wasmBytes[0]).equals(0x00);
    check(bundle.wasmBytes[1]).equals(0x61); // 'a'
    check(bundle.wasmBytes[2]).equals(0x73); // 's'
    check(bundle.wasmBytes[3]).equals(0x6D); // 'm'
  });

  test('handles missing optional url', () {
    final AixBundle bundle = AixParser.parse(buildFakeAix(url: null));
    check(bundle.sourceInfo.url).isNull();
  });

  test('throws when source.json is missing', () {
    check(() => AixParser.parse(buildFakeAix(includeSourceJson: false))).throws<AixParseException>();
  });

  test('throws when no .wasm file is present', () {
    check(() => AixParser.parse(buildFakeAix(includeWasm: false))).throws<AixParseException>();
  });

  test('filters and settings are null when not present', () {
    final AixBundle bundle = AixParser.parse(buildFakeAix());
    check(bundle.filters).isNull();
    check(bundle.settings).isNull();
  });

  test('parses filters when present', () {
    final archive = Archive();
    final Uint8List meta = utf8.encode(
      jsonEncode(<String, Object>{'id': 'en.test', 'name': 'T', 'version': 1, 'language': 'en'}),
    );
    archive.addFile(ArchiveFile('Payload/source.json', meta.length, meta));
    final wasm = Uint8List.fromList(<int>[0x00, 0x61, 0x73, 0x6D, 0x01, 0x00, 0x00, 0x00]);
    archive.addFile(ArchiveFile('en.test.wasm', wasm.length, wasm));
    // filters.json is a top-level JSON array (list of filter descriptor objects)
    final Uint8List filters = utf8.encode(jsonEncode(<Object>[]));
    archive.addFile(ArchiveFile('Payload/filters.json', filters.length, filters));

    final AixBundle bundle = AixParser.parse(Uint8List.fromList(ZipEncoder().encode(archive)));
    check(bundle.filters).isNotNull().isEmpty();
  });

  test('parses settings when present', () {
    final archive = Archive();
    final Uint8List meta = utf8.encode(
      jsonEncode(<String, Object>{'id': 'en.test', 'name': 'T', 'version': 1, 'language': 'en'}),
    );
    archive.addFile(ArchiveFile('Payload/source.json', meta.length, meta));
    final wasm = Uint8List.fromList(<int>[0x00, 0x61, 0x73, 0x6D, 0x01, 0x00, 0x00, 0x00]);
    archive.addFile(ArchiveFile('en.test.wasm', wasm.length, wasm));
    final Uint8List settingsJson = utf8.encode(
      jsonEncode(<Map<String, String>>[
        <String, String>{'type': 'toggle', 'key': 'nsfw'},
      ]),
    );
    archive.addFile(ArchiveFile('Payload/settings.json', settingsJson.length, settingsJson));

    final AixBundle bundle = AixParser.parse(Uint8List.fromList(ZipEncoder().encode(archive)));
    check(bundle.settings).isNotNull();
    check(bundle.settings!).length.equals(1);
    check(bundle.settings![0]).isA<SwitchSetting>().has((SwitchSetting s) => s.key, 'key').equals('nsfw');
  });

  test('parses check filter from filters.json', () {
    final archive = Archive();
    final Uint8List meta = utf8.encode(
      jsonEncode(<String, Object>{'id': 'en.test', 'name': 'T', 'version': 1, 'language': 'en'}),
    );
    archive.addFile(ArchiveFile('Payload/source.json', meta.length, meta));
    final wasm = Uint8List.fromList(<int>[0x00, 0x61, 0x73, 0x6D, 0x01, 0x00, 0x00, 0x00]);
    archive.addFile(ArchiveFile('en.test.wasm', wasm.length, wasm));
    final Uint8List filtersJson = utf8.encode(
      jsonEncode(<Map<String, Object>>[
        <String, Object>{'type': 'check', 'name': 'Has chapters', 'default': true},
      ]),
    );
    archive.addFile(ArchiveFile('Payload/filters.json', filtersJson.length, filtersJson));

    final AixBundle bundle = AixParser.parse(Uint8List.fromList(ZipEncoder().encode(archive)));
    check(bundle.filters).isNotNull();
    check(bundle.filters!).length.equals(1);
    final FilterInfo fi = bundle.filters![0];
    check(fi).isA<FilterInfo>().has((FilterInfo f) => f.type, 'type').equals('check');
    check(fi.defaultValue).equals(true);
  });

  test('parses nested info format (info.id + info.languages)', () {
    final archive = Archive();
    final Uint8List meta = utf8.encode(
      jsonEncode(<String, Map<String, Object>>{
        'info': <String, Object>{
          'id': 'en.nested',
          'name': 'Nested Source',
          'languages': <String>['en'],
          'url': 'https://nested.com',
        },
      }),
    );
    archive.addFile(ArchiveFile('Payload/source.json', meta.length, meta));
    final wasm = Uint8List.fromList(<int>[0x00, 0x61, 0x73, 0x6D, 0x01, 0x00, 0x00, 0x00]);
    archive.addFile(ArchiveFile('en.nested.wasm', wasm.length, wasm));

    final AixBundle bundle = AixParser.parse(Uint8List.fromList(ZipEncoder().encode(archive)));
    check(bundle.sourceInfo.id).equals('en.nested');
    check(bundle.sourceInfo.name).equals('Nested Source');
    check(bundle.sourceInfo.languages).deepEquals(<Object?>['en']);
    check(bundle.sourceInfo.url).equals('https://nested.com');
  });

  test('parses multi-language nested format', () {
    final archive = Archive();
    final Uint8List meta = utf8.encode(
      jsonEncode(<String, Map<String, Object>>{
        'info': <String, Object>{
          'id': 'multi.test',
          'name': 'Multi Source',
          'languages': <String>['en', 'ja'],
        },
      }),
    );
    archive.addFile(ArchiveFile('Payload/source.json', meta.length, meta));
    final wasm = Uint8List.fromList(<int>[0x00, 0x61, 0x73, 0x6D, 0x01, 0x00, 0x00, 0x00]);
    archive.addFile(ArchiveFile('multi.test.wasm', wasm.length, wasm));

    final AixBundle bundle = AixParser.parse(Uint8List.fromList(ZipEncoder().encode(archive)));
    check(bundle.sourceInfo.languages).deepEquals(<Object?>['en', 'ja']);
  });

  test('throws when source.json contains invalid JSON', () {
    final archive = Archive();
    final Uint8List badJson = utf8.encode('not valid json {{{');
    archive.addFile(ArchiveFile('Payload/source.json', badJson.length, badJson));
    final wasm = Uint8List.fromList(<int>[0x00, 0x61, 0x73, 0x6D, 0x01, 0x00, 0x00, 0x00]);
    archive.addFile(ArchiveFile('en.test.wasm', wasm.length, wasm));

    check(() => AixParser.parse(Uint8List.fromList(ZipEncoder().encode(archive)))).throws<Object>();
  });

  test('AixParseException toString includes the message', () {
    const ex = AixParseException('test error message');
    check(ex.toString()).contains('AixParseException');
    check(ex.toString()).contains('test error message');
  });

  test('parses languages as LanguageInfo objects with isDefault', () {
    final archive = Archive();
    final Uint8List meta = utf8.encode(
      jsonEncode(<String, Map<String, Object>>{
        'info': <String, Object>{
          'id': 'multi.test',
          'name': 'Multi Source',
          'languages': <Map<String, Object>>[
            <String, Object>{'code': 'en', 'value': 'english', 'default': true},
            <String, String>{'code': 'ja', 'value': 'japanese'},
          ],
        },
      }),
    );
    archive.addFile(ArchiveFile('Payload/source.json', meta.length, meta));
    final wasm = Uint8List.fromList(<int>[0x00, 0x61, 0x73, 0x6D, 0x01, 0x00, 0x00, 0x00]);
    archive.addFile(ArchiveFile('multi.test.wasm', wasm.length, wasm));

    final AixBundle bundle = AixParser.parse(Uint8List.fromList(ZipEncoder().encode(archive)));

    // languageInfos preserves full metadata
    check(bundle.languageInfos).length.equals(2);
    check(bundle.languageInfos[0]).isA<LanguageInfo>()
      ..has((LanguageInfo l) => l.code, 'code').equals('en')
      ..has((LanguageInfo l) => l.value, 'value').equals('english')
      ..has((LanguageInfo l) => l.isDefault, 'isDefault').equals(true);
    check(bundle.languageInfos[1]).isA<LanguageInfo>()
      ..has((LanguageInfo l) => l.code, 'code').equals('ja')
      ..has((LanguageInfo l) => l.value, 'value').equals('japanese')
      ..has((LanguageInfo l) => l.isDefault, 'isDefault').isNull();

    // sourceInfo.languages maps to effectiveValue
    check(bundle.sourceInfo.languages).deepEquals(<Object?>['english', 'japanese']);
  });

  test('parses languageSelectType from manifest', () {
    final archive = Archive();
    final Uint8List meta = utf8.encode(
      jsonEncode(<String, Object>{
        'info': <String, Object>{
          'id': 'multi.test',
          'name': 'Multi Source',
          'languages': <String>['en', 'ja'],
        },
        'languageSelectType': 'single',
      }),
    );
    archive.addFile(ArchiveFile('Payload/source.json', meta.length, meta));
    final wasm = Uint8List.fromList(<int>[0x00, 0x61, 0x73, 0x6D, 0x01, 0x00, 0x00, 0x00]);
    archive.addFile(ArchiveFile('multi.test.wasm', wasm.length, wasm));

    final AixBundle bundle = AixParser.parse(Uint8List.fromList(ZipEncoder().encode(archive)));
    check(bundle.languageSelectType).equals('single');
  });

  test('languageSelectType defaults to null when absent', () {
    final AixBundle bundle = AixParser.parse(buildFakeAix());
    check(bundle.languageSelectType).isNull();
  });

  test('flat string languages populate languageInfos', () {
    final AixBundle bundle = AixParser.parse(buildFakeAix());
    check(bundle.languageInfos).length.equals(1);
    check(bundle.languageInfos[0]).isA<LanguageInfo>()
      ..has((LanguageInfo l) => l.code, 'code').equals('en')
      ..has((LanguageInfo l) => l.effectiveValue, 'effectiveValue').equals('en');
  });
}
