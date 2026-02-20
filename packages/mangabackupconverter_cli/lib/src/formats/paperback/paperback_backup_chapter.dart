import 'package:dart_mappable/dart_mappable.dart';
import 'package:mangabackupconverter_cli/mangabackupconverter_lib.dart';
import 'package:mangabackupconverter_cli/src/common/seconds_epoc_date_time_mapper.dart';

part 'paperback_backup_chapter.mapper.dart';

@MappableClass(includeCustomMappers: <MapperBase<Object>>[SecondsEpochDateTimeMapper()])
class PaperbackBackupChapter with PaperbackBackupChapterMappable {
  final num volume;
  final String langCode;
  final String group;
  final int sortingIndex;
  final String id;
  final num chapNum;
  final String chapterId;
  final DateTime time;
  final bool isNew;
  final String name;
  final PaperbackBackupItemReference sourceManga;

  PaperbackBackupChapter({
    required this.volume,
    required this.langCode,
    required this.group,
    required this.sortingIndex,
    required this.id,
    required this.chapNum,
    required this.chapterId,
    required this.time,
    required this.isNew,
    required this.name,
    required this.sourceManga,
  });

  static const PaperbackBackupChapter Function(Map<String, dynamic> map) fromMap = PaperbackBackupChapterMapper.fromMap;
  static const PaperbackBackupChapter Function(String json) fromJson = PaperbackBackupChapterMapper.fromJson;
}
