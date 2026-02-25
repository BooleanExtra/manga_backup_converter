import 'dart:typed_data';

import 'package:aidoku_plugin_loader/src/aidoku/libs/canvas_host.dart';
import 'package:aidoku_plugin_loader/src/aidoku/libs/host_store.dart';
import 'package:aidoku_plugin_loader/src/codec/postcard_writer.dart';
import 'package:checks/checks.dart';
import 'package:image/image.dart' as img;
import 'package:test/scaffolding.dart';

void main() {
  group('Canvas resources', () {
    late HostStore store;
    setUp(() => store = HostStore());
    tearDown(() => store.dispose());

    test('CanvasContextResource stores image and transform defaults', () {
      final image = img.Image(width: 10, height: 10, numChannels: 4);
      final ctx = CanvasContextResource(image);
      check(ctx.image.width).equals(10);
      check(ctx.image.height).equals(10);
      check(ctx.tx).equals(0.0);
      check(ctx.ty).equals(0.0);
      check(ctx.sx).equals(1.0);
      check(ctx.sy).equals(1.0);
      check(ctx.angle).equals(0.0);
    });

    test('ImageResource stores decoded image', () {
      final image = img.Image(width: 5, height: 3, numChannels: 4);
      final res = ImageResource(image);
      check(res.image.width).equals(5);
      check(res.image.height).equals(3);
    });

    test('FontResource stores name and weight', () {
      final res = FontResource(name: 'Arial', weight: 4);
      check(res.name).equals('Arial');
      check(res.weight).equals(4);
    });

    test('store can add and retrieve canvas resources', () {
      final image = img.Image(width: 10, height: 10, numChannels: 4);
      final int ctxRid = store.add(CanvasContextResource(image));
      final int imgRid = store.add(ImageResource(image));
      final int fontRid = store.add(FontResource(name: 'test', weight: 2));

      check(store.get<CanvasContextResource>(ctxRid)).isNotNull();
      check(store.get<ImageResource>(imgRid)).isNotNull();
      check(store.get<FontResource>(fontRid)).isNotNull();
    });

    test('store returns null for wrong resource type', () {
      final int rid = store.add(CanvasContextResource(img.Image(width: 1, height: 1)));
      check(store.get<ImageResource>(rid)).isNull();
    });
  });

  group('Path deserialization', () {
    test('deserializes MoveTo + LineTo + Close', () {
      final writer = PostcardWriter()
        ..writeVarInt(3) // 3 ops
        ..writeVarInt(0) // MoveTo
        ..writeF32(10.0)
        ..writeF32(20.0)
        ..writeVarInt(1) // LineTo
        ..writeF32(30.0)
        ..writeF32(40.0)
        ..writeVarInt(5); // Close
      final List<PathOp> ops = deserializePathOps(writer.bytes);
      check(ops).length.equals(3);
      check(ops[0]).isA<MoveToOp>();
      final move = ops[0] as MoveToOp;
      check(move.x).isCloseTo(10.0, 0.01);
      check(move.y).isCloseTo(20.0, 0.01);
      check(ops[1]).isA<LineToOp>();
      check(ops[2]).isA<CloseOp>();
    });

    test('deserializes QuadTo', () {
      final writer = PostcardWriter()
        ..writeVarInt(1)
        ..writeVarInt(2) // QuadTo
        ..writeF32(1.0)
        ..writeF32(2.0)
        ..writeF32(3.0)
        ..writeF32(4.0);
      final List<PathOp> ops = deserializePathOps(writer.bytes);
      check(ops).length.equals(1);
      final quad = ops[0] as QuadToOp;
      check(quad.cx).isCloseTo(1.0, 0.01);
      check(quad.cy).isCloseTo(2.0, 0.01);
      check(quad.x).isCloseTo(3.0, 0.01);
      check(quad.y).isCloseTo(4.0, 0.01);
    });

    test('deserializes CubicTo', () {
      final writer = PostcardWriter()
        ..writeVarInt(1)
        ..writeVarInt(3) // CubicTo
        ..writeF32(1.0)
        ..writeF32(2.0)
        ..writeF32(3.0)
        ..writeF32(4.0)
        ..writeF32(5.0)
        ..writeF32(6.0);
      final List<PathOp> ops = deserializePathOps(writer.bytes);
      check(ops).length.equals(1);
      check(ops[0]).isA<CubicToOp>();
    });

    test('deserializes Arc', () {
      final writer = PostcardWriter()
        ..writeVarInt(1)
        ..writeVarInt(4) // Arc
        ..writeF32(10.0)
        ..writeF32(20.0)
        ..writeF32(5.0)
        ..writeF32(0.0)
        ..writeF32(3.14);
      final List<PathOp> ops = deserializePathOps(writer.bytes);
      check(ops).length.equals(1);
      final arc = ops[0] as ArcOp;
      check(arc.x).isCloseTo(10.0, 0.01);
      check(arc.radius).isCloseTo(5.0, 0.01);
    });

    test('deserializes empty path', () {
      final writer = PostcardWriter()..writeVarInt(0);
      final List<PathOp> ops = deserializePathOps(writer.bytes);
      check(ops).isEmpty();
    });
  });

  group('StrokeStyle deserialization', () {
    test('deserializes stroke style', () {
      final writer = PostcardWriter()
        ..writeF32(1.0) // r
        ..writeF32(0.0) // g
        ..writeF32(0.0) // b
        ..writeF32(1.0) // a
        ..writeF32(2.5) // width
        ..writeVarInt(0) // cap = butt
        ..writeVarInt(1) // join = round
        ..writeF32(4.0) // miter limit
        ..writeVarInt(2) // dash array length
        ..writeF32(5.0) // dash[0]
        ..writeF32(3.0) // dash[1]
        ..writeF32(0.0); // dash offset
      final StrokeStyleData style = deserializeStrokeStyle(writer.bytes);
      check(style.width).isCloseTo(2.5, 0.01);
      check(style.cap).equals(0);
      check(style.join).equals(1);
      check(style.miterLimit).isCloseTo(4.0, 0.01);
      check(style.dashArray).length.equals(2);
      check(style.dashOffset).isCloseTo(0.0, 0.01);
    });
  });

  group('fillPath', () {
    test('fills a rectangular path', () {
      final image = img.Image(width: 20, height: 20, numChannels: 4);
      // Clear to black
      img.fill(image, color: img.ColorRgba8(0, 0, 0, 255));

      // Rectangle path: (5,5) → (15,5) → (15,15) → (5,15) → close
      final writer = PostcardWriter()
        ..writeVarInt(5) // 5 ops
        ..writeVarInt(0)
        ..writeF32(5.0)
        ..writeF32(5.0) // MoveTo
        ..writeVarInt(1)
        ..writeF32(15.0)
        ..writeF32(5.0) // LineTo
        ..writeVarInt(1)
        ..writeF32(15.0)
        ..writeF32(15.0) // LineTo
        ..writeVarInt(1)
        ..writeF32(5.0)
        ..writeF32(15.0) // LineTo
        ..writeVarInt(5); // Close
      final List<PathOp> ops = deserializePathOps(writer.bytes);

      fillPath(image, ops, 1.0, 0.0, 0.0, 1.0); // red

      // Check pixel inside rect is red
      final img.Pixel inside = image.getPixel(10, 10);
      check(inside.r.toInt()).equals(255);
      check(inside.g.toInt()).equals(0);
      check(inside.b.toInt()).equals(0);

      // Check pixel outside rect is still black
      final img.Pixel outside = image.getPixel(0, 0);
      check(outside.r.toInt()).equals(0);
    });
  });

  group('strokePath', () {
    test('strokes a line segment', () {
      final image = img.Image(width: 20, height: 20, numChannels: 4);
      img.fill(image, color: img.ColorRgba8(0, 0, 0, 255));

      // MoveTo(0,10) → LineTo(19,10)
      final pathWriter = PostcardWriter()
        ..writeVarInt(2)
        ..writeVarInt(0)
        ..writeF32(0.0)
        ..writeF32(10.0) // MoveTo
        ..writeVarInt(1)
        ..writeF32(19.0)
        ..writeF32(10.0); // LineTo
      final List<PathOp> ops = deserializePathOps(pathWriter.bytes);

      final style = StrokeStyleData(
        color: img.ColorFloat32.rgba(0, 1, 0, 1), // green
        width: 1.0,
        cap: 0,
        join: 0,
        miterLimit: 4.0,
        dashArray: <double>[],
        dashOffset: 0.0,
      );

      strokePath(image, ops, style);

      // Check a pixel along the line is green
      final img.Pixel onLine = image.getPixel(10, 10);
      check(onLine.g.toInt()).equals(255);
    });
  });

  group('Image round-trip', () {
    test('encode PNG and decode back', () {
      final image = img.Image(width: 4, height: 4, numChannels: 4);
      img.fill(image, color: img.ColorRgba8(128, 64, 32, 255));

      final Uint8List png = img.encodePng(image);
      check(png).isNotEmpty();

      final img.Image? decoded = img.decodeImage(png);
      check(decoded).isNotNull();
      check(decoded!.width).equals(4);
      check(decoded.height).equals(4);

      final img.Pixel p = decoded.getPixel(0, 0);
      check(p.r.toInt()).equals(128);
      check(p.g.toInt()).equals(64);
      check(p.b.toInt()).equals(32);
    });
  });

  group('Image compositing', () {
    test('draw_image composites source onto destination', () {
      final dst = img.Image(width: 20, height: 20, numChannels: 4);
      img.fill(dst, color: img.ColorRgba8(0, 0, 0, 255));

      final src = img.Image(width: 5, height: 5, numChannels: 4);
      img.fill(src, color: img.ColorRgba8(255, 0, 0, 255));

      img.compositeImage(dst, src, dstX: 3, dstY: 3, dstW: 5, dstH: 5, blend: img.BlendMode.direct);

      // Inside composited region
      final img.Pixel inside = dst.getPixel(5, 5);
      check(inside.r.toInt()).equals(255);
      check(inside.g.toInt()).equals(0);

      // Outside composited region
      final img.Pixel outside = dst.getPixel(0, 0);
      check(outside.r.toInt()).equals(0);
    });

    test('copy_image copies a sub-region (tile swap for descrambling)', () {
      // Create a source image with distinct quadrants
      final src = img.Image(width: 10, height: 10, numChannels: 4);
      // Top-left = red
      img.fillRect(src, x1: 0, y1: 0, x2: 5, y2: 5, color: img.ColorRgba8(255, 0, 0, 255));
      // Top-right = green
      img.fillRect(src, x1: 5, y1: 0, x2: 10, y2: 5, color: img.ColorRgba8(0, 255, 0, 255));
      // Bottom-left = blue
      img.fillRect(src, x1: 0, y1: 5, x2: 5, y2: 10, color: img.ColorRgba8(0, 0, 255, 255));
      // Bottom-right = white
      img.fillRect(src, x1: 5, y1: 5, x2: 10, y2: 10, color: img.ColorRgba8(255, 255, 255, 255));

      // Descramble: swap top-left with bottom-right
      final dst = img.Image(width: 10, height: 10, numChannels: 4);
      // Place bottom-right tile (white) in top-left of dst
      img.compositeImage(
        dst,
        src,
        srcX: 5,
        srcY: 5,
        srcW: 5,
        srcH: 5,
        dstX: 0,
        dstY: 0,
        dstW: 5,
        dstH: 5,
        blend: img.BlendMode.direct,
      );
      // Place top-left tile (red) in bottom-right of dst
      img.compositeImage(
        dst,
        src,
        srcX: 0,
        srcY: 0,
        srcW: 5,
        srcH: 5,
        dstX: 5,
        dstY: 5,
        dstW: 5,
        dstH: 5,
        blend: img.BlendMode.direct,
      );

      // Verify: top-left of dst should be white (was bottom-right)
      final img.Pixel topLeft = dst.getPixel(2, 2);
      check(topLeft.r.toInt()).equals(255);
      check(topLeft.g.toInt()).equals(255);
      check(topLeft.b.toInt()).equals(255);

      // Verify: bottom-right of dst should be red (was top-left)
      final img.Pixel bottomRight = dst.getPixel(7, 7);
      check(bottomRight.r.toInt()).equals(255);
      check(bottomRight.g.toInt()).equals(0);
      check(bottomRight.b.toInt()).equals(0);
    });
  });
}
