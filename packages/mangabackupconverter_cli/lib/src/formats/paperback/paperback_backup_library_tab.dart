import 'package:dart_mappable/dart_mappable.dart';
import 'package:mangabackupconverter_cli/src/common/seconds_epoc_date_time_mapper.dart';

part 'paperback_backup_library_tab.mapper.dart';

@MappableClass(includeCustomMappers: [SecondsEpochDateTimeMapper()])
class PaperbackBackupLibraryTab with PaperbackBackupLibraryTabMappable {
  final int sortOrder;
  final String id;
  final String name;

  PaperbackBackupLibraryTab({required this.sortOrder, required this.id, required this.name});

  static const fromMap = PaperbackBackupLibraryTabMapper.fromMap;
  static const fromJson = PaperbackBackupLibraryTabMapper.fromJson;
}
