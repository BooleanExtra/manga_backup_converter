import 'package:checks/checks.dart';
import 'package:mangabackupconverter_cli/src/common/normalize_chapter_number.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('normalizeChapterNumber', () {
    test('strips float32 promotion artifact from 1.1', () {
      check(normalizeChapterNumber(1.100000023841858)).equals(1.1);
    });

    test('strips float32 promotion artifact from 10.1', () {
      check(normalizeChapterNumber(10.100000381469727)).equals(10.1);
    });

    test('preserves clean 5.5', () {
      check(normalizeChapterNumber(5.5)).equals(5.5);
    });

    test('preserves clean 10.0', () {
      check(normalizeChapterNumber(10.0)).equals(10.0);
    });

    test('preserves negative -1.0', () {
      check(normalizeChapterNumber(-1.0)).equals(-1.0);
    });

    test('preserves 10.125', () {
      check(normalizeChapterNumber(10.125)).equals(10.125);
    });

    test('preserves clean 100.0', () {
      check(normalizeChapterNumber(100.0)).equals(100.0);
    });

    test('preserves 0.0', () {
      check(normalizeChapterNumber(0.0)).equals(0.0);
    });

    test('preserves 2.25', () {
      check(normalizeChapterNumber(2.25)).equals(2.25);
    });
  });
}
