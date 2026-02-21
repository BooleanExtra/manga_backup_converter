// ignore_for_file: avoid_print

import 'dart:typed_data';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:mangabackupconverter_cli/src/common/aidoku_date_time_mapper.dart';
import 'package:mangabackupconverter_cli/src/common/convertable.dart';
import 'package:mangabackupconverter_cli/src/exceptions/aidoku_exception.dart';
import 'package:mangabackupconverter_cli/src/formats/aidoku/aidoku_backup_chapter.dart';
import 'package:mangabackupconverter_cli/src/formats/aidoku/aidoku_backup_history.dart';
import 'package:mangabackupconverter_cli/src/formats/aidoku/aidoku_backup_library_manga.dart';
import 'package:mangabackupconverter_cli/src/formats/aidoku/aidoku_backup_manga.dart';
import 'package:mangabackupconverter_cli/src/formats/aidoku/aidoku_backup_track_item.dart';
import 'package:mangabackupconverter_cli/src/pipeline/source_manga_data.dart';
import 'package:propertylistserialization/propertylistserialization.dart';

part 'aidoku_backup.mapper.dart';

@MappableClass(includeCustomMappers: <MapperBase<Object>>[AidokuDateTimeMapper()], ignoreNull: true)
class AidokuBackup with AidokuBackupMappable implements ConvertableBackup {
  final Set<AidokuBackupLibraryManga>? library;
  final Set<AidokuBackupHistory>? history;
  final Set<AidokuBackupManga>? manga;
  final Set<AidokuBackupChapter>? chapters;
  final Set<AidokuBackupTrackItem>? trackItems;
  final Set<String>? categories;
  final Set<String>? sources;
  final DateTime date;
  final String? name;
  final String? version;

  const AidokuBackup({
    required this.library,
    required this.history,
    required this.manga,
    required this.chapters,
    required this.trackItems,
    required this.categories,
    required this.sources,
    required this.date,
    required this.name,
    required this.version,
  });

  static AidokuBackup fromData(Uint8List bytes, {String? overrideName}) {
    final asMap = PropertyListSerialization.propertyListWithData(ByteData.sublistView(bytes)) as Map<String, Object>;
    AidokuBackup backup = fromMap(asMap);
    if (overrideName != null) {
      backup = backup.copyWith(name: overrideName);
    }
    return backup;
  }

  @override
  Future<Uint8List> toData() async {
    try {
      return Uint8List.sublistView(PropertyListSerialization.dataWithPropertyList(toMap()));
    } on PropertyListWriteStreamException catch (e) {
      throw AidokuException(e);
    }
  }

  static const AidokuBackup Function(Map<String, dynamic> map) fromMap = AidokuBackupMapper.fromMap;
  static const AidokuBackup Function(String json) fromJson = AidokuBackupMapper.fromJson;

