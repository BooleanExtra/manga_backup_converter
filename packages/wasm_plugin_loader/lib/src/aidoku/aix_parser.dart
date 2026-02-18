import 'dart:convert';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:wasm_plugin_loader/src/models/source_info.dart';

class AixBundle {
  const AixBundle({
    required this.sourceInfo,
    required this.wasmBytes,
    this.filtersJson,
    this.settingsJson,
  });

  final SourceInfo sourceInfo;
  final Uint8List wasmBytes;
  final List<dynamic>? filtersJson;
  final List<dynamic>? settingsJson;
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

    final info = SourceInfo(
      id: infoJson['id'] as String,
      name: infoJson['name'] as String,
      language: language,
      url: infoJson['url'] as String?,
    );

    // Find the .wasm file (may be at root or in a subdirectory)
    final wasmFile = archive.files.where((f) => f.name.endsWith('.wasm')).firstOrNull;
    if (wasmFile == null) throw const AixParseException('No .wasm file found in .aix archive');

    final filtersFile = archive.findFile('Payload/filters.json');
    final settingsFile = archive.findFile('Payload/settings.json');

    return AixBundle(
      sourceInfo: info,
      wasmBytes: Uint8List.fromList(wasmFile.content as List<int>),
      filtersJson: filtersFile != null
          ? jsonDecode(utf8.decode(filtersFile.content as List<int>)) as List<dynamic>
          : null,
      settingsJson: settingsFile != null
          ? jsonDecode(utf8.decode(settingsFile.content as List<int>)) as List<dynamic>
          : null,
    );
  }
}

class AixParseException implements Exception {
  const AixParseException(this.message);

  final String message;

  @override
  String toString() => 'AixParseException: $message';
}
