import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:local_tl_app/canvas/canvas_background.dart';
import 'package:local_tl_app/controllers/position_controller.dart';

/// no magic deps except what you pass
class CanvasView extends StatelessWidget {
  final Offset offset;
  final List<Position> positions;
  final List<Widget> children;
  final CanvasBackground canvasBackground;
  final double scale;
  final void Function(ScaleUpdateDetails details) handleScaleUpdate;
  final void Function(ScaleStartDetails details) handleScaleStart;

  const CanvasView({
    required this.children,
    required this.positions,
    required this.offset,
    required this.scale,
    required this.handleScaleUpdate,
    required this.handleScaleStart,
    this.canvasBackground = const DotGridBackround(),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: canvasBackground.baseColor,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onScaleUpdate: handleScaleUpdate,
        onScaleStart: handleScaleStart,
        child: _CanvasRenderObject(
          offset: offset,
          scale: scale,
          positions: positions,
          canvasBackground: canvasBackground,
          children: children,
        ),
      ),
    );
  }
}

class _CanvasRenderObject extends MultiChildRenderObjectWidget {
  final Offset offset;
  final double scale;

  final List<Position> positions;
  final CanvasBackground canvasBackground;

  const _CanvasRenderObject({
    required this.offset,
    required this.scale,
    required this.positions,
    required super.children,
    required this.canvasBackground,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _CanvasRenderBox(offset: offset, scale: scale, positions: positions, canvasBackground: canvasBackground);
  }

  @override
  void updateRenderObject(BuildContext context, _CanvasRenderBox renderObject) {
    renderObject
      ..offset = offset
      ..positions = positions
      ..scale = scale;
  }
}

class _CanvasParentData extends ContainerBoxParentData<RenderBox> {}

class _CanvasRenderBox extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _CanvasParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _CanvasParentData> {
  CanvasBackground canvasBackground;
  Offset _offset;
  double _scale;
  List<Position> _positions;

  _CanvasRenderBox({required positions, required offset, required scale, required this.canvasBackground})
      : _offset = offset,
        _positions = positions,
        _scale = scale;

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

  set scale(double value) {
    if (_scale == value) return;
    _scale = value;
    markNeedsPaint();
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

    canvasBackground.paint(canvas, _offset, _scale, size);

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
