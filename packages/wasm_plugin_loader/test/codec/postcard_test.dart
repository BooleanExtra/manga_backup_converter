import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:wasm_plugin_loader/src/codec/postcard_reader.dart';
import 'package:wasm_plugin_loader/src/codec/postcard_writer.dart';

void main() {
  test('u8', () {
    final w = PostcardWriter()..writeU8(42);
    expect(PostcardReader(w.bytes).readU8(), 42);
  });

  test('u8 boundary values', () {
    final w = PostcardWriter()..writeU8(0)..writeU8(255);
    final r = PostcardReader(w.bytes);
    expect(r.readU8(), 0);
    expect(r.readU8(), 255);
  });

  test('varint small value', () {
    final w = PostcardWriter()..writeVarInt(42);
    expect(PostcardReader(w.bytes).readVarInt(), 42);
  });

  test('varint multi-byte value 300', () {
    final w = PostcardWriter()..writeVarInt(300);
    expect(PostcardReader(w.bytes).readVarInt(), 300);
  });

  test('varint large value', () {
    final w = PostcardWriter()..writeVarInt(1 << 21);
    expect(PostcardReader(w.bytes).readVarInt(), 1 << 21);
  });

  test('signed varint positive', () {
    final w = PostcardWriter()..writeSignedVarInt(42);
    expect(PostcardReader(w.bytes).readSignedVarInt(), 42);
  });

  test('signed varint negative', () {
    final w = PostcardWriter()..writeSignedVarInt(-1);
    expect(PostcardReader(w.bytes).readSignedVarInt(), -1);
  });

  test('signed varint large negative', () {
    final w = PostcardWriter()..writeSignedVarInt(-1000);
    expect(PostcardReader(w.bytes).readSignedVarInt(), -1000);
  });

  test('bool true and false', () {
    final w = PostcardWriter()..writeBool(true)..writeBool(false);
    final r = PostcardReader(w.bytes);
    expect(r.readBool(), true);
    expect(r.readBool(), false);
  });

  test('f32', () {
    final w = PostcardWriter()..writeF32(3.14);
    expect(PostcardReader(w.bytes).readF32(), closeTo(3.14, 0.0001));
  });

  test('f64', () {
    final w = PostcardWriter()..writeF64(3.141592653589793);
    expect(PostcardReader(w.bytes).readF64(), closeTo(3.141592653589793, 1e-12));
  });

  test('empty string', () {
    final w = PostcardWriter()..writeString('');
    expect(PostcardReader(w.bytes).readString(), '');
  });

  test('ascii string', () {
    final w = PostcardWriter()..writeString('hello');
    expect(PostcardReader(w.bytes).readString(), 'hello');
  });

  test('unicode string', () {
    final w = PostcardWriter()..writeString('こんにちは');
    expect(PostcardReader(w.bytes).readString(), 'こんにちは');
  });

  test('bytes roundtrip', () {
    final data = Uint8List.fromList([1, 2, 3, 4, 5]);
    final w = PostcardWriter()..writeBytes(data);
    expect(PostcardReader(w.bytes).readBytes(), data);
  });

  test('option none', () {
    final w = PostcardWriter()..writeOption<String>(null, (v, pw) => pw.writeString(v));
    expect(PostcardReader(w.bytes).readOption(() => 'unused'), isNull);
  });

  test('option some string', () {
    final w = PostcardWriter()..writeOption<String>('world', (v, pw) => pw.writeString(v));
    final r = PostcardReader(w.bytes);
    expect(r.readOption(r.readString), 'world');
  });

  test('empty list', () {
    final w = PostcardWriter()..writeList(<String>[], (v, pw) => pw.writeString(v));
    final r = PostcardReader(w.bytes);
    expect(r.readList(r.readString), isEmpty);
  });

  test('list of strings', () {
    final w = PostcardWriter()..writeList(['a', 'b', 'c'], (v, pw) => pw.writeString(v));
    final r = PostcardReader(w.bytes);
    expect(r.readList(r.readString), ['a', 'b', 'c']);
  });

  test('list of ints', () {
    final w = PostcardWriter()..writeList([1, 2, 300], (v, pw) => pw.writeVarInt(v));
    final r = PostcardReader(w.bytes);
    expect(r.readList(r.readVarInt), [1, 2, 300]);
  });

  test('sequential reads preserve position', () {
    final w = PostcardWriter()
      ..writeU8(7)
      ..writeString('test')
      ..writeBool(true);
    final r = PostcardReader(w.bytes);
    expect(r.readU8(), 7);
    expect(r.readString(), 'test');
    expect(r.readBool(), true);
    expect(r.isAtEnd, true);
  });
}
