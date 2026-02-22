import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:mangabackupconverter_cli/src/commands/live_search_select.dart';
import 'package:mangabackupconverter_cli/src/commands/terminal_ui.dart';
import 'package:mangabackupconverter_cli/src/pipeline/migration_pipeline.dart';
import 'package:mangabackupconverter_cli/src/pipeline/plugin_source.dart';
import 'package:mangabackupconverter_cli/src/pipeline/source_manga_data.dart';

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

class MigrationEntry {
  MigrationEntry({required this.source})
      : selected = true,
        searching = true,
        candidates = [],
        failures = [];

  final SourceMangaData source;
  bool selected;
  bool searching;
  PluginSearchResult? match;
  List<PluginSearchResult> candidates;
  List<PluginSearchFailure> failures;
}

// ---------------------------------------------------------------------------
// Internal events
// ---------------------------------------------------------------------------

sealed class _DashboardEvent {}

class _KeyEvent extends _DashboardEvent {
  _KeyEvent(this.key);
  final KeyEvent key;
}

class _SearchResultEvent extends _DashboardEvent {
  _SearchResultEvent(this.entry, this.event);
  final MigrationEntry entry;
  final PluginSearchEvent event;
}

class _SearchDoneEvent extends _DashboardEvent {
  _SearchDoneEvent(this.entry);
  final MigrationEntry entry;
}

class _SpinnerTickEvent extends _DashboardEvent {}

// ---------------------------------------------------------------------------
// Dashboard
// ---------------------------------------------------------------------------

class MigrationDashboard {
  Future<List<MangaMatchConfirmation>> run(
    List<SourceMangaData> manga,
    Stream<PluginSearchEvent> Function(String query) onSearch,
    Future<(PluginMangaDetails, List<PluginChapter>)?> Function(
      String pluginSourceId,
      String mangaKey,
    ) onFetchDetails,
  ) async {
    if (manga.isEmpty) return [];

    final List<MigrationEntry> entries = manga.map((SourceMangaData m) => MigrationEntry(source: m)).toList();
    var cursorIndex = 0;
    var scrollOffset = 0;

    final events = StreamController<_DashboardEvent>();
    final spinner = Spinner();
    final screen = ScreenRegion();
    final keyInput = KeyInput();

    // Start key input.
    keyInput.start();
    installSigintHandler();
    final StreamSubscription<KeyEvent> keySub = keyInput.stream.listen((KeyEvent key) => events.add(_KeyEvent(key)));

    // Start searches for all manga concurrently.
    final searchSubs = <StreamSubscription<PluginSearchEvent>>[];
    for (final entry in entries) {
      final Stream<PluginSearchEvent> stream = onSearch(entry.source.details.title);
      searchSubs.add(
        stream.listen(
          (PluginSearchEvent event) => events.add(_SearchResultEvent(entry, event)),
          onDone: () => events.add(_SearchDoneEvent(entry)),
        ),
      );
    }

    // Spinner tick.
    spinner.start(() => events.add(_SpinnerTickEvent()));

    hideCursor();

    void render() {
      final int maxVisible = _maxVisibleEntries();
      // Adjust scroll to keep cursor visible.
      if (cursorIndex < scrollOffset) scrollOffset = cursorIndex;
      if (cursorIndex >= scrollOffset + maxVisible) {
        scrollOffset = cursorIndex - maxVisible + 1;
      }

      final lines = <String>[];
      lines.add(bold('Migration'));
      lines.add('');

      final int visibleEnd = min(entries.length, scrollOffset + maxVisible);
      if (scrollOffset > 0) {
        lines.add(dim('↑ more above'));
      }

      for (var i = scrollOffset; i < visibleEnd; i++) {
        final MigrationEntry entry = entries[i];
        final isCursor = i == cursorIndex;
        lines.addAll(_renderEntry(entry, isCursor, spinner));
      }

      if (visibleEnd < entries.length) {
        lines.add(dim('↓ more below'));
      }

      lines.add('');
      lines.add(
        dim('y to accept selections')
        + dim(' · ')
        + dim('Space to toggle')
        + dim(' · ')
        + dim('Enter to choose manually'),
      );

      screen.render(lines);
    }

    render();

    var accepted = false;

    try {
      await for (final _DashboardEvent event in events.stream) {
        switch (event) {
          case _KeyEvent(key: ArrowUp()):
            cursorIndex = max(0, cursorIndex - 1);
            render();

          case _KeyEvent(key: ArrowDown()):
            cursorIndex = min(entries.length - 1, cursorIndex + 1);
            render();

          case _KeyEvent(key: Space()):
            entries[cursorIndex].selected = !entries[cursorIndex].selected;
            render();

          case _KeyEvent(key: CharKey(char: 'y')):
            accepted = true;
            unawaited(events.close());

          case _KeyEvent(key: Enter()):
            // Pause dashboard, open live search for this manga.
            screen.clear();
            showCursor();

            final MigrationEntry entry = entries[cursorIndex];
            final liveSearch = LiveSearchSelect();
            final PluginSearchResult? result = await liveSearch.run(
              initialQuery: entry.source.details.title,
              onSearch: onSearch,
              onFetchDetails: onFetchDetails,
            );
            if (result != null) {
              entry.match = result;
              entry.selected = true;
            }

            hideCursor();
            render();

          case _SearchResultEvent(:final entry, event: PluginSearchResults(:final results)):
            entry.candidates.addAll(results);
            entry.match ??= _findBestMatch(entry.source.details.title, results);
            render();

          case _SearchResultEvent(:final entry, event: PluginSearchError(:final failure)):
            entry.failures.add(failure);

          case _SearchDoneEvent(:final entry):
            entry.searching = false;
            render();

          case _SpinnerTickEvent():
            if (entries.any((MigrationEntry e) => e.searching)) render();

          case _KeyEvent():
            break; // Unhandled keys.
        }

        if (events.isClosed) break;
      }
    } finally {
      // Cleanup — always restore terminal state.
      spinner.stop();
      for (final sub in searchSubs) {
        await sub.cancel();
      }
      await keySub.cancel();
      keyInput.dispose();
      removeSigintHandler();
      screen.clear();
      showCursor();
    }

    if (!accepted) return [];

    return entries
        .map(
          (MigrationEntry e) => MangaMatchConfirmation(
            sourceManga: e.source,
            confirmedMatch: e.selected ? e.match : null,
          ),
        )
        .toList();
  }
}

