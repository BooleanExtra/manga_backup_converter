@TestOn('vm')
library;

import 'dart:async';

import 'package:checks/checks.dart';
import 'package:mangabackupconverter_cli/src/commands/migration_dashboard.dart';
import 'package:mangabackupconverter_cli/src/commands/terminal_ui.dart';
import 'package:mangabackupconverter_cli/src/pipeline/manga_details.dart';
import 'package:mangabackupconverter_cli/src/pipeline/migration_pipeline.dart';
import 'package:mangabackupconverter_cli/src/pipeline/plugin_source.dart';
import 'package:mangabackupconverter_cli/src/pipeline/source_manga_data.dart';
import 'package:test/scaffolding.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

SourceMangaData _source(String title, {int chapters = 0}) => SourceMangaData(
  details: MangaSearchDetails(title: title),
  chapters: List<SourceChapter>.generate(
    chapters,
    (int i) => SourceChapter(title: 'Ch ${i + 1}', chapterNumber: i + 1.0),
  ),
);

PluginSearchResult _result(
  String pluginId,
  String title, {
  String? mangaKey,
  List<PluginChapter> chapters = const [],
  PluginMangaDetails? details,
}) => PluginSearchResult(
  pluginSourceId: pluginId,
  mangaKey: mangaKey ?? title.toLowerCase().replaceAll(' ', '-'),
  title: title,
  chapters: chapters,
  details: details,
);

List<PluginChapter> _chapters(int count) => List<PluginChapter>.generate(
  count,
  (int i) => PluginChapter(chapterId: 'ch-$i', chapterNumber: i + 1.0),
);

/// Runs the dashboard with the given manga and fake search/enrichment callbacks,
/// then presses 'y' to accept after all searches complete.
Future<List<MangaMatchConfirmation>> _runDashboard({
  required List<SourceMangaData> manga,
  required Stream<PluginSearchEvent> Function(String query) onSearch,
  required Future<(PluginMangaDetails, List<PluginChapter>)?> Function(
    String pluginSourceId,
    String mangaKey,
  )
  onFetchDetails,
  List<String> pluginNames = const ['testPlugin'],
  void Function(StreamController<List<int>> input)? beforeAccept,
}) async {
  final output = StringBuffer();
  final input = StreamController<List<int>>.broadcast();

  final context = TerminalContext.test(
    output: output,
    inputStream: input.stream,
    height: 40,
    width: 120,
  );

  final dashboard = MigrationDashboard();
  final Future<List<MangaMatchConfirmation>> future = dashboard.run(
    context: context,
    pluginNames: pluginNames,
    manga: manga,
    onSearch: onSearch,
    onFetchDetails: onFetchDetails,
  );

  // Wait for searches + enrichment to settle.
  await Future<void>.delayed(const Duration(milliseconds: 300));

  beforeAccept?.call(input);
  await Future<void>.delayed(const Duration(milliseconds: 50));

  // Press 'y' to accept.
  input.add([0x79]); // 'y'
  await Future<void>.delayed(const Duration(milliseconds: 50));

  final List<MangaMatchConfirmation> confirmations = await future;
  context.dispose();
  await input.close();
  return confirmations;
}

