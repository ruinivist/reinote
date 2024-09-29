import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_tl_app/screens/settings.dart';

import '../utils/log.dart';

class UiTest extends StatelessWidget {
  const UiTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DotGridWidget(),
    );
  }
}

class DotGridPainter extends CustomPainter {
  final Color color;
  final double spacing;
  final double dotSize;
  final Offset offset;
  final double scale;

  DotGridPainter({
    required this.color,
    required this.spacing,
    required this.dotSize,
    required this.offset,
    required this.scale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0 * scale;

    double scaledSpacing = spacing * scale;
    double scaledSize = dotSize * scale;
    double startX = (offset.dx % scaledSpacing) - scaledSpacing;
    double startY = (offset.dy % scaledSpacing) - scaledSpacing;

    for (double x = startX; x < size.width + scaledSpacing; x += scaledSpacing) {
      for (double y = startY; y < size.height + scaledSpacing; y += scaledSpacing) {
        canvas.drawCircle(Offset(x, y), scaledSize, paint);
      }
    }
  }

  @override
  bool shouldRepaint(DotGridPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.spacing != spacing ||
        oldDelegate.dotSize != dotSize ||
        oldDelegate.offset != offset ||
        oldDelegate.scale != scale;
  }
}

class DotGridWidget extends StatefulWidget {
  @override
  _DotGridWidgetState createState() => _DotGridWidgetState();
}

class _DotGridWidgetState extends State<DotGridWidget> {
  Offset _offset = Offset.zero;
  double _scale = 1.0;
  Offset? _lastFocalPoint;

  void _handleScaleStart(ScaleStartDetails details) {
    _lastFocalPoint = details.focalPoint;
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      // Handle scaling
      double newScale = _scale * details.scale;
      newScale = newScale.clamp(0.5, 5.0); // Limit scale between 0.5 and 5.0

      // Calculate the focal point in the coordinate system of the grid
      Offset focalPoint = details.localFocalPoint;
      Offset gridFocalPoint = (focalPoint - _offset) / _scale;

      // Update the scale
      _scale = newScale;

      // Adjust offset to keep the focal point stationary
      _offset = focalPoint - gridFocalPoint * _scale;

      // Handle panning
      if (_lastFocalPoint != null) {
        _offset += details.focalPoint - _lastFocalPoint!;
      }
      _lastFocalPoint = details.focalPoint;

      lg.i('focalPoint: ${details.focalPoint}\noffset: $_offset\nscale: $_scale\nx: ${gridFocalPoint * _scale}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: _handleScaleStart,
      onScaleUpdate: _handleScaleUpdate,
      child: CustomPaint(
        painter: DotGridPainter(
          color: Colors.black,
          spacing: 20,
          dotSize: 2,
          offset: _offset,
          scale: _scale,
        ),
        child: Container(), // This ensures the CustomPaint fills its parent
      ),
    );
  }
}
