import 'package:mangabackupconverter_cli/src/pipeline/plugin_source.dart';

// TODO: implement search functionality for other sources
class StubPluginSource implements PluginSource {
  const StubPluginSource({required this.sourceId, required this.sourceName});

  @override
  final String sourceId;

  @override
  final String sourceName;

  @override
  Future<PluginSearchPageResult> search(String query, int page) {
    throw UnimplementedError('Search is not yet implemented for stub sources');
  }

  @override
  Future<PluginMangaDetails?> getMangaDetails(String mangaKey) {
    throw UnimplementedError('getMangaDetails is not yet implemented for stub sources');
  }

  @override
  Future<List<PluginChapter>> getChapterList(String mangaKey) {
    throw UnimplementedError('getChapterList is not yet implemented for stub sources');
  }

  @override
  void dispose() {}
}
