import 'package:dart_mappable/dart_mappable.dart';
import 'package:mangabackupconverter_cli/src/common/seconds_epoc_date_time_mapper.dart';
import 'package:mangabackupconverter_cli/src/formats/paperback/paperback_backup_item_reference.dart';
import 'package:mangabackupconverter_cli/src/formats/paperback/paperback_backup_library_tab.dart';

part 'paperback_backup_library_manga.mapper.dart';

@MappableClass(includeCustomMappers: <MapperBase<Object>>[SecondsEpochDateTimeMapper()])
class PaperbackBackupLibraryManga with PaperbackBackupLibraryMangaMappable {
  final List<PaperbackBackupLibraryTab> libraryTabs;
  final DateTime? lastRead;
  final PaperbackBackupItemReference primarySource;
  final DateTime? dateBookmarked;
  final List<PaperbackBackupItemReference> trackedSources;
  final String id;
  final List<PaperbackBackupItemReference> secondarySources;

  PaperbackBackupLibraryManga({
    required this.libraryTabs,
    required this.lastRead,
    required this.primarySource,
    required this.dateBookmarked,
    required this.trackedSources,
    required this.id,
    required this.secondarySources,
  });

  static const PaperbackBackupLibraryManga Function(Map<String, dynamic> map) fromMap =
      PaperbackBackupLibraryMangaMapper.fromMap;
  static const PaperbackBackupLibraryManga Function(String json) fromJson = PaperbackBackupLibraryMangaMapper.fromJson;
}
