import 'dart:async';

import 'package:checks/checks.dart';
import 'package:mangabackupconverter_cli/src/common/convertable.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_backup.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_backup_chapter.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_backup_history.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_backup_manga.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_backup_tracking.dart';
import 'package:mangabackupconverter_cli/src/formats/tachimanga/tachimanga_backup.dart';
import 'package:mangabackupconverter_cli/src/pipeline/backup_format.dart';
import 'package:mangabackupconverter_cli/src/pipeline/extension_entry.dart';
import 'package:mangabackupconverter_cli/src/pipeline/migration_pipeline.dart';
import 'package:mangabackupconverter_cli/src/pipeline/plugin_loader.dart';
import 'package:mangabackupconverter_cli/src/pipeline/plugin_source.dart';
import 'package:mangabackupconverter_cli/src/pipeline/source_manga_data.dart';
import 'package:test/scaffolding.dart';

TachiBackup _minimalTachiBackup() {
  return const TachiBackup(
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
        viewer: 0,
        viewerFlags: 0,
        chapterFlags: 0,
        favorite: true,
        chapters: <TachiBackupChapter>[],
        categories: <int>[],
        tracking: <TachiBackupTracking>[],
        history: <TachiBackupHistory>[],
      ),
    ],
  );
}

class _FakePluginLoader extends PluginLoader {
  _FakePluginLoader(this.extensions, this.sources);

  final List<ExtensionEntry> extensions;
  final List<PluginSource> sources;

  @override
  Future<List<ExtensionEntry>> fetchExtensionLists(
    List<String> repoUrls, {
    void Function(String)? onWarning,
  }) async => extensions;

  @override
  Future<List<PluginSource>> loadPlugins(
    List<ExtensionEntry> extensions, {
    void Function(int current, int total, String message)? onProgress,
  }) async => sources;
}

class _FakePluginSource implements PluginSource {
  _FakePluginSource({required this.sourceId, required this.sourceName});

  @override
  final String sourceId;

  @override
  final String sourceName;

  List<PluginSearchResult> searchResults = <PluginSearchResult>[];

  @override
  Future<PluginSearchPageResult> search(String query, int page) async {
    return PluginSearchPageResult(results: searchResults, hasNextPage: false);
  }

  @override
  Future<(PluginMangaDetails, List<PluginChapter>)?> getMangaWithChapters(
    String mangaKey,
  ) async => null;

  @override
  void dispose() {}
}

