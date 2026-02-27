// ignore_for_file: avoid_print
import 'dart:typed_data';

import 'package:aidoku_plugin_loader/src/codec/postcard_reader.dart';
import 'package:aidoku_plugin_loader/src/wasm/wasm_runner.dart';
import 'package:image/image.dart' as img;

// ---------------------------------------------------------------------------
// WASM memory helpers
// ---------------------------------------------------------------------------

/// Reads a postcard-encoded byte payload from WASM memory at [ptr].
///
/// The aidoku-rs `encode()` layout is:
///   `[i32 totalLen LE][i32 capacity LE][postcard bytes...]`
/// where totalLen includes the 8-byte header itself.
Uint8List readEncodedPostcard(WasmRunner runner, int ptr) {
  final Uint8List lenBytes = runner.readMemory(ptr, 4);
  final int totalLen = ByteData.sublistView(lenBytes).getInt32(0, Endian.little);
  final int payloadLen = totalLen - 8;
  if (payloadLen <= 0) return Uint8List(0);
  return runner.readMemory(ptr + 8, payloadLen);
}

// ---------------------------------------------------------------------------
// Path operations
// ---------------------------------------------------------------------------

/// A single path operation deserialized from postcard-encoded `Vec<PathOp>`.
sealed class PathOp {
  const PathOp();
}

class MoveToOp extends PathOp {
  const MoveToOp(this.x, this.y);
  final double x;
  final double y;
}

class LineToOp extends PathOp {
  const LineToOp(this.x, this.y);
  final double x;
  final double y;
}

class QuadToOp extends PathOp {
  const QuadToOp(this.cx, this.cy, this.x, this.y);
  final double cx;
  final double cy;
  final double x;
  final double y;
}

class CubicToOp extends PathOp {
  const CubicToOp(this.x, this.y, this.cx1, this.cy1, this.cx2, this.cy2);
  final double x;
  final double y;
  final double cx1;
  final double cy1;
  final double cx2;
  final double cy2;
}

class ArcOp extends PathOp {
  const ArcOp(this.x, this.y, this.radius, this.startAngle, this.sweepAngle);
  final double x;
  final double y;
  final double radius;
  final double startAngle;
  final double sweepAngle;
}

class CloseOp extends PathOp {
  const CloseOp();
}

/// Deserialize a postcard-encoded `Vec<PathOp>`.
List<PathOp> deserializePathOps(Uint8List bytes) {
  final reader = PostcardReader(bytes);
  final int count = reader.readVarInt();
  final ops = <PathOp>[];
  for (var i = 0; i < count; i++) {
    final int variant = reader.readVarInt();
    switch (variant) {
      case 0: // MoveTo
        ops.add(MoveToOp(reader.readF32(), reader.readF32()));
      case 1: // LineTo
        ops.add(LineToOp(reader.readF32(), reader.readF32()));
      case 2: // QuadTo
        ops.add(QuadToOp(reader.readF32(), reader.readF32(), reader.readF32(), reader.readF32()));
      case 3: // CubicTo
        ops.add(
          CubicToOp(
            reader.readF32(),
            reader.readF32(),
            reader.readF32(),
            reader.readF32(),
            reader.readF32(),
            reader.readF32(),
          ),
        );
      case 4: // Arc
        ops.add(
          ArcOp(reader.readF32(), reader.readF32(), reader.readF32(), reader.readF32(), reader.readF32()),
        );
      case 5: // Close
        ops.add(const CloseOp());
      default:
        print('[aidoku] canvas: unknown PathOp variant $variant');
    }
  }
  return ops;
}

// ---------------------------------------------------------------------------
// Stroke style
// ---------------------------------------------------------------------------

class StrokeStyleData {
  const StrokeStyleData({
    required this.color,
    required this.width,
    required this.cap,
    required this.join,
    required this.miterLimit,
    required this.dashArray,
    required this.dashOffset,
  });
  final img.ColorFloat32 color;
  final double width;
  final int cap; // 0=butt, 1=round, 2=square
  final int join; // 0=miter, 1=round, 2=bevel
  final double miterLimit;
  final List<double> dashArray;
  final double dashOffset;
}

/// Deserialize a postcard-encoded `StrokeStyle`.
StrokeStyleData deserializeStrokeStyle(Uint8List bytes) {
  final reader = PostcardReader(bytes);
  final double r = reader.readF32();
  final double g = reader.readF32();
  final double b = reader.readF32();
  final double a = reader.readF32();
  final double width = reader.readF32();
  final int cap = reader.readVarInt();
  final int join = reader.readVarInt();
  final double miterLimit = reader.readF32();
  final List<double> dashArray = reader.readList(reader.readF32);
  final double dashOffset = reader.readF32();
  return StrokeStyleData(
    color: img.ColorFloat32.rgba(r, g, b, a),
    width: width,
    cap: cap,
    join: join,
    miterLimit: miterLimit,
    dashArray: dashArray,
    dashOffset: dashOffset,
  );
}

