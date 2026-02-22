// ignore_for_file: avoid_print, avoid_redundant_argument_values

import 'dart:convert' show jsonDecode, jsonEncode;
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:mangabackupconverter_cli/src/common/convertable.dart';
import 'package:mangabackupconverter_cli/src/common/seconds_epoc_date_time_mapper.dart';
import 'package:mangabackupconverter_cli/src/exceptions/mangayomi_exception.dart';
import 'package:mangabackupconverter_cli/src/formats/mangayomi/mangayomi_backup_db.dart';
import 'package:mangabackupconverter_cli/src/pipeline/source_manga_data.dart';
import 'package:path/path.dart' as p;

part 'mangayomi_backup.mapper.dart';

@MappableClass(includeCustomMappers: <MapperBase<Object>>[SecondsEpochDateTimeMapper()], caseStyle: CaseStyle.camelCase)
class MangayomiBackup with MangayomiBackupMappable implements ConvertableBackup {
  final String? name;
  final MangayomiBackupDb db;

  const MangayomiBackup({required this.db, this.name});

  factory MangayomiBackup.fromData(Uint8List bytes, {String? overrideName}) {
    final Archive backupArchive = ZipDecoder().decodeBytes(bytes);
    final ArchiveFile? backupJsonFile = backupArchive.files
        .where((ArchiveFile file) => file.name.endsWith('.db'))
        .firstOrNull;
    if (backupJsonFile == null) {
      throw const MangayomiException('Could not decode Mangayomi backup');
    }
    final String backupName = p.basenameWithoutExtension(backupJsonFile.name);
    final backupJson = String.fromCharCodes(backupJsonFile.content);
    final backupMap = jsonDecode(backupJson) as Map<String, dynamic>?;
    if (backupMap == null) {
      throw const MangayomiException('Could not decode Mangayomi backup');
    }
    final MangayomiBackupDb db = MangayomiBackupDb.fromMap(backupMap);

    return MangayomiBackup(name: overrideName ?? backupName, db: db);
  }

  static const MangayomiBackup Function(Map<String, dynamic> map) fromMap = MangayomiBackupMapper.fromMap;
  static const MangayomiBackup Function(String json) fromJson = MangayomiBackupMapper.fromJson;

  @override
  List<MangayomiBackupManga> get mangaSearchEntries => db.manga ?? const <MangayomiBackupManga>[];

