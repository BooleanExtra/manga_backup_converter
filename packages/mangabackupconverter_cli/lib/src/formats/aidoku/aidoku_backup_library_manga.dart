import 'package:dart_mappable/dart_mappable.dart';
import 'package:mangabackupconverter_cli/src/common/aidoku_date_time_mapper.dart';

part 'aidoku_backup_library_manga.mapper.dart';

@MappableClass(includeCustomMappers: <MapperBase<Object>>[AidokuDateTimeMapper()], ignoreNull: true)
class AidokuBackupLibraryManga with AidokuBackupLibraryMangaMappable {
  final DateTime lastOpened;
  final DateTime lastUpdated;
  final DateTime? lastRead;
  final DateTime dateAdded;
  final List<String> categories;
  final String mangaId;
  final String sourceId;

  AidokuBackupLibraryManga({
    required this.lastOpened,
    required this.lastUpdated,
    required this.lastRead,
    required this.dateAdded,
    required this.categories,
    required this.mangaId,
    required this.sourceId,
  });

  static const AidokuBackupLibraryManga Function(Map<String, dynamic> map) fromMap =
      AidokuBackupLibraryMangaMapper.fromMap;
  static const AidokuBackupLibraryManga Function(String json) fromJson = AidokuBackupLibraryMangaMapper.fromJson;
}
