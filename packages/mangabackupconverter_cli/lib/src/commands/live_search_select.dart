import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:mangabackupconverter_cli/src/commands/manga_details_screen.dart';
import 'package:mangabackupconverter_cli/src/commands/terminal_ui.dart';
import 'package:mangabackupconverter_cli/src/pipeline/migration_pipeline.dart';
import 'package:mangabackupconverter_cli/src/pipeline/plugin_source.dart';

// ---------------------------------------------------------------------------
// Per-plugin status
// ---------------------------------------------------------------------------

enum _PluginSearchState { searching, done, failed }

class _PluginStatus {
  _PluginSearchState state = _PluginSearchState.searching;
  final results = <PluginSearchResult>[];
}

// ---------------------------------------------------------------------------
// Internal events
// ---------------------------------------------------------------------------

sealed class _SearchEvent {}

class _KeyEvent extends _SearchEvent {
  _KeyEvent(this.key);
  final KeyEvent key;
}

class _PluginResultEvent extends _SearchEvent {
  _PluginResultEvent(this.generation, this.event);
  final int generation;
  final PluginSearchEvent event;
}

class _PluginStreamDoneEvent extends _SearchEvent {
  _PluginStreamDoneEvent(this.generation);
  final int generation;
}

class _SpinnerTickEvent extends _SearchEvent {}

class _DebounceFireEvent extends _SearchEvent {}

// ---------------------------------------------------------------------------
// Live search select
// ---------------------------------------------------------------------------

