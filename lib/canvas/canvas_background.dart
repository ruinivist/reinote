import 'package:flutter/material.dart';

abstract class CanvasBackground {
  /// the fill color of background
  final Color baseColor;
  const CanvasBackground({this.baseColor = Colors.white});

  /// draw the backround on this context. Implement this to have
  /// different kinds of backgrounds
  void paint(Canvas canvas, Offset offset, double scale, Size canvasSize);
}

class DotGridBackround extends CanvasBackground {
  final double size;
  final double spacing;
  final Color color;

  const DotGridBackround({
    this.size = 2.0,
    this.spacing = 24.0,
    this.color = Colors.black26,
  }) : super();

  @override
  void paint(Canvas canvas, Offset offset, double scale, Size canvasSize) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0 * scale;
    double scaledSpacing = spacing * scale;
    double scaledSize = size * scale;

    double startX = (offset.dx % scaledSpacing) - scaledSpacing;
    double startY = (offset.dy % scaledSpacing) - scaledSpacing;

    for (double x = startX; x < canvasSize.width + scaledSpacing; x += scaledSpacing) {
      for (double y = startY; y < canvasSize.height + scaledSpacing; y += scaledSpacing) {
        canvas.drawCircle(Offset(x, y), scaledSize, paint);
      }
    }
  }
}

class NoBackground extends CanvasBackground {
  const NoBackground();

  @override
  void paint(Canvas canvas, Offset offset, double scale, Size canvasSize) {}
}
