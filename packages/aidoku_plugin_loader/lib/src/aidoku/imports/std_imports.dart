import 'dart:convert';
import 'dart:typed_data';

import 'package:aidoku_plugin_loader/src/aidoku/libs/host_store.dart';
import 'package:aidoku_plugin_loader/src/aidoku/libs/import_context.dart';
import 'package:intl/intl.dart';

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
      final String format = fmtLen > 0 ? utf8.decode(ctx.runner.readMemory(fmtPtr, fmtLen)) : '';
      final String locale = localeLen > 0 ? utf8.decode(ctx.runner.readMemory(localePtr, localeLen)) : '';
      final String timezone = tzLen > 0 ? utf8.decode(ctx.runner.readMemory(tzPtr, tzLen)) : '';

      DateTime? parsed;
      if (format.isNotEmpty) {
        // Use intl DateFormat with the provided format string (Unicode TR35/ICU).
        final String? intlLocale = locale.isNotEmpty ? locale : null;
        try {
          final df = DateFormat(format, intlLocale);
          parsed = df.parseLoose(dateStr.trim());
        } on FormatException {
          // Format didn't match — try ISO fallback.
          parsed = tryParseDate(dateStr);
        }
      } else {
        parsed = tryParseDate(dateStr);
      }

      if (parsed == null) return -1.0;

      // Timezone handling: "UTC" → treat as UTC, otherwise treat as local.
      if (timezone.toUpperCase() == 'UTC' || timezone == 'GMT') {
        if (!parsed.isUtc) {
          parsed = DateTime.utc(
            parsed.year,
            parsed.month,
            parsed.day,
            parsed.hour,
            parsed.minute,
            parsed.second,
            parsed.millisecond,
          );
        }
      }

      return parsed.millisecondsSinceEpoch / 1000.0;
    } on Object catch (e) {
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