class LiveSearchSelect {
  Future<PluginSearchResult?> run({
    required String initialQuery,
    required Stream<PluginSearchEvent> Function(String query) onSearch,
    required Future<(PluginMangaDetails, List<PluginChapter>)?> Function(
      String pluginSourceId,
      String mangaKey,
    ) onFetchDetails,
  }) async {
    var query = initialQuery;
    var cursorIndex = 0;
    var scrollOffset = 0;
    var searchGeneration = 0;
    final pluginStatuses = <String, _PluginStatus>{};
    StreamSubscription<PluginSearchEvent>? currentSearchSub;
    Timer? debounceTimer;

    final events = StreamController<_SearchEvent>();
    final spinner = Spinner();
    final screen = ScreenRegion();
    final keyInput = KeyInput();

    // Start key input.
    keyInput.start();
    installSigintHandler();
    final StreamSubscription<KeyEvent> keySub = keyInput.stream.listen((KeyEvent key) => events.add(_KeyEvent(key)));
    spinner.start(() => events.add(_SpinnerTickEvent()));

    List<PluginSearchResult> allResults() {
      final results = <PluginSearchResult>[];
      for (final _PluginStatus status in pluginStatuses.values) {
        results.addAll(status.results);
      }
      return results;
    }

    bool anySearching() =>
        pluginStatuses.values.any((_PluginStatus s) => s.state == _PluginSearchState.searching);

    void startSearch(String q) {
      currentSearchSub?.cancel();
      pluginStatuses.clear();
      cursorIndex = 0;
      scrollOffset = 0;
      searchGeneration++;
      final gen = searchGeneration;

      final Stream<PluginSearchEvent> stream = onSearch(q);
      currentSearchSub = stream.listen(
        (PluginSearchEvent event) => events.add(_PluginResultEvent(gen, event)),
        onDone: () => events.add(_PluginStreamDoneEvent(gen)),
      );
    }

    hideCursor();

    void render() {
      final int width = terminalWidth;
      final List<PluginSearchResult> results = allResults();
      final bool searching = anySearching();
      final int maxVisible = _maxVisibleResults();

      // Adjust scroll.
      if (results.isNotEmpty) {
        cursorIndex = cursorIndex.clamp(0, results.length - 1);
      }
      if (cursorIndex < scrollOffset) scrollOffset = cursorIndex;
      if (cursorIndex >= scrollOffset + maxVisible) {
        scrollOffset = cursorIndex - maxVisible + 1;
      }

      final lines = <String>[];

      // Header.
      if (searching) {
        lines.add('┌ ${bold('Searching...')} ${spinner.frame}');
      } else {
        lines.add('┌ ${bold('${results.length} results')}');
      }
      lines.add('│');

      // Results.
      if (results.isEmpty && !searching) {
        lines.add('  ${dim('No results found')}');
      } else {
        if (scrollOffset > 0) lines.add(dim('↑ more above'));

        final int visibleEnd = min(results.length, scrollOffset + maxVisible);
        for (var i = scrollOffset; i < visibleEnd; i++) {
          final PluginSearchResult r = results[i];
          final isCursor = i == cursorIndex;
          final prefix = isCursor ? '❯ ' : '  ';
          final authorStr = r.authors.isNotEmpty ? ' · ${r.authors.join(', ')}' : '';
          final line = '[${r.pluginSourceId}] ${r.title}$authorStr';
          lines.add(truncate('$prefix$line', width));
        }

        if (visibleEnd < results.length) lines.add(dim('↓ more below'));
      }

      // Per-plugin spinners / errors.
      for (final MapEntry<String, _PluginStatus> entry in pluginStatuses.entries) {
        if (entry.value.state == _PluginSearchState.searching) {
          lines.add('  [${entry.key}] ${spinner.frame}');
        } else if (entry.value.state == _PluginSearchState.failed) {
          lines.add('  ${yellow('[${entry.key}] ⚠ search failed')}');
        }
      }

      lines.add('');
      lines.add(
        dim('type to search · Space for details · Enter to select · Esc to back'),
      );

      // Search input box.
      final inputContent = '⌕ $query';
      final int boxWidth = max(width - 2, 10);
      final String inner = truncate(inputContent, boxWidth).padRight(boxWidth);
      lines.add('╭${'─' * boxWidth}╮');
      lines.add('│$inner│');
      lines.add('╰${'─' * boxWidth}╯');

      screen.render(lines);
    }

    // Initial search.
    startSearch(query);
    render();

    PluginSearchResult? selected;

    try {
      await for (final _SearchEvent event in events.stream) {
        switch (event) {
          case _KeyEvent(key: Escape()):
            unawaited(events.close());

          case _KeyEvent(key: Enter()):
            final List<PluginSearchResult> results = allResults();
            if (results.isNotEmpty && cursorIndex < results.length) {
              selected = results[cursorIndex];
            }
            unawaited(events.close());

          case _KeyEvent(key: ArrowUp()):
            cursorIndex = max(0, cursorIndex - 1);
            render();

          case _KeyEvent(key: ArrowDown()):
            final List<PluginSearchResult> results = allResults();
            cursorIndex = min(max(0, results.length - 1), cursorIndex + 1);
            render();

          case _KeyEvent(key: Backspace()):
            if (query.isNotEmpty) {
              query = query.substring(0, query.length - 1);
              debounceTimer?.cancel();
              debounceTimer = Timer(
                const Duration(milliseconds: 300),
                () => events.add(_DebounceFireEvent()),
              );
              render();
            }

          case _KeyEvent(key: CharKey(:final char)):
            query += char;
            debounceTimer?.cancel();
            debounceTimer = Timer(
              const Duration(milliseconds: 300),
              () => events.add(_DebounceFireEvent()),
            );
            render();

          case _KeyEvent(key: Space()):
            // Show details for highlighted result.
            final List<PluginSearchResult> results = allResults();
            if (results.isNotEmpty && cursorIndex < results.length) {
              final PluginSearchResult result = results[cursorIndex];
              screen.clear();
              showCursor();

              final detailsScreen = MangaDetailsScreen();
              await detailsScreen.run(
                result: result,
                fetchDetails: (String mangaKey) =>
                    onFetchDetails(result.pluginSourceId, mangaKey),
              );

              hideCursor();
              render();
            }

          case _DebounceFireEvent():
            startSearch(query);
            render();

          case _PluginResultEvent(:final generation, event: PluginSearchResults(:final pluginId, :final results)):
            if (generation != searchGeneration) break; // Discard stale results.
            pluginStatuses.putIfAbsent(pluginId, _PluginStatus.new).results.addAll(results);
            pluginStatuses[pluginId]!.state = _PluginSearchState.done;
            render();

          case _PluginResultEvent(:final generation, event: PluginSearchError(:final failure)):
            if (generation != searchGeneration) break;
            pluginStatuses.putIfAbsent(failure.pluginId, _PluginStatus.new).state =
                _PluginSearchState.failed;
            render();

          case _PluginStreamDoneEvent(:final generation):
            if (generation != searchGeneration) break;
            // Mark any remaining as done.
            for (final _PluginStatus status in pluginStatuses.values) {
              if (status.state == _PluginSearchState.searching) {
                status.state = _PluginSearchState.done;
              }
            }
            render();

          case _SpinnerTickEvent():
            if (anySearching()) render();
        }

        if (events.isClosed) break;
      }
    } finally {
      // Cleanup — always restore terminal state.
      debounceTimer?.cancel();
      await currentSearchSub?.cancel();
      spinner.stop();
      await keySub.cancel();
      keyInput.dispose();
      removeSigintHandler();
      screen.clear();
      showCursor();
    }

    return selected;
  }
}

int _maxVisibleResults() {
  try {
    // Reserve ~8 lines for header, footer, input box.
    return max(1, (stdout.terminalLines - 8) ~/ 1);
  } on StdoutException {
    return 10;
  }
}
