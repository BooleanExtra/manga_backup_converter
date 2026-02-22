import 'dart:convert';
import 'dart:typed_data';

class PostcardReader {
  PostcardReader(Uint8List bytes) : _bytes = bytes, _pos = 0;

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
      final int byte = readU8();
      result |= (byte & 0x7F) << shift;
      if ((byte & 0x80) == 0) break;
      shift += 7;
    }
    return result;
  }

  /// Decode a zigzag-encoded signed variable-length integer.
  int readSignedVarInt() {
    final int n = readVarInt();
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

  int readI64() {
    final view = ByteData.sublistView(_bytes, _pos, _pos + 8);
    _pos += 8;
    return view.getInt64(0, Endian.little);
  }

  String readString() {
    final int len = readVarInt();
    final String str = utf8.decode(_bytes.sublist(_pos, _pos + len));
    _pos += len;
    return _tryFixDoubleEncoded(str);
  }

  /// Detect and repair double-encoded UTF-8 strings.
  ///
  /// Some WASM plugins interpret UTF-8 HTTP response bytes as Latin-1 code
  /// points, producing strings where e.g. 二 (U+4E8C, UTF-8: E4 BA 8C)
  /// becomes ä (U+E4) + º (U+BA) + Œ (U+8C). This re-encodes to Latin-1
  /// (recovering the original bytes) and re-decodes as UTF-8.
  static String _tryFixDoubleEncoded(String s) {
    var hasHighLatin = false;
    for (final int c in s.codeUnits) {
      if (c > 0xFF) return s;
      if (c >= 0x80) hasHighLatin = true;
    }
    if (!hasHighLatin) return s;

    try {
      final bytes = Uint8List.fromList(s.codeUnits);
      return utf8.decode(bytes);
    } on FormatException {
      return s;
    }
  }

  Uint8List readBytes() {
    final int len = readVarInt();
    final Uint8List bytes = _bytes.sublist(_pos, _pos + len);
    _pos += len;
    return bytes;
  }

  T? readOption<T>(T Function() readFn) {
    if (readU8() == 0) return null;
    return readFn();
  }

  List<T> readList<T>(T Function() readFn) {
    final int count = readVarInt();
    return List<T>.generate(count, (_) => readFn());
  }
}
