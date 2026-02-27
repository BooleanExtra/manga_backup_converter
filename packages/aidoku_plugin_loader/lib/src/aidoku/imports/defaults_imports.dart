import 'dart:convert';
import 'dart:typed_data';

import 'package:aidoku_plugin_loader/src/aidoku/libs/host_store.dart';
import 'package:aidoku_plugin_loader/src/aidoku/libs/import_context.dart';

/// `defaults` module host imports.
Map<String, Function> buildDefaultsImports(ImportContext ctx) => <String, Function>{
  'get': (int keyPtr, int keyLen) {
    final key = '${ctx.sourceId}.${utf8.decode(ctx.runner.readMemory(keyPtr, keyLen))}';
    final Object? stored = ctx.store.defaults[key];
    if (stored == null) return 0;
    if (stored is int) return stored;
    if (stored is Uint8List) return ctx.store.addBytes(stored);
    return 0;
  },
  // Aidoku SDK DefaultValue kinds:
  // 1=Bool, 2=Int, 3=Float, 4=String, 5=StringArray, 6=Null.
  'set': (int keyPtr, int keyLen, int kind, int value) {
    final key = '${ctx.sourceId}.${utf8.decode(ctx.runner.readMemory(keyPtr, keyLen))}';
    if (kind == 6 || value == 0) {
      ctx.store.defaults.remove(key);
    } else {
      final BytesResource? res = ctx.store.get<BytesResource>(value);
      if (res != null) {
        ctx.store.defaults[key] = Uint8List.fromList(res.bytes);
      }
    }
    return 0;
  },
};
