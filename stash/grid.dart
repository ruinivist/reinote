import 'package:flutter/material.dart';

class GridCard {
  final Widget child;
  final Offset position;

  GridCard({required this.child, required this.position});
}

class InfiniteGridWithCards extends StatefulWidget {
  final List<GridCard> cards;

  InfiniteGridWithCards({required this.cards});

  @override
  _InfiniteGridWithCardsState createState() => _InfiniteGridWithCardsState();
}

class _InfiniteGridWithCardsState extends State<InfiniteGridWithCards> {
  Offset _offset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _offset += details.delta;
        });
      },
      child: Stack(
        children: [
          CustomPaint(
            painter: GridPainter(_offset),
            size: Size.infinite,
          ),
          ...widget.cards.map((card) => Positioned(
                left: card.position.dx + _offset.dx,
                top: card.position.dy + _offset.dy,
                child: card.child,
              )),
        ],
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  final Offset offset;
  final double spacing = 50.0;
  final double dotRadius = 2.0;

  GridPainter(this.offset);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1.0;

    double startX = (offset.dx % spacing) - spacing;
    double startY = (offset.dy % spacing) - spacing;

    for (double x = startX; x < size.width + spacing; x += spacing) {
      for (double y = startY; y < size.height + spacing; y += spacing) {
        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
