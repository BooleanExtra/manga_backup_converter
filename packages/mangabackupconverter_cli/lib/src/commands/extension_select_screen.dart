import 'dart:async';
import 'dart:math';

import 'package:mangabackupconverter_cli/src/commands/terminal_ui.dart';
import 'package:mangabackupconverter_cli/src/pipeline/extension_entry.dart';

// ---------------------------------------------------------------------------
// Internal events
// ---------------------------------------------------------------------------

sealed class _Event {}

class _KeyEvent extends _Event {
  _KeyEvent(this.key);
  final KeyEvent key;
}

// ---------------------------------------------------------------------------
// Extension select screen
// ---------------------------------------------------------------------------

class ExtensionSelectScreen {
  Future<List<ExtensionEntry>?> run({
    required TerminalContext context,
    required List<ExtensionEntry> extensions,
  }) async {
    final searchInput = SearchInputState();
    var cursorIndex = -1; // -1 = search bar, >= 0 = result index
    var scrollOffset = 0;
    final selected = <String>{}; // selected extension IDs

    final events = StreamController<_Event>();
    final screen = ScreenRegion(context);

    final StreamSubscription<KeyEvent> keySub = context.keyInput.stream.listen(
      (KeyEvent key) => events.add(_KeyEvent(key)),
    );

    context.hideCursor();

    List<ExtensionEntry> filtered() {
      if (searchInput.query.isEmpty) return extensions;
      final String lowerQuery = searchInput.query.toLowerCase();
      return extensions.where((ExtensionEntry e) {
        if (e.name.toLowerCase().contains(lowerQuery)) return true;
        if (e.id.toLowerCase().contains(lowerQuery)) return true;
        if (e.languages.any(
          (String lang) => lang.toLowerCase().contains(lowerQuery),
        )) {
          return true;
        }
        final String rating = switch (e.contentRating) {
          0 => 'safe',
          1 => 'suggestive',
          2 => 'nsfw',
          _ => '',
        };
        if (rating.isNotEmpty && rating.contains(lowerQuery)) return true;
        if (e is AidokuExtensionEntry) {
          if (e.altNames.any(
            (String alt) => alt.toLowerCase().contains(lowerQuery),
          )) {
            return true;
          }
        }
        return false;
      }).toList();
    }

    void render() {
      final int width = context.width;
      final List<ExtensionEntry> results = filtered();

      final int availableLines = context.height - 8;

      // Pre-compute heights for all results.
      final List<int> heights = [
        for (final ExtensionEntry e in results)
          () {
            final String langStr = e.languages.join(', ');
            final String detail = langStr.isNotEmpty ? '${e.id} · $langStr' : e.id;
            return 1 + wrappedLineCount(detail, width - 6);
          }(),
      ];

      /// How many entries fit starting from [from] within [budget] lines.
      int countFitting(int from, int lineBudget) {
        var remaining = lineBudget;
        var count = 0;
        for (var i = from; i < results.length && remaining > 0; i++) {
          if (heights[i] > remaining && count > 0) break;
          remaining -= heights[i];
          count++;
        }
        return max(1, count);
      }

      // Clamp cursorIndex first.
      if (cursorIndex >= 0 && results.isNotEmpty) {
        cursorIndex = cursorIndex.clamp(0, results.length - 1);
      }

      // Budget available for entries, reserving lines for scroll indicators.
      int entryBudget(int from) {
        var budget = availableLines;
        if (from > 0) budget--; // "↑ more above"
        final int visible = countFitting(from, budget);
        if (from + visible < results.length) budget--; // "↓ more below"
        return max(1, budget);
      }

      // Adjust scrollOffset so cursorIndex is visible.
      scrollOffset = scrollOffset.clamp(0, max(0, results.length - 1));
      if (cursorIndex >= 0) {
        if (cursorIndex < scrollOffset) scrollOffset = cursorIndex;
        // Scroll down: ensure cursor fits in the viewport from scrollOffset.
        while (scrollOffset < cursorIndex) {
          final int visible = countFitting(scrollOffset, entryBudget(scrollOffset));
          if (cursorIndex < scrollOffset + visible) break;
          scrollOffset++;
        }
      }

      final int budget = entryBudget(scrollOffset);
      final int maxVisible = countFitting(scrollOffset, budget);

      final lines = <String>[];

      // Search input box.
      lines.addAll(searchInput.renderBox(width: width));

      // Header.
      final int selectedCount = selected.length;
      final int shownCount = results.length;
      lines.add(
        '┌ ${bold('Extensions')} · '
        '$selectedCount selected · $shownCount shown',
      );
      lines.add('│');

      // Results.
      if (results.isEmpty) {
        lines.add('  ${dim('No extensions found')}');
      } else {
        if (scrollOffset > 0) lines.add(dim('↑ more above'));

        final int visibleEnd = min(results.length, scrollOffset + maxVisible);
        for (var i = scrollOffset; i < visibleEnd; i++) {
          final ExtensionEntry e = results[i];
          final isCursor = i == cursorIndex;
          final prefix = isCursor ? '❯ ' : '  ';
          final checkbox = selected.contains(e.id) ? '◉' : '◯';

          // Line 1: checkbox + name + version + content rating.
          final buf = StringBuffer('$prefix$checkbox ${e.name}');
          if (e is AidokuExtensionEntry) buf.write(' v${e.version}');
          final String rating = switch (e.contentRating) {
            0 => 'Safe',
            1 => 'Suggestive',
            2 => 'NSFW',
            _ => '',
          };
          if (rating.isNotEmpty) buf.write(' · $rating');
          lines.add(truncate(buf.toString(), width));

          // Detail lines: plugin ID + languages (dimmed, indented, wrapped).
          final String langStr = e.languages.join(', ');
          final String detail = langStr.isNotEmpty ? '${e.id} · $langStr' : e.id;
          for (final String line in wordWrap(detail, width - 6)) {
            lines.add('      ${dim(line)}');
          }
        }

        if (visibleEnd < results.length) lines.add(dim('↓ more below'));
      }

      lines.add('');
      lines.add(
        dim(
          'type to filter · ←→ move cursor · ↑↓ navigate · '
          'Space toggle · Enter confirm · Esc cancel',
        ),
      );

      screen.render(lines);
    }

    render();

    List<ExtensionEntry>? result;

    try {
      await for (final _Event event in events.stream) {
        switch (event) {
          case _KeyEvent(key: Escape()):
            unawaited(events.close());

          case _KeyEvent(key: Enter()) when cursorIndex >= 0:
            if (selected.isNotEmpty) {
              result = extensions.where((ExtensionEntry e) => selected.contains(e.id)).toList();
            } else {
              final List<ExtensionEntry> results = filtered();
              if (cursorIndex < results.length) {
                result = [results[cursorIndex]];
              }
            }
            unawaited(events.close());

          case _KeyEvent(key: CharKey(char: 'y')) when cursorIndex >= 0 && selected.isNotEmpty:
            result = extensions.where((ExtensionEntry e) => selected.contains(e.id)).toList();
            unawaited(events.close());

          case _KeyEvent(key: ArrowUp()):
            cursorIndex = max(-1, cursorIndex - 1);
            searchInput.focused = cursorIndex < 0;
            render();

          case _KeyEvent(key: ArrowDown()):
            final List<ExtensionEntry> results = filtered();
            cursorIndex = min(
              max(0, results.length) - 1,
              cursorIndex + 1,
            );
            searchInput.focused = cursorIndex < 0;
            render();

          case _KeyEvent(key: Space()) when cursorIndex >= 0:
            // Toggle selection.
            final List<ExtensionEntry> results = filtered();
            if (results.isNotEmpty && cursorIndex < results.length) {
              final String id = results[cursorIndex].id;
              if (selected.contains(id)) {
                selected.remove(id);
              } else {
                selected.add(id);
              }
              render();
            }

          case _KeyEvent(key: final k):
            final SearchKeyResult r = searchInput.tryHandleKey(k);
            if (r == SearchKeyResult.ignored) break;
            if (searchInput.focused && cursorIndex >= 0) cursorIndex = -1;
            render();
        }

        if (events.isClosed) break;
      }
    } finally {
      await keySub.cancel();
      screen.clear();
      context.showCursor();
    }

    return result;
  }
}
