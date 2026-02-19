import 'dart:convert';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:wasm_plugin_loader/src/models/filter_info.dart';
import 'package:wasm_plugin_loader/src/models/setting_item.dart';
import 'package:wasm_plugin_loader/src/models/source_info.dart';

class AixBundle {
  const AixBundle({
    required this.sourceInfo,
    required this.wasmBytes,
    this.filters,
    this.settings,
  });

  final SourceInfo sourceInfo;
  final Uint8List wasmBytes;
  final List<FilterInfo>? filters;
  final List<SettingItem>? settings;
}

class AixParser {
  AixParser._();

  static AixBundle parse(Uint8List aixBytes) {
    final archive = ZipDecoder().decodeBytes(aixBytes);

    final sourceFile = archive.findFile('Payload/source.json');
    if (sourceFile == null) throw const AixParseException('Payload/source.json not found in .aix archive');
    final sourceJson = jsonDecode(utf8.decode(sourceFile.content as List<int>)) as Map<String, dynamic>;

    // Support both flat format { "id": ..., "language": ... }
    // and nested format { "info": { "id": ..., "languages": [...] } }
    final infoJson = (sourceJson['info'] as Map<String, dynamic>?) ?? sourceJson;
    final languagesRaw = infoJson['languages'];
    final language = languagesRaw is List && languagesRaw.isNotEmpty
        ? languagesRaw.first as String
        : infoJson['language'] as String;

    // Listings may be at root level or inside the info block.
    final listingsRaw = (sourceJson['listings'] ?? infoJson['listings']) as List<dynamic>?;
    final listings = listingsRaw
            ?.map((l) {
              final m = l as Map<String, dynamic>;
              return SourceListing(
                id: m['id'] as String,
                name: m['name'] as String,
                kind: (m['kind'] as int?) ?? 0,
              );
            })
            .toList() ??
        const [];

    final info = SourceInfo(
      id: infoJson['id'] as String,
      name: infoJson['name'] as String,
      language: language,
      url: infoJson['url'] as String?,
      listings: listings,
    );

    // Find the .wasm file (may be at root or in a subdirectory)
    final wasmFile = archive.files.where((f) => f.name.endsWith('.wasm')).firstOrNull;
    if (wasmFile == null) throw const AixParseException('No .wasm file found in .aix archive');

    final filtersFile = archive.findFile('Payload/filters.json');
    final settingsFile = archive.findFile('Payload/settings.json');

    List<FilterInfo>? filters;
    if (filtersFile != null) {
      final rawFilters = jsonDecode(utf8.decode(filtersFile.content as List<int>)) as List<dynamic>;
      filters = rawFilters.whereType<Map<String, dynamic>>().map(FilterInfo.fromJson).toList();
    }

    List<SettingItem>? settings;
    if (settingsFile != null) {
      final rawSettings = jsonDecode(utf8.decode(settingsFile.content as List<int>)) as List<dynamic>;
      settings = rawSettings.whereType<Map<String, dynamic>>().map(SettingItem.fromJson).toList();
    }

    return AixBundle(
      sourceInfo: info,
      wasmBytes: Uint8List.fromList(wasmFile.content as List<int>),
      filters: filters,
      settings: settings,
    );
  }
}

class AixParseException implements Exception {
  const AixParseException(this.message);

  final String message;

  @override
  String toString() => 'AixParseException: $message';
}
