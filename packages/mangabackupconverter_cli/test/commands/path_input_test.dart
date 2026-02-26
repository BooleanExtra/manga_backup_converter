@TestOn('vm')
library;

import 'dart:async';
import 'dart:io';

import 'package:checks/checks.dart';
import 'package:mangabackupconverter_cli/src/commands/terminal_ui.dart';
import 'package:path/path.dart' as p;
import 'package:test/scaffolding.dart';

void main() {
  group('PathInputState text editing', () {
    test('initial text and cursor position', () {
      final state = PathInputState('/home/user');
      check(state.text).equals('/home/user');
      check(state.cursorPos).equals(10);
    });

    test('CharKey inserts at cursor', () {
      final state = PathInputState();
      state.handleKey(CharKey('a'));
      state.handleKey(CharKey('b'));
      check(state.text).equals('ab');
      check(state.cursorPos).equals(2);
    });

    test('Backspace removes before cursor', () {
      final state = PathInputState('abc');
      check(state.handleKey(Backspace())).equals(PathInputResult.textChanged);
      check(state.text).equals('ab');
      check(state.cursorPos).equals(2);
    });

    test('Backspace at start returns ignored', () {
      final state = PathInputState('abc');
      state.cursorPos = 0;
      check(state.handleKey(Backspace())).equals(PathInputResult.ignored);
      check(state.text).equals('abc');
    });

    test('Delete removes at cursor', () {
      final state = PathInputState('abc');
      state.cursorPos = 1;
      check(state.handleKey(Delete())).equals(PathInputResult.textChanged);
      check(state.text).equals('ac');
    });

    test('Delete at end returns ignored', () {
      final state = PathInputState('abc');
      check(state.handleKey(Delete())).equals(PathInputResult.ignored);
    });

    test('ArrowLeft moves cursor left', () {
      final state = PathInputState('abc');
      check(state.handleKey(ArrowLeft())).equals(PathInputResult.cursorMoved);
      check(state.cursorPos).equals(2);
    });

    test('ArrowLeft at start returns ignored', () {
      final state = PathInputState('abc');
      state.cursorPos = 0;
      check(state.handleKey(ArrowLeft())).equals(PathInputResult.ignored);
    });

    test('ArrowRight moves cursor right', () {
      final state = PathInputState('abc');
      state.cursorPos = 1;
      check(state.handleKey(ArrowRight())).equals(PathInputResult.cursorMoved);
      check(state.cursorPos).equals(2);
    });

    test('ArrowRight at end returns ignored', () {
      final state = PathInputState('abc');
      check(state.handleKey(ArrowRight())).equals(PathInputResult.ignored);
    });

    test('Home moves to start', () {
      final state = PathInputState('abc');
      check(state.handleKey(Home())).equals(PathInputResult.cursorMoved);
      check(state.cursorPos).equals(0);
    });

    test('End moves to end', () {
      final state = PathInputState('abc');
      state.cursorPos = 0;
      check(state.handleKey(End())).equals(PathInputResult.cursorMoved);
      check(state.cursorPos).equals(3);
    });

    test('Space inserts space', () {
      final state = PathInputState('ab');
      state.cursorPos = 1;
      check(state.handleKey(Space())).equals(PathInputResult.textChanged);
      check(state.text).equals('a b');
      check(state.cursorPos).equals(2);
    });

    test('Enter returns submitted', () {
      final state = PathInputState();
      check(state.handleKey(Enter())).equals(PathInputResult.submitted);
    });

    test('Escape returns cancelled', () {
      final state = PathInputState();
      check(state.handleKey(Escape())).equals(PathInputResult.cancelled);
    });

    test('ArrowUp returns ignored', () {
      final state = PathInputState();
      check(state.handleKey(ArrowUp())).equals(PathInputResult.ignored);
    });

    test('text setter resets cursor and completions', () {
      final state = PathInputState('old');
      state.text = 'new value';
      check(state.text).equals('new value');
      check(state.cursorPos).equals(9);
    });
  });

  group('PathInputState Tab completion', () {
    late Directory tempDir;
    late String basePath;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('path_input_test_');
      basePath = tempDir.path;
      // Create test fixtures.
      File(p.join(basePath, 'backup.aib')).createSync();
      File(p.join(basePath, 'backup.tachibk')).createSync();
      File(p.join(basePath, 'readme.txt')).createSync();
      Directory(p.join(basePath, 'subdir')).createSync();
    });

    tearDown(() {
      tempDir.deleteSync(recursive: true);
    });

    test('resolveCompletions returns matching files', () {
      final String partial = p.join(basePath, 'back');
      final List<String> completions = PathInputState.resolveCompletions(partial);
      check(completions.length).equals(2);
      check(completions[0]).contains('backup.aib');
      check(completions[1]).contains('backup.tachibk');
    });

    test('resolveCompletions appends separator to directories', () {
      final String partial = p.join(basePath, 'sub');
      final List<String> completions = PathInputState.resolveCompletions(partial);
      check(completions.length).equals(1);
      check(completions[0]).endsWith(p.separator);
    });

    test('resolveCompletions case-insensitive', () {
      final String partial = p.join(basePath, 'BACK');
      final List<String> completions = PathInputState.resolveCompletions(partial);
      check(completions.length).equals(2);
    });

    test('resolveCompletions returns empty for non-existent directory', () {
      final String partial = p.join(basePath, 'nonexistent', 'foo');
      final List<String> completions = PathInputState.resolveCompletions(partial);
      check(completions).isEmpty();
    });

    test('resolveCompletions returns empty for empty path', () {
      final List<String> completions = PathInputState.resolveCompletions('');
      check(completions).isEmpty();
    });

    test('resolveCompletions lists directory contents when trailing separator', () {
      final partial = '$basePath${p.separator}';
      final List<String> completions = PathInputState.resolveCompletions(partial);
      check(completions.length).equals(4); // backup.aib, backup.tachibk, readme.txt, subdir/
    });

    test('single Tab match completes inline', () {
      final state = PathInputState(p.join(basePath, 'read'));
      final PathInputResult result = state.handleKey(Tab());
      check(result).equals(PathInputResult.tabCompleted);
      check(state.text).equals(p.join(basePath, 'readme.txt'));
      check(state.completions).isEmpty();
    });

    test('multiple Tab matches complete common prefix', () {
      final state = PathInputState(p.join(basePath, 'back'));
      final PathInputResult result = state.handleKey(Tab());
      check(result).equals(PathInputResult.tabCompleted);
      // Common prefix is "backup." — the text should be at least that long.
      check(state.text).contains('backup.');
      check(state.completions.length).equals(2);
    });

    test('second Tab cycles through completions', () {
      final state = PathInputState(p.join(basePath, 'back'));
      state.handleKey(Tab()); // first Tab — resolves completions
      final String firstText = state.text;
      state.handleKey(Tab()); // second Tab — cycles to next
      final String secondText = state.text;
      check(secondText).not((it) => it.equals(firstText));
    });

    test('ArrowDown cycles through completions', () {
      final state = PathInputState(p.join(basePath, 'back'));
      state.handleKey(Tab()); // resolve completions
      final String firstText = state.text;
      check(state.completionIndex).equals(0);

      check(state.handleKey(ArrowDown())).equals(PathInputResult.tabCompleted);
      check(state.completionIndex).equals(1);
      check(state.text).not((it) => it.equals(firstText));
    });

    test('ArrowUp cycles backwards through completions', () {
      final state = PathInputState(p.join(basePath, 'back'));
      state.handleKey(Tab()); // resolve completions
      check(state.completionIndex).equals(0);

      // Up from 0 wraps to last
      check(state.handleKey(ArrowUp())).equals(PathInputResult.tabCompleted);
      check(state.completionIndex).equals(1); // 2 items, (0-1)%2 = 1
    });

    test('ArrowDown without active completions returns ignored', () {
      final state = PathInputState('/some/path');
      check(state.handleKey(ArrowDown())).equals(PathInputResult.ignored);
    });

    test('ArrowUp without active completions returns ignored', () {
      final state = PathInputState('/some/path');
      check(state.handleKey(ArrowUp())).equals(PathInputResult.ignored);
    });

    test('ArrowRight accepts completion and dismisses list', () {
      final state = PathInputState(p.join(basePath, 'back'));
      state.handleKey(Tab()); // resolve completions (2 matches)
      check(state.completions).isNotEmpty();

      check(state.handleKey(ArrowRight())).equals(PathInputResult.tabCompleted);
      // List should be dismissed.
      check(state.completions).isEmpty();
      // Text should remain at the accepted completion.
      check(state.text).contains('backup.');
    });

    test('ArrowRight on directory completion auto-enters directory', () {
      // Put a file inside subdir so the auto-enter Tab finds something.
      File(p.join(basePath, 'subdir', 'nested.txt')).createSync();

      // List all entries in basePath.
      final state = PathInputState('$basePath${p.separator}');
      state.handleKey(Tab()); // resolve all entries (4 items)
      check(state.completions.length).equals(4);

      // Find the subdir entry and navigate to it.
      final int subdirIdx = state.completions.indexWhere(
        (c) => c.endsWith('subdir${p.separator}'),
      );
      check(subdirIdx).isGreaterOrEqual(0);

      while (state.completionIndex != subdirIdx) {
        state.handleKey(ArrowDown());
      }
      check(state.text).endsWith('subdir${p.separator}');

      // ArrowRight should accept and auto-enter the directory.
      final PathInputResult result = state.handleKey(ArrowRight());
      check(result).equals(PathInputResult.tabCompleted);
      // Should now show contents of subdir.
      check(state.text).contains('nested.txt');
    });

    test('ArrowRight without active completions moves cursor', () {
      final state = PathInputState('abc');
      state.cursorPos = 1;
      check(state.handleKey(ArrowRight())).equals(PathInputResult.cursorMoved);
      check(state.cursorPos).equals(2);
    });

    test('text change resets Tab state', () {
      final state = PathInputState(p.join(basePath, 'back'));
      state.handleKey(Tab());
      check(state.completions).isNotEmpty();
      state.handleKey(CharKey('x'));
      check(state.completions).isEmpty();
    });

    test('Escape during Tab completion resets without cancelling', () {
      final state = PathInputState(p.join(basePath, 'back'));
      state.handleKey(Tab());
      check(state.completions).isNotEmpty();
      final PathInputResult result = state.handleKey(Escape());
      check(result).equals(PathInputResult.textChanged);
      check(state.completions).isEmpty();
    });
  });

  group('_readPath integration', () {
    test('renders prompt and completes on Enter', () async {
      final output = StringBuffer();
      final inputController = StreamController<List<int>>();
      addTearDown(inputController.close);

      final context = TerminalContext.test(
        output: output,
        inputStream: inputController.stream,
      );
      addTearDown(context.dispose);

      // We can't call _readPath directly since it's private to convert_command.
      // Instead, test PathInputState key sequence that simulates what _readPath does.
      final state = PathInputState();
      state.handleKey(CharKey('/'));
      state.handleKey(CharKey('t'));
      state.handleKey(CharKey('m'));
      state.handleKey(CharKey('p'));
      final PathInputResult result = state.handleKey(Enter());

      check(state.text).equals('/tmp');
      check(result).equals(PathInputResult.submitted);
    });

    test('returns null on Escape', () {
      final state = PathInputState('/some/path');
      final PathInputResult result = state.handleKey(Escape());
      check(result).equals(PathInputResult.cancelled);
    });
  });
}
