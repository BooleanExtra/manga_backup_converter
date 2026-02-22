import 'package:checks/checks.dart';
import 'package:mangabackupconverter_cli/mangabackupconverter_lib.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('TachimangaBackup.toTachiBackup()', () {
    late TachimangaBackupDb db;
    late TachimangaBackup backup;

    setUp(() {
      db = const TachimangaBackupDb(
        categoryTable: <TachimangaBackupCategory>[
          TachimangaBackupCategory(id: 1, name: 'Favorites', order: 0, isDefault: false),
          TachimangaBackupCategory(id: 2, name: 'Reading', order: 1, isDefault: false),
        ],
        categoryMangaTable: <TachimangaBackupCategoryManga>[
          TachimangaBackupCategoryManga(id: 1, category: 1, manga: 100),
          TachimangaBackupCategoryManga(id: 2, category: 2, manga: 100),
          TachimangaBackupCategoryManga(id: 3, category: 2, manga: 200),
        ],
        categoryMetaTable: <TachimangaBackupCategoryMeta>[],
        chapterTable: <TachimangaBackupChapter>[
          TachimangaBackupChapter(
            id: 10,
            url: '/ch/10',
            name: 'Chapter 1',
            dateUpload: 0,
            chapterNumber: 1,
            scanlator: null,
            read: true,
            bookmark: false,
            lastPageRead: 5,
            lastReadAt: 1000,
            fetchedAt: 0,
            sourceOrder: 0,
            realUrl: null,
            isDownloaded: false,
            pageCount: 20,
            manga: 100,
          ),
          TachimangaBackupChapter(
            id: 11,
            url: '/ch/11',
            name: 'Chapter 2',
            dateUpload: 0,
            chapterNumber: 2,
            scanlator: 'GroupA',
            read: false,
            bookmark: true,
            lastPageRead: 0,
            lastReadAt: 0,
            fetchedAt: 0,
            sourceOrder: 1,
            realUrl: null,
            isDownloaded: false,
            pageCount: 15,
            manga: 100,
          ),
          TachimangaBackupChapter(
            id: 20,
            url: '/ch/20',
            name: 'Manga2 Ch1',
            dateUpload: 0,
            chapterNumber: 1,
            scanlator: null,
            read: false,
            bookmark: false,
            lastPageRead: 0,
            lastReadAt: 0,
            fetchedAt: 0,
            sourceOrder: 0,
            realUrl: null,
            isDownloaded: false,
            pageCount: 10,
            manga: 200,
          ),
        ],
        chapterMetaTable: <TachimangaBackupChapterMeta>[],
        extensionTable: <TachimangaBackupExtension>[],
        historyTable: <TachimangaBackupHistory>[
          TachimangaBackupHistory(
            id: 1,
            createAt: 0,
            isDelete: false,
            mangaId: 100,
            lastChapterId: 10,
            lastReadAt: 5000,
          ),
          TachimangaBackupHistory(
            id: 2,
            createAt: 0,
            isDelete: false,
            mangaId: 200,
            lastChapterId: 20,
            lastReadAt: 3000,
          ),
        ],
        mangaTable: <TachimangaBackupManga>[
          TachimangaBackupManga(
            id: 100,
            url: '/manga/100',
            title: 'Manga One',
            initialized: true,
            artist: 'Artist1',
            author: 'Author1',
            description: 'Desc 1',
            genre: 'Action, Comedy',
            status: 1,
            thumbnailUrl: 'https://example.com/1.jpg',
            thumbnailUrlLastFetched: 0,
            inLibrary: true,
            defaultCategory: false,
            inLibraryAt: 1000,
            source: 999,
            realUrl: null,
            lastFetchedAt: 0,
            chaptersLastFetchedAt: 0,
            updateStrategy: '0',
            lastDownloadAt: 0,
          ),
          TachimangaBackupManga(
            id: 200,
            url: '/manga/200',
            title: 'Manga Two',
            initialized: true,
            artist: null,
            author: null,
            description: null,
            genre: null,
            status: 0,
            thumbnailUrl: null,
            thumbnailUrlLastFetched: 0,
            inLibrary: true,
            defaultCategory: false,
            inLibraryAt: 2000,
            source: 888,
            realUrl: '/manga/200/real',
            lastFetchedAt: 0,
            chaptersLastFetchedAt: 0,
            updateStrategy: '0',
            lastDownloadAt: 0,
          ),
        ],
        mangaMetaTable: <TachimangaBackupMangaMeta>[],
        migrationsTable: <TachimangaBackupDbMigrations>[],
        pageTable: <TachimangaBackupPage>[],
        repoTable: <TachimangaBackupRepo>[],
        settingTable: <TachimangaBackupSetting>[],
        sourceTable: <TachimangaBackupSource>[
          TachimangaBackupSource(
            id: 999,
            name: 'Source A',
            lang: 'en',
            extension: 1,
            isNsfw: false,
            isDirect: null,
            randomUa: null,
          ),
          TachimangaBackupSource(
            id: 888,
            name: 'Source B',
            lang: 'en',
            extension: 2,
            isNsfw: false,
            isDirect: null,
            randomUa: null,
          ),
        ],
        trackRecordTable: <TachimangaBackupTrackRecord>[
          TachimangaBackupTrackRecord(
            id: 1,
            mangaId: 100,
            syncId: 1,
            remoteId: 111,
            libraryId: null,
            title: 'Manga One Tracker',
            lastChapterRead: 1.0,
            totalChapters: 50,
            status: 1,
            score: 8.0,
            remoteUrl: 'https://tracker.com/100',
            startDate: 0,
            finishDate: 0,
          ),
          TachimangaBackupTrackRecord(
            id: 2,
            mangaId: 200,
            syncId: 2,
            remoteId: 222,
            libraryId: 5,
            title: 'Manga Two Tracker',
            lastChapterRead: 0.0,
            totalChapters: 10,
            status: 0,
            score: 0.0,
            remoteUrl: 'https://tracker.com/200',
            startDate: 0,
            finishDate: 0,
          ),
        ],
        sqliteSequenceTable: <TachimangaBackupSqliteSequence>[],
      );

      backup = TachimangaBackup(
        meta: TachimangaBackupMeta(
          name: 'test',
          version: 1,
          remoteBackup: false,
          downloaded: false,
          backupId: 0,
          updateAt: 0,
          type: 0,
          size: 0,
          checksum: '',
          createAt: 0,
          cloudBackup: false,
          downloadProgress: 0,
          state: 0,
          extInfo: null,
        ),
        db: db,
      );
    });

    test('each manga gets only its own chapters', () {
      final TachiBackup tachi = backup.toTachiBackup();

      check(tachi.backupManga).length.equals(2);
      final TachiBackupManga manga1 = tachi.backupManga[0];
      final TachiBackupManga manga2 = tachi.backupManga[1];

      check(manga1.chapters).length.equals(2);
      check(manga1.chapters[0].name).equals('Chapter 1');
      check(manga1.chapters[1].name).equals('Chapter 2');

      check(manga2.chapters).length.equals(1);
      check(manga2.chapters[0].name).equals('Manga2 Ch1');
    });

    test('each manga gets only its own history entries', () {
      final TachiBackup tachi = backup.toTachiBackup();

      final TachiBackupManga manga1 = tachi.backupManga[0];
      final TachiBackupManga manga2 = tachi.backupManga[1];

      check(manga1.history).length.equals(1);
      check(manga1.history[0].lastRead).equals(10);
      check(manga1.history[0].readDuration).equals(5000);

      check(manga2.history).length.equals(1);
      check(manga2.history[0].lastRead).equals(20);
      check(manga2.history[0].readDuration).equals(3000);
    });

    test('each manga gets only its own tracking records', () {
      final TachiBackup tachi = backup.toTachiBackup();

      final TachiBackupManga manga1 = tachi.backupManga[0];
      final TachiBackupManga manga2 = tachi.backupManga[1];

      check(manga1.tracking).length.equals(1);
      check(manga1.tracking[0].title).equals('Manga One Tracker');
      check(manga1.tracking[0].syncId).equals(1);

      check(manga2.tracking).length.equals(1);
      check(manga2.tracking[0].title).equals('Manga Two Tracker');
      check(manga2.tracking[0].syncId).equals(2);
    });

    test('each manga gets only its own category IDs via junction table', () {
      final TachiBackup tachi = backup.toTachiBackup();

      final TachiBackupManga manga1 = tachi.backupManga[0];
      final TachiBackupManga manga2 = tachi.backupManga[1];

      // Manga 100 is in categories 1 and 2
      check(manga1.categories).length.equals(2);
      check(manga1.categories).contains(1);
      check(manga1.categories).contains(2);

      // Manga 200 is only in category 2
      check(manga2.categories).length.equals(1);
      check(manga2.categories).contains(2);
    });

    test('top-level backup fields are correct', () {
      final TachiBackup tachi = backup.toTachiBackup();

      check(tachi.backupCategories).length.equals(2);
      check(tachi.backupCategories[0].name).equals('Favorites');
      check(tachi.backupCategories[1].name).equals('Reading');

      check(tachi.backupSources).length.equals(2);

      check(tachi.backupExtensionRepo).isEmpty();
    });

    test('manga with no related data gets empty lists', () {
      const emptyDb = TachimangaBackupDb(
        categoryTable: <TachimangaBackupCategory>[],
        categoryMangaTable: <TachimangaBackupCategoryManga>[],
        categoryMetaTable: <TachimangaBackupCategoryMeta>[],
        chapterTable: <TachimangaBackupChapter>[],
        chapterMetaTable: <TachimangaBackupChapterMeta>[],
        extensionTable: <TachimangaBackupExtension>[],
        historyTable: <TachimangaBackupHistory>[],
        mangaTable: <TachimangaBackupManga>[
          TachimangaBackupManga(
            id: 1,
            url: '/manga/1',
            title: 'Lonely Manga',
            initialized: true,
            artist: null,
            author: null,
            description: null,
            genre: null,
            status: 0,
            thumbnailUrl: null,
            thumbnailUrlLastFetched: 0,
            inLibrary: true,
            defaultCategory: false,
            inLibraryAt: 0,
            source: 1,
            realUrl: null,
            lastFetchedAt: 0,
            chaptersLastFetchedAt: 0,
            updateStrategy: '0',
            lastDownloadAt: 0,
          ),
        ],
        mangaMetaTable: <TachimangaBackupMangaMeta>[],
        migrationsTable: <TachimangaBackupDbMigrations>[],
        pageTable: <TachimangaBackupPage>[],
        repoTable: <TachimangaBackupRepo>[],
        settingTable: <TachimangaBackupSetting>[],
        sourceTable: <TachimangaBackupSource>[],
        trackRecordTable: <TachimangaBackupTrackRecord>[],
        sqliteSequenceTable: <TachimangaBackupSqliteSequence>[],
      );

      final emptyBackup = TachimangaBackup(
        meta: TachimangaBackupMeta(
          name: 'test',
          version: 1,
          remoteBackup: false,
          downloaded: false,
          backupId: 0,
          updateAt: 0,
          type: 0,
          size: 0,
          checksum: '',
          createAt: 0,
          cloudBackup: false,
          downloadProgress: 0,
          state: 0,
          extInfo: null,
        ),
        db: emptyDb,
      );

      final TachiBackup tachi = emptyBackup.toTachiBackup();
      check(tachi.backupManga).length.equals(1);
      final TachiBackupManga manga = tachi.backupManga[0];
      check(manga.chapters).isEmpty();
      check(manga.history).isEmpty();
      check(manga.tracking).isEmpty();
      check(manga.categories).isEmpty();
    });
  });
}
