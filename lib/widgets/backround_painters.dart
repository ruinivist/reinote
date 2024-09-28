import 'package:flutter/material.dart';

import '../canvas/canvas_background.dart';

class AnimatedOffsetBackground extends CustomPainter {
  final CanvasBackground background;
  final Animation<Offset> animation;

  AnimatedOffsetBackground({required this.background, required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    background.paint(canvas, animation.value, size);
  }

  @override
  bool shouldRepaint(covariant AnimatedOffsetBackground oldDelegate) {
    return oldDelegate.animation.value != animation.value;
  }
}
