import 'package:dart_mappable/dart_mappable.dart';
import 'package:mangabackupconverter_cli/src/formats/aidoku/aidoku_enums.dart';
import 'package:mangabackupconverter_cli/src/formats/paperback/paperback_backup_manga_info.dart';

part 'aidoku_backup_manga.mapper.dart';

@MappableClass(ignoreNull: true)
class AidokuBackupManga with AidokuBackupMangaMappable {
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

  PaperbackBackupMangaInfo toPaperbackMangaInfo() {
    final mangaCover = cover;
    return PaperbackBackupMangaInfo(
      tags: (tags ?? <String>[]).map((tag) => PaperbackBackupMangaTag(label: tag, id: tag)).toList(),
      desc: desc ?? '',
      titles: [title],
      covers: mangaCover == null ? [] : [mangaCover],
      author: author ?? '',
      image: cover ?? '',
      hentai: nsfw == AidokuMangaContentRating.nsfw,
      additionalInfo: PaperbackBackupMangaAdditionalInfo(),
      artist: artist ?? '',
      id: id,
      status: PaperbackBackupMangaInfo.statusFromAidoku(status),
    );
  }

  static const fromMap = AidokuBackupMangaMapper.fromMap;
  static const fromJson = AidokuBackupMangaMapper.fromJson;
}
