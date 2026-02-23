import 'dart:typed_data';

import 'package:checks/checks.dart';
import 'package:mangabackupconverter_cli/src/formats/aidoku/aidoku_backup.dart';
import 'package:mangabackupconverter_cli/src/formats/aidoku/aidoku_backup_chapter.dart';
import 'package:mangabackupconverter_cli/src/formats/aidoku/aidoku_backup_history.dart';
import 'package:mangabackupconverter_cli/src/formats/aidoku/aidoku_backup_library_manga.dart';
import 'package:mangabackupconverter_cli/src/formats/aidoku/aidoku_backup_manga.dart';
import 'package:mangabackupconverter_cli/src/formats/aidoku/aidoku_backup_track_item.dart';
import 'package:mangabackupconverter_cli/src/pipeline/source_manga_data.dart';
import 'package:test/scaffolding.dart';

void main() {
  final now = DateTime(2025, 1, 15);
  final earlier = DateTime(2024, 6);
  final later = DateTime(2025, 6);

  AidokuBackupManga manga({
    String id = 'manga1',
    String sourceId = 'src1',
    String title = 'Test Manga',
    String? author,
    String? artist,
  }) {
    return AidokuBackupManga(
      id: id,
      sourceId: sourceId,
      title: title,
      author: author,
      artist: artist,
    );
  }

  AidokuBackupLibraryManga libraryManga({
    String mangaId = 'manga1',
    String sourceId = 'src1',
    List<String> categories = const <String>['Action'],
    DateTime? dateAdded,
    DateTime? lastOpened,
    DateTime? lastUpdated,
    DateTime? lastRead,
  }) {
    return AidokuBackupLibraryManga(
      mangaId: mangaId,
      sourceId: sourceId,
      categories: categories,
      dateAdded: dateAdded ?? now,
      lastOpened: lastOpened ?? now,
      lastUpdated: lastUpdated ?? now,
      lastRead: lastRead,
    );
  }

  AidokuBackupChapter chapter({
    String id = 'ch1',
    String mangaId = 'manga1',
    String sourceId = 'src1',
    String? title = 'Chapter 1',
    double? chapter = 1,
    String lang = 'en',
    int sourceOrder = 0,
  }) {
    return AidokuBackupChapter(
      id: id,
      mangaId: mangaId,
      sourceId: sourceId,
      title: title,
      chapter: chapter,
      volume: null,
      scanlator: null,
      lang: lang,
      dateUploaded: null,
      sourceOrder: sourceOrder,
    );
  }

  AidokuBackupHistory history({
    String chapterId = 'ch1',
    String mangaId = 'manga1',
    String sourceId = 'src1',
    bool completed = true,
    int? progress,
    int? total,
  }) {
    return AidokuBackupHistory(
      chapterId: chapterId,
      mangaId: mangaId,
      sourceId: sourceId,
      dateRead: now,
      completed: completed,
      progress: progress,
      total: total,
    );
  }

  group('AidokuBackup', () {
    group('fromData / toData round-trip', () {
      test('round-trips a minimal backup through property list', () async {
        final backup = AidokuBackup(
          library: <AidokuBackupLibraryManga>{},
          history: <AidokuBackupHistory>{},
          manga: <AidokuBackupManga>{},
          chapters: <AidokuBackupChapter>{},
          trackItems: <AidokuBackupTrackItem>{},
          categories: <String>{'Action'},
          sources: <String>{'src1'},
          date: now,
          name: 'test_backup',
          version: '0.6.10',
        );

        final Uint8List bytes = await backup.toData();
        final AidokuBackup restored = AidokuBackup.fromData(bytes);

        check(restored.name).equals('test_backup');
        check(restored.version).equals('0.6.10');
        check(restored.categories).isNotNull().contains('Action');
        check(restored.sources).isNotNull().contains('src1');
      });

      test('fromData with overrideName replaces name', () async {
        final backup = AidokuBackup(
          library: null,
          history: null,
          manga: null,
          chapters: null,
          trackItems: null,
          categories: null,
          sources: null,
          date: now,
          name: 'original',
          version: '0.6.10',
        );

        final Uint8List bytes = await backup.toData();
        final AidokuBackup restored = AidokuBackup.fromData(bytes, overrideName: 'custom');

        check(restored.name).equals('custom');
      });
    });

    group('mangaSearchEntries', () {
      test('returns manga list', () {
        final backup = AidokuBackup(
          library: null,
          history: null,
          manga: <AidokuBackupManga>{
            manga(),
            manga(id: 'manga2'),
          },
          chapters: null,
          trackItems: null,
          categories: null,
          sources: null,
          date: now,
          name: null,
          version: null,
        );

        check(backup.mangaSearchEntries.length).equals(2);
      });

      test('returns empty list when manga is null', () {
        final backup = AidokuBackup(
          library: null,
          history: null,
          manga: null,
          chapters: null,
          trackItems: null,
          categories: null,
          sources: null,
          date: now,
          name: null,
          version: null,
        );

        check(backup.mangaSearchEntries).isEmpty();
      });
    });

    group('sourceMangaDataEntries', () {
      test('links chapters, history, and tracking by sourceId and mangaId', () {
        final backup = AidokuBackup(
          library: <AidokuBackupLibraryManga>{libraryManga()},
          history: <AidokuBackupHistory>{history()},
          manga: <AidokuBackupManga>{manga()},
          chapters: <AidokuBackupChapter>{chapter()},
          trackItems: <AidokuBackupTrackItem>{
            AidokuBackupTrackItem(
              id: 't1',
              trackerId: '2',
              mangaId: 'manga1',
              sourceId: 'src1',
              title: 'Tracked',
            ),
          },
          categories: <String>{'Action'},
          sources: <String>{'src1'},
          date: now,
          name: null,
          version: null,
        );

        final List<SourceMangaData> entries = backup.sourceMangaDataEntries;
        check(entries.length).equals(1);

        final SourceMangaData entry = entries.first;
        check(entry.details.title).equals('Test Manga');
        check(entry.sourceId).equals('src1');
        check(entry.categories).deepEquals(<String>['Action']);
        check(entry.chapters.length).equals(1);
        check(entry.chapters.first.title).equals('Chapter 1');
        check(entry.chapters.first.isRead).isTrue();
        check(entry.history.length).equals(1);
        check(entry.history.first.completed).isTrue();
        check(entry.tracking.length).equals(1);
        check(entry.tracking.first.syncId).equals(2);
      });

      test('chapter isRead is false when no matching completed history entry', () {
        final backup = AidokuBackup(
          library: null,
          history: <AidokuBackupHistory>{
            history(completed: false),
          },
          manga: <AidokuBackupManga>{manga()},
          chapters: <AidokuBackupChapter>{chapter()},
          trackItems: null,
          categories: null,
          sources: null,
          date: now,
          name: null,
          version: null,
        );

        final List<SourceMangaData> entries = backup.sourceMangaDataEntries;
        check(entries.first.chapters.first.isRead).isFalse();
      });

      test('returns empty categories when no library entry found', () {
        final backup = AidokuBackup(
          library: null,
          history: null,
          manga: <AidokuBackupManga>{manga()},
          chapters: null,
          trackItems: null,
          categories: null,
          sources: null,
          date: now,
          name: null,
          version: null,
        );

        final List<SourceMangaData> entries = backup.sourceMangaDataEntries;
        check(entries.first.categories).isEmpty();
      });

      test('history entry uses chapterId as title when chapter not found', () {
        final backup = AidokuBackup(
          library: null,
          history: <AidokuBackupHistory>{
            history(chapterId: 'missing-ch'),
          },
          manga: <AidokuBackupManga>{manga()},
          chapters: <AidokuBackupChapter>{chapter()},
          trackItems: null,
          categories: null,
          sources: null,
          date: now,
          name: null,
          version: null,
        );

        final List<SourceMangaData> entries = backup.sourceMangaDataEntries;
        check(entries.first.history.first.chapterTitle).equals('missing-ch');
      });
    });

    group('mergeWith', () {
      test('combines manga, chapters, history from both backups', () {
        final backup1 = AidokuBackup(
          library: <AidokuBackupLibraryManga>{libraryManga()},
          history: <AidokuBackupHistory>{history()},
          manga: <AidokuBackupManga>{manga()},
          chapters: <AidokuBackupChapter>{chapter()},
          trackItems: null,
          categories: <String>{'Action'},
          sources: <String>{'src1'},
          date: now,
          name: 'backup1',
          version: '0.6.10',
        );

        final backup2 = AidokuBackup(
          library: <AidokuBackupLibraryManga>{
            libraryManga(
              mangaId: 'manga2',
              categories: <String>['Comedy'],
            ),
          },
          history: null,
          manga: <AidokuBackupManga>{manga(id: 'manga2', title: 'Other')},
          chapters: <AidokuBackupChapter>{
            chapter(id: 'ch2', mangaId: 'manga2'),
          },
          trackItems: null,
          categories: <String>{'Comedy'},
          sources: <String>{'src1'},
          date: now,
          name: 'backup2',
          version: null,
        );

        final AidokuBackup merged = backup1.mergeWith(backup2);

        check(merged.manga).isNotNull().length.equals(2);
        check(merged.chapters).isNotNull().length.equals(2);
        check(merged.categories).isNotNull().length.equals(2);
        check(merged.name).equals('backup1_MergedWith_backup2');
        check(merged.version).equals('0.6.10');
      });

      test('merges categories for duplicate library entries', () {
        final AidokuBackupLibraryManga lib1 = libraryManga(categories: <String>['Action']);
        final AidokuBackupLibraryManga lib2 = libraryManga(categories: <String>['Comedy']);

        final backup1 = AidokuBackup(
          library: <AidokuBackupLibraryManga>{lib1},
          history: null,
          manga: <AidokuBackupManga>{manga()},
          chapters: null,
          trackItems: null,
          categories: <String>{'Action'},
          sources: null,
          date: now,
          name: 'b1',
          version: null,
        );

        final backup2 = AidokuBackup(
          library: <AidokuBackupLibraryManga>{lib2},
          history: null,
          manga: null,
          chapters: null,
          trackItems: null,
          categories: <String>{'Comedy'},
          sources: null,
          date: now,
          name: 'b2',
          version: null,
        );

        final AidokuBackup merged = backup1.mergeWith(backup2);
        final AidokuBackupLibraryManga mergedLib = merged.library!.first;

        check(mergedLib.categories).contains('Action');
        check(mergedLib.categories).contains('Comedy');
      });

      test('assigns Default category when item has no categories', () {
        final AidokuBackupLibraryManga lib = libraryManga(categories: <String>[]);

        final backup1 = AidokuBackup(
          library: <AidokuBackupLibraryManga>{lib},
          history: null,
          manga: <AidokuBackupManga>{manga()},
          chapters: null,
          trackItems: null,
          categories: null,
          sources: null,
          date: now,
          name: 'b1',
          version: null,
        );

        final backup2 = AidokuBackup(
          library: null,
          history: null,
          manga: null,
          chapters: null,
          trackItems: null,
          categories: null,
          sources: null,
          date: now,
          name: 'b2',
          version: null,
        );

        final AidokuBackup merged = backup1.mergeWith(backup2);
        final AidokuBackupLibraryManga mergedLib = merged.library!.first;

        check(mergedLib.categories).contains('Default');
        check(merged.categories).isNotNull().contains('Default');
      });

      test('picks latest dates from duplicates', () {
        final AidokuBackupLibraryManga lib1 = libraryManga(
          dateAdded: earlier,
          lastOpened: earlier,
          lastUpdated: earlier,
          lastRead: earlier,
        );
        final AidokuBackupLibraryManga lib2 = libraryManga(
          dateAdded: later,
          lastOpened: later,
          lastUpdated: later,
          lastRead: later,
        );

        final backup1 = AidokuBackup(
          library: <AidokuBackupLibraryManga>{lib1},
          history: null,
          manga: <AidokuBackupManga>{manga()},
          chapters: null,
          trackItems: null,
          categories: null,
          sources: null,
          date: now,
          name: 'b1',
          version: null,
        );

        final backup2 = AidokuBackup(
          library: <AidokuBackupLibraryManga>{lib2},
          history: null,
          manga: null,
          chapters: null,
          trackItems: null,
          categories: null,
          sources: null,
          date: now,
          name: 'b2',
          version: null,
        );

        final AidokuBackup merged = backup1.mergeWith(backup2);
        final AidokuBackupLibraryManga mergedLib = merged.library!.first;

        check(mergedLib.dateAdded).equals(later);
        check(mergedLib.lastOpened).equals(later);
        check(mergedLib.lastUpdated).equals(later);
      });

      test('handles null lastRead in both backups', () {
        final AidokuBackupLibraryManga lib1 = libraryManga();

        final backup1 = AidokuBackup(
          library: <AidokuBackupLibraryManga>{lib1},
          history: null,
          manga: <AidokuBackupManga>{manga()},
          chapters: null,
          trackItems: null,
          categories: null,
          sources: null,
          date: now,
          name: 'b1',
          version: null,
        );

        final backup2 = AidokuBackup(
          library: null,
          history: null,
          manga: null,
          chapters: null,
          trackItems: null,
          categories: null,
          sources: null,
          date: now,
          name: 'b2',
          version: null,
        );

        final AidokuBackup merged = backup1.mergeWith(backup2);
        final AidokuBackupLibraryManga mergedLib = merged.library!.first;

        check(mergedLib.lastRead).isNull();
      });
    });
  });
}
