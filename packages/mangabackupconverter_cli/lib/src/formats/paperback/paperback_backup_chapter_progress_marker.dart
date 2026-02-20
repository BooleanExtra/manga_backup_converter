import 'package:dart_mappable/dart_mappable.dart';
import 'package:mangabackupconverter_cli/mangabackupconverter_lib.dart';
import 'package:mangabackupconverter_cli/src/common/seconds_epoc_date_time_mapper.dart';

part 'paperback_backup_chapter_progress_marker.mapper.dart';

@MappableClass(includeCustomMappers: <MapperBase<Object>>[SecondsEpochDateTimeMapper()])
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

  static const PaperbackBackupChapterProgressMarker Function(Map<String, dynamic> map) fromMap =
      PaperbackBackupChapterProgressMarkerMapper.fromMap;
  static const PaperbackBackupChapterProgressMarker Function(String json) fromJson =
      PaperbackBackupChapterProgressMarkerMapper.fromJson;
}
