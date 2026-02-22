import 'package:aidoku_plugin_loader/src/codec/postcard_reader.dart';
import 'package:aidoku_plugin_loader/src/codec/postcard_writer.dart';
import 'package:checks/checks.dart';
import 'package:test/scaffolding.dart';

void main() {
  test('readString corrects double-encoded CJK (Korean)', () {
    // Simulate what the WASM plugin produces: the UTF-8 bytes of 격 (EA B2 A9)
    // stored as individual Latin-1 code points (U+EA, U+B2, U+A9) → then
    // postcard-encoded as UTF-8: C3 AA, C2 B2, C2 A9.
    final w = PostcardWriter();
    w.writeString(String.fromCharCodes([0xEA, 0xB2, 0xA9]));
    final r = PostcardReader(w.bytes);
    check(r.readString()).equals('격');
  });

  test('readString corrects double-encoded CJK (Japanese)', () {
    // 二日市とふろう → UTF-8 bytes treated as Latin-1
    const original = '二日市とふろう';
    // Double-encode: take UTF-8 bytes, treat each as a code point
    final List<int> utf8Bytes = [...original.runes].expand((r) {
      if (r <= 0x7F) return [r];
      if (r <= 0x7FF) return [(0xC0 | (r >> 6)), (0x80 | (r & 0x3F))];
      if (r <= 0xFFFF) {
        return [
          (0xE0 | (r >> 12)),
          (0x80 | ((r >> 6) & 0x3F)),
          (0x80 | (r & 0x3F)),
        ];
      }
      return [r]; // Should not happen for these chars
    }).toList();
    final garbled = String.fromCharCodes(utf8Bytes);
    final w = PostcardWriter()..writeString(garbled);
    final r = PostcardReader(w.bytes);
    check(r.readString()).equals(original);
  });

  test('readString preserves correctly-encoded strings', () {
    final w = PostcardWriter()..writeString('격');
    final r = PostcardReader(w.bytes);
    check(r.readString()).equals('격');
  });

  test('readString preserves ASCII strings', () {
    final w = PostcardWriter()..writeString('hello');
    final r = PostcardReader(w.bytes);
    check(r.readString()).equals('hello');
  });

  test('readString preserves accented Latin text', () {
    final w = PostcardWriter()..writeString('café');
    final r = PostcardReader(w.bytes);
    check(r.readString()).equals('café');
  });

  test('readString preserves strings with real Unicode above U+00FF', () {
    final w = PostcardWriter()..writeString('hello 世界');
    final r = PostcardReader(w.bytes);
    check(r.readString()).equals('hello 世界');
  });
}
