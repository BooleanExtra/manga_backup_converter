import 'package:dart_mappable/dart_mappable.dart';

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
  final int status;
  final int nsfw;
  final int viewer;
  final int? chapterFlags;
  final String? langFilter;

  AidokuBackupManga({
    required this.id,
    required this.sourceId,
    required this.title,
    required this.author,
    required this.artist,
    required this.desc,
    required this.tags,
    required this.cover,
    required this.url,
    required this.status,
    required this.nsfw,
    required this.viewer,
    required this.chapterFlags,
    required this.langFilter,
  });

  static const fromMap = AidokuBackupMangaMapper.fromMap;
  static const fromJson = AidokuBackupMangaMapper.fromJson;
}