  AidokuBackup mergeWith(AidokuBackup otherBackup, {bool verbose = false}) {
    final libraryCombined = <AidokuBackupLibraryManga>{};
    var itemsWithoutCategories = 0;
    var itemsWithDuplicates = 0;
    for (final AidokuBackupLibraryManga libraryItem in (library ?? <AidokuBackupLibraryManga>{})) {
      final Set<AidokuBackupLibraryManga> libraryItemDuplicates = _findDuplicates(otherBackup, libraryItem);
      if (libraryItemDuplicates.isNotEmpty) {
        itemsWithDuplicates++;
      }
      final combinedCategories = <String>{
        ...libraryItem.categories,
        ...libraryItemDuplicates.fold(
          <String>{},
          (Iterable<String> previousCategories, AidokuBackupLibraryManga libraryItemDuplicate) => <String>{
            ...previousCategories,
            ...libraryItemDuplicate.categories,
          },
        ),
      };
      if (combinedCategories.isEmpty) {
        itemsWithoutCategories++;
        combinedCategories.add('Default');
      }
      final DateTime latestDateAdded = libraryItemDuplicates.fold(
        libraryItem.dateAdded,
        (DateTime previousDateAdded, AidokuBackupLibraryManga libraryItem) =>
            previousDateAdded.isAfter(libraryItem.dateAdded) ? previousDateAdded : libraryItem.dateAdded,
      );
      final DateTime latestLastOpened = libraryItemDuplicates.fold(
        libraryItem.lastOpened,
        (DateTime previousDateOpened, AidokuBackupLibraryManga libraryItem) =>
            previousDateOpened.isAfter(libraryItem.lastOpened) ? previousDateOpened : libraryItem.lastOpened,
      );
      final DateTime latestLastUpdated = libraryItemDuplicates.fold(
        libraryItem.lastUpdated,
        (DateTime previousLastUpdated, AidokuBackupLibraryManga libraryItem) =>
            previousLastUpdated.isAfter(libraryItem.lastUpdated) ? previousLastUpdated : libraryItem.lastUpdated,
      );
      final DateTime? latestLastRead = libraryItemDuplicates.fold(libraryItem.lastRead, (
        DateTime? previousLastRead,
        AidokuBackupLibraryManga libraryItem,
      ) {
        final DateTime? otherLastRead = libraryItem.lastRead;
        if (previousLastRead == null && otherLastRead == null) {
          return null;
        }
        if (previousLastRead != null && otherLastRead == null) {
          return previousLastRead;
        }
        return switch ((previousLastRead: previousLastRead, otherLastRead: otherLastRead)) {
          _ when otherLastRead == null && previousLastRead == null => null,
          _ when otherLastRead != null && previousLastRead == null => otherLastRead,
          _ when otherLastRead == null && previousLastRead != null => previousLastRead,
          _ when otherLastRead != null && previousLastRead != null =>
            previousLastRead.isAfter(otherLastRead) ? previousLastRead : libraryItem.lastRead,
          (otherLastRead: _, previousLastRead: _) => null,
        };
      });
      libraryCombined.add(
        libraryItem.copyWith(
          categories: combinedCategories.toList(),
          dateAdded: latestDateAdded,
          lastOpened: latestLastOpened,
          lastUpdated: latestLastUpdated,
          lastRead: latestLastRead,
        ),
      );
    }
    if (itemsWithDuplicates > 0 && verbose) {
      print('Found $itemsWithDuplicates library items with duplicates, merging categories and dates.');
    }
    if (itemsWithoutCategories > 0 && verbose) {
      print('Found $itemsWithoutCategories library items without categories, using "Default" category.');
    }
    for (final AidokuBackupLibraryManga otherLibraryItem in (otherBackup.library ?? <AidokuBackupLibraryManga>{})) {
      if (libraryCombined
          .where(
            (AidokuBackupLibraryManga libraryItem) =>
                libraryItem.mangaId == otherLibraryItem.mangaId && libraryItem.sourceId == otherLibraryItem.sourceId,
          )
          .isEmpty) {
        if (otherLibraryItem.categories.isEmpty) {
          otherLibraryItem.categories.add('Default');
        }
        libraryCombined.add(otherLibraryItem);
      }
    }
    final mangaCombined = <AidokuBackupManga>{
      ...?manga?.map((AidokuBackupManga e) => e.copyWith()).toSet(),
      ...?otherBackup.manga?.map((AidokuBackupManga e) => e.copyWith()).toSet(),
    };
    final historyCombined = <AidokuBackupHistory>{
      ...?history?.map((AidokuBackupHistory e) => e.copyWith()).toSet(),
      ...?otherBackup.history?.map((AidokuBackupHistory e) => e.copyWith()).toSet(),
    };
    final chaptersCombined = <AidokuBackupChapter>{
      ...?chapters?.map((AidokuBackupChapter e) => e.copyWith()).toSet(),
      ...?otherBackup.chapters?.map((AidokuBackupChapter e) => e.copyWith()).toSet(),
    };
    final trackItemsCombined = <AidokuBackupTrackItem>{
      ...?trackItems?.map((AidokuBackupTrackItem e) => e.copyWith()).toSet(),
      ...?otherBackup.trackItems?.map((AidokuBackupTrackItem e) => e.copyWith()).toSet(),
    };
    final combinedCategories = <String>{...?categories, ...?otherBackup.categories};
    if (libraryCombined.where((AidokuBackupLibraryManga l) => l.categories.contains('Default')).isNotEmpty) {
      combinedCategories.add('Default');
    }
    return AidokuBackup(
      library: libraryCombined,
      history: historyCombined,
      manga: mangaCombined,
      chapters: chaptersCombined,
      trackItems: trackItemsCombined,
      categories: combinedCategories,
      sources: (sources ?? <String>{})..addAll(otherBackup.sources ?? <String>{}),
      date: DateTime.now(),
      name: name == null ? null : '${name}_MergedWith_${otherBackup.name}',
      version: version ?? otherBackup.version ?? '0.6.10',
    );
  }