// ---------------------------------------------------------------------------
// Rendering helpers
// ---------------------------------------------------------------------------

/// Convert float RGBA (0.0–1.0) to an `img.ColorRgba8`.
img.ColorRgba8 _toRgba8(double r, double g, double b, double a) {
  return img.ColorRgba8(
    (r * 255).round().clamp(0, 255),
    (g * 255).round().clamp(0, 255),
    (b * 255).round().clamp(0, 255),
    (a * 255).round().clamp(0, 255),
  );
}

/// Fill rectangular path regions on [image] with the given color.
///
/// Only supports paths made of MoveTo/LineTo/Close that form axis-aligned
/// rectangles (the common case for image descrambling). Non-rectangular paths
/// are silently ignored.
// TODO: support general polygon fill for non-rectangular paths
void fillPath(img.Image image, List<PathOp> ops, double r, double g, double b, double a) {
  final img.ColorRgba8 color = _toRgba8(r, g, b, a);
  final List<_Rect> rects = _extractRects(ops);
  for (final rect in rects) {
    img.fillRect(
      image,
      x1: rect.x.round(),
      y1: rect.y.round(),
      x2: (rect.x + rect.w).round(),
      y2: (rect.y + rect.h).round(),
      color: color,
    );
  }
}

/// Stroke line segments on [image] using the given style.
///
/// Only supports LineTo segments. Curves and arcs are silently skipped.
// TODO: support QuadTo, CubicTo, and Arc stroke rendering
void strokePath(img.Image image, List<PathOp> ops, StrokeStyleData style) {
  final img.ColorRgba8 color = _toRgba8(
    style.color.r.toDouble(),
    style.color.g.toDouble(),
    style.color.b.toDouble(),
    style.color.a.toDouble(),
  );
  var cx = 0.0;
  var cy = 0.0;
  for (final op in ops) {
    switch (op) {
      case MoveToOp():
        cx = op.x;
        cy = op.y;
      case LineToOp():
        img.drawLine(
          image,
          x1: cx.round(),
          y1: cy.round(),
          x2: op.x.round(),
          y2: op.y.round(),
          color: color,
          thickness: style.width,
        );
        cx = op.x;
        cy = op.y;
      case CloseOp():
      // No-op for stroke.
      case QuadToOp():
      case CubicToOp():
      case ArcOp():
      // Not supported — silently skip.
    }
  }
}

// ---------------------------------------------------------------------------
// Internal helpers
// ---------------------------------------------------------------------------

class _Rect {
  const _Rect(this.x, this.y, this.w, this.h);
  final double x;
  final double y;
  final double w;
  final double h;
}

/// Extract axis-aligned rectangles from a path.
///
/// A rectangle is: MoveTo → LineTo → LineTo → LineTo → (LineTo|Close).
/// We detect any 4-corner axis-aligned polygon.
List<_Rect> _extractRects(List<PathOp> ops) {
  final rects = <_Rect>[];
  // Collect points between MoveTo and Close (or end).
  final points = <(double, double)>[];
  for (final op in ops) {
    switch (op) {
      case MoveToOp():
        points.clear();
        points.add((op.x, op.y));
      case LineToOp():
        points.add((op.x, op.y));
      case CloseOp():
        final _Rect? r = _rectFromPoints(points);
        if (r != null) rects.add(r);
        points.clear();
      default:
        points.clear();
    }
  }
  // If path ended without Close but has 4-5 points, try to extract.
  if (points.length >= 4) {
    final _Rect? r = _rectFromPoints(points);
    if (r != null) rects.add(r);
  }
  return rects;
}

_Rect? _rectFromPoints(List<(double, double)> points) {
  if (points.length < 4 || points.length > 5) return null;
  double minX = points[0].$1;
  double maxX = points[0].$1;
  double minY = points[0].$2;
  double maxY = points[0].$2;
  for (final (double x, double y) in points) {
    if (x < minX) minX = x;
    if (x > maxX) maxX = x;
    if (y < minY) minY = y;
    if (y > maxY) maxY = y;
  }
  // Verify all points are on the rectangle corners.
  for (final (double x, double y) in points) {
    final bool onX = (x - minX).abs() < 0.5 || (x - maxX).abs() < 0.5;
    final bool onY = (y - minY).abs() < 0.5 || (y - maxY).abs() < 0.5;
    if (!onX || !onY) return null;
  }
  return _Rect(minX, minY, maxX - minX, maxY - minY);
}
