import 'package:dart_mappable/dart_mappable.dart';
import 'package:mangabackupconverter_cli/src/formats/aidoku/aidoku_enums.dart';
import 'package:mangabackupconverter_cli/src/formats/paperback/paperback_backup_manga_info.dart';
import 'package:mangabackupconverter_cli/src/pipeline/manga_details.dart';

part 'aidoku_backup_manga.mapper.dart';

@MappableClass(ignoreNull: true)
class AidokuBackupManga with AidokuBackupMangaMappable implements MangaDetails {
  final String id;
  final String sourceId;
  @override
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

  PaperbackBackupMangaInfo toPaperbackMangaInfo() {
    final String? mangaCover = cover;
    return PaperbackBackupMangaInfo(
      tags: (tags ?? <String>[]).map((String tag) => PaperbackBackupMangaTag(label: tag, id: tag)).toList(),
      desc: desc ?? '',
      titles: <String>[title],
      covers: mangaCover == null ? <String>[] : <String>[mangaCover],
      author: author ?? '',
      image: cover ?? '',
      hentai: nsfw == AidokuMangaContentRating.nsfw,
      additionalInfo: PaperbackBackupMangaAdditionalInfo(),
      artist: artist ?? '',
      id: id,
      status: PaperbackBackupMangaInfo.statusFromAidoku(status),
    );
  }

  @override
  List<String> get altTitles => const <String>[];

  @override
  List<String> get authors => <String>[if (author != null) author!];

  @override
  List<String> get artists => <String>[if (artist != null) artist!];

  @override
  List<String> get tagNames => tags ?? const <String>[];

  @override
  String? get description => desc;

  @override
  int? get chaptersCount => null;

  @override
  double? get latestChapterNum => null;

  @override
  String? get coverImageUrl => cover;

  @override
  List<String> get languages => const <String>[];

  static const AidokuBackupManga Function(Map<String, dynamic> map) fromMap = AidokuBackupMangaMapper.fromMap;
  static const AidokuBackupManga Function(String json) fromJson = AidokuBackupMangaMapper.fromJson;
}
