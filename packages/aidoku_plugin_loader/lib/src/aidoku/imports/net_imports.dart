import 'dart:convert';
import 'dart:typed_data';

import 'package:aidoku_plugin_loader/src/aidoku/libs/host_store.dart';
import 'package:aidoku_plugin_loader/src/aidoku/libs/import_context.dart';
import 'package:jsoup/jsoup.dart';

/// `net` module host imports.
Map<String, Function> buildNetImports(ImportContext ctx) {
  return <String, Function>{
    'init': (int method) {
      return ctx.store.add(HttpRequestResource(method: method));
    },
    'set_url': (int rid, int ptr, int len) {
      final HttpRequestResource? req = ctx.store.get<HttpRequestResource>(rid);
      if (req == null) return -1;
      req.url = ctx.readString(ptr, len);
      return 0;
    },
    'set_header': (int rid, int keyPtr, int keyLen, int valPtr, int valLen) {
      final HttpRequestResource? req = ctx.store.get<HttpRequestResource>(rid);
      if (req == null) return -1;
      req.headers[ctx.readString(keyPtr, keyLen)] = ctx.readString(valPtr, valLen);
      return 0;
    },
    'set_body': (int rid, int ptr, int len) {
      final HttpRequestResource? req = ctx.store.get<HttpRequestResource>(rid);
      if (req == null) return -1;
      req.body = Uint8List.fromList(ctx.runner.readMemory(ptr, len));
      return 0;
    },
    'set_timeout': (int rid, double timeout) {
      final HttpRequestResource? req = ctx.store.get<HttpRequestResource>(rid);
      if (req == null) return -1;
      req.timeout = timeout;
      return 0;
    },
    'send': (int rid) {
      final HttpRequestResource? req = ctx.store.get<HttpRequestResource>(rid);
      if (req == null || req.url == null) return -1;
      if (ctx.asyncHttp == null) return -1;
      final ({Uint8List? body, int statusCode}) resp = ctx.asyncHttp!(
        req.url!,
        req.method,
        Map<String, String>.from(req.headers),
        req.body,
        req.timeout,
      );
      req.statusCode = resp.statusCode;
      req.responseBody = resp.body;
      return rid;
    },
    'send_all': (int ridsPtr, int count) {
      if (ctx.asyncHttp == null) return -1;
      for (var i = 0; i < count; i++) {
        final Uint8List ridBytes = ctx.runner.readMemory(ridsPtr + i * 4, 4);
        final int rid = ByteData.sublistView(ridBytes).getInt32(0, Endian.little);
        final HttpRequestResource? req = ctx.store.get<HttpRequestResource>(rid);
        if (req == null || req.url == null) continue;
        final ({Uint8List? body, int statusCode}) resp = ctx.asyncHttp!(
          req.url!,
          req.method,
          Map<String, String>.from(req.headers),
          req.body,
          req.timeout,
        );
        req.statusCode = resp.statusCode;
        req.responseBody = resp.body;
      }
      return 0;
    },
    'data_len': (int rid) {
      return ctx.store.get<HttpRequestResource>(rid)?.responseBody?.length ?? -1;
    },
    'read_data': (int rid, int ptr, int len) {
      final HttpRequestResource? req = ctx.store.get<HttpRequestResource>(rid);
      final Uint8List? body = req?.responseBody;
      if (body == null) return -1;
      final int n = len < body.length ? len : body.length;
      ctx.runner.writeMemory(ptr, body.sublist(0, n));
      return n;
    },
    'get_status_code': (int rid) {
      return ctx.store.get<HttpRequestResource>(rid)?.statusCode ?? -1;
    },
    'get_header': (int rid, int keyPtr, int keyLen) {
      final HttpRequestResource? req = ctx.store.get<HttpRequestResource>(rid);
      if (req == null) return -1;
      final String key = ctx.readString(keyPtr, keyLen).toLowerCase();
      final String? val = req.responseHeaders[key];
      if (val == null) return -1;
      return ctx.storeString(val);
    },
    'html': (int rid) {
      if (ctx.htmlParser == null) return -1;
      final HttpRequestResource? req = ctx.store.get<HttpRequestResource>(rid);
      final Uint8List? body = req?.responseBody;
      if (body == null) return -1;
      try {
        final String html = utf8.decode(body, allowMalformed: true);
        final Document doc = ctx.htmlParser!.parse(html, baseUri: req!.url ?? '');
        return ctx.store.add(HtmlElementResource(doc));
      } on Object {
        return -1;
      }
    },
    'get_image': (int rid) {
      final HttpRequestResource? req = ctx.store.get<HttpRequestResource>(rid);
      final Uint8List? body = req?.responseBody;
      if (body == null) return -1;
      return ctx.store.addBytes(body);
    },
    'net_set_rate_limit': (int permits, int period, int unit) {
      final config = RateLimitConfig.fromWasm(permits, period, unit);
      ctx.onRateLimitSet?.call(config.permits, config.periodMs);
    },
    'set_rate_limit': (int permits, int period, int unit) {
      final config = RateLimitConfig.fromWasm(permits, period, unit);
      ctx.onRateLimitSet?.call(config.permits, config.periodMs);
    },
  };
}
