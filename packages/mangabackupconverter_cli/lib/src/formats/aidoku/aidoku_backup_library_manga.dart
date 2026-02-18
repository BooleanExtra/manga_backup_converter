import 'package:collection/collection.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:mangabackupconverter_cli/src/common/aidoku_date_time_mapper.dart';
import 'package:mangabackupconverter_cli/src/common/extensions.dart';
import 'package:mangabackupconverter_cli/src/formats/paperback/paperback_backup_item_reference.dart';
import 'package:mangabackupconverter_cli/src/formats/paperback/paperback_backup_item_type.dart';
import 'package:mangabackupconverter_cli/src/formats/paperback/paperback_backup_library_manga.dart';
import 'package:mangabackupconverter_cli/src/formats/paperback/paperback_backup_library_tab.dart';

part 'aidoku_backup_library_manga.mapper.dart';

@MappableClass(includeCustomMappers: [AidokuDateTimeMapper()], ignoreNull: true)
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

  static const fromMap = AidokuBackupLibraryMangaMapper.fromMap;
  static const fromJson = AidokuBackupLibraryMangaMapper.fromJson;

  PaperbackBackupLibraryManga toPaperbackBackupLibraryManga() {
    final extensionRepo = ExtensionRepoIndex.parseExtensionRepoIndex();
    final categoriesSorted = categories.sorted();
    final libraryTabs = categoriesSorted
        .mapIndexed(
          (index, category) => PaperbackBackupLibraryTab(id: index.toString(), name: category, sortOrder: index),
        )
        .toList();

    final primarySource = PaperbackBackupItemReference(
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
      trackedSources: [],
      id: mangaId,
      secondarySources: [],
    );
  }
}
