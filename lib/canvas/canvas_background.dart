import 'package:flutter/material.dart';

abstract class CanvasBackground {
  /// the fill color of background
  final Color baseColor;
  const CanvasBackground({this.baseColor = Colors.white});

  /// draw the backround on this context. Implement this to have
  /// different kinds of backgrounds
  void paint(PaintingContext context, Offset offset, Size canvasSize);
}

class DotGridBackround extends CanvasBackground {
  final double size;
  final double spacing;
  final Color color;

  const DotGridBackround({
    this.size = 4.0,
    this.spacing = 24.0,
    this.color = Colors.black26,
  }) : super();

  @override
  void paint(PaintingContext context, Offset offset, Size canvasSize) {
    final canvas = context.canvas;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0;

    double startX = (offset.dx % spacing) - spacing;
    double startY = (offset.dy % spacing) - spacing;

    for (double x = startX; x < canvasSize.width + spacing; x += spacing) {
      for (double y = startY; y < canvasSize.height + spacing; y += spacing) {
        canvas.drawCircle(Offset(x, y), size, paint);
      }
    }
  }
}

class NoBackground extends CanvasBackground {
  const NoBackground();

  @override
  void paint(PaintingContext context, Offset offset, Size canvasSize) {}
}
