import 'package:checks/checks.dart';
import 'package:mangabackupconverter_cli/src/common/convertable.dart';
import 'package:mangabackupconverter_cli/src/formats/aidoku/aidoku_backup.dart';
import 'package:mangabackupconverter_cli/src/formats/aidoku/aidoku_backup_chapter.dart';
import 'package:mangabackupconverter_cli/src/formats/aidoku/aidoku_backup_history.dart';
import 'package:mangabackupconverter_cli/src/formats/aidoku/aidoku_backup_library_manga.dart';
import 'package:mangabackupconverter_cli/src/formats/aidoku/aidoku_backup_manga.dart';
import 'package:mangabackupconverter_cli/src/pipeline/manga_details.dart';
import 'package:mangabackupconverter_cli/src/pipeline/migration_pipeline.dart';
import 'package:mangabackupconverter_cli/src/pipeline/plugin_source.dart';
import 'package:mangabackupconverter_cli/src/pipeline/source_manga_data.dart';
import 'package:mangabackupconverter_cli/src/pipeline/target_backup_builder.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('AidokuBackupBuilder', () {
    const builder = AidokuBackupBuilder();

    test('empty confirmations produces empty backup', () {
      final ConvertableBackup result = builder.build(const <MangaMatchConfirmation>[]);
      check(result).isA<AidokuBackup>();
      final backup = result as AidokuBackup;
      check(backup.manga).isNotNull().isEmpty();
      check(backup.library).isNotNull().isEmpty();
      check(backup.sources).isNotNull().isEmpty();
      check(backup.history).isNull();
      check(backup.chapters).isNull();
      check(backup.trackItems).isNull();
      check(backup.categories).isNull();
    });

    test('single confirmed match produces correct manga and library entry', () {
      final confirmations = <MangaMatchConfirmation>[
        MangaMatchConfirmation(
          sourceManga: SourceMangaData(
            details: const MangaSearchDetails(
              title: 'Original Title',
              authors: <String>['Author A'],
              artists: <String>['Artist B'],
              tagNames: <String>['Action', 'Comedy'],
              description: 'A great manga',
            ),
            categories: const <String>['Favorites'],
            dateAdded: DateTime(2024),
          ),
          confirmedMatch: const PluginSearchResult(
            pluginSourceId: 'multi.mangadex',
            mangaKey: '/manga/abc123',
            title: 'Matched Title',
            coverUrl: 'https://example.com/cover.jpg',
            authors: <String>['Author A'],
          ),
        ),
      ];

      final ConvertableBackup result = builder.build(confirmations);
      final backup = result as AidokuBackup;

      check(backup.manga).isNotNull().length.equals(1);
      final AidokuBackupManga manga = backup.manga!.first;
      check(manga.sourceId).equals('multi.mangadex');
      check(manga.id).equals('/manga/abc123');
      check(manga.title).equals('Matched Title');
      check(manga.cover).equals('https://example.com/cover.jpg');
      check(manga.author).equals('Author A');
      check(manga.artist).equals('Artist B');
      check(manga.desc).equals('A great manga');
      check(manga.tags).isNotNull().deepEquals(<Object?>['Action', 'Comedy']);

      check(backup.library).isNotNull().length.equals(1);
      final AidokuBackupLibraryManga lib = backup.library!.first;
      check(lib.mangaId).equals('/manga/abc123');
      check(lib.sourceId).equals('multi.mangadex');
      check(lib.categories).deepEquals(<String>['Favorites']);
      check(lib.dateAdded).equals(DateTime(2024));

      check(backup.sources).isNotNull().length.equals(1);
      check(backup.sources!.contains('multi.mangadex')).isTrue();

      check(backup.categories).isNotNull().contains('Favorites');
    });

    test('skipped (null) match is filtered out', () {
      final confirmations = <MangaMatchConfirmation>[
        const MangaMatchConfirmation(
          sourceManga: SourceMangaData(
            details: MangaSearchDetails(title: 'Skipped Manga'),
          ),
        ),
        const MangaMatchConfirmation(
          sourceManga: SourceMangaData(
            details: MangaSearchDetails(title: 'Kept Manga'),
          ),
          confirmedMatch: PluginSearchResult(
            pluginSourceId: 'en.source',
            mangaKey: 'key1',
            title: 'Kept Manga',
          ),
        ),
      ];

      final ConvertableBackup result = builder.build(confirmations);
      final backup = result as AidokuBackup;

      check(backup.manga).isNotNull().length.equals(1);
      check(backup.manga!.first.title).equals('Kept Manga');
    });

    test('multiple matches with same source deduplicates sources', () {
      final confirmations = <MangaMatchConfirmation>[
        const MangaMatchConfirmation(
          sourceManga: SourceMangaData(
            details: MangaSearchDetails(title: 'Manga A'),
          ),
          confirmedMatch: PluginSearchResult(
            pluginSourceId: 'multi.mangadex',
            mangaKey: 'key-a',
            title: 'Manga A',
          ),
        ),
        const MangaMatchConfirmation(
          sourceManga: SourceMangaData(
            details: MangaSearchDetails(title: 'Manga B'),
          ),
          confirmedMatch: PluginSearchResult(
            pluginSourceId: 'multi.mangadex',
            mangaKey: 'key-b',
            title: 'Manga B',
          ),
        ),
      ];

      final ConvertableBackup result = builder.build(confirmations);
      final backup = result as AidokuBackup;

      check(backup.manga).isNotNull().length.equals(2);
      check(backup.library).isNotNull().length.equals(2);
      check(backup.sources).isNotNull().length.equals(1);
    });

    test('manga with no tags sets tags to null', () {
      final confirmations = <MangaMatchConfirmation>[
        const MangaMatchConfirmation(
          sourceManga: SourceMangaData(
            details: MangaSearchDetails(title: 'No Tags'),
          ),
          confirmedMatch: PluginSearchResult(
            pluginSourceId: 'en.src',
            mangaKey: 'k',
            title: 'No Tags',
          ),
        ),
      ];

      final ConvertableBackup result = builder.build(confirmations);
      final backup = result as AidokuBackup;
      check(backup.manga!.first.tags).isNull();
    });

    test('chapters from source manga are migrated', () {
      final confirmations = <MangaMatchConfirmation>[
        const MangaMatchConfirmation(
          sourceManga: SourceMangaData(
            details: MangaSearchDetails(title: 'With Chapters'),
            chapters: <SourceChapter>[
              SourceChapter(
                title: 'Chapter 1',
                chapterNumber: 1,
                isRead: true,
              ),
              SourceChapter(
                title: 'Chapter 2',
                chapterNumber: 2,
                sourceOrder: 1,
              ),
            ],
          ),
          confirmedMatch: PluginSearchResult(
            pluginSourceId: 'en.src',
            mangaKey: 'manga-key',
            title: 'With Chapters',
          ),
          targetChapters: <PluginChapter>[
            PluginChapter(chapterId: 'ch-1', title: 'Chapter 1', chapterNumber: 1),
            PluginChapter(chapterId: 'ch-2', title: 'Chapter 2', chapterNumber: 2, sourceOrder: 1),
          ],
        ),
      ];

      final ConvertableBackup result = builder.build(confirmations);
      final backup = result as AidokuBackup;

      check(backup.chapters).isNotNull().length.equals(2);
      final List<AidokuBackupChapter> chs = backup.chapters!.toList();
      check(chs[0].title).equals('Chapter 1');
      check(chs[0].chapter).equals(1.0);
      check(chs[0].mangaId).equals('manga-key');
      check(chs[0].sourceId).equals('en.src');
      check(chs[1].title).equals('Chapter 2');

      // Read chapter should produce history entry
      check(backup.history).isNotNull().isNotEmpty();
      final AidokuBackupHistory historyEntry = backup.history!.first;
      check(historyEntry.completed).isTrue();
      check(historyEntry.mangaId).equals('manga-key');
    });

    test('tracking is not migrated (target tracker IDs are unknown)', () {
      final confirmations = <MangaMatchConfirmation>[
        const MangaMatchConfirmation(
          sourceManga: SourceMangaData(
            details: MangaSearchDetails(title: 'Tracked'),
          ),
          confirmedMatch: PluginSearchResult(
            pluginSourceId: 'en.src',
            mangaKey: 'tracked-key',
            title: 'Tracked',
          ),
        ),
      ];

      final ConvertableBackup result = builder.build(confirmations);
      final backup = result as AidokuBackup;

      check(backup.trackItems).isNull();
    });

    test('categories are collected from all confirmed manga', () {
      final confirmations = <MangaMatchConfirmation>[
        const MangaMatchConfirmation(
          sourceManga: SourceMangaData(
            details: MangaSearchDetails(title: 'A'),
            categories: <String>['Favorites', 'Action'],
          ),
          confirmedMatch: PluginSearchResult(
            pluginSourceId: 'src',
            mangaKey: 'a',
            title: 'A',
          ),
        ),
        const MangaMatchConfirmation(
          sourceManga: SourceMangaData(
            details: MangaSearchDetails(title: 'B'),
            categories: <String>['Action', 'Comedy'],
          ),
          confirmedMatch: PluginSearchResult(
            pluginSourceId: 'src',
            mangaKey: 'b',
            title: 'B',
          ),
        ),
      ];

      final ConvertableBackup result = builder.build(confirmations);
      final backup = result as AidokuBackup;

      check(backup.categories).isNotNull().length.equals(3);
      check(backup.categories!).contains('Favorites');
      check(backup.categories!).contains('Action');
      check(backup.categories!).contains('Comedy');
    });
  });

  group('UnimplementedBackupBuilder', () {
    test('throws UnimplementedError', () {
      const builder = UnimplementedBackupBuilder();
      check(() => builder.build(const <MangaMatchConfirmation>[])).throws<UnimplementedError>();
    });
  });
}
