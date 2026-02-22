import 'dart:convert';
import 'dart:typed_data';

import 'package:checks/checks.dart';
import 'package:mangabackupconverter_cli/src/common/fix_double_encoding.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('fixDoubleEncoding', () {
    test('fixes double-encoded Japanese', () {
      // '二日市とふろう' UTF-8 bytes interpreted as Latin-1
      const original = '二日市とふろう';
      final garbled = String.fromCharCodes(utf8.encode(original));
      check(garbled).not((it) => it.equals(original));
      check(fixDoubleEncoding(garbled)).equals(original);
    });

    test('fixes double-encoded Korean', () {
      const original = '격';
      final garbled = String.fromCharCodes(utf8.encode(original));
      check(fixDoubleEncoding(garbled)).equals(original);
    });

    test('returns pure ASCII unchanged', () {
      check(fixDoubleEncoding('hello world')).equals('hello world');
    });

    test('returns correctly-encoded CJK unchanged (code units > 0xFF)', () {
      const cjk = '二日市とふろう';
      check(fixDoubleEncoding(cjk)).equals(cjk);
    });

    test('returns empty string unchanged', () {
      check(fixDoubleEncoding('')).equals('');
    });

    test('fixes double-encoded smart quotes', () {
      // Right single quote U+2019 (') → UTF-8 bytes E2 80 99
      // When interpreted as Latin-1: â + control chars
      const original = '\u2019'; // '
      final garbled = String.fromCharCodes(utf8.encode(original));
      check(fixDoubleEncoding(garbled)).equals(original);

      // Full phrase: "It's"
      const phrase = 'It\u2019s';
      final garbledPhrase = String.fromCharCodes(utf8.encode(phrase));
      check(fixDoubleEncoding(garbledPhrase)).equals(phrase);
    });

    test('returns accented Latin unchanged (invalid re-decode)', () {
      // 'café' has code units in 0x80-0xFF range but is not double-encoded.
      // Attempting utf8.decode on its code units would fail, so it's returned
      // as-is. We simulate a string whose code units are all <= 0xFF but
      // don't form valid UTF-8.
      final bytes = Uint8List.fromList([0x63, 0x61, 0x66, 0xE9]); // 'caf\xe9'
      final latin1String = String.fromCharCodes(bytes);
      check(fixDoubleEncoding(latin1String)).equals(latin1String);
    });
  });
}
