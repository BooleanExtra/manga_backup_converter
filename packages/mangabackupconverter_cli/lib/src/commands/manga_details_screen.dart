import 'dart:async';
import 'dart:math';

import 'package:mangabackupconverter_cli/src/commands/terminal_ui.dart';
import 'package:mangabackupconverter_cli/src/pipeline/plugin_source.dart';

class MangaDetailsScreen {
  Future<void> run({
    required TerminalContext context,
    required PluginSearchResult result,
    required Future<(PluginMangaDetails, List<PluginChapter>)?> Function(String mangaKey) fetchDetails,
  }) async {
    final screen = ScreenRegion(context);
    final spinner = Spinner();

    context.hideCursor();

    // Show loading spinner while fetching.
    final loadTimer = Timer.periodic(const Duration(milliseconds: 80), (_) {
      screen.render([bold(result.title), '', '  Loading... ${spinner.frame}']);
    });

    final (PluginMangaDetails, List<PluginChapter>)? fetchResult = await fetchDetails(result.mangaKey);
    loadTimer.cancel();

    if (fetchResult == null) {
      screen.render([bold(result.title), '', '  ${yellow('Failed to load details.')}', '', dim('Esc to back')]);
      final StreamSubscription<KeyEvent> keySub = context.keyInput.stream.listen(null);
      final completer = Completer<void>();
      keySub.onData((KeyEvent k) {
        if ((k is Escape || k is Enter) && !completer.isCompleted) {
          completer.complete();
        }
      });
      await completer.future;
      await keySub.cancel();
      screen.clear();
      context.showCursor();
      return;
    }

    final (PluginMangaDetails details, List<PluginChapter> chapters) = fetchResult;

    // Sort chapters by number descending.
    final sortedChapters = List<PluginChapter>.of(chapters)
      ..sort((PluginChapter a, PluginChapter b) => (b.chapterNumber ?? 0).compareTo(a.chapterNumber ?? 0));

    var chapterScrollOffset = 0;
    final int width = context.width;

    // Build static header lines.
    final headerLines = <String>[];
    final String titleText = details.url != null
        ? hyperlink(green(details.title), details.url!)
        : bold(details.title);
    headerLines.add(titleText);

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
        // Reserve header + 3 footer lines.
        final int maxChapterLines = max(1, context.height - headerLines.length - 3);
        final int visibleEnd = min(sortedChapters.length, chapterScrollOffset + maxChapterLines);

        if (chapterScrollOffset > 0) lines.add(dim('↑ more above'));

        for (var i = chapterScrollOffset; i < visibleEnd; i++) {
          final PluginChapter ch = sortedChapters[i];
          final num = ch.chapterNumber != null ? 'Ch. ${_formatChNum(ch.chapterNumber!)}' : '';
          final String title = ch.title ?? '';
          final scanlator = ch.scanlator != null ? ' [${ch.scanlator}]' : '';
          final lang = ch.language != null ? ' ${ch.language}' : '';
          final String chapterText = '$num $title'.trimRight();
          final String linkedChapter = ch.url != null
              ? hyperlink(chapterText, ch.url!)
              : chapterText;
          lines.add(truncate('   $linkedChapter${dim('$scanlator$lang')}', width));
        }

        if (visibleEnd < sortedChapters.length) lines.add(dim('↓ more below'));
      }

      lines.add('');
      lines.add(dim('Esc to back'));
      screen.render(lines);
    }

    render();

    final StreamSubscription<KeyEvent> keySub = context.keyInput.stream.listen(null);
    final completer = Completer<void>();
    keySub.onData((KeyEvent key) {
      switch (key) {
        case Escape() || Enter():
          if (!completer.isCompleted) completer.complete();
        case ArrowUp():
          chapterScrollOffset = max(0, chapterScrollOffset - 1);
          render();
        case ArrowDown():
          chapterScrollOffset = min(
            max(0, sortedChapters.length - 1),
            chapterScrollOffset + 1,
          );
          render();
        default:
          break;
      }
    });

    await completer.future;
    await keySub.cancel();
    screen.clear();
    context.showCursor();
  }
}

String _formatChNum(double n) {
  return n == n.truncateToDouble() ? n.toInt().toString() : n.toString();
}
