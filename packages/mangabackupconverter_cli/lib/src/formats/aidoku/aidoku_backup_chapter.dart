import 'package:dart_mappable/dart_mappable.dart';
import 'package:mangabackupconverter_cli/src/common/seconds_epoc_date_time_mapper.dart';

part 'aidoku_backup_chapter.mapper.dart';

@MappableClass(
  includeCustomMappers: [SecondsEpochDateTimeMapper()],
  ignoreNull: true,
)
class AidokuBackupChapter with AidokuBackupChapterMappable {
  final String sourceId;
  final String mangaId;
  final String id;
  final String? title;
  final String? scanlator;
  final String lang;
  final double? chapter;
  final double? volume;
  final DateTime? dateUploaded;
  final int sourceOrder;

  AidokuBackupChapter({
    required this.sourceId,
    required this.mangaId,
    required this.id,
    required this.title,
    required this.scanlator,
    required this.lang,
    required this.chapter,
    required this.volume,
    required this.dateUploaded,
    required this.sourceOrder,
  });

  static const fromMap = AidokuBackupChapterMapper.fromMap;
  static const fromJson = AidokuBackupChapterMapper.fromJson;
}
