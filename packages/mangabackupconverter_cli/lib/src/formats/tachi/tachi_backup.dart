// ignore_for_file: unused_import, avoid_print

import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:mangabackupconverter_cli/src/common/convertable.dart';
import 'package:mangabackupconverter_cli/src/common/seconds_epoc_date_time_mapper.dart';
import 'package:mangabackupconverter_cli/src/exceptions/tachi_exception.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_backup_category.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_backup_chapter.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_backup_extension_repo.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_backup_history.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_backup_manga.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_backup_preference.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_backup_source.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_backup_source_preferences.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_backup_tracking.dart';
import 'package:mangabackupconverter_cli/src/formats/tachimanga/tachimanga_backup.dart';
import 'package:mangabackupconverter_cli/src/formats/tachimanga/tachimanga_backup_db.dart';
import 'package:mangabackupconverter_cli/src/formats/tachimanga/tachimanga_backup_db_models.dart';
import 'package:mangabackupconverter_cli/src/formats/tachimanga/tachimanga_backup_meta.dart';
import 'package:mangabackupconverter_cli/src/pipeline/backup_format.dart';
import 'package:mangabackupconverter_cli/src/pipeline/source_manga_data.dart';
import 'package:mangabackupconverter_cli/src/proto/schema_j2k.proto/proto/schema_j2k.pb.dart' as j2k;
import 'package:mangabackupconverter_cli/src/proto/schema_mihon.proto/proto/schema_mihon.pb.dart' as mihon;
import 'package:mangabackupconverter_cli/src/proto/schema_neko.proto/proto/schema_neko.pb.dart' as neko;
import 'package:mangabackupconverter_cli/src/proto/schema_sy.proto/proto/schema_sy.pb.dart' as sy;
import 'package:mangabackupconverter_cli/src/proto/schema_yokai.proto/proto/schema_yokai.pb.dart' as yokai;
import 'package:meta/meta.dart';
import 'package:protobuf/protobuf.dart';

part 'tachi_backup.mapper.dart';

@MappableClass(includeCustomMappers: <MapperBase<Object>>[SecondsEpochDateTimeMapper()])
class TachiBackup with TachiBackupMappable implements ConvertableBackup {
  final Tachiyomi format;
  final List<TachiBackupSource> backupBrokenSources;
  final List<TachiBackupSource> backupSources;
  final List<TachiBackupCategory> backupCategories;
  final List<TachiBackupExtensionRepo> backupExtensionRepo;
  final List<TachiBackupManga> backupManga;
  final List<TachiBackupPreference> backupPreferences;
  final List<TachiBackupSourcePreferences> backupSourcePreferences;

  const TachiBackup({
    this.backupCategories = const <TachiBackupCategory>[],
    this.backupManga = const <TachiBackupManga>[],
    this.backupBrokenSources = const <TachiBackupSource>[],
    this.backupSources = const <TachiBackupSource>[],
    this.backupExtensionRepo = const <TachiBackupExtensionRepo>[],
    this.backupPreferences = const <TachiBackupPreference>[],
    this.backupSourcePreferences = const <TachiBackupSourcePreferences>[],
    this.format = const Mihon(),
  });

  factory TachiBackup._fromMihon({required mihon.Backup backup}) {
    return TachiBackup(
      backupSources: backup.backupSources.map(TachiBackupSource.fromMihon).toList(),
      backupCategories: backup.backupCategories.map(TachiBackupCategory.fromMihon).toList(),
      backupManga: backup.backupManga.map(TachiBackupManga.fromMihon).toList(),
      backupExtensionRepo: backup.backupExtensionRepo.map(TachiBackupExtensionRepo.fromMihon).toList(),
      backupPreferences: backup.backupPreferences.map(TachiBackupPreference.fromMihon).toList(),
      backupSourcePreferences: backup.backupSourcePreferences.map(TachiBackupSourcePreferences.fromMihon).toList(),
    );
  }

  factory TachiBackup._fromSy({required sy.Backup backup}) {
    return TachiBackup(
      format: const TachiSy(),
      backupSources: backup.backupSources.map(TachiBackupSource.fromSy).toList(),
      backupCategories: backup.backupCategories.map(TachiBackupCategory.fromSy).toList(),
      backupManga: backup.backupManga.map(TachiBackupManga.fromSy).toList(),
      backupExtensionRepo: backup.backupExtensionRepo.map(TachiBackupExtensionRepo.fromSy).toList(),
      backupPreferences: backup.backupPreferences.map(TachiBackupPreference.fromSy).toList(),
      backupSourcePreferences: backup.backupSourcePreferences.map(TachiBackupSourcePreferences.fromSy).toList(),
    );
  }