// ---------------------------------------------------------------------------
// Rendering helpers
// ---------------------------------------------------------------------------

int _maxVisibleEntries() {
  try {
    // Each entry takes ~4 lines, reserve 6 lines for header/footer.
    return max(1, (stdout.terminalLines - 6) ~/ 4);
  } on StdoutException {
    return 5;
  }
}

List<String> _renderEntry(MigrationEntry entry, bool isCursor, Spinner spinner) {
  final prefix = isCursor ? '❯ ' : '  ';
  final checkbox = entry.selected ? '◉' : '◯';
  final int width = terminalWidth;

  final String sourceTitle = entry.source.details.title;
  final String sourceAuthors = <String>{
    ...entry.source.details.authors,
    ...entry.source.details.artists,
  }.join(', ');
  final int sourceChapters = entry.source.chapters.length;
  final String sourceInfo =
      [if (sourceAuthors.isNotEmpty) sourceAuthors, '$sourceChapters chapters'].join(' · ');

  final lines = <String>[];
  lines.add(truncate('$prefix$checkbox ${bold(sourceTitle)}', width));
  lines.add(truncate('$prefix  ${dim(sourceInfo)}', width));
  lines.add('$prefix  ${dim('↓')}');

  if (entry.searching && entry.match == null) {
    lines.add('$prefix  ${spinner.frame}');
  } else if (entry.match != null) {
    final PluginSearchResult m = entry.match!;
    final String matchAuthors = m.authors.join(', ');
    final matchLine = '[${m.pluginSourceId}] ${m.title}';
    lines.add(truncate('$prefix  ${green(matchLine)}', width));
    if (matchAuthors.isNotEmpty) {
      lines.add(truncate('$prefix  ${dim(matchAuthors)}', width));
    }
  } else {
    lines.add('$prefix  ${dim('No match found')}');
  }

  return lines;
}

PluginSearchResult? _findBestMatch(String sourceTitle, List<PluginSearchResult> results) {
  if (results.isEmpty) return null;
  final String lower = sourceTitle.toLowerCase();
  for (final r in results) {
    if (r.title.toLowerCase() == lower) return r;
  }
  return results.first;
}
