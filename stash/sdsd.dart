import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';

class InfiniteGridWithCards extends MultiChildRenderObjectWidget {
  final Offset offset;
  final List<GridCard> cards;

  InfiniteGridWithCards({
    Key? key,
    required this.offset,
    required this.cards,
  }) : super(key: key, children: cards.map((card) => card.child).toList());

  @override
  RenderInfiniteGridWithCards createRenderObject(BuildContext context) {
    return RenderInfiniteGridWithCards(
      offset: offset,
      cardPositions: cards.map((card) => card.position).toList(),
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderInfiniteGridWithCards renderObject) {
    renderObject
      ..offset = offset
      ..cardPositions = cards.map((card) => card.position).toList();
  }
}

class InfiniteGridParentData extends ContainerBoxParentData<RenderBox> {
  late Offset initialPosition;
}

class RenderInfiniteGridWithCards extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, InfiniteGridParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, InfiniteGridParentData> {
  RenderInfiniteGridWithCards({
    required Offset offset,
    required List<Offset> cardPositions,
  })  : _offset = offset,
        _cardPositions = cardPositions;

  Offset _offset;
  List<Offset> _cardPositions;

  set offset(Offset value) {
    if (_offset == value) return;
    _offset = value;
    markNeedsPaint();
  }

  set cardPositions(List<Offset> value) {
    if (_cardPositions == value) return;
    _cardPositions = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! InfiniteGridParentData) {
      child.parentData = InfiniteGridParentData();
    }
  }

  @override
  void performLayout() {
    size = constraints.biggest;

    RenderBox? child = firstChild;
    for (int i = 0; i < _cardPositions.length; i++) {
      if (child != null) {
        final parentData = child.parentData as InfiniteGridParentData;
        parentData.initialPosition = _cardPositions[i];
        child.layout(constraints.loosen(), parentUsesSize: true);
        child = childAfter(child);
      }
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // Draw grid
    final canvas = context.canvas;
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1.0;

    final spacing = 50.0;
    final dotRadius = 2.0;

    double startX = (_offset.dx % spacing) - spacing;
    double startY = (_offset.dy % spacing) - spacing;

    for (double x = startX; x < size.width + spacing; x += spacing) {
      for (double y = startY; y < size.height + spacing; y += spacing) {
        canvas.drawCircle(offset + Offset(x, y), dotRadius, paint);
      }
    }

    // Draw children (cards)
    RenderBox? child = firstChild;
    while (child != null) {
      final parentData = child.parentData as InfiniteGridParentData;
      final childOffset = parentData.initialPosition + _offset;
      if (_isVisible(childOffset)) {
        context.paintChild(child, childOffset + offset);
      }
      child = childAfter(child);
    }
  }

  bool _isVisible(Offset position) {
    return position.dx > -100 &&
        position.dx < size.width + 100 &&
        position.dy > -100 &&
        position.dy < size.height + 100;
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    RenderBox? child = lastChild;
    while (child != null) {
      final parentData = child.parentData as InfiniteGridParentData;
      final childOffset = parentData.initialPosition + _offset;
      final isHit = result.addWithPaintOffset(
        offset: childOffset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          return child!.hitTest(result, position: transformed);
        },
      );
      if (isHit) return true;
      child = childBefore(child);
    }
    return false;
  }
}

class InfiniteGridWidget extends StatefulWidget {
  final List<GridCard> cards;

  InfiniteGridWidget({required this.cards});

  @override
  _InfiniteGridWidgetState createState() => _InfiniteGridWidgetState();
}

class _InfiniteGridWidgetState extends State<InfiniteGridWidget> {
  Offset _offset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _offset += details.delta;
        });
      },
      child: InfiniteGridWithCards(
        offset: _offset,
        cards: widget.cards,
      ),
    );
  }
}
