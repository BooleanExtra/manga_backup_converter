import 'dart:convert';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:wasm_plugin_loader/src/models/filter_info.dart';
import 'package:wasm_plugin_loader/src/models/language_info.dart';
import 'package:wasm_plugin_loader/src/models/setting_item.dart';
import 'package:wasm_plugin_loader/src/models/source_info.dart';

class AixBundle {
  const AixBundle({
    required this.sourceInfo,
    required this.wasmBytes,
    this.filters,
    this.settings,
    this.languageInfos = const <LanguageInfo>[],
    this.languageSelectType,
  });

  final SourceInfo sourceInfo;
  final Uint8List wasmBytes;
  final List<FilterInfo>? filters;
  final List<SettingItem>? settings;

  /// Parsed language entries from the manifest (preserves isDefault metadata).
  final List<LanguageInfo> languageInfos;

  /// From the manifest's `languageSelectType` field (e.g. "single", "multi").
  final String? languageSelectType;
}

class AixParser {
  AixParser._();

  static AixBundle parse(Uint8List aixBytes) {
    final Archive archive = ZipDecoder().decodeBytes(aixBytes);

    final ArchiveFile? sourceFile = archive.findFile('Payload/source.json');
    if (sourceFile == null) throw const AixParseException('Payload/source.json not found in .aix archive');
    final Map<String, dynamic> sourceJson =
        jsonDecode(utf8.decode(sourceFile.content as List<int>)) as Map<String, dynamic>;

    // Support both flat format { "id": ..., "language": ... }
    // and nested format { "info": { "id": ..., "languages": [...] } }
    final Map<String, dynamic> infoJson = (sourceJson['info'] as Map<String, dynamic>?) ?? sourceJson;
    final String? languageSelectType = sourceJson['languageSelectType'] as String?;

    final List<Object>? rawLangs = infoJson['languages'] as List<Object>?;
    List<LanguageInfo> languageInfos = rawLangs != null
        ? rawLangs.map(LanguageInfo.fromJson).toList()
        : <LanguageInfo>[];
    // Flat-format fallback: single 'language' string.
    if (languageInfos.isEmpty) {
      final String? single = infoJson['language'] as String?;
      if (single != null) languageInfos = <LanguageInfo>[LanguageInfo.fromJson(single)];
    }
    final List<String> languages = languageInfos.map((LanguageInfo l) => l.effectiveValue).toList();

    // Listings may be at root level or inside the info block.
    final List<Object>? listingsRaw = (sourceJson['listings'] ?? infoJson['listings']) as List<Object>?;
    final List<SourceListing> listings =
        listingsRaw?.map((Object l) {
          final Map<String, dynamic> m = l as Map<String, dynamic>;
          return SourceListing(
            id: m['id'] as String,
            name: m['name'] as String,
            kind: (m['kind'] as int?) ?? 0,
          );
        }).toList() ??
        const <SourceListing>[];

    final SourceInfo info = SourceInfo(
      id: infoJson['id'] as String,
      name: infoJson['name'] as String,
      version: (infoJson['version'] as num?)?.toInt() ?? 0,
      languages: languages,
      url: infoJson['url'] as String?,
      contentRating: (infoJson['contentRating'] as int?) ?? 0,
      listings: listings,
    );

    // Find the .wasm file (may be at root or in a subdirectory)
    final ArchiveFile? wasmFile = archive.files.where((ArchiveFile f) => f.name.endsWith('.wasm')).firstOrNull;
    if (wasmFile == null) throw const AixParseException('No .wasm file found in .aix archive');

    final ArchiveFile? filtersFile = archive.findFile('Payload/filters.json');
    final ArchiveFile? settingsFile = archive.findFile('Payload/settings.json');

    List<FilterInfo>? filters;
    if (filtersFile != null) {
      final List<dynamic> rawFilters = jsonDecode(utf8.decode(filtersFile.content as List<int>)) as List<dynamic>;
      filters = rawFilters.whereType<Map<String, dynamic>>().map(FilterInfo.fromJson).toList();
    }

    List<SettingItem>? settings;
    if (settingsFile != null) {
      final List<dynamic> rawSettings = jsonDecode(utf8.decode(settingsFile.content as List<int>)) as List<dynamic>;
      settings = rawSettings.whereType<Map<String, dynamic>>().map(SettingItem.fromJson).toList();
    }

    return AixBundle(
      sourceInfo: info,
      wasmBytes: Uint8List.fromList(wasmFile.content as List<int>),
      filters: filters,
      settings: settings,
      languageInfos: languageInfos,
      languageSelectType: languageSelectType,
    );
  }
}

class AixParseException implements Exception {
  const AixParseException(this.message);

  final String message;

  @override
  String toString() => 'AixParseException: $message';
}
