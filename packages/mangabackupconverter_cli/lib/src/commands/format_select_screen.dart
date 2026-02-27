import 'dart:async';

import 'package:mangabackupconverter_cli/src/commands/terminal_ui.dart';
import 'package:mangabackupconverter_cli/src/pipeline/backup_format.dart';

class FormatSelectScreen {
  Future<BackupFormat?> run({
    required TerminalContext context,
    required List<BackupFormat> formats,
    String title = 'Select format',
  }) async {
    var cursorIndex = 0;

    final events = StreamController<KeyEvent>();
    final screen = ScreenRegion(context);

    final StreamSubscription<KeyEvent> keySub = context.keyInput.stream.listen(
      events.add,
    );

    context.hideCursor();

    void render() {
      final int width = context.width;
      final lines = <String>[];

      lines.add('');
      lines.add('  ${bold(title)}');
      lines.add('');

      for (var i = 0; i < formats.length; i++) {
        final BackupFormat f = formats[i];
        final isCursor = i == cursorIndex;
        final prefix = isCursor ? '  ❯ ' : '    ';
        final String exts = dim(f.extensions.join(', '));
        lines.add(truncate('$prefix${f.alias.padRight(14)}$exts', width));
      }

      lines.add('');
      lines.add(dim('  ↑↓ navigate · Enter select · Esc cancel'));

      screen.render(lines);
    }

    render();

    BackupFormat? result;

    try {
      await for (final KeyEvent key in events.stream) {
        switch (key) {
          case Escape():
            unawaited(events.close());

          case Enter():
            result = formats[cursorIndex];
            unawaited(events.close());

          case ArrowUp() || ScrollUp():
            if (cursorIndex > 0) {
              cursorIndex--;
              render();
            }

          case ArrowDown() || ScrollDown():
            if (cursorIndex < formats.length - 1) {
              cursorIndex++;
              render();
            }

          default:
            break;
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
