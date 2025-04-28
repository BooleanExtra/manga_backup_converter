// ignore_for_file: avoid_print

import 'dart:typed_data';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:mangabackupconverter_cli/src/common/aidoku_date_time_mapper.dart';
import 'package:mangabackupconverter_cli/src/common/backup_type.dart';
import 'package:mangabackupconverter_cli/src/common/convertable.dart';
import 'package:mangabackupconverter_cli/src/common/extensions.dart';
import 'package:mangabackupconverter_cli/src/exceptions/aidoku_exception.dart';
import 'package:mangabackupconverter_cli/src/formats/aidoku/aidoku_backup_chapter.dart';
import 'package:mangabackupconverter_cli/src/formats/aidoku/aidoku_backup_history.dart';
import 'package:mangabackupconverter_cli/src/formats/aidoku/aidoku_backup_library_manga.dart';
import 'package:mangabackupconverter_cli/src/formats/aidoku/aidoku_backup_manga.dart';
import 'package:mangabackupconverter_cli/src/formats/aidoku/aidoku_backup_track_item.dart';
import 'package:mangabackupconverter_cli/src/formats/aidoku/aidoku_enums.dart';
import 'package:mangabackupconverter_cli/src/formats/paperback/paperback_backup.dart';
import 'package:mangabackupconverter_cli/src/formats/paperback/paperback_backup_chapter.dart';
import 'package:mangabackupconverter_cli/src/formats/paperback/paperback_backup_chapter_progress_marker.dart';
import 'package:mangabackupconverter_cli/src/formats/paperback/paperback_backup_library_manga.dart';
import 'package:mangabackupconverter_cli/src/formats/paperback/paperback_backup_manga_info.dart';
import 'package:mangabackupconverter_cli/src/formats/paperback/paperback_backup_source_manga.dart';
import 'package:propertylistserialization/propertylistserialization.dart';

part 'aidoku_backup.mapper.dart';

