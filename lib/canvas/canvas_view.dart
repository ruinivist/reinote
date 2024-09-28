import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:local_tl_app/canvas/canvas_background.dart';
import 'package:local_tl_app/controllers/position_controller.dart';

/// no magic deps except what you pass
class CanvasView extends StatefulWidget {
  final Function(Offset) onOffsetChange;
  final List<Position> positions;
  final List<Widget> children;
  final CanvasBackground canvasBackground;

  const CanvasView({
    required this.children,
    required this.positions,
    required this.onOffsetChange,
    this.canvasBackground = const DotGridBackround(),
    super.key,
  });

  @override
  State<CanvasView> createState() => _CanvasViewState();
}

class _CanvasViewState extends State<CanvasView> with SingleTickerProviderStateMixin {
  Offset _offset = Offset.zero;

  void _handlePanUpdate(DragUpdateDetails details) {
    setState(() {
      _offset += details.delta;
      // TODO: i think this causes a 2x render bug
      widget.onOffsetChange(_offset);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.canvasBackground.baseColor,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanUpdate: _handlePanUpdate,
        child: _CanvasRenderObject(
          offset: _offset,
          positions: widget.positions,
          canvasBackground: widget.canvasBackground,
          children: widget.children,
        ),
      ),
    );
  }
}

class _CanvasRenderObject extends MultiChildRenderObjectWidget {
  final Offset offset;

  final List<Position> positions;
  final CanvasBackground canvasBackground;

  const _CanvasRenderObject({
    required this.offset,
    required this.positions,
    required super.children,
    required this.canvasBackground,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _CanvasRenderBox(offset: offset, positions: positions, canvasBackground: canvasBackground);
  }

  @override
  void updateRenderObject(BuildContext context, _CanvasRenderBox renderObject) {
    renderObject
      ..offset = offset
      ..positions = positions;
  }
}

class _CanvasParentData extends ContainerBoxParentData<RenderBox> {}

class _CanvasRenderBox extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _CanvasParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _CanvasParentData> {
  CanvasBackground canvasBackground;
  Offset _offset;
  List<Position> _positions;

  _CanvasRenderBox({required positions, required offset, required this.canvasBackground})
      : _offset = offset,
        _positions = positions;

  set offset(Offset value) {
    if (_offset == value) return;
    _offset = value;
    markNeedsPaint();
  }

  set positions(List<Position> value) {
    if (_positions == value) return;
    _positions = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _CanvasParentData) {
      child.parentData = _CanvasParentData();
    }
  }

  @override
  void performLayout() {
    size = constraints.biggest;

    RenderBox? child = firstChild;
    while (child != null) {
      final _CanvasParentData childParentData = child.parentData! as _CanvasParentData;
      child.layout(constraints.loosen(), parentUsesSize: false); // TODO: parentUsesSize should be false, but idk
      child = childParentData.nextSibling;
    }
  }

  @override
  void paint(PaintingContext context, Offset canvasStartOffset) {
    final canvas = context.canvas;

    canvasBackground.paint(canvas, _offset, size);

    RenderBox? child = firstChild;
    for (int idx = 0; child != null; idx++) {
      final _CanvasParentData childParentData = child.parentData! as _CanvasParentData;
      context.paintChild(child, _offset + _positions[idx].toOffset());
      child = childParentData.nextSibling;
    }
  }

  // do i need to override hitTest? yes I do
  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    bool hitChild = false;
    RenderBox? child = lastChild;
    for (int i = childCount - 1; i >= 0; i--) {
      if (child != null) {
        final _CanvasParentData childParentData = child.parentData! as _CanvasParentData;
        final childPosition = position - _offset - _positions[i].toOffset();
        if (child.size.contains(childPosition)) {
          final isHit = result.addWithPaintOffset(
            offset: _offset + _positions[i].toOffset(),
            position: position,
            hitTest: (BoxHitTestResult result, Offset transformed) {
              return child!.hitTest(result, position: transformed);
            },
          );
          if (isHit) {
            hitChild = true;
            break;
          }
        }
        child = childParentData.previousSibling;
      }
    }

    return hitChild;
  }
}
