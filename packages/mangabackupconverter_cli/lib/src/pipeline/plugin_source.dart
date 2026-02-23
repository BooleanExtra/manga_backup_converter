import 'package:mangabackupconverter_cli/src/common/normalize_chapter_number.dart';
import 'package:mangabackupconverter_cli/src/pipeline/chapter_data.dart';

abstract interface class PluginSource {
  String get sourceId;
  String get sourceName;
  Future<PluginSearchPageResult> search(String query, int page);
  Future<(PluginMangaDetails, List<PluginChapter>)?> getMangaWithChapters(String mangaKey);
  void dispose();
}

class PluginSearchResult {
  const PluginSearchResult({
    required this.pluginSourceId,
    required this.mangaKey,
    required this.title,
    this.coverUrl,
    this.authors = const <String>[],
    this.details,
    this.chapters = const <PluginChapter>[],
  });

  final String pluginSourceId;
  final String mangaKey;
  final String title;
  final String? coverUrl;
  final List<String> authors;
  final PluginMangaDetails? details;
  final List<PluginChapter> chapters;
}

class PluginSearchPageResult {
  const PluginSearchPageResult({
    required this.results,
    required this.hasNextPage,
    this.warnings = const <String>[],
  });

  final List<PluginSearchResult> results;
  final bool hasNextPage;
  final List<String> warnings;
}

enum MangaPublishingStatus { unknown, ongoing, completed, cancelled, hiatus }

enum MangaContentRating { safe, suggestive, nsfw }

class PluginMangaDetails {
  const PluginMangaDetails({
    required this.key,
    required this.title,
    this.coverUrl,
    this.authors = const <String>[],
    this.artists = const <String>[],
    this.description,
    this.tags = const <String>[],
    this.status = MangaPublishingStatus.unknown,
    this.contentRating = MangaContentRating.safe,
    this.url,
  });

  final String key;
  final String title;
  final String? coverUrl;
  final List<String> authors;
  final List<String> artists;
  final String? description;
  final List<String> tags;
  final MangaPublishingStatus status;
  final MangaContentRating contentRating;
  final String? url;
}

class PluginChapter implements ChapterData {
  PluginChapter({
    required this.chapterId,
    this.title,
    double? chapterNumber,
    double? volumeNumber,
    this.scanlator,
    this.language,
    this.dateUploaded,
    this.url,
    this.sourceOrder = 0,
  }) : chapterNumber = chapterNumber == null ? null : normalizeChapterNumber(chapterNumber),
       volumeNumber = volumeNumber == null ? null : normalizeChapterNumber(volumeNumber);

  @override
  final String chapterId;

  @override
  final String? title;

  @override
  final double? chapterNumber;

  @override
  final double? volumeNumber;

  @override
  final String? scanlator;

  @override
  final String? language;

  @override
  final DateTime? dateUploaded;

  @override
  final String? url;

  @override
  final int sourceOrder;
}