  @override
  List<AidokuBackupManga> get mangaSearchEntries => manga?.toList() ?? const <AidokuBackupManga>[];

  @override
  List<SourceMangaData> get sourceMangaDataEntries {
    return (manga ?? <AidokuBackupManga>{}).map((AidokuBackupManga m) {
      final AidokuBackupLibraryManga? libraryEntry = library?.where(
        (AidokuBackupLibraryManga l) => l.sourceId == m.sourceId && l.mangaId == m.id,
      ).firstOrNull;

      final List<AidokuBackupChapter> mangaChapters = (chapters ?? <AidokuBackupChapter>{}).where(
        (AidokuBackupChapter c) => c.sourceId == m.sourceId && c.mangaId == m.id,
      ).toList();

      final List<AidokuBackupHistory> mangaHistory = (history ?? <AidokuBackupHistory>{}).where(
        (AidokuBackupHistory h) => h.sourceId == m.sourceId && h.mangaId == m.id,
      ).toList();

      final List<AidokuBackupTrackItem> mangaTracks = (trackItems ?? <AidokuBackupTrackItem>{}).where(
        (AidokuBackupTrackItem t) => t.sourceId == m.sourceId && t.mangaId == m.id,
      ).toList();

      return SourceMangaData(
        details: m.toMangaSearchDetails(),
        categories: libraryEntry?.categories ?? const <String>[],
        chapters: mangaChapters.map((AidokuBackupChapter c) {
          final bool isRead = mangaHistory.any(
            (AidokuBackupHistory h) => h.chapterId == c.id && h.completed,
          );
          return SourceChapter(
            title: c.title ?? '',
            chapterNumber: c.chapter,
            volumeNumber: c.volume,
            scanlator: c.scanlator,
            language: c.lang,
            isRead: isRead,
            dateUploaded: c.dateUploaded,
            sourceOrder: c.sourceOrder,
          );
        }).toList(),
        history: mangaHistory.map((AidokuBackupHistory h) {
          final AidokuBackupChapter? ch = mangaChapters.where(
            (AidokuBackupChapter c) => c.id == h.chapterId,
          ).firstOrNull;
          return SourceHistoryEntry(
            chapterTitle: ch?.title ?? h.chapterId,
            chapterNumber: ch?.chapter,
            dateRead: h.dateRead,
            completed: h.completed,
            progress: h.progress,
            total: h.total,
          );
        }).toList(),
        tracking: mangaTracks.map((AidokuBackupTrackItem t) {
          return SourceTrackingEntry(
            syncId: int.tryParse(t.trackerId) ?? 0,
            title: t.title,
          );
        }).toList(),
        dateAdded: libraryEntry?.dateAdded,
        lastRead: libraryEntry?.lastRead,
        status: m.status.index,
      );
    }).toList();
  }

  @override
  void verbosePrint(bool verbose) {
    if (!verbose) return;

    print('Library Manga: ${library?.length}');
    print('Manga: ${manga?.length}');
    print('Chapters: ${chapters?.length}');
    print('Manga History: ${history?.length}');
    print('Tracked Manga Items: ${trackItems?.length}');
    print('Categories: ${categories?.length}');
    print('Sources: ${sources?.length}');
    print('Aidoku Backup Name: $name');
    print('Aidoku Version: $version');
  }
}

Set<AidokuBackupLibraryManga> _findDuplicates(AidokuBackup aidokuBackup, AidokuBackupLibraryManga libraryItem) {
  final duplicates = <AidokuBackupLibraryManga>{};
  for (final AidokuBackupLibraryManga otherLibraryItem in (aidokuBackup.library ?? <AidokuBackupLibraryManga>{})) {
    if (otherLibraryItem.mangaId == libraryItem.mangaId &&
        otherLibraryItem.sourceId == libraryItem.sourceId &&
        libraryItem != otherLibraryItem) {
      duplicates.add(otherLibraryItem);
    }
  }
  return duplicates;
}