void main() {
  group('MigrationPipeline', () {
    group('DirectConversion', () {
      test('Tachi → Tachimanga uses direct conversion', () async {
        final TachiBackup tachiBackup = _minimalTachiBackup();

        final pipeline = MigrationPipeline(
          repoUrls: <String>[],
          onSelectExtensions: (_) async => <ExtensionEntry>[],
          onConfirmMatches: (_, __, ___, ____) async => <MangaMatchConfirmation>[],
          onProgress: (_, __, ___) {},
        );

        final ConvertableBackup result = await pipeline.run(
          sourceBackup: tachiBackup,
          sourceFormat: const Mihon(),
          targetFormat: const Tachimanga(),
        );

        check(result).isA<TachimangaBackup>();
      });

      test('result is TachimangaBackup for Tachi → Tachimanga', () async {
        final TachiBackup tachiBackup2 = _minimalTachiBackup();

        final pipeline = MigrationPipeline(
          repoUrls: <String>[],
          onSelectExtensions: (_) async => <ExtensionEntry>[],
          onConfirmMatches: (_, __, ___, ____) async => <MangaMatchConfirmation>[],
          onProgress: (_, __, ___) {},
        );

        final ConvertableBackup result = await pipeline.run(
          sourceBackup: tachiBackup2,
          sourceFormat: const TachiSy(),
          targetFormat: const Tachimanga(),
        );

        check(result).isA<TachimangaBackup>();
      });
    });

    group('Migration', () {
      test('calls onConfirmMatches with source manga data', () async {
        final TachiBackup tachiBackup = _minimalTachiBackup();
        final fakeSource = _FakePluginSource(
          sourceId: 'fake',
          sourceName: 'Fake',
        );
        final fakeLoader = _FakePluginLoader(
          <ExtensionEntry>[
            const StubExtensionEntry(id: 'ext1', name: 'Ext 1'),
          ],
          <PluginSource>[fakeSource],
        );

        List<SourceMangaData>? receivedManga;

        final pipeline = MigrationPipeline(
          repoUrls: <String>['https://example.com'],
          pluginLoader: fakeLoader,
          onSelectExtensions: (extensions) async => extensions,
          onConfirmMatches: (pluginNames, manga, onSearch, onFetchDetails) async {
            receivedManga = manga;
            return manga.map((SourceMangaData m) {
              return MangaMatchConfirmation(sourceManga: m);
            }).toList();
          },
          onProgress: (_, __, ___) {},
        );

        await pipeline.run(
          sourceBackup: tachiBackup,
          sourceFormat: const Mihon(),
          targetFormat: const Aidoku(),
        );

        check(receivedManga).isNotNull().length.equals(1);
      });
    });

    group('forceMigration', () {
      test('uses plugin migration instead of direct conversion when forced', () async {
        final TachiBackup tachiBackup = _minimalTachiBackup();
        final fakeSource = _FakePluginSource(
          sourceId: 'fake',
          sourceName: 'Fake',
        );
        final fakeLoader = _FakePluginLoader(
          <ExtensionEntry>[
            const StubExtensionEntry(id: 'ext1', name: 'Ext 1'),
          ],
          <PluginSource>[fakeSource],
        );

        var migrationPathUsed = false;

        final pipeline = MigrationPipeline(
          repoUrls: <String>['https://example.com'],
          pluginLoader: fakeLoader,
          onSelectExtensions: (extensions) async => extensions,
          onConfirmMatches: (pluginNames, manga, onSearch, onFetchDetails) async {
            migrationPathUsed = true;
            return manga.map((SourceMangaData m) {
              return MangaMatchConfirmation(sourceManga: m);
            }).toList();
          },
          onProgress: (_, __, ___) {},
        );

        // Mihon → Tachimanga is normally DirectConversion.
        // With forceMigration, it takes the migration path instead.
        // The build step throws because Tachimanga's builder is unimplemented,
        // but onConfirmMatches being called proves migration was used.
        Object? caughtError;
        try {
          await pipeline.run(
            sourceBackup: tachiBackup,
            sourceFormat: const Mihon(),
            targetFormat: const Tachimanga(),
            forceMigration: true,
          );
        } on Object catch (e) {
          caughtError = e;
        }

        check(caughtError).isA<UnimplementedError>();

        check(migrationPathUsed).isTrue();
      });
    });

    group('_streamSearch', () {
      test('emits PluginSearchStarted and PluginSearchResults', () async {
        final fakeSource = _FakePluginSource(
          sourceId: 'fake',
          sourceName: 'Fake',
        );
        fakeSource.searchResults = <PluginSearchResult>[
          const PluginSearchResult(
            pluginSourceId: 'fake',
            mangaKey: 'key1',
            title: 'Result 1',
          ),
        ];
        final fakeLoader = _FakePluginLoader(
          <ExtensionEntry>[
            const StubExtensionEntry(id: 'ext1', name: 'Ext 1'),
          ],
          <PluginSource>[fakeSource],
        );

        late Stream<PluginSearchEvent> Function(String) capturedOnSearch;

        final pipeline = MigrationPipeline(
          repoUrls: <String>['https://example.com'],
          pluginLoader: fakeLoader,
          onSelectExtensions: (extensions) async => extensions,
          onConfirmMatches: (pluginNames, manga, onSearch, onFetchDetails) async {
            capturedOnSearch = onSearch;
            return manga.map((SourceMangaData m) {
              return MangaMatchConfirmation(sourceManga: m);
            }).toList();
          },
          onProgress: (_, __, ___) {},
        );

        final TachiBackup tachiBackup = _minimalTachiBackup();
        await pipeline.run(
          sourceBackup: tachiBackup,
          sourceFormat: const Mihon(),
          targetFormat: const Aidoku(),
        );

        final List<PluginSearchEvent> events = await capturedOnSearch('test').toList();
        check(events.first).isA<PluginSearchStarted>();
        check(events.last).isA<PluginSearchResults>();
      });
    });
  });
}