  factory TachiBackup._fromNeko({required neko.Backup backup}) {
    return TachiBackup(
      format: const TachiNeko(),
      backupCategories: backup.backupCategories.map(TachiBackupCategory.fromNeko).toList(),
      backupManga: backup.backupManga.map(TachiBackupManga.fromNeko).toList(),
    );
  }

  factory TachiBackup._fromJ2k({required j2k.Backup backup}) {
    return TachiBackup(
      format: const TachiJ2k(),
      backupSources: backup.backupSources.map(TachiBackupSource.fromJ2k).toList(),
      backupCategories: backup.backupCategories.map(TachiBackupCategory.fromJ2k).toList(),
      backupManga: backup.backupManga.map(TachiBackupManga.fromJ2k).toList(),
    );
  }

  factory TachiBackup._fromYokai({required yokai.Backup backup}) {
    return TachiBackup(
      format: const TachiYokai(),
      backupSources: backup.backupSources.map(TachiBackupSource.fromYokai).toList(),
      backupCategories: backup.backupCategories.map(TachiBackupCategory.fromYokai).toList(),
      backupManga: backup.backupManga.map(TachiBackupManga.fromYokai).toList(),
    );
  }

  factory TachiBackup.fromData(Uint8List bytes, {Tachiyomi format = const Mihon()}) {
    final Uint8List backupArchive = const GZipDecoder().decodeBytes(bytes);
    return switch (format) {
      Mihon() => TachiBackup._fromMihon(backup: mihon.Backup.fromBuffer(backupArchive)),
      TachiSy() => TachiBackup._fromSy(backup: sy.Backup.fromBuffer(backupArchive)),
      TachiJ2k() => TachiBackup._fromJ2k(backup: j2k.Backup.fromBuffer(backupArchive)),
      TachiYokai() => TachiBackup._fromYokai(backup: yokai.Backup.fromBuffer(backupArchive)),
      TachiNeko() => TachiBackup._fromNeko(backup: neko.Backup.fromBuffer(backupArchive)),
    };
  }

  @override
  Future<Uint8List> toData() async {
    final String json = toJson();
    final Uint8List backupBytes = switch (format) {
      Mihon() => mihon.Backup.fromJson(json).writeToBuffer(),
      TachiSy() => sy.Backup.fromJson(json).writeToBuffer(),
      TachiJ2k() => j2k.Backup.fromJson(json).writeToBuffer(),
      TachiYokai() => yokai.Backup.fromJson(json).writeToBuffer(),
      TachiNeko() => neko.Backup.fromJson(json).writeToBuffer(),
    };
    return const GZipEncoder().encodeBytes(backupBytes);
  }

  @override
  List<TachiBackupManga> get mangaSearchEntries => backupManga;

