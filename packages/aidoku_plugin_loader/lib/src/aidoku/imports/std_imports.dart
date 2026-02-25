import 'dart:convert';
import 'dart:typed_data';

import 'package:aidoku_plugin_loader/src/aidoku/libs/host_store.dart';
import 'package:aidoku_plugin_loader/src/aidoku/libs/import_context.dart';

/// `std` module host imports.
Map<String, Function> buildStdImports(ImportContext ctx) {
  final map = <String, Function>{
    'destroy': (int rid) {
      ctx.store.remove(rid);
    },
    'buffer_len': (int rid) {
      final BytesResource? r = ctx.store.get<BytesResource>(rid);
      if (r == null) return -1;
      return r.bytes.length;
    },
    'utc_offset': () => DateTime.now().timeZoneOffset.inSeconds,
  };

  addAlias(map, 'read_buffer', (int rid, int ptr, int len) {
    final BytesResource? r = ctx.store.get<BytesResource>(rid);
    if (r == null) return -1;
    final Uint8List bytes = r.bytes.length <= len ? r.bytes : r.bytes.sublist(0, len);
    ctx.runner.writeMemory(ptr, bytes);
    return 0;
  });

  addAlias(
    map,
    'current_date',
    () => DateTime.now().millisecondsSinceEpoch / 1000.0,
  );

  addAlias(map, 'parse_date', (
    int strPtr,
    int strLen,
    int fmtPtr,
    int fmtLen,
    int localePtr,
    int localeLen,
    int tzPtr,
    int tzLen,
  ) {
    try {
      final String dateStr = utf8.decode(ctx.runner.readMemory(strPtr, strLen));
      final DateTime? parsed = tryParseDate(dateStr);
      return parsed != null ? parsed.millisecondsSinceEpoch / 1000.0 : -1.0;
    } on Exception catch (e) {
      ctx.onLog?.call('[aidoku] parse_date failed: $e');
      return -1.0;
    }
  });

  return map;
}

/// Try to parse a date string using ISO 8601 and common fallback formats.
DateTime? tryParseDate(String s) {
  final String trimmed = s.trim();
  if (trimmed.isEmpty) return null;
  final DateTime? iso = DateTime.tryParse(trimmed);
  if (iso != null) return iso;
  // Strip trailing timezone abbreviation / extra text and retry.
  final String cleaned = trimmed.replaceAll(RegExp(r'\s+\w+$'), '');
  return DateTime.tryParse(cleaned);
}
