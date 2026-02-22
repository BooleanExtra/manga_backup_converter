import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:mangabackupconverter_cli/src/commands/terminal_ui.dart';
import 'package:mangabackupconverter_cli/src/pipeline/plugin_source.dart';

class MangaDetailsScreen {
  Future<void> run({
    required PluginSearchResult result,
    required Future<(PluginMangaDetails, List<PluginChapter>)?> Function(String mangaKey) fetchDetails,
  }) async {
    final screen = ScreenRegion();
    final spinner = Spinner();
    final keyInput = KeyInput();

    hideCursor();

    // Show loading spinner while fetching.
    final loadTimer = Timer.periodic(const Duration(milliseconds: 80), (_) {
      screen.render([bold(result.title), '', '  Loading... ${spinner.frame}']);
    });

    final (PluginMangaDetails, List<PluginChapter>)? fetchResult =
        await fetchDetails(result.mangaKey);
    loadTimer.cancel();

    if (fetchResult == null) {
      screen.render([bold(result.title), '', '  ${yellow('Failed to load details.')}', '', dim('Esc to back')]);
      keyInput.start();
      await keyInput.stream.firstWhere((KeyEvent k) => k is Escape || k is Enter);
      keyInput.dispose();
      screen.clear();
      showCursor();
      return;
    }

    final (PluginMangaDetails details, List<PluginChapter> chapters) = fetchResult;

    // Sort chapters by number descending.
    final sortedChapters = List<PluginChapter>.of(chapters)
      ..sort((PluginChapter a, PluginChapter b) => (b.chapterNumber ?? 0).compareTo(a.chapterNumber ?? 0));

    var chapterScrollOffset = 0;
    final int width = terminalWidth;

    // Build static header lines.
    final headerLines = <String>[];
    headerLines.add(bold(details.title));

    final String authors = <String>{...details.authors, ...details.artists}.join(', ');
    if (authors.isNotEmpty) headerLines.add('Author: $authors');
    headerLines.add('Source: ${result.pluginSourceId}');

    if (details.description != null && details.description!.isNotEmpty) {
      headerLines.add('');
      headerLines.addAll(wordWrap(details.description!, max(20, width - 4)).map((String l) => '  $l'));
    }

    if (sortedChapters.isNotEmpty) {
      headerLines.add('');
      headerLines.add(bold('   Chapters (${sortedChapters.length})'));
    }

    void render() {
      final lines = List<String>.of(headerLines);

      if (sortedChapters.isNotEmpty) {
        final int maxChapterLines = _maxChapterLines(headerLines.length);
        final int visibleEnd = min(sortedChapters.length, chapterScrollOffset + maxChapterLines);

        if (chapterScrollOffset > 0) lines.add(dim('↑ more above'));

        for (var i = chapterScrollOffset; i < visibleEnd; i++) {
          final PluginChapter ch = sortedChapters[i];
          final num = ch.chapterNumber != null ? 'Ch. ${_formatChNum(ch.chapterNumber!)}' : '';
          final String title = ch.title ?? '';
          final scanlator = ch.scanlator != null ? ' [${ch.scanlator}]' : '';
          lines.add(truncate('   $num $title${dim(scanlator)}', width));
        }

        if (visibleEnd < sortedChapters.length) lines.add(dim('↓ more below'));
      }

      lines.add('');
      lines.add(dim('Esc to back'));
      screen.render(lines);
    }

    keyInput.start();
    render();

    await for (final KeyEvent key in keyInput.stream) {
      switch (key) {
        case Escape() || Enter():
          break;
        case ArrowUp():
          chapterScrollOffset = max(0, chapterScrollOffset - 1);
          render();
          continue;
        case ArrowDown():
          chapterScrollOffset = min(
            max(0, sortedChapters.length - 1),
            chapterScrollOffset + 1,
          );
          render();
          continue;
        default:
          continue;
      }
      break;
    }

    keyInput.dispose();
    screen.clear();
    showCursor();
  }
}

String _formatChNum(double n) {
  return n == n.truncateToDouble() ? n.toInt().toString() : n.toString();
}

int _maxChapterLines(int headerHeight) {
  try {
    // Reserve header + 3 footer lines.
    return max(1, stdout.terminalLines - headerHeight - 3);
  } on StdoutException {
    return 10;
  }
}
