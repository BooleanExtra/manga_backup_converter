import 'dart:convert';
import 'dart:typed_data';

class PostcardReader {
  PostcardReader(Uint8List bytes)
      : _bytes = bytes,
        _pos = 0;

  final Uint8List _bytes;
  int _pos;

  int get position => _pos;
  bool get isAtEnd => _pos >= _bytes.length;

  int readU8() => _bytes[_pos++];

  bool readBool() => readU8() != 0;

  /// Decode a variable-length unsigned integer (LEB128).
  int readVarInt() {
    var result = 0;
    var shift = 0;
    while (true) {
      final byte = readU8();
      result |= (byte & 0x7F) << shift;
      if ((byte & 0x80) == 0) break;
      shift += 7;
    }
    return result;
  }

  /// Decode a zigzag-encoded signed variable-length integer.
  int readSignedVarInt() {
    final n = readVarInt();
    return (n >> 1) ^ -(n & 1);
  }

  double readF32() {
    final view = ByteData.sublistView(_bytes, _pos, _pos + 4);
    _pos += 4;
    return view.getFloat32(0, Endian.little);
  }

  double readF64() {
    final view = ByteData.sublistView(_bytes, _pos, _pos + 8);
    _pos += 8;
    return view.getFloat64(0, Endian.little);
  }

  String readString() {
    final len = readVarInt();
    final str = utf8.decode(_bytes.sublist(_pos, _pos + len));
    _pos += len;
    return str;
  }

  Uint8List readBytes() {
    final len = readVarInt();
    final bytes = _bytes.sublist(_pos, _pos + len);
    _pos += len;
    return bytes;
  }

  T? readOption<T>(T Function() readFn) {
    if (readU8() == 0) return null;
    return readFn();
  }

  List<T> readList<T>(T Function() readFn) {
    final count = readVarInt();
    return List.generate(count, (_) => readFn());
  }
}