  @override
  List<SourceMangaData> get sourceMangaDataEntries {
    return backupManga.map((TachiBackupManga manga) {
      final List<String> categoryNames = manga.categories.map((int idx) {
        if (idx >= 0 && idx < backupCategories.length) {
          return backupCategories[idx].name;
        }
        return 'Category $idx';
      }).toList();

      final String? sourceName = <TachiBackupSource>[
        ...backupSources,
        ...backupBrokenSources,
      ].where((TachiBackupSource s) => s.sourceId == manga.source).map((TachiBackupSource s) => s.name).firstOrNull;

      return SourceMangaData(
        details: manga.toMangaSearchDetails(),
        sourceId: sourceName ?? 'Source ${manga.source}',
        categories: categoryNames,
        chapters: manga.chapters.map((TachiBackupChapter c) {
          return SourceChapter(
            title: c.name,
            chapterNumber: c.chapterNumber,
            scanlator: c.scanlator.isEmpty ? null : c.scanlator,
            isRead: c.read,
            isBookmarked: c.bookmark,
            lastPageRead: c.lastPageRead,
            dateUploaded: c.dateUpload > 0 ? DateTime.fromMillisecondsSinceEpoch(c.dateUpload) : null,
            sourceOrder: c.sourceOrder,
          );
        }).toList(),
        history: manga.history.map((TachiBackupHistory h) {
          final TachiBackupChapter? ch = manga.chapters
              .where(
                (TachiBackupChapter c) => c.url == h.url,
              )
              .firstOrNull;
          return SourceHistoryEntry(
            chapterTitle: ch?.name ?? h.url,
            chapterNumber: ch?.chapterNumber,
            dateRead: h.lastRead > 0 ? DateTime.fromMillisecondsSinceEpoch(h.lastRead) : null,
            completed: ch?.read ?? false,
          );
        }).toList(),
        tracking: manga.tracking.map((TachiBackupTracking t) {
          return SourceTrackingEntry(
            syncId: t.syncId,
            libraryId: t.libraryId,
            mediaId: t.mediaId,
            trackingUrl: t.trackingUrl,
            title: t.title,
            lastChapterRead: t.lastChapterRead,
            totalChapters: t.totalChapters,
            score: t.score,
            status: t.status,
            startedReadingDate: t.startedReadingDate > 0
                ? DateTime.fromMillisecondsSinceEpoch(t.startedReadingDate)
                : null,
            finishedReadingDate: t.finishedReadingDate > 0
                ? DateTime.fromMillisecondsSinceEpoch(t.finishedReadingDate)
                : null,
          );
        }).toList(),
        dateAdded: manga.dateAdded > 0 ? DateTime.fromMillisecondsSinceEpoch(manga.dateAdded) : null,
        lastUpdated: (manga.lastModifiedAt ?? 0) > 0
            ? DateTime.fromMillisecondsSinceEpoch(manga.lastModifiedAt!)
            : null,
        status: manga.status,
      );
    }).toList();
  }

  static const TachiBackup Function(Map<String, dynamic> map) fromMap = TachiBackupMapper.fromMap;
  static const TachiBackup Function(String json) fromJson = TachiBackupMapper.fromJson;

