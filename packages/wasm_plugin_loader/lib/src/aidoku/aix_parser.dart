import 'dart:convert';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import '../models/source_info.dart';

class AixBundle {
  const AixBundle({
    required this.sourceInfo,
    required this.wasmBytes,
    this.filtersJson,
    this.settingsJson,
  });

  final SourceInfo sourceInfo;
  final Uint8List wasmBytes;
  final Map<String, dynamic>? filtersJson;
  final Map<String, dynamic>? settingsJson;
}

class AixParser {
  AixParser._();

  static AixBundle parse(Uint8List aixBytes) {
    final archive = ZipDecoder().decodeBytes(aixBytes);

    final sourceFile = archive.findFile('res/source.json');
    if (sourceFile == null) throw const AixParseException('res/source.json not found in .aix archive');
    final sourceJson = jsonDecode(utf8.decode(sourceFile.content as List<int>)) as Map<String, dynamic>;

    final info = SourceInfo(
      id: sourceJson['id'] as String,
      name: sourceJson['name'] as String,
      language: sourceJson['language'] as String,
      url: sourceJson['url'] as String?,
    );

    // Find the .wasm file (may be at root or in a subdirectory)
    final wasmFile = archive.files.where((f) => f.name.endsWith('.wasm')).firstOrNull;
    if (wasmFile == null) throw const AixParseException('No .wasm file found in .aix archive');

    final filtersFile = archive.findFile('res/filters.json');
    final settingsFile = archive.findFile('res/settings.json');

    return AixBundle(
      sourceInfo: info,
      wasmBytes: Uint8List.fromList(wasmFile.content as List<int>),
      filtersJson: filtersFile != null
          ? jsonDecode(utf8.decode(filtersFile.content as List<int>)) as Map<String, dynamic>
          : null,
      settingsJson: settingsFile != null
          ? jsonDecode(utf8.decode(settingsFile.content as List<int>)) as Map<String, dynamic>
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
