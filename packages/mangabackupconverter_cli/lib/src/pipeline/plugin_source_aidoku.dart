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
  Future<PluginMangaDetails?> getMangaDetails(String mangaKey) async {
    final Manga? manga = await _plugin.getMangaDetails(mangaKey);
    if (manga == null) return null;
    return PluginMangaDetails(
      key: manga.key,
      title: manga.title,
      coverUrl: manga.coverUrl,
      authors: manga.authors,
      artists: manga.artists,
      description: manga.description,
      tags: manga.tags,
      status: _mapStatus(manga.status),
      contentRating: _mapContentRating(manga.contentRating),
      url: manga.url,
    );
  }

  @override
  Future<List<PluginChapter>> getChapterList(String mangaKey) async {
    final Manga? manga = await _plugin.getMangaDetails(mangaKey);
    if (manga == null) return const <PluginChapter>[];
    return [
      for (final (int i, Chapter ch) in manga.chapters.indexed)
        PluginChapter(
          chapterId: ch.key,
          title: ch.title,
          chapterNumber: ch.chapterNumber,
          volumeNumber: ch.volumeNumber,
          scanlator: ch.scanlators.firstOrNull,
          language: ch.language,
          dateUploaded: ch.dateUploaded,
          url: ch.url,
          sourceOrder: i,
        ),
    ];
  }

  @override
  void dispose() {
    _plugin.dispose();
  }

  static MangaPublishingStatus _mapStatus(MangaStatus status) => switch (status) {
        MangaStatus.unknown => MangaPublishingStatus.unknown,
        MangaStatus.ongoing => MangaPublishingStatus.ongoing,
        MangaStatus.completed => MangaPublishingStatus.completed,
        MangaStatus.cancelled => MangaPublishingStatus.cancelled,
        MangaStatus.hiatus => MangaPublishingStatus.hiatus,
      };

  static MangaContentRating _mapContentRating(ContentRating rating) => switch (rating) {
        ContentRating.safe => MangaContentRating.safe,
        ContentRating.suggestive => MangaContentRating.suggestive,
        ContentRating.nsfw => MangaContentRating.nsfw,
      };
}
