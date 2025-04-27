import 'package:dart_mappable/dart_mappable.dart';
import 'package:mangabackupconverter_cli/mangabackupconverter_lib.dart';
import 'package:mangabackupconverter_cli/src/common/seconds_epoc_date_time_mapper.dart';

part 'paperback_backup_chapter_progress_marker.mapper.dart';

@MappableClass(includeCustomMappers: [SecondsEpochDateTimeMapper()])
class PaperbackBackupChapterProgressMarker with PaperbackBackupChapterProgressMarkerMappable {
  final int totalPages;
  final bool completed;
  final PaperbackBackupItemReference chapter;
  final int lastPage;
  final DateTime time;
  final bool hidden;

  PaperbackBackupChapterProgressMarker({
    required this.totalPages,
    required this.completed,
    required this.chapter,
    required this.lastPage,
    required this.time,
    required this.hidden,
  });

  static const fromMap = PaperbackBackupChapterProgressMarkerMapper.fromMap;
  static const fromJson = PaperbackBackupChapterProgressMarkerMapper.fromJson;
}
