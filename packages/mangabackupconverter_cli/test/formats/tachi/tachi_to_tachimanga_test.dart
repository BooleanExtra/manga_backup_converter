import 'package:checks/checks.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_backup.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_backup_category.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_backup_chapter.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_backup_extension_repo.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_backup_history.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_backup_manga.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_backup_source.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_backup_tracking.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_update_strategy.dart';
import 'package:mangabackupconverter_cli/src/formats/tachimanga/tachimanga_backup.dart';
import 'package:mangabackupconverter_cli/src/formats/tachimanga/tachimanga_backup_db_models.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('TachiBackup.toTachimangaBackup()', () {
    late TachiBackup backup;

    setUp(() {
      backup = TachiBackup(
        backupCategories: <TachiBackupCategory>[
          TachiBackupCategory(name: 'Favorites', order: 0, flags: 1),
          TachiBackupCategory(name: 'Reading', order: 1, flags: 1),
        ],
        backupSources: <TachiBackupSource>[
          const TachiBackupSource(name: 'Source A', sourceId: 999),
          const TachiBackupSource(name: 'Source B', sourceId: 888),
        ],
        backupExtensionRepo: <TachiBackupExtensionRepo>[
          const TachiBackupExtensionRepo(
            name: 'Repo1',
            baseUrl: 'https://repo1.example.com',
            shortName: 'R1',
            website: 'https://repo1.example.com/home',
            signingKeyFingerprint: 'abc',
          ),
        ],
        backupManga: <TachiBackupManga>[
          const TachiBackupManga(
            source: 999,
            url: '/manga/100',
            title: 'Manga One',
            artist: 'Artist1',
            author: 'Author1',
            description: 'Desc 1',
            genre: <String>['Action', 'Comedy'],
            status: 1,
            thumbnailUrl: 'https://example.com/1.jpg',
            dateAdded: 1000,
            viewer: 1,
            viewerFlags: 1,
            chapterFlags: 1,
            favorite: true,
            categories: <int>[0, 1],
            chapters: <TachiBackupChapter>[
              TachiBackupChapter(
                url: '/ch/10',
                name: 'Chapter 1',
                scanlator: '',
                read: true,
                bookmark: false,
                lastPageRead: 5,
                dateFetch: 500,
                dateUpload: 100,
                chapterNumber: 1,
                sourceOrder: 0,
                lastModifiedAt: 2000,
              ),
              TachiBackupChapter(
                url: '/ch/11',
                name: 'Chapter 2',
                scanlator: 'GroupA',
                read: false,
                bookmark: true,
                lastPageRead: 0,
                dateFetch: 600,
                dateUpload: 200,
                chapterNumber: 2,
                sourceOrder: 1,
              ),
            ],
            history: <TachiBackupHistory>[
              TachiBackupHistory(url: '/ch/10', lastRead: 3000, readDuration: 2000),
              TachiBackupHistory(url: '/ch/11', lastRead: 7000, readDuration: 3000),
            ],
            tracking: <TachiBackupTracking>[
              TachiBackupTracking(
                syncId: 1,
                libraryId: -1,
                mediaIdInt: 111,
                trackingUrl: 'https://tracker.com/100',
                title: 'Manga One Tracker',
                lastChapterRead: 1.0,
                totalChapters: 50,
                score: 8.0,
                status: 1,
                startedReadingDate: 1000,
                finishedReadingDate: 0,
                mediaId: 111,
              ),
            ],
          ),
          const TachiBackupManga(
            source: 888,
            url: '/manga/200',
            title: 'Manga Two',
            artist: '',
            author: '',
            description: '',
            genre: <String>[],
            status: 0,
            thumbnailUrl: '',
            dateAdded: 2000,
            viewer: 1,
            viewerFlags: 1,
            chapterFlags: 1,
            favorite: true,
            updateStrategy: TachiUpdateStrategy.onlyFetchOnce,
            categories: <int>[1],
            chapters: <TachiBackupChapter>[
              TachiBackupChapter(
                url: '/ch/20',
                name: 'Manga2 Ch1',
                scanlator: '',
                read: false,
                bookmark: false,
                lastPageRead: 0,
                dateFetch: 0,
                dateUpload: 0,
                chapterNumber: 1,
                sourceOrder: 0,
              ),
            ],
            history: <TachiBackupHistory>[
              TachiBackupHistory(url: '/ch/20', lastRead: 4000, readDuration: 3000),
            ],
            tracking: <TachiBackupTracking>[
              TachiBackupTracking(
                syncId: 2,
                libraryId: 5,
                mediaIdInt: 222,
                trackingUrl: 'https://tracker.com/200',
                title: 'Manga Two Tracker',
                lastChapterRead: 0.0,
                totalChapters: 10,
                score: 0.0,
                status: 0,
                startedReadingDate: 0,
                finishedReadingDate: 0,
                mediaId: 222,
              ),
            ],
          ),
        ],
      );
    });

    test('manga fields mapped correctly', () {
      final TachimangaBackup result = backup.toTachimangaBackup();
      final List<TachimangaBackupManga> manga = result.db.mangaTable;

      check(manga).length.equals(2);

      // Manga 1
      check(manga[0].id).equals(1);
      check(manga[0].url).equals('/manga/100');
      check(manga[0].title).equals('Manga One');
      check(manga[0].artist).equals('Artist1');
      check(manga[0].author).equals('Author1');
      check(manga[0].description).equals('Desc 1');
      check(manga[0].genre).equals('Action, Comedy');
      check(manga[0].status).equals(1);
      check(manga[0].thumbnailUrl).equals('https://example.com/1.jpg');
      check(manga[0].inLibraryAt).equals(1000);
      check(manga[0].initialized).isTrue();
      check(manga[0].inLibrary).isTrue();
      check(manga[0].updateStrategy).equals('0');
      check(manga[0].source).equals(999);

      // Manga 2 — empty strings become null
      check(manga[1].id).equals(2);
      check(manga[1].artist).isNull();
      check(manga[1].author).isNull();
      check(manga[1].description).isNull();
      check(manga[1].genre).isNull();
      check(manga[1].thumbnailUrl).isNull();
      check(manga[1].updateStrategy).equals('1');
    });

    test('each manga gets its own chapters with correct FKs', () {
      final TachimangaBackup result = backup.toTachimangaBackup();
      final List<TachimangaBackupChapter> chapters = result.db.chapterTable;

      check(chapters).length.equals(3);

      // Manga 1 chapters
      final List<TachimangaBackupChapter> m1Chapters = chapters
          .where((TachimangaBackupChapter c) => c.manga == 1)
          .toList();
      check(m1Chapters).length.equals(2);
      check(m1Chapters[0].name).equals('Chapter 1');
      check(m1Chapters[0].scanlator).isNull();
      check(m1Chapters[0].read).isTrue();
      check(m1Chapters[0].lastPageRead).equals(5);
      check(m1Chapters[0].fetchedAt).equals(500);
      check(m1Chapters[0].dateUpload).equals(100);
      check(m1Chapters[0].lastReadAt).equals(2000);

      check(m1Chapters[1].name).equals('Chapter 2');
      check(m1Chapters[1].scanlator).equals('GroupA');
      check(m1Chapters[1].bookmark).isTrue();

      // Manga 2 chapters
      final List<TachimangaBackupChapter> m2Chapters = chapters
          .where((TachimangaBackupChapter c) => c.manga == 2)
          .toList();
      check(m2Chapters).length.equals(1);
      check(m2Chapters[0].name).equals('Manga2 Ch1');
    });

    test('category junction table built correctly', () {
      final TachimangaBackup result = backup.toTachimangaBackup();

      // Categories
      check(result.db.categoryTable).length.equals(2);
      check(result.db.categoryTable[0].id).equals(1);
      check(result.db.categoryTable[0].name).equals('Favorites');
      check(result.db.categoryTable[1].id).equals(2);
      check(result.db.categoryTable[1].name).equals('Reading');

      // Junction — manga 1 in categories 0,1 → IDs 1,2
      final List<TachimangaBackupCategoryManga> m1Cats = result.db.categoryMangaTable
          .where((TachimangaBackupCategoryManga cm) => cm.manga == 1)
          .toList();
      check(m1Cats).length.equals(2);
      check(m1Cats.map((TachimangaBackupCategoryManga cm) => cm.category).toSet()).contains(1);
      check(m1Cats.map((TachimangaBackupCategoryManga cm) => cm.category).toSet()).contains(2);

      // Junction — manga 2 in category 1 → ID 2
      final List<TachimangaBackupCategoryManga> m2Cats = result.db.categoryMangaTable
          .where((TachimangaBackupCategoryManga cm) => cm.manga == 2)
          .toList();
      check(m2Cats).length.equals(1);
      check(m2Cats[0].category).equals(2);
    });

    test('history collapsed to one row per manga with latest chapter and summed duration', () {
      final TachimangaBackup result = backup.toTachimangaBackup();
      final List<TachimangaBackupHistory> history = result.db.historyTable;

      // One row per manga, not per chapter
      check(history).length.equals(2);

      // Manga 1: two history entries collapsed — latest is /ch/11 (lastRead=7000,
      // id=2), total duration = 2000 + 3000 = 5000
      check(history[0].mangaId).equals(1);
      check(history[0].lastChapterId).equals(2);
      check(history[0].lastReadAt).equals(5000);

      // Manga 2: single history entry — /ch/20 (id=3), duration=3000
      check(history[1].mangaId).equals(2);
      check(history[1].lastChapterId).equals(3);
      check(history[1].lastReadAt).equals(3000);
    });

    test('tracking records mapped with correct field renames', () {
      final TachimangaBackup result = backup.toTachimangaBackup();
      final List<TachimangaBackupTrackRecord> tracks = result.db.trackRecordTable;

      check(tracks).length.equals(2);

      // Track 1 — libraryId -1 becomes null
      check(tracks[0].mangaId).equals(1);
      check(tracks[0].syncId).equals(1);
      check(tracks[0].remoteId).equals(111);
      check(tracks[0].libraryId).isNull();
      check(tracks[0].title).equals('Manga One Tracker');
      check(tracks[0].lastChapterRead).equals(1.0);
      check(tracks[0].totalChapters).equals(50);
      check(tracks[0].score).equals(8.0);
      check(tracks[0].status).equals(1);
      check(tracks[0].remoteUrl).equals('https://tracker.com/100');
      check(tracks[0].startDate).equals(1000);
      check(tracks[0].finishDate).equals(0);

      // Track 2 — libraryId 5 preserved
      check(tracks[1].mangaId).equals(2);
      check(tracks[1].libraryId).equals(5);
    });

    test('sources and repos mapped', () {
      final TachimangaBackup result = backup.toTachimangaBackup();

      check(result.db.sourceTable).length.equals(2);
      check(result.db.sourceTable[0].id).equals(999);
      check(result.db.sourceTable[0].name).equals('Source A');
      check(result.db.sourceTable[1].id).equals(888);
      check(result.db.sourceTable[1].name).equals('Source B');

      check(result.db.repoTable).length.equals(1);
      check(result.db.repoTable[0].name).equals('Repo1');
      check(result.db.repoTable[0].baseUrl).equals('https://repo1.example.com');
      check(result.db.repoTable[0].homepage).equals('https://repo1.example.com/home');
    });

    test('empty input produces empty tables', () {
      const emptyBackup = TachiBackup();
      final TachimangaBackup result = emptyBackup.toTachimangaBackup();

      check(result.db.mangaTable).isEmpty();
      check(result.db.chapterTable).isEmpty();
      check(result.db.categoryTable).isEmpty();
      check(result.db.categoryMangaTable).isEmpty();
      check(result.db.historyTable).isEmpty();
      check(result.db.trackRecordTable).isEmpty();
      check(result.db.sourceTable).isEmpty();
      check(result.db.repoTable).isEmpty();
      check(result.db.extensionTable).isEmpty();
    });

    test('history with unknown chapter URL gets lastChapterId 0', () {
      const backupWithBadHistory = TachiBackup(
        backupManga: <TachiBackupManga>[
          TachiBackupManga(
            source: 1,
            url: '/manga/1',
            title: 'Test',
            artist: '',
            author: '',
            description: '',
            genre: <String>[],
            status: 0,
            thumbnailUrl: '',
            dateAdded: 0,
            viewer: 1,
            viewerFlags: 1,
            chapterFlags: 1,
            favorite: true,
            chapters: <TachiBackupChapter>[],
            categories: <int>[],
            tracking: <TachiBackupTracking>[],
            history: <TachiBackupHistory>[
              TachiBackupHistory(url: '/unknown', lastRead: 0, readDuration: 100),
            ],
          ),
        ],
      );

      final TachimangaBackup result = backupWithBadHistory.toTachimangaBackup();
      check(result.db.historyTable).length.equals(1);
      check(result.db.historyTable[0].lastChapterId).equals(0);
    });
  });
}
