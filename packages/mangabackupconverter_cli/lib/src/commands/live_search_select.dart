import 'dart:async';
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
    required TerminalContext context,
    required String initialQuery,
    required Stream<PluginSearchEvent> Function(String query) onSearch,
    required Future<(PluginMangaDetails, List<PluginChapter>)?> Function(
      String pluginSourceId,
      String mangaKey,
    )
    onFetchDetails,
  }) async {
    final searchInput = SearchInputState(initialQuery);
    var cursorIndex = -1; // -1 = search bar, >= 0 = result index
    var scrollOffset = 0;
    var searchGeneration = 0;
    final pluginStatuses = <String, _PluginStatus>{};
    var cachedResults = <PluginSearchResult>[];
    var searchActive = false;
    StreamSubscription<PluginSearchEvent>? currentSearchSub;
    Timer? debounceTimer;

    final events = StreamController<_SearchEvent>();
    final spinner = Spinner();
    final screen = ScreenRegion(context);

    // Listen for key events on shared KeyInput (broadcast stream).
    StreamSubscription<KeyEvent> keySub = context.keyInput.stream.listen((KeyEvent key) => events.add(_KeyEvent(key)));
    spinner.start(() => events.add(_SpinnerTickEvent()));

    List<PluginSearchResult> allResults() {
      final String lowerQuery = searchInput.query.toLowerCase();
      final results = <PluginSearchResult>[];
      for (final _PluginStatus status in pluginStatuses.values) {
        final List<PluginSearchResult> sorted = [...status.results]
          ..sort((a, b) {
            final double sa = diceCoefficient(lowerQuery, a.title.toLowerCase());
            final double sb = diceCoefficient(lowerQuery, b.title.toLowerCase());
            return sb.compareTo(sa);
          });
        results.addAll(sorted);
      }
      return results;
    }

    bool anySearching() => pluginStatuses.values.any((_PluginStatus s) => s.state == _PluginSearchState.searching);

    void startSearch(String q) {
      currentSearchSub?.cancel();
      cachedResults = allResults();
      pluginStatuses.clear();
      searchActive = true;
      cursorIndex = -1;
      searchInput.focused = true;
      scrollOffset = 0;
      searchGeneration++;
      final gen = searchGeneration;

      final Stream<PluginSearchEvent> stream = onSearch(q);
      currentSearchSub = stream.listen(
        (PluginSearchEvent event) => events.add(_PluginResultEvent(gen, event)),
        onDone: () => events.add(_PluginStreamDoneEvent(gen)),
      );
    }

    context.hideCursor();

    void render() {
      final int width = context.width;
      List<PluginSearchResult> results = allResults();
      final bool searching = searchActive || anySearching();

      // Use cached results while searching if no new results have arrived yet.
      final bool usingCached = searching && results.isEmpty && cachedResults.isNotEmpty;
      if (usingCached) results = cachedResults;

      // Reserve ~8 lines for header, footer, input box.
      final int maxVisible = max(1, context.height - 8);

      // Clamp cursor to valid result range.
      if (cursorIndex >= 0 && results.isNotEmpty) {
        cursorIndex = cursorIndex.clamp(0, results.length - 1);
      }

      final lines = <String>[];

      // Search input box (at top).
      lines.addAll(searchInput.renderBox(width: width));

      // Header.
      if (searching && !usingCached) {
        lines.add('┌ ${bold('Searching...')} ${spinner.frame}');
      } else {
        lines.add('┌ ${bold('${results.length} results')}');
      }
      lines.add('│');

      // Build display rows: group headers (non-selectable) + result rows.
      // Each entry is (resultIndex or -1 for headers, display line).
      final displayRows = <(int, String)>[];
      {
        String? lastPlugin;
        for (var i = 0; i < results.length; i++) {
          final PluginSearchResult r = results[i];
          if (r.pluginSourceId != lastPlugin) {
            lastPlugin = r.pluginSourceId;
            final String header = dim('── $lastPlugin ──');
            displayRows.add((-1, header));
          }
          final String detailAuthors = <String>{
            ...r.authors,
            if (r.details != null) ...r.details!.artists,
          }.join(', ');
          final authorStr = detailAuthors.isNotEmpty ? ' · $detailAuthors' : '';
          final String? url = r.details?.url;
          final String titleText = url != null ? hyperlink(green(r.title), url) : r.title;
          displayRows.add((i, '$titleText$authorStr'));
        }
      }

      // Map cursorIndex (result index) to display row index for scroll.
      int cursorDisplayRow() {
        for (var d = 0; d < displayRows.length; d++) {
          if (displayRows[d].$1 == cursorIndex) return d;
        }
        return 0;
      }

      // Adjust scroll offset in display-row space.
      var displayScroll = scrollOffset;
      if (cursorIndex >= 0 && displayRows.isNotEmpty) {
        final int cdr = cursorDisplayRow();
        if (cdr < displayScroll) displayScroll = cdr;
        if (cdr >= displayScroll + maxVisible) {
          displayScroll = cdr - maxVisible + 1;
        }
      }
      scrollOffset = displayScroll;

      // Results.
      if (results.isEmpty && !searching) {
        lines.add('  ${dim('No results found')}');
      } else {
        if (displayScroll > 0) lines.add(dim('↑ more above'));

        final int visibleEnd = min(displayRows.length, displayScroll + maxVisible);
        for (var d = displayScroll; d < visibleEnd; d++) {
          final (int resultIdx, String text) = displayRows[d];
          if (resultIdx < 0) {
            // Group header — not selectable.
            lines.add('  $text');
          } else {
            final isCursor = resultIdx == cursorIndex;
            final prefix = isCursor ? '❯ ' : '  ';
            lines.add(truncate('$prefix$text', width));
          }
        }

        if (visibleEnd < displayRows.length) lines.add(dim('↓ more below'));
      }

      // Per-plugin spinners / errors (suppress when showing cached results).
      if (!usingCached) {
        for (final MapEntry<String, _PluginStatus> entry in pluginStatuses.entries) {
          if (entry.value.state == _PluginSearchState.searching) {
            lines.add('  [${entry.key}] ${spinner.frame}');
          } else if (entry.value.state == _PluginSearchState.failed) {
            lines.add('  ${yellow('[${entry.key}] ⚠ search failed')}');
          } else if (entry.value.state == _PluginSearchState.done && entry.value.results.isEmpty) {
            lines.add('  ${dim('[${entry.key}] no results')}');
          }
        }
      }

      lines.add('');
      lines.add(
        dim('type to search · ←→ move cursor · ↑↓ navigate · Tab details · Enter select · Esc back'),
      );

      screen.render(lines);
    }

    // Initial search.
    startSearch(searchInput.query);
    render();

    PluginSearchResult? selected;

    try {
      await for (final _SearchEvent event in events.stream) {
        switch (event) {
          case _KeyEvent(key: Escape()):
            unawaited(events.close());

          case _KeyEvent(key: Enter()):
            final List<PluginSearchResult> results = allResults();
            if (cursorIndex >= 0 && cursorIndex < results.length) {
              selected = results[cursorIndex];
            }
            unawaited(events.close());

          case _KeyEvent(key: ArrowUp()):
            cursorIndex = max(-1, cursorIndex - 1);
            searchInput.focused = cursorIndex < 0;
            render();

          case _KeyEvent(key: ArrowDown()):
            final List<PluginSearchResult> results = allResults();
            cursorIndex = min(max(0, results.length) - 1, cursorIndex + 1);
            searchInput.focused = cursorIndex < 0;
            render();

          case _KeyEvent(key: Tab()) when cursorIndex >= 0:
            // Show details for highlighted result.
            final List<PluginSearchResult> results = allResults();
            if (results.isNotEmpty && cursorIndex < results.length) {
              final PluginSearchResult result = results[cursorIndex];
              await keySub.cancel();
              screen.clear();

              final detailsScreen = MangaDetailsScreen();
              final bool confirmed = await detailsScreen.run(
                context: context,
                result: result,
                fetchDetails: (String mangaKey) {
                  if (result.details != null) {
                    return Future.value((result.details!, result.chapters));
                  }
                  return onFetchDetails(result.pluginSourceId, mangaKey);
                },
              );

              if (confirmed) {
                selected = result;
                unawaited(events.close());
                break;
              }

              keySub = context.keyInput.stream.listen(
                (KeyEvent key) => events.add(_KeyEvent(key)),
              );
              context.hideCursor();
              render();
            }

          case _KeyEvent(key: final k):
            final SearchKeyResult r = searchInput.tryHandleKey(k);
            if (r == SearchKeyResult.ignored) break;
            if (searchInput.focused && cursorIndex >= 0) cursorIndex = -1;
            if (r == SearchKeyResult.consumed) {
              debounceTimer?.cancel();
              debounceTimer = Timer(
                const Duration(milliseconds: 300),
                () => events.add(_DebounceFireEvent()),
              );
            }
            render();

          case _DebounceFireEvent():
            startSearch(searchInput.query);
            render();

          case _PluginResultEvent(:final generation, event: PluginSearchStarted(:final pluginId)):
            if (generation != searchGeneration) break;
            pluginStatuses.putIfAbsent(pluginId, _PluginStatus.new);
            render();

          case _PluginResultEvent(:final generation, event: PluginSearchResults(:final pluginId, :final results)):
            if (generation != searchGeneration) break; // Discard stale results.
            cachedResults = [];
            pluginStatuses.putIfAbsent(pluginId, _PluginStatus.new).results.addAll(results);
            pluginStatuses[pluginId]!.state = _PluginSearchState.done;
            render();

          case _PluginResultEvent(:final generation, event: PluginSearchError(:final failure)):
            if (generation != searchGeneration) break;
            pluginStatuses.putIfAbsent(failure.pluginId, _PluginStatus.new).state = _PluginSearchState.failed;
            render();

          case _PluginStreamDoneEvent(:final generation):
            if (generation != searchGeneration) break;
            searchActive = false;
            // Mark any remaining as done.
            for (final _PluginStatus status in pluginStatuses.values) {
              if (status.state == _PluginSearchState.searching) {
                status.state = _PluginSearchState.done;
              }
            }
            render();

          case _SpinnerTickEvent():
            if (searchActive || anySearching()) render();
        }

        if (events.isClosed) break;
      }
    } finally {
      // Cleanup -- always restore terminal state.
      debounceTimer?.cancel();
      await currentSearchSub?.cancel();
      spinner.stop();
      await keySub.cancel();
      screen.clear();
      context.showCursor();
    }

    return selected;
  }
}
