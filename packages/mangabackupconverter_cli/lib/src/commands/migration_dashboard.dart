import 'dart:async';
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
  MigrationEntry({required this.source}) : selected = true, searching = true, candidates = [], failures = [];

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
  Future<List<MangaMatchConfirmation>> run({
    required TerminalContext context,
    required List<SourceMangaData> manga,
    required Stream<PluginSearchEvent> Function(String query) onSearch,
    required Future<(PluginMangaDetails, List<PluginChapter>)?> Function(
      String pluginSourceId,
      String mangaKey,
    )
    onFetchDetails,
  }) async {
    if (manga.isEmpty) return [];

    final List<MigrationEntry> entries = manga.map((SourceMangaData m) => MigrationEntry(source: m)).toList();
    var cursorIndex = 0;
    var scrollOffset = 0;

    final events = StreamController<_DashboardEvent>();
    final spinner = Spinner();
    final screen = ScreenRegion(context);

    // Listen for key events on shared KeyInput (broadcast stream).
    StreamSubscription<KeyEvent> keySub = context.keyInput.stream.listen((KeyEvent key) => events.add(_KeyEvent(key)));

    // Search entries one at a time — each search enriches results with
    // getMangaDetails which shares the plugin, so we avoid concurrent calls.
    var nextSearchIndex = 0;
    StreamSubscription<PluginSearchEvent>? activeSub;

    void startNextSearch() {
      if (nextSearchIndex >= entries.length) return;
      final MigrationEntry entry = entries[nextSearchIndex++];
      final Stream<PluginSearchEvent> stream = onSearch(entry.source.details.title);
      activeSub = stream.listen(
        (PluginSearchEvent event) => events.add(_SearchResultEvent(entry, event)),
        onDone: () => events.add(_SearchDoneEvent(entry)),
      );
    }

    startNextSearch();

    // Spinner tick.
    spinner.start(() => events.add(_SpinnerTickEvent()));

    context.hideCursor();

    void render() {
      final int budget = max(4, context.height - 6);

      // Adjust scroll to keep cursor visible.
      if (cursorIndex < scrollOffset) scrollOffset = cursorIndex;
      while (cursorIndex >= scrollOffset + _visibleCount(entries, scrollOffset, budget)) {
        scrollOffset++;
      }

      final int visibleEnd = min(
        entries.length,
        scrollOffset + _visibleCount(entries, scrollOffset, budget),
      );

      final lines = <String>[];
      lines.add(bold('Migration'));
      lines.add('');
      if (scrollOffset > 0) {
        lines.add(dim('↑ more above'));
      }

      for (var i = scrollOffset; i < visibleEnd; i++) {
        final MigrationEntry entry = entries[i];
        final isCursor = i == cursorIndex;
        lines.addAll(_renderEntry(entry, isCursor, spinner, context.width));
      }

      if (visibleEnd < entries.length) {
        lines.add(dim('↓ more below'));
      }

      lines.add('');
      final bool allDone = !entries.any((MigrationEntry e) => e.searching);
      final acceptHint = allDone
          ? 'y to accept selections'
          : 'searching... ${spinner.frame}';
      lines.add(
        dim(acceptHint) +
            dim(' · ') +
            dim('Space to toggle') +
            dim(' · ') +
            dim('Enter to choose manually'),
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
            if (entries.any((MigrationEntry e) => e.searching)) break;
            accepted = true;
            unawaited(events.close());

          case _KeyEvent(key: Enter()):
            // Pause dashboard, open live search for this manga.
            await keySub.cancel();
            screen.clear();

            final MigrationEntry entry = entries[cursorIndex];
            final liveSearch = LiveSearchSelect();
            final PluginSearchResult? result = await liveSearch.run(
              context: context,
              initialQuery: entry.source.details.title,
              onSearch: onSearch,
              onFetchDetails: onFetchDetails,
            );
            if (result != null) {
              entry.match = result;
              entry.selected = true;
            }

            keySub = context.keyInput.stream.listen(
              (KeyEvent key) => events.add(_KeyEvent(key)),
            );
            context.hideCursor();
            render();

          case _SearchResultEvent(:final entry, event: PluginSearchResults(:final results)):
            entry.candidates.addAll(results);
            entry.match ??= _findBestMatch(entry.source.details.title, results);
            render();

          case _SearchResultEvent(:final entry, event: PluginSearchError(:final failure)):
            entry.failures.add(failure);

          case _SearchDoneEvent(:final entry):
            entry.searching = false;
            startNextSearch();
            render();

          case _SpinnerTickEvent():
            if (entries.any((MigrationEntry e) => e.searching)) render();

          case _KeyEvent():
            break; // Unhandled keys.
        }

        if (events.isClosed) break;
      }
    } finally {
      // Cleanup -- always restore terminal state.
      spinner.stop();
      await activeSub?.cancel();
      await keySub.cancel();
      screen.clear();
      context.showCursor();
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

int _entryLineCount(MigrationEntry entry) => 5;

/// How many entries fit within [budget] lines starting from [scrollOffset].
int _visibleCount(List<MigrationEntry> entries, int scrollOffset, int budget) {
  var used = 0;
  var count = 0;
  for (var i = scrollOffset; i < entries.length; i++) {
    final int h = _entryLineCount(entries[i]);
    if (used + h > budget) break;
    used += h;
    count++;
  }
  return max(1, count);
}

List<String> _renderEntry(MigrationEntry entry, bool isCursor, Spinner spinner, int width) {
  final checkbox = entry.selected ? '◉' : '◯';
  const indent = '  ';

  final String sourceTitle = entry.source.details.title;
  final String sourceAuthors = <String>{
    ...entry.source.details.authors,
    ...entry.source.details.artists,
  }.join(', ');
  final int sourceChapters = entry.source.chapters.length;
  final String? sourceId = entry.source.sourceId;
  final String sourceInfo = [
    if (sourceId != null && sourceId.isNotEmpty) sourceId,
    if (sourceAuthors.isNotEmpty) sourceAuthors,
    '$sourceChapters chapters',
  ].join(' · ');

  final lines = <String>[];
  final cursorMark = isCursor ? '❯ ' : '  ';
  lines.add(truncate('$cursorMark$checkbox ${bold(sourceTitle)}', width));
  lines.add(truncate('$indent  ${dim(sourceInfo)}', width));

  if (!entry.selected) {
    lines.add('$indent  ${dim('⏭ skipped')}');
    lines.add(indent);
    lines.add(indent);
  } else {
    lines.add('$indent  ${dim('↓')}');

    if (entry.searching && entry.match == null) {
      lines.add('$indent  ${spinner.frame}');
      lines.add(indent);
    } else if (entry.match != null) {
      final PluginSearchResult m = entry.match!;
      final PluginMangaDetails? d = m.details;
      final String matchText = green(m.title);
      final String? linkUrl = d?.url;
      final String linkedMatch = linkUrl != null ? hyperlink(matchText, linkUrl) : matchText;
      lines.add(truncate('$indent  $linkedMatch', width));

      final String matchAuthors = <String>{
        ...m.authors,
        if (d != null) ...d.artists,
      }.join(', ');
      final String? chapterCount = d != null ? '${m.chapters.length} chapters' : null;
      final String infoLine = [
        m.pluginSourceId,
        if (matchAuthors.isNotEmpty) matchAuthors,
        if (chapterCount != null) chapterCount,
      ].join(' · ');
      lines.add(infoLine.isNotEmpty ? truncate('$indent  ${dim(infoLine)}', width) : indent);
    } else {
      lines.add('$indent  ${dim('No match found')}');
      lines.add(indent);
    }
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