  @override
  List<SourceMangaData> get sourceMangaDataEntries {
    final List<MangayomiBackupManga> allManga = db.manga ?? const <MangayomiBackupManga>[];
    final List<MangayomiBackupChapter> allChapters = db.chapters ?? const <MangayomiBackupChapter>[];
    final List<MangayomiBackupHistory> allHistory = db.history ?? const <MangayomiBackupHistory>[];
    final List<MangayomiBackupTrack> allTracks = db.tracks ?? const <MangayomiBackupTrack>[];
    final List<MangayomiBackupCategory> allCategories = db.categories ?? const <MangayomiBackupCategory>[];

    return allManga.map((MangayomiBackupManga manga) {
      final int? mangaId = manga.id;

      final List<MangayomiBackupChapter> mangaChapters = allChapters
          .where(
            (MangayomiBackupChapter c) => c.mangaId == mangaId,
          )
          .toList();

      final List<MangayomiBackupHistory> mangaHistory = allHistory
          .where(
            (MangayomiBackupHistory h) => h.mangaId == mangaId,
          )
          .toList();

      final List<MangayomiBackupTrack> mangaTracks = allTracks
          .where(
            (MangayomiBackupTrack t) => t.mangaId == mangaId,
          )
          .toList();

      // Parse comma-separated category IDs from manga.categories
      final List<String> categoryNames;
      final String? categoriesStr = manga.categories;
      if (categoriesStr != null && categoriesStr.isNotEmpty) {
        final List<int?> categoryIds = categoriesStr
            .split(',')
            .map(
              (String s) => int.tryParse(s.trim()),
            )
            .toList();
        categoryNames = categoryIds
            .map((int? id) {
              if (id == null) return null;
              final MangayomiBackupCategory? cat = allCategories
                  .where(
                    (MangayomiBackupCategory c) => c.id == id,
                  )
                  .firstOrNull;
              return cat?.name;
            })
            .whereType<String>()
            .toList();
      } else {
        categoryNames = const <String>[];
      }

      return SourceMangaData(
        details: manga.toMangaSearchDetails(),
        sourceId: manga.source,
        categories: categoryNames,
        chapters: mangaChapters.map((MangayomiBackupChapter c) {
          return SourceChapter(
            title: c.name ?? '',
            isRead: c.isRead ?? false,
            isBookmarked: c.isBookmarked ?? false,
            lastPageRead: int.tryParse(c.lastPageRead ?? '') ?? 0,
            scanlator: (c.scanlator?.isEmpty ?? true) ? null : c.scanlator,
            dateUploaded: _tryParseDate(c.dateUpload),
          );
        }).toList(),
        history: mangaHistory.map((MangayomiBackupHistory h) {
          final MangayomiBackupChapter? ch = mangaChapters
              .where(
                (MangayomiBackupChapter c) => c.id == h.chapterId,
              )
              .firstOrNull;
          return SourceHistoryEntry(
            chapterTitle: ch?.name ?? 'Chapter ${h.chapterId}',
            dateRead: _tryParseDate(h.date),
            completed: ch?.isRead ?? false,
          );
        }).toList(),
        tracking: mangaTracks.map((MangayomiBackupTrack t) {
          return SourceTrackingEntry(
            syncId: t.syncId ?? 0,
            libraryId: t.libraryId,
            mediaId: t.mediaId,
            trackingUrl: t.trackingUrl,
            title: t.title,
            lastChapterRead: t.lastChapterRead?.toDouble(),
            totalChapters: t.totalChapter,
            score: t.score?.toDouble(),
            status: t.status,
            startedReadingDate: t.startedReadingDate != null && t.startedReadingDate! > 0
                ? DateTime.fromMillisecondsSinceEpoch(t.startedReadingDate!)
                : null,
            finishedReadingDate: t.finishedReadingDate != null && t.finishedReadingDate! > 0
                ? DateTime.fromMillisecondsSinceEpoch(t.finishedReadingDate!)
                : null,
          );
        }).toList(),
        dateAdded: manga.dateAdded != null && manga.dateAdded! > 0
            ? DateTime.fromMillisecondsSinceEpoch(manga.dateAdded!)
            : null,
        lastRead: manga.lastRead != null && manga.lastRead! > 0
            ? DateTime.fromMillisecondsSinceEpoch(manga.lastRead!)
            : null,
        status: manga.status,
      );
    }).toList();
  }

  static DateTime? _tryParseDate(String? value) {
    if (value == null || value.isEmpty) return null;
    final int? millis = int.tryParse(value);
    if (millis != null && millis > 0) return DateTime.fromMillisecondsSinceEpoch(millis);
    return DateTime.tryParse(value);
  }

  @override
  Future<Uint8List> toData() async {
    final archive = Archive();
    final List<int> dbJson = jsonEncode(db.toMap()).codeUnits;
    archive.addFile(ArchiveFile('$name.db', dbJson.length, dbJson));
    return ZipEncoder().encodeBytes(archive);
  }

  @override
  void verbosePrint(bool verbose) {
    if (!verbose) return;

    print('Mangayomi name: $name');
    print('Manga: ${db.manga?.length}');
    print('Categories: ${db.categories?.length}');
    print('Chapters: ${db.chapters?.length}');
    print('Downloads: ${db.downloads?.length}');
    print('Tracks: ${db.tracks?.length}');
    print('History: ${db.history?.length}');
    print('Updates: ${db.updates?.length}');
    print('Settings: ${db.settings?.length}');
    print('Extension Preferences: ${db.extensionPreferences?.length}');
    print('Track Preferences: ${db.trackPreferences?.length}');
    print('Extensions: ${db.extensions?.length}');
  }
}
