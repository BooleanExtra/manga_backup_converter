import 'dart:convert';
import 'dart:typed_data';

class PostcardWriter {
  final List<int> _buf = <int>[];

  Uint8List get bytes => Uint8List.fromList(_buf);

  void writeU8(int v) => _buf.add(v & 0xFF);

  // ignore: avoid_positional_boolean_parameters
  void writeBool(bool v) => writeU8(v ? 1 : 0);

  /// Encode an unsigned integer as a variable-length LEB128 value.
  void writeVarInt(int v) {
    int temp = v;
    while (temp >= 0x80) {
      _buf.add((temp & 0x7F) | 0x80);
      temp >>= 7;
    }
    _buf.add(temp & 0x7F);
  }

  /// Encode a signed integer using zigzag encoding then LEB128.
  void writeSignedVarInt(int v) {
    writeVarInt((v << 1) ^ (v >> 63));
  }

  void writeF32(double v) {
    final ByteData bd = ByteData(4)..setFloat32(0, v, Endian.little);
    _buf.addAll(bd.buffer.asUint8List());
  }

  void writeF64(double v) {
    final ByteData bd = ByteData(8)..setFloat64(0, v, Endian.little);
    _buf.addAll(bd.buffer.asUint8List());
  }

  void writeI64(int v) {
    final ByteData bd = ByteData(8)..setInt64(0, v, Endian.little);
    _buf.addAll(bd.buffer.asUint8List());
  }

  void writeString(String v) {
    final Uint8List encoded = utf8.encode(v);
    writeVarInt(encoded.length);
    _buf.addAll(encoded);
  }

  void writeBytes(Uint8List v) {
    writeVarInt(v.length);
    _buf.addAll(v);
  }

  void writeOption<T>(T? v, void Function(T, PostcardWriter) writeFn) {
    if (v == null) {
      writeU8(0);
    } else {
      writeU8(1);
      writeFn(v, this);
    }
  }

  void writeList<T>(List<T> list, void Function(T, PostcardWriter) writeFn) {
    writeVarInt(list.length);
    for (final T item in list) {
      writeFn(item, this);
    }
  }
}
