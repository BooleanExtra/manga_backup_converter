import 'package:wasm_plugin_loader/wasm_plugin_loader.dart';

sealed class ExtensionEntry {
  const ExtensionEntry({
    required this.id,
    required this.name,
    this.languages = const <String>[],
  });

  final String id;
  final String name;
  final List<String> languages;
}

class AidokuExtensionEntry extends ExtensionEntry {
  const AidokuExtensionEntry({
    required super.id,
    required super.name,
    required this.version,
    required this.iconUrl,
    required this.downloadUrl,
    super.languages,
    this.contentRating = 0,
    this.baseUrl,
    this.altNames = const <String>[],
  });

  factory AidokuExtensionEntry.fromSourceEntry(SourceEntry entry) {
    return AidokuExtensionEntry(
      id: entry.id,
      name: entry.name,
      languages: entry.languages,
      version: entry.version,
      iconUrl: entry.iconUrl,
      downloadUrl: entry.downloadUrl,
      contentRating: entry.contentRating,
      baseUrl: entry.baseUrl,
      altNames: entry.altNames,
    );
  }

  final int version;
  final String iconUrl;
  final String downloadUrl;
  final int contentRating;
  final String? baseUrl;
  final List<String> altNames;
}

class StubExtensionEntry extends ExtensionEntry {
  const StubExtensionEntry({
    required super.id,
    required super.name,
    super.languages,
  });
}
