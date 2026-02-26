@TestOn('vm')
library;

import 'package:checks/checks.dart';
import 'package:mangabackupconverter_cli/src/commands/terminal_ui.dart';
import 'package:test/scaffolding.dart';

void main() {
  // ---------------------------------------------------------------------------
  // diceCoefficient
  // ---------------------------------------------------------------------------
  group('diceCoefficient', () {
    test('identical strings return 1.0', () {
      check(diceCoefficient('hello', 'hello')).equals(1.0);
    });

    test('completely different strings return 0.0', () {
      check(diceCoefficient('abc', 'xyz')).equals(0.0);
    });

    test('similar strings return value between 0 and 1', () {
      final double score = diceCoefficient('night', 'nacht');
      check(score).isGreaterThan(0.0);
      check(score).isLessThan(1.0);
    });

    test('single-char string returns 0.0', () {
      check(diceCoefficient('a', 'abc')).equals(0.0);
    });

    test('empty string returns 0.0', () {
      check(diceCoefficient('', 'abc')).equals(0.0);
    });
  });

  // ---------------------------------------------------------------------------
  // wordWrap
  // ---------------------------------------------------------------------------
  group('wordWrap', () {
    test('short text returns single element list', () {
      final List<String> result = wordWrap('hello', 80);
      check(result).length.equals(1);
      check(result.first).equals('hello');
    });

    test('wraps at word boundaries', () {
      final List<String> result = wordWrap('one two three', 8);
      check(result.length).isGreaterThan(1);
      // Each line should be at most 8 characters
      for (final line in result) {
        check(line.length).isLessOrEqual(8);
      }
    });

    test('preserves empty lines from newlines', () {
      final List<String> result = wordWrap('hello\n\nworld', 80);
      check(result).length.equals(3);
      check(result[1]).equals('');
    });

    test('long single word does not break mid-word', () {
      final List<String> result = wordWrap('supercalifragilistic', 10);
      // A single word longer than width should remain intact
      check(result).length.equals(1);
      check(result.first).equals('supercalifragilistic');
    });
  });

  // ---------------------------------------------------------------------------
  // renderMarkdown
  // ---------------------------------------------------------------------------
  group('renderMarkdown', () {
    test('link renders as hyperlink with green text', () {
      final String result = renderMarkdown('[click](https://example.com)');
      check(result).contains('\x1b]8;;https://example.com\x1b\\');
      check(result).contains('\x1b[32mclick\x1b[39m');
      check(result).contains('\x1b]8;;\x1b\\');
    });

    test('bold text renders with bold ANSI codes', () {
      final String result = renderMarkdown('**bold**');
      check(result).contains('\x1b[1mbold\x1b[22m');
    });

    test('italic text renders with italic ANSI codes', () {
      final String result = renderMarkdown('*italic*');
      check(result).contains('\x1b[3mitalic\x1b[23m');
    });

    test('plain text passes through unchanged', () {
      final String result = renderMarkdown('plain text');
      check(result).equals('plain text');
    });
  });

  // ---------------------------------------------------------------------------
  // SearchInputState — handleKey
  // ---------------------------------------------------------------------------
  group('SearchInputState.handleKey', () {
    test('CharKey inserts character and returns true', () {
      final state = SearchInputState();
      final bool changed = state.handleKey(CharKey('a'));
      check(changed).equals(true);
      check(state.query).equals('a');
      check(state.cursorPos).equals(1);
    });

    test('Backspace at position > 0 removes character and returns true', () {
      final state = SearchInputState('ab');
      final bool changed = state.handleKey(Backspace());
      check(changed).equals(true);
      check(state.query).equals('a');
      check(state.cursorPos).equals(1);
    });

    test('ArrowLeft moves cursor and returns false', () {
      final state = SearchInputState('abc');
      final bool changed = state.handleKey(ArrowLeft());
      check(changed).equals(false);
      check(state.cursorPos).equals(2);
    });

    test('Home sets cursor to 0', () {
      final state = SearchInputState('hello');
      state.handleKey(Home());
      check(state.cursorPos).equals(0);
    });
  });

  // ---------------------------------------------------------------------------
  // SearchInputState — tryHandleKey
  // ---------------------------------------------------------------------------
  group('SearchInputState.tryHandleKey', () {
    test('focused CharKey returns consumed', () {
      final state = SearchInputState();
      final SearchKeyResult result = state.tryHandleKey(CharKey('x'));
      check(result).equals(SearchKeyResult.consumed);
    });

    test('focused ArrowUp returns ignored', () {
      final state = SearchInputState();
      final SearchKeyResult result = state.tryHandleKey(ArrowUp());
      check(result).equals(SearchKeyResult.ignored);
    });

    test('unfocused CharKey refocuses and returns consumed', () {
      final state = SearchInputState()..focused = false;
      final SearchKeyResult result = state.tryHandleKey(CharKey('z'));
      check(result).equals(SearchKeyResult.consumed);
      check(state.focused).equals(true);
    });

    test('unfocused Space returns ignored', () {
      final state = SearchInputState()..focused = false;
      final SearchKeyResult result = state.tryHandleKey(Space());
      check(result).equals(SearchKeyResult.ignored);
    });
  });
}
