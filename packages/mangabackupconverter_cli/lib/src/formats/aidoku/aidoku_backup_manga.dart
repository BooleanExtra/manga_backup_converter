import 'package:dart_mappable/dart_mappable.dart';
import 'package:mangabackupconverter_cli/src/formats/aidoku/aidoku_enums.dart';
import 'package:mangabackupconverter_cli/src/pipeline/manga_details.dart';

part 'aidoku_backup_manga.mapper.dart';

@MappableClass(ignoreNull: true)
class AidokuBackupManga with AidokuBackupMangaMappable, MangaSearchEntry {
  final String id;
  final String sourceId;
  final String title;
  final String? author;
  final String? artist;
  final String? desc;
  final List<String>? tags;
  final String? cover;
  final String? url;
  final AidokuPublishingStatus status;
  final AidokuMangaContentRating nsfw;
  final AidokuMangaViewer viewer;
  final int chapterFlags;
  final String? langFilter;
  final List<String>? scanlatorFilter;

  AidokuBackupManga({
    required this.id,
    required this.sourceId,
    required this.title,
    this.author,
    this.artist,
    this.desc,
    this.tags,
    this.cover,
    this.url,
    this.status = AidokuPublishingStatus.unknown,
    this.nsfw = AidokuMangaContentRating.safe,
    this.viewer = AidokuMangaViewer.defaultViewer,
    this.chapterFlags = 0,
    this.langFilter,
    this.scanlatorFilter,
  });

  @override
  MangaSearchDetails toMangaSearchDetails() {
    return MangaSearchDetails(
      title: title,
      authors: <String>[if (author != null) author!],
      artists: <String>[if (artist != null) artist!],
      tagNames: tags ?? const <String>[],
      description: desc,
      coverImageUrl: cover,
    );
  }

  static const AidokuBackupManga Function(Map<String, dynamic> map) fromMap = AidokuBackupMangaMapper.fromMap;
  static const AidokuBackupManga Function(String json) fromJson = AidokuBackupMangaMapper.fromJson;
}
