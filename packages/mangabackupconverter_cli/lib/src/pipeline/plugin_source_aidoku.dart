import 'package:aidoku_plugin_loader/aidoku_plugin_loader.dart';
import 'package:mangabackupconverter_cli/src/pipeline/plugin_source.dart';

class AidokuPluginSource implements PluginSource {
  AidokuPluginSource({required AidokuPlugin plugin}) : _plugin = plugin;

  final AidokuPlugin _plugin;

  @override
  String get sourceId => _plugin.sourceInfo.id;

  @override
  String get sourceName => _plugin.sourceInfo.name;

  @override
  Future<PluginSearchPageResult> search(String query, int page) async {
    final MangaPageResult result = await _plugin.searchManga(query, page);
    return PluginSearchPageResult(
      results: result.manga
          .map(
            (Manga m) => PluginSearchResult(
              pluginSourceId: sourceId,
              mangaKey: m.key,
              title: m.title,
              coverUrl: m.coverUrl,
              authors: m.authors,
            ),
          )
          .toList(),
      hasNextPage: result.hasNextPage,
    );
  }

  @override
  void dispose() {
    _plugin.dispose();
  }
}
