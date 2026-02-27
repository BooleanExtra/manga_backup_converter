import 'dart:typed_data';

import 'package:aidoku_plugin_loader/src/aidoku/libs/canvas_host.dart';
import 'package:aidoku_plugin_loader/src/aidoku/libs/host_store.dart';
import 'package:aidoku_plugin_loader/src/aidoku/libs/import_context.dart';
import 'package:image/image.dart' as img;

/// `canvas` module host imports.
Map<String, Function> buildCanvasImports(ImportContext ctx) => <String, Function>{
  'new_context': (double width, double height) {
    try {
      final image = img.Image(
        width: width.toInt(),
        height: height.toInt(),
        numChannels: 4,
      );
      return ctx.store.add(CanvasContextResource(image));
    } on Exception catch (e) {
      ctx.onLog?.call('[aidoku] canvas::new_context: $e');
      return -1;
    }
  },
  'set_transform':
      (
        int ctxRid,
        double tx,
        double ty,
        double sx,
        double sy,
        double angle,
      ) {
        final CanvasContextResource? c = ctx.store.get<CanvasContextResource>(ctxRid);
        if (c == null) return -1;
        c.tx = tx;
        c.ty = ty;
        c.sx = sx;
        c.sy = sy;
        c.angle = angle;
        return 0;
      },
  'draw_image':
      (
        int ctxRid,
        int imgRid,
        double dx,
        double dy,
        double dw,
        double dh,
      ) {
        try {
          final CanvasContextResource? c = ctx.store.get<CanvasContextResource>(ctxRid);
          final ImageResource? src = ctx.store.get<ImageResource>(imgRid);
          if (c == null || src == null) return -1;
          img.compositeImage(
            c.image,
            src.image,
            dstX: dx.toInt(),
            dstY: dy.toInt(),
            dstW: dw.toInt(),
            dstH: dh.toInt(),
            blend: img.BlendMode.direct,
          );
          return 0;
        } on Exception catch (e) {
          ctx.onLog?.call('[aidoku] canvas::draw_image: $e');
          return -1;
        }
      },
  'copy_image':
      (
        int ctxRid,
        int imgRid,
        double sx,
        double sy,
        double sw,
        double sh,
        double dx,
        double dy,
        double dw,
        double dh,
      ) {
        try {
          final CanvasContextResource? c = ctx.store.get<CanvasContextResource>(ctxRid);
          final ImageResource? src = ctx.store.get<ImageResource>(imgRid);
          if (c == null || src == null) return -1;
          img.compositeImage(
            c.image,
            src.image,
            srcX: sx.toInt(),
            srcY: sy.toInt(),
            srcW: sw.toInt(),
            srcH: sh.toInt(),
            dstX: dx.toInt(),
            dstY: dy.toInt(),
            dstW: dw.toInt(),
            dstH: dh.toInt(),
            blend: img.BlendMode.direct,
          );
          return 0;
        } on Exception catch (e) {
          ctx.onLog?.call('[aidoku] canvas::copy_image: $e');
          return -1;
        }
      },
  'fill': (int ctxRid, int pathPtr, double r, double g, double b, double a) {
    try {
      final CanvasContextResource? c = ctx.store.get<CanvasContextResource>(ctxRid);
      if (c == null) return -1;
      final Uint8List postcard = readEncodedPostcard(ctx.runner, pathPtr);
      if (postcard.isEmpty) return -1;
      final List<PathOp> ops = deserializePathOps(postcard);
      fillPath(c.image, ops, r, g, b, a);
      return 0;
    } on Exception catch (e) {
      ctx.onLog?.call('[aidoku] canvas::fill: $e');
      return -1;
    }
  },
  'stroke': (int ctxRid, int pathPtr, int stylePtr) {
    try {
      final CanvasContextResource? c = ctx.store.get<CanvasContextResource>(ctxRid);
      if (c == null) return -1;
      final Uint8List pathPostcard = readEncodedPostcard(ctx.runner, pathPtr);
      final Uint8List stylePostcard = readEncodedPostcard(ctx.runner, stylePtr);
      if (pathPostcard.isEmpty || stylePostcard.isEmpty) return -1;
      final List<PathOp> ops = deserializePathOps(pathPostcard);
      final StrokeStyleData style = deserializeStrokeStyle(stylePostcard);
      strokePath(c.image, ops, style);
      return 0;
    } on Exception catch (e) {
      ctx.onLog?.call('[aidoku] canvas::stroke: $e');
      return -1;
    }
  },
  'draw_text':
      (
        int ctxRid,
        int textPtr,
        int textLen,
        double size,
        double x,
        double y,
        int font,
        double r,
        double g,
        double b,
        double a,
      ) {
        try {
          final CanvasContextResource? c = ctx.store.get<CanvasContextResource>(ctxRid);
          if (c == null) return -1;
          final String text = ctx.readString(textPtr, textLen);
          final color = img.ColorRgba8(
            (r * 255).round().clamp(0, 255),
            (g * 255).round().clamp(0, 255),
            (b * 255).round().clamp(0, 255),
            (a * 255).round().clamp(0, 255),
          );
          img.drawString(
            c.image,
            text,
            font: img.arial14,
            x: x.toInt(),
            y: y.toInt(),
            color: color,
          );
          return 0;
        } on Exception catch (e) {
          ctx.onLog?.call('[aidoku] canvas::draw_text: $e');
          return -1;
        }
      },
  'get_image': (int ctxRid) {
    try {
      final CanvasContextResource? c = ctx.store.get<CanvasContextResource>(ctxRid);
      if (c == null) return -1;
      return ctx.store.add(ImageResource(c.image.clone()));
    } on Exception catch (e) {
      ctx.onLog?.call('[aidoku] canvas::get_image: $e');
      return -1;
    }
  },
  'new_font': (int namePtr, int nameLen) {
    try {
      final String name = ctx.readString(namePtr, nameLen);
      return ctx.store.add(FontResource(name: name, weight: 4));
    } on Exception catch (e) {
      ctx.onLog?.call('[aidoku] canvas::new_font: $e');
      return -1;
    }
  },
  'system_font': (int weight) {
    return ctx.store.add(FontResource(name: 'system', weight: weight));
  },
  'load_font': (int urlPtr, int urlLen) {
    try {
      final String url = ctx.readString(urlPtr, urlLen);
      ctx.onLog?.call(
        '[aidoku] canvas::load_font: font loading not supported (url=$url)',
      );
      return ctx.store.add(FontResource(name: 'loaded', weight: 4));
    } on Exception catch (e) {
      ctx.onLog?.call('[aidoku] canvas::load_font: $e');
      return -1;
    }
  },
  'new_image': (int dataPtr, int dataLen) {
    try {
      final Uint8List bytes = ctx.runner.readMemory(dataPtr, dataLen);
      final img.Image? decoded = img.decodeImage(bytes);
      if (decoded == null) return -1;
      return ctx.store.add(ImageResource(decoded));
    } on Exception catch (e) {
      ctx.onLog?.call('[aidoku] canvas::new_image: $e');
      return -1;
    }
  },
  'get_image_data': (int imgRid) {
    try {
      final ImageResource? r = ctx.store.get<ImageResource>(imgRid);
      if (r == null) return -1;
      return ctx.store.addBytes(img.encodePng(r.image));
    } on Exception catch (e) {
      ctx.onLog?.call('[aidoku] canvas::get_image_data: $e');
      return -1;
    }
  },
  'get_image_width': (int imgRid) {
    final ImageResource? r = ctx.store.get<ImageResource>(imgRid);
    if (r == null) return 0.0;
    return r.image.width.toDouble();
  },
  'get_image_height': (int imgRid) {
    final ImageResource? r = ctx.store.get<ImageResource>(imgRid);
    if (r == null) return 0.0;
    return r.image.height.toDouble();
  },
};