@MappableClass(includeCustomMappers: [AidokuDateTimeMapper()], ignoreNull: true)
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

  static const fromMap = AidokuBackupMapper.fromMap;
  static const fromJson = AidokuBackupMapper.fromJson;

  AidokuBackup mergeWith(AidokuBackup otherBackup) {
    final libraryCombined = <AidokuBackupLibraryManga>{};
    for (final libraryItem in (library ?? <AidokuBackupLibraryManga>{})) {
      final libraryItemDuplicates = _findDuplicates(otherBackup, libraryItem);
      final combinedCategories = {
        ...libraryItem.categories,
        ...libraryItemDuplicates.fold(
          <String>{},
          (previousCategories, libraryItemDuplicate) => {...previousCategories, ...libraryItemDuplicate.categories},
        ),
      };
      if (combinedCategories.isEmpty) {
        combinedCategories.add('Default');
      }
      final latestDateAdded = libraryItemDuplicates.fold(
        libraryItem.dateAdded,
        (previousDateAdded, libraryItem) =>
            previousDateAdded.isAfter(libraryItem.dateAdded) ? previousDateAdded : libraryItem.dateAdded,
      );
      final latestLastOpened = libraryItemDuplicates.fold(
        libraryItem.lastOpened,
        (previousDateOpened, libraryItem) =>
            previousDateOpened.isAfter(libraryItem.lastOpened) ? previousDateOpened : libraryItem.lastOpened,
      );
      final latestLastUpdated = libraryItemDuplicates.fold(
        libraryItem.lastUpdated,
        (previousLastUpdated, libraryItem) =>
            previousLastUpdated.isAfter(libraryItem.lastUpdated) ? previousLastUpdated : libraryItem.lastUpdated,
      );
      final latestLastRead = libraryItemDuplicates.fold(libraryItem.lastRead, (previousLastRead, libraryItem) {
        final otherLastRead = libraryItem.lastRead;
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
    for (final otherLibraryItem in (otherBackup.library ?? <AidokuBackupLibraryManga>{})) {
      if (libraryCombined
          .where(
            (libraryItem) =>
                libraryItem.mangaId == otherLibraryItem.mangaId && libraryItem.sourceId == otherLibraryItem.sourceId,
          )
          .isEmpty) {
        if (otherLibraryItem.categories.isEmpty) {
          otherLibraryItem.categories.add('Default');
        }
        libraryCombined.add(otherLibraryItem);
      }
    }
    final mangaCombined = {
      ...?manga?.map((e) => e.copyWith()).toSet(),
      ...?otherBackup.manga?.map((e) => e.copyWith()).toSet(),
    };
    final historyCombined = {
      ...?history?.map((e) => e.copyWith()).toSet(),
      ...?otherBackup.history?.map((e) => e.copyWith()).toSet(),
    };
    final chaptersCombined = {
      ...?chapters?.map((e) => e.copyWith()).toSet(),
      ...?otherBackup.chapters?.map((e) => e.copyWith()).toSet(),
    };
    final trackItemsCombined = {
      ...?trackItems?.map((e) => e.copyWith()).toSet(),
      ...?otherBackup.trackItems?.map((e) => e.copyWith()).toSet(),
    };
    final combinedCategories = {...?categories, ...?otherBackup.categories};
    if (libraryCombined.where((l) => l.categories.contains('Default')).isNotEmpty) {
      combinedCategories.add('Default');
    }
    return AidokuBackup(
      library: libraryCombined,
      history: historyCombined,
      manga: mangaCombined,
      chapters: chaptersCombined,
      trackItems: trackItemsCombined,
      categories: combinedCategories,
      sources: (sources ?? {})..addAll(otherBackup.sources ?? {}),
      date: DateTime.now(),
      name: name == null ? null : '${name}_MergedWith_${otherBackup.name}',
      version: version ?? otherBackup.version ?? '0.6.10',
    );
  }

  @override
  ConvertableBackup toBackup(BackupType type) {
    // TODO: implement toBackup
    final repoIndex = ExtensionRepoIndex.parseExtensionRepoIndex();
    return switch (type) {
      BackupType.aidoku => this,
      BackupType.paperback =>
        (() {
          final List<PaperbackBackupChapterProgressMarker> chapterProgressMarker = [];
          final List<PaperbackBackupChapter> chapters = [];
          final List<PaperbackBackupLibraryManga> libraryManga = [];
          final List<PaperbackBackupMangaInfo> mangaInfo =
              manga?.map((eachManga) {
                final (source, repo) =
                    repoIndex.findExtension(eachManga.sourceId, ExtensionType.aidoku).firstOrNull ?? (null, null);
                if (source == null) {
                  throw AidokuException('Could not find source for manga ${eachManga.id}');
                }
                final newSource = repoIndex.convertExtension(source, ExtensionType.aidoku, ExtensionType.paperback);
                return PaperbackBackupMangaInfo(
                  tags: [],
                  desc: '',
                  titles: [],
                  covers: [],
                  author: eachManga.author ?? '',
                  image: eachManga.cover ?? '',
                  hentai: eachManga.nsfw == AidokuMangaContentRating.nsfw,
                  additionalInfo: PaperbackBackupMangaAdditionalInfo(),
                  artist: '',
                  id: '',
                  status: '',
                  rating: '',
                  banner: '',
                );
              }).toList() ??
              <PaperbackBackupMangaInfo>[];
          final List<PaperbackBackupSourceManga> sourceManga = [];
          return PaperbackBackup(
            name: name,
            chapterProgressMarker: chapterProgressMarker,
            chapters: chapters,
            libraryManga: libraryManga,
            mangaInfo: mangaInfo,
            sourceManga: sourceManga,
          );
        })(),
      BackupType.tachi => throw const AidokuException('Aidoku backup cannot be converted to Tachi'),
      BackupType.tachimanga => throw const AidokuException('Aidoku backup cannot be converted to TachiManga'),
      BackupType.mangayomi => throw const AidokuException('Aidoku backup cannot be converted to Mangayomi'),
    };
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
  for (final otherLibraryItem in (aidokuBackup.library ?? <AidokuBackupLibraryManga>{})) {
    if (otherLibraryItem.mangaId == libraryItem.mangaId &&
        otherLibraryItem.sourceId == libraryItem.sourceId &&
        libraryItem != otherLibraryItem) {
      duplicates.add(otherLibraryItem);
    }
  }
  return duplicates;
}
