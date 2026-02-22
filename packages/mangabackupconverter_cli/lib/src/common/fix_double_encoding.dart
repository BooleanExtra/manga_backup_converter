import 'dart:convert';
import 'dart:typed_data';

/// Detect and repair double-encoded UTF-8 strings.
///
/// Some sources (WASM plugins, backup files) store strings where UTF-8 bytes
/// were interpreted as Latin-1 code points. This reverses that by re-encoding
/// to Latin-1 (recovering original bytes) and re-decoding as UTF-8.
///
/// Safe: pure ASCII -> unchanged, real Unicode (U+0100+) -> unchanged,
/// legitimate accented text -> FormatException -> unchanged.
String fixDoubleEncoding(String s) {
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
