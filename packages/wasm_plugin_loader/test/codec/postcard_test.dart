import 'dart:typed_data';

import 'package:checks/checks.dart';
import 'package:test/scaffolding.dart';
import 'package:wasm_plugin_loader/src/codec/postcard_reader.dart';
import 'package:wasm_plugin_loader/src/codec/postcard_writer.dart';

void main() {
  test('u8', () {
    final w = PostcardWriter()..writeU8(42);
    check(PostcardReader(w.bytes).readU8()).equals(42);
  });

  test('u8 boundary values', () {
    final w = PostcardWriter()
      ..writeU8(0)
      ..writeU8(255);
    final r = PostcardReader(w.bytes);
    check(r.readU8()).equals(0);
    check(r.readU8()).equals(255);
  });

  test('varint small value', () {
    final w = PostcardWriter()..writeVarInt(42);
    check(PostcardReader(w.bytes).readVarInt()).equals(42);
  });

  test('varint multi-byte value 300', () {
    final w = PostcardWriter()..writeVarInt(300);
    check(PostcardReader(w.bytes).readVarInt()).equals(300);
  });

  test('varint large value', () {
    final w = PostcardWriter()..writeVarInt(1 << 21);
    check(PostcardReader(w.bytes).readVarInt()).equals(1 << 21);
  });

  test('signed varint positive', () {
    final w = PostcardWriter()..writeSignedVarInt(42);
    check(PostcardReader(w.bytes).readSignedVarInt()).equals(42);
  });

  test('signed varint negative', () {
    final w = PostcardWriter()..writeSignedVarInt(-1);
    check(PostcardReader(w.bytes).readSignedVarInt()).equals(-1);
  });

  test('signed varint large negative', () {
    final w = PostcardWriter()..writeSignedVarInt(-1000);
    check(PostcardReader(w.bytes).readSignedVarInt()).equals(-1000);
  });

  test('bool true and false', () {
    final w = PostcardWriter()
      ..writeBool(true)
      ..writeBool(false);
    final r = PostcardReader(w.bytes);
    check(r.readBool()).isTrue();
    check(r.readBool()).isFalse();
  });

  test('f32', () {
    final w = PostcardWriter()..writeF32(3.14);
    check(PostcardReader(w.bytes).readF32()).isA<num>().isCloseTo(3.14, 0.0001);
  });

  test('f64', () {
    final w = PostcardWriter()..writeF64(3.141592653589793);
    check(PostcardReader(w.bytes).readF64()).isA<num>().isCloseTo(3.141592653589793, 1e-12);
  });

  test('empty string', () {
    final w = PostcardWriter()..writeString('');
    check(PostcardReader(w.bytes).readString()).equals('');
  });

  test('ascii string', () {
    final w = PostcardWriter()..writeString('hello');
    check(PostcardReader(w.bytes).readString()).equals('hello');
  });

  test('unicode string', () {
    final w = PostcardWriter()..writeString('こんにちは');
    check(PostcardReader(w.bytes).readString()).equals('こんにちは');
  });

  test('bytes roundtrip', () {
    final data = Uint8List.fromList(<int>[1, 2, 3, 4, 5]);
    final w = PostcardWriter()..writeBytes(data);
    check(PostcardReader(w.bytes).readBytes()).deepEquals(data);
  });

  test('option none', () {
    final w = PostcardWriter()..writeOption<String>(null, (String v, PostcardWriter pw) => pw.writeString(v));
    check(PostcardReader(w.bytes).readOption(() => 'unused')).isNull();
  });

  test('option some string', () {
    final w = PostcardWriter()..writeOption<String>('world', (String v, PostcardWriter pw) => pw.writeString(v));
    final r = PostcardReader(w.bytes);
    check(r.readOption(r.readString)).equals('world');
  });

  test('empty list', () {
    final w = PostcardWriter()..writeList(<String>[], (String v, PostcardWriter pw) => pw.writeString(v));
    final r = PostcardReader(w.bytes);
    check(r.readList(r.readString)).isEmpty();
  });

  test('list of strings', () {
    final w = PostcardWriter()..writeList(<String>['a', 'b', 'c'], (String v, PostcardWriter pw) => pw.writeString(v));
    final r = PostcardReader(w.bytes);
    check(r.readList(r.readString)).deepEquals(<Object?>['a', 'b', 'c']);
  });

  test('list of ints', () {
    final w = PostcardWriter()..writeList(<int>[1, 2, 300], (int v, PostcardWriter pw) => pw.writeVarInt(v));
    final r = PostcardReader(w.bytes);
    check(r.readList(r.readVarInt)).deepEquals(<Object?>[1, 2, 300]);
  });

  test('sequential reads preserve position', () {
    final w = PostcardWriter()
      ..writeU8(7)
      ..writeString('test')
      ..writeBool(true);
    final r = PostcardReader(w.bytes);
    check(r.readU8()).equals(7);
    check(r.readString()).equals('test');
    check(r.readBool()).isTrue();
    check(r.isAtEnd).isTrue();
  });

  test('position advances with each read', () {
    final w = PostcardWriter()
      ..writeU8(1)
      ..writeU8(2)
      ..writeU8(3);
    final r = PostcardReader(w.bytes);
    check(r.position).equals(0);
    r.readU8();
    check(r.position).equals(1);
    r.readU8();
    check(r.position).equals(2);
    r.readU8();
    check(r.position).equals(3);
  });

  test('reading past end throws RangeError', () {
    final r = PostcardReader(Uint8List(0));
    check(r.readU8).throws<RangeError>();
  });

  test('f32 NaN roundtrip', () {
    final w = PostcardWriter()..writeF32(double.nan);
    check(PostcardReader(w.bytes).readF32()).isA<num>().isNaN();
  });

  test('f32 positive infinity roundtrip', () {
    final w = PostcardWriter()..writeF32(double.infinity);
    check(PostcardReader(w.bytes).readF32()).equals(double.infinity);
  });

  test('f32 negative infinity roundtrip', () {
    final w = PostcardWriter()..writeF32(double.negativeInfinity);
    check(PostcardReader(w.bytes).readF32()).equals(double.negativeInfinity);
  });
}
