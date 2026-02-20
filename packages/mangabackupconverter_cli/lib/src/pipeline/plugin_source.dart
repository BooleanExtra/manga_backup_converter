import 'package:mangabackupconverter_cli/src/common/extensions.dart';

abstract interface class PluginSource {
  String get sourceId;
  String get sourceName;
  ExtensionType get extensionType;
  Future<PluginSearchPageResult> search(String query, int page);
  void dispose();
}

class PluginSearchResult {
  const PluginSearchResult({
    required this.pluginSourceId,
    required this.mangaKey,
    required this.title,
    this.coverUrl,
    this.authors = const <String>[],
  });

  final String pluginSourceId;
  final String mangaKey;
  final String title;
  final String? coverUrl;
  final List<String> authors;
}

class PluginSearchPageResult {
  const PluginSearchPageResult({required this.results, required this.hasNextPage});

  final List<PluginSearchResult> results;
  final bool hasNextPage;
}
