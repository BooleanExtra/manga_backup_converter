import 'dart:convert';
import 'dart:typed_data';

import 'package:aidoku_plugin_loader/src/aidoku/libs/import_context.dart';

/// `env` module host imports.
Map<String, Function> buildEnvImports(ImportContext ctx) {
  final map = <String, Function>{
    '_sleep': (int seconds) {
      ctx.asyncSleep?.call(seconds);
    },
    // Rust panic/abort — log and return.
    'abort': () {
      ctx.onLog?.call('[aidoku] WASM abort called (plugin panic)');
    },
  };

  addAlias(map, 'print', (int ptr, int len) {
    if (len > 0) {
      ctx.onLog?.call('[aidoku] ${utf8.decode(ctx.runner.readMemory(ptr, len))}');
    }
  });

  addAlias(map, 'send_partial_result', (int ptr) {
    try {
      // Layout: [u32 length LE][u32 capacity LE][<length> bytes postcard]
      final Uint8List lenBytes = ctx.runner.readMemory(ptr, 4);
      final int length = ByteData.sublistView(lenBytes).getUint32(0, Endian.little);
      if (length > 0) {
        final Uint8List data = ctx.runner.readMemory(ptr + 8, length);
        ctx.store.addPartialResult(data);
      }
    } on Exception catch (e) {
      ctx.onLog?.call('[aidoku] send_partial_result failed: $e');
    }
  });

  return map;
}
