import 'package:collection/collection.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:mangabackupconverter_cli/src/common/aidoku_date_time_mapper.dart';
import 'package:mangabackupconverter_cli/src/common/extensions.dart';
import 'package:mangabackupconverter_cli/src/formats/paperback/paperback_backup_item_reference.dart';
import 'package:mangabackupconverter_cli/src/formats/paperback/paperback_backup_item_type.dart';
import 'package:mangabackupconverter_cli/src/formats/paperback/paperback_backup_library_manga.dart';
import 'package:mangabackupconverter_cli/src/formats/paperback/paperback_backup_library_tab.dart';

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

  PaperbackBackupLibraryManga toPaperbackBackupLibraryManga() {
    final ExtensionRepoIndex extensionRepo = ExtensionRepoIndex.parseExtensionRepoIndex();
    final List<String> categoriesSorted = categories.sorted();
    final List<PaperbackBackupLibraryTab> libraryTabs = categoriesSorted
        .mapIndexed(
          (int index, String category) =>
              PaperbackBackupLibraryTab(id: index.toString(), name: category, sortOrder: index),
        )
        .toList();

    final PaperbackBackupItemReference primarySource = PaperbackBackupItemReference(
      id: extensionRepo
          .convertExtension(Extension(name: sourceId, id: sourceId), ExtensionType.aidoku, ExtensionType.paperback)
          .first
          .$1
          .id,
      type: PaperbackBackupItemType.sourceMangaV4,
    );

    return PaperbackBackupLibraryManga(
      libraryTabs: libraryTabs,
      lastRead: lastRead,
      primarySource: primarySource,
      dateBookmarked: dateAdded,
      trackedSources: <PaperbackBackupItemReference>[],
      id: mangaId,
      secondarySources: <PaperbackBackupItemReference>[],
    );
  }
}