  TachimangaBackup toTachimangaBackup() {
    // Categories — sequential IDs starting at 1
    final categoryTable = <TachimangaBackupCategory>[
      for (var i = 0; i < backupCategories.length; i++)
        TachimangaBackupCategory(
          id: i + 1,
          name: backupCategories[i].name,
          order: backupCategories[i].order,
          isDefault: false,
        ),
    ];

    // Manga — sequential IDs starting at 1
    final mangaTable = <TachimangaBackupManga>[];
    final chapterTable = <TachimangaBackupChapter>[];
    final categoryMangaTable = <TachimangaBackupCategoryManga>[];
    final historyTable = <TachimangaBackupHistory>[];
    final trackRecordTable = <TachimangaBackupTrackRecord>[];

    var chapterId = 1;
    var categoryMangaId = 1;
    var historyId = 1;
    var trackId = 1;

    for (var mangaIdx = 0; mangaIdx < backupManga.length; mangaIdx++) {
      final TachiBackupManga manga = backupManga[mangaIdx];
      final int mangaId = mangaIdx + 1;

      mangaTable.add(
        TachimangaBackupManga(
          id: mangaId,
          url: manga.url,
          title: manga.title,
          initialized: true,
          artist: manga.artist.isEmpty ? null : manga.artist,
          author: manga.author.isEmpty ? null : manga.author,
          description: manga.description.isEmpty ? null : manga.description,
          genre: manga.genre.isEmpty ? null : manga.genre.join(', '),
          status: manga.status,
          thumbnailUrl: manga.thumbnailUrl.isEmpty ? null : manga.thumbnailUrl,
          thumbnailUrlLastFetched: 0,
          inLibrary: true,
          defaultCategory: false,
          inLibraryAt: manga.dateAdded,
          source: manga.source,
          realUrl: null,
          lastFetchedAt: 0,
          chaptersLastFetchedAt: 0,
          updateStrategy: manga.updateStrategy.index.toString(),
          lastDownloadAt: 0,
        ),
      );

      // Chapters — build URL→chapterId map for history lookup
      final chapterUrlToId = <String, int>{};
      for (final TachiBackupChapter ch in manga.chapters) {
        final int id = chapterId++;
        chapterUrlToId[ch.url] = id;
        chapterTable.add(
          TachimangaBackupChapter(
            id: id,
            url: ch.url,
            name: ch.name,
            dateUpload: ch.dateUpload,
            chapterNumber: ch.chapterNumber,
            scanlator: ch.scanlator.isEmpty ? null : ch.scanlator,
            read: ch.read,
            bookmark: ch.bookmark,
            lastPageRead: ch.lastPageRead,
            lastReadAt: ch.lastModifiedAt ?? 0,
            fetchedAt: ch.dateFetch,
            sourceOrder: ch.sourceOrder,
            realUrl: null,
            isDownloaded: false,
            pageCount: 0,
            manga: mangaId,
          ),
        );
      }

      // CategoryManga junction
      for (final int catIdx in manga.categories) {
        categoryMangaTable.add(
          TachimangaBackupCategoryManga(
            id: categoryMangaId++,
            category: catIdx + 1,
            manga: mangaId,
          ),
        );
      }

      // History — Tachimanga has UNIQUE(manga_id), so collapse all
      // per-chapter history entries into one row per manga: latest chapter
      // by lastRead timestamp, summed readDuration.
      if (manga.history.isNotEmpty) {
        final TachiBackupHistory latestHistory = manga.history.reduce(
          (TachiBackupHistory a, TachiBackupHistory b) => a.lastRead >= b.lastRead ? a : b,
        );
        final int totalDuration = manga.history.fold<int>(
          0,
          (int sum, TachiBackupHistory h) => sum + h.readDuration,
        );
        historyTable.add(
          TachimangaBackupHistory(
            id: historyId++,
            createAt: 0,
            isDelete: false,
            mangaId: mangaId,
            lastChapterId: chapterUrlToId[latestHistory.url] ?? 0,
            lastReadAt: totalDuration,
          ),
        );
      }

      // Tracking
      for (final TachiBackupTracking t in manga.tracking) {
        trackRecordTable.add(
          TachimangaBackupTrackRecord(
            id: trackId++,
            mangaId: mangaId,
            syncId: t.syncId,
            remoteId: t.mediaId,
            libraryId: t.libraryId == -1 ? null : t.libraryId,
            title: t.title,
            lastChapterRead: t.lastChapterRead,
            totalChapters: t.totalChapters,
            status: t.status,
            score: t.score,
            remoteUrl: t.trackingUrl,
            startDate: t.startedReadingDate,
            finishDate: t.finishedReadingDate,
          ),
        );
      }
    }

    // Sources
    final sourceTable = <TachimangaBackupSource>[
      for (final TachiBackupSource s in <TachiBackupSource>[...backupSources, ...backupBrokenSources])
        TachimangaBackupSource(
          id: s.sourceId,
          name: s.name,
          lang: '',
          extension: 0,
          isNsfw: false,
          isDirect: null,
          randomUa: null,
        ),
    ];

    // Repos
    final repoTable = <TachimangaBackupRepo>[
      for (var i = 0; i < backupExtensionRepo.length; i++)
        TachimangaBackupRepo(
          id: i + 1,
          type: 0,
          name: backupExtensionRepo[i].name,
          metaUrl: '',
          baseUrl: backupExtensionRepo[i].baseUrl,
          homepage: backupExtensionRepo[i].website,
          deleted: false,
          createAt: 0,
          updateAt: 0,
        ),
    ];

    return TachimangaBackup(
      meta: TachimangaBackupMeta(
        name: 'Converted Backup',
        remoteBackup: false,
        downloaded: false,
        backupId: 0,
        updateAt: 0,
        type: 0,
        size: 0,
        checksum: '',
        createAt: 0,
        cloudBackup: false,
        version: 1,
        downloadProgress: 0,
        state: 0,
        extInfo: null,
      ),
      db: TachimangaBackupDb(
        categoryTable: categoryTable,
        categoryMangaTable: categoryMangaTable,
        categoryMetaTable: const <TachimangaBackupCategoryMeta>[],
        chapterTable: chapterTable,
        chapterMetaTable: const <TachimangaBackupChapterMeta>[],
        extensionTable: const <TachimangaBackupExtension>[],
        historyTable: historyTable,
        mangaTable: mangaTable,
        mangaMetaTable: const <TachimangaBackupMangaMeta>[],
        migrationsTable: const <TachimangaBackupDbMigrations>[],
        pageTable: const <TachimangaBackupPage>[],
        repoTable: repoTable,
        settingTable: const <TachimangaBackupSetting>[],
        sourceTable: sourceTable,
        trackRecordTable: trackRecordTable,
        sqliteSequenceTable: const <TachimangaBackupSqliteSequence>[],
      ),
    );
  }

  @override
  void verbosePrint(bool verbose) {
    if (!verbose) return;
    print('Categories: ${backupCategories.length}');
    print('Manga: ${backupManga.length}');
    print('Sources: ${backupSources.length}');
    print('Extension Repos: ${backupExtensionRepo.length}');
  }
}
