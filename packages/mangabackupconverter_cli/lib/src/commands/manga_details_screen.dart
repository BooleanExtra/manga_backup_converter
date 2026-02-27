import 'dart:async';
import 'dart:math';

import 'package:mangabackupconverter_cli/src/commands/terminal_ui.dart';
import 'package:mangabackupconverter_cli/src/pipeline/plugin_source.dart';

class MangaDetailsScreen {
  Future<bool> run({
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
      final completer = Completer<bool>();
      keySub.onData((KeyEvent k) {
        if ((k is Escape || k is Enter) && !completer.isCompleted) {
          completer.complete(false);
        }
      });
      await completer.future;
      await keySub.cancel();
      screen.clear();
      context.showCursor();
      return false;
    }

    final (PluginMangaDetails details, List<PluginChapter> chapters) = fetchResult;

    // Sort chapters by number descending.
    final sortedChapters = List<PluginChapter>.of(chapters)
      ..sort((PluginChapter a, PluginChapter b) => (b.chapterNumber ?? 0).compareTo(a.chapterNumber ?? 0));

    var chapterScrollOffset = 0;
    final int width = context.width;

    // Build static header lines (used by both render() and key handler).
    final headerLines = <String>[];
    final String titleText = details.url != null ? hyperlink(green(details.title), details.url!) : bold(details.title);
    headerLines.add(titleText);

    final String authors = <String>{...details.authors, ...details.artists}.join(', ');
    if (authors.isNotEmpty) headerLines.add('Author: $authors');
    headerLines.add('Source: ${result.pluginSourceName ?? result.pluginSourceId}');

    if (details.description != null && details.description!.isNotEmpty) {
      headerLines.add('');
      headerLines.addAll(
        wordWrap(details.description!, max(20, width - 4)).map((String l) => '  ${renderMarkdown(l)}'),
      );
    }

    if (sortedChapters.isNotEmpty) {
      headerLines.add('');
      headerLines.add(bold('   Chapters (${sortedChapters.length})'));
    }

    // Total lines available for chapters + scroll indicators.
    final int chapterAreaLines = max(1, context.height - headerLines.length - 2);

    void render() {
      final lines = List<String>.of(headerLines);

      if (sortedChapters.isNotEmpty) {
        final bool hasAbove = chapterScrollOffset > 0;
        final int tentativeVisible = chapterAreaLines - (hasAbove ? 1 : 0);
        final int tentativeEnd = min(sortedChapters.length, chapterScrollOffset + tentativeVisible);
        final bool hasBelow = tentativeEnd < sortedChapters.length;
        final int visibleCount = hasBelow ? tentativeVisible - 1 : tentativeVisible;
        final int visibleEnd = min(sortedChapters.length, chapterScrollOffset + visibleCount);

        if (hasAbove) lines.add(dim('↑ more above'));

        for (var i = chapterScrollOffset; i < visibleEnd; i++) {
          final PluginChapter ch = sortedChapters[i];
          final num = ch.chapterNumber != null ? 'Ch. ${_formatChNum(ch.chapterNumber!)}' : '';
          final String title = ch.title ?? '';
          final scanlator = ch.scanlator != null ? ' [${ch.scanlator}]' : '';
          final lang = ch.language != null ? ' ${ch.language}' : '';
          final String chapterText = '$num $title'.trimRight();
          final String linkedChapter = ch.url != null ? hyperlink(chapterText, ch.url!) : chapterText;
          lines.add(truncate('   $linkedChapter${dim('$scanlator$lang')}', width));
        }

        if (hasBelow) lines.add(dim('↓ more below'));
      }

      lines.add('');
      lines.add(dim('Enter select · Esc back'));
      screen.render(lines);
    }

    render();

    final StreamSubscription<KeyEvent> keySub = context.keyInput.stream.listen(null);
    final completer = Completer<bool>();
    keySub.onData((KeyEvent key) {
      switch (key) {
        case Escape():
          if (!completer.isCompleted) completer.complete(false);
        case Enter():
          if (!completer.isCompleted) completer.complete(true);
        case ArrowUp():
          chapterScrollOffset = max(0, chapterScrollOffset - 1);
          render();
        case ArrowDown():
          final int maxOffset = sortedChapters.length <= chapterAreaLines
              ? 0
              : sortedChapters.length - (chapterAreaLines - 1);
          chapterScrollOffset = min(maxOffset, chapterScrollOffset + 1);
          render();
        default:
          break;
      }
    });

    final bool confirmed = await completer.future;
    await keySub.cancel();
    screen.clear();
    context.showCursor();
    return confirmed;
  }
}

String _formatChNum(double n) {
  return n == n.truncateToDouble() ? n.toInt().toString() : n.toString();
}