void main() {
  group('MigrationDashboard', () {
    test('enriches candidates and picks match with most chapters', () async {
      final List<MangaMatchConfirmation> results = await _runDashboard(
        manga: [_source('Naruto', chapters: 100)],
        onSearch: (String query) {
          final controller = StreamController<PluginSearchEvent>();
          scheduleMicrotask(() {
            controller.add(
              PluginSearchResults(
                pluginId: 'pluginA',
                results: [_result('pluginA', 'Naruto')],
              ),
            );
            controller.add(
              PluginSearchResults(
                pluginId: 'pluginB',
                results: [_result('pluginB', 'Naruto')],
              ),
            );
            controller.close();
          });
          return controller.stream;
        },
        onFetchDetails: (String pluginSourceId, String mangaKey) async {
          final chapterCount = pluginSourceId == 'pluginA' ? 50 : 200;
          return (
            PluginMangaDetails(
              key: mangaKey,
              title: 'Naruto',
              authors: ['Kishimoto'],
            ),
            _chapters(chapterCount),
          );
        },
        pluginNames: ['pluginA', 'pluginB'],
      );

      check(results).length.equals(1);
      final PluginSearchResult match = results.first.confirmedMatch!;
      check(match.pluginSourceId).equals('pluginB');
      check(match.chapters).length.equals(200);
    });

    test('takes only first result per plugin', () async {
      final List<MangaMatchConfirmation> results = await _runDashboard(
        manga: [_source('One Piece')],
        onSearch: (String query) {
          final controller = StreamController<PluginSearchEvent>();
          scheduleMicrotask(() {
            controller.add(
              PluginSearchResults(
                pluginId: 'plugin1',
                results: [
                  _result('plugin1', 'One Piece'),
                  _result('plugin1', 'One Piece: Wanted!'),
                ],
              ),
            );
            controller.close();
          });
          return controller.stream;
        },
        onFetchDetails: (String pluginSourceId, String mangaKey) async => (
          PluginMangaDetails(key: mangaKey, title: 'One Piece'),
          _chapters(10),
        ),
      );

      check(results).length.equals(1);
      // Should have only 1 candidate (first result), not 2.
      final PluginSearchResult match = results.first.confirmedMatch!;
      check(match.title).equals('One Piece');
    });

    test('handles enrichment failure gracefully', () async {
      final List<MangaMatchConfirmation> results = await _runDashboard(
        manga: [_source('Bleach')],
        onSearch: (String query) {
          final controller = StreamController<PluginSearchEvent>();
          scheduleMicrotask(() {
            controller.add(
              PluginSearchResults(
                pluginId: 'plugin1',
                results: [_result('plugin1', 'Bleach')],
              ),
            );
            controller.close();
          });
          return controller.stream;
        },
        onFetchDetails: (String pluginSourceId, String mangaKey) async {
          throw Exception('Network error');
        },
      );

      check(results).length.equals(1);
      // Match should still be set (unenriched candidate kept).
      final PluginSearchResult match = results.first.confirmedMatch!;
      check(match.title).equals('Bleach');
    });

    test('no candidates yields no match', () async {
      final List<MangaMatchConfirmation> results = await _runDashboard(
        manga: [_source('Obscure Manga')],
        onSearch: (String query) {
          final controller = StreamController<PluginSearchEvent>();
          scheduleMicrotask(() {
            controller.add(
              PluginSearchResults(
                pluginId: 'plugin1',
                results: [],
              ),
            );
            controller.close();
          });
          return controller.stream;
        },
        onFetchDetails: (String pluginSourceId, String mangaKey) async => null,
      );

      check(results).length.equals(1);
      check(results.first.confirmedMatch).isNull();
    });

    test('toggling entry off skips it in results', () async {
      final List<MangaMatchConfirmation> results = await _runDashboard(
        manga: [_source('Manga A'), _source('Manga B')],
        onSearch: (String query) {
          final controller = StreamController<PluginSearchEvent>();
          scheduleMicrotask(() {
            controller.add(
              PluginSearchResults(
                pluginId: 'plugin1',
                results: [_result('plugin1', query)],
              ),
            );
            controller.close();
          });
          return controller.stream;
        },
        onFetchDetails: (String pluginSourceId, String mangaKey) async => (
          PluginMangaDetails(key: mangaKey, title: mangaKey),
          _chapters(5),
        ),
        beforeAccept: (StreamController<List<int>> input) {
          // Press Space on first entry to deselect it.
          input.add([0x20]); // Space
        },
      );

      check(results).length.equals(2);
      // First entry deselected -> confirmedMatch is null.
      check(results.first.confirmedMatch).isNull();
      // Second entry should still have a match.
      check(results[1].confirmedMatch).isNotNull();
    });

    test('enriched details populate authors and chapters', () async {
      final List<MangaMatchConfirmation> results = await _runDashboard(
        manga: [_source('Test Manga')],
        onSearch: (String query) {
          final controller = StreamController<PluginSearchEvent>();
          scheduleMicrotask(() {
            controller.add(
              PluginSearchResults(
                pluginId: 'plugin1',
                results: [
                  _result('plugin1', 'Test Manga', mangaKey: 'test-key'),
                ],
              ),
            );
            controller.close();
          });
          return controller.stream;
        },
        onFetchDetails: (String pluginSourceId, String mangaKey) async => (
          PluginMangaDetails(
            key: mangaKey,
            title: 'Test Manga',
            authors: ['Author A'],
            artists: ['Artist B'],
            url: 'https://example.com/test',
          ),
          _chapters(42),
        ),
      );

      check(results).length.equals(1);
      final PluginSearchResult match = results.first.confirmedMatch!;
      check(match.authors).deepEquals(['Author A']);
      check(match.chapters).length.equals(42);
      check(match.details)
          .isNotNull()
          .has(
            (PluginMangaDetails d) => d.url,
            'url',
          )
          .equals('https://example.com/test');
    });

    test('multiple manga entries searched sequentially', () async {
      var searchCount = 0;

      final List<MangaMatchConfirmation> results = await _runDashboard(
        manga: [_source('Manga 1'), _source('Manga 2'), _source('Manga 3')],
        onSearch: (String query) {
          searchCount++;
          final controller = StreamController<PluginSearchEvent>();
          scheduleMicrotask(() {
            controller.add(
              PluginSearchResults(
                pluginId: 'plugin1',
                results: [_result('plugin1', query)],
              ),
            );
            controller.close();
          });
          return controller.stream;
        },
        onFetchDetails: (String pluginSourceId, String mangaKey) async => (
          PluginMangaDetails(key: mangaKey, title: mangaKey),
          _chapters(3),
        ),
      );

      check(searchCount).equals(3);
      check(results).length.equals(3);
      for (final r in results) {
        check(r.confirmedMatch).isNotNull();
      }
    });
  });
}
