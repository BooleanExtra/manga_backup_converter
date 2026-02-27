import 'package:aidoku_plugin_loader/aidoku_plugin_loader.dart';

sealed class ExtensionEntry {
  const ExtensionEntry({
    required this.id,
    required this.name,
    this.languages = const <String>[],
    this.contentRating = 0,
  });

  final String id;
  final String name;
  final List<String> languages;
  final int contentRating;

  String get cacheKey;
}

class AidokuExtensionEntry extends ExtensionEntry {
  const AidokuExtensionEntry({
    required super.id,
    required super.name,
    required this.version,
    required this.iconUrl,
    required this.downloadUrl,
    super.languages,
    super.contentRating,
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
  final String? baseUrl;
  final List<String> altNames;

  @override
  String get cacheKey => '$id-v$version';
}

class StubExtensionEntry extends ExtensionEntry {
  const StubExtensionEntry({
    required super.id,
    required super.name,
    super.languages,
  });

  @override
  String get cacheKey => id;
}
