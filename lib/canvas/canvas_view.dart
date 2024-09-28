import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:local_tl_app/canvas/canvas_background.dart';
import 'package:local_tl_app/controllers/position_controller.dart';
import 'package:local_tl_app/note/note_model.dart';
import 'package:local_tl_app/note/note_widget.dart';

import '../note/note_data.dart';
import '../utils/log.dart';

class CanvasView extends StatefulWidget {
  final CanvasBackground canvasBackground;

  const CanvasView({
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
      PositionController.to.offset.value = -_offset;
    });
  }

  late Note dfsSource;
  late Point dfsSourcePos;

  // List<Widget> childrenToDraw() {
  //   // i have the offset and I have the root
  //   // assumptio: wrong but for now. dfs starts at root ending when a node is reached
  //   // that is not visible'
  //   List<Widget> widgets = [];

  //   // lg.i('offset ${_offset}');
  //   // lg.i('screen size ${MediaQuery.of(context).size}');

  //   List<Pair<Note, Point>> stack = [Pair(dfsSource, dfsSourcePos)];
  //   Set<Note> visited = {};

  //   // lg.i('starting at ${dfsSource.title} ${dfsSourcePos.x} ${dfsSourcePos.y}');

  //   while (stack.isNotEmpty) {
  //     final current = stack.removeLast();

  //     widgets.add(NoteWidget(note: current.a));
  //     visited.add(current.a);

  //     // lg.i(_offset);
  //     // if this one won't be visible, don't add its children
  //     final pos = current.b;
  //     if (!(pos.x > _offset.dx - 500 &&
  //         pos.x < _offset.dx + MediaQuery.of(context).size.width + 500 &&
  //         pos.y > -_offset.dy - 500 &&
  //         pos.y < -_offset.dy + MediaQuery.of(context).size.height + 500)) {
  //       // lg.i('not visible ${pos.x} ${pos.y}');
  //       continue;
  //     }

  //     // for (final next in current.a.validNeighbors) {
  //     //   if (!visited.contains(next)) {
  //     //     stack.add(next);
  //     //   }
  //     // }

  //     // only down for now
  //     //

  //     dfsSource = current.a;
  //     dfsSourcePos = current.b;

  //     // lg.i('current ${current.a.title} ${current.b.x} ${current.b.y}');

  //     double noteHeight = 100;
  //     if (current.a.hasDown && !visited.contains(current.a.down)) {
  //       stack.add(Pair(current.a.down as Note, Point(current.b.x, current.b.y + noteHeight)));
  //     }
  //     if (current.a.hasUp && !visited.contains(current.a.up)) {
  //       stack.add(Pair(current.a.up as Note, Point(current.b.x, current.b.y - noteHeight)));
  //     }
  //   }

  //   return widgets;
  // }

  @override
  void initState() {
    super.initState();
    dfsSource = root;
    dfsSourcePos = Point(Get.size.width / 2, Get.size.height / 2);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: widget.canvasBackground.baseColor,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onPanUpdate: _handlePanUpdate,
            child: _CanvasRenderObject(
              offset: _offset,
              positions: PositionController.to.positions,
              canvasBackground: widget.canvasBackground,
              childr: PositionController.to.children,
            ),
          ),
        ),
        Positioned(
          child: IconButton(icon: Icon(Icons.add), onPressed: () {}),
          top: 10,
          left: 10,
        ),
      ],
    );
  }
}

class _CanvasRenderObject extends MultiChildRenderObjectWidget {
  final Offset offset;

  List<Position> positions;
  List<Widget> childr;
  final CanvasBackground canvasBackground;

  _CanvasRenderObject({
    required this.offset,
    required this.positions,
    required this.childr,
    required this.canvasBackground,
    super.key,
  }) : super(children: childr);

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
    // if (_positions == value) return;

    // lg.i("setting positions to $value");
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
      child.layout(constraints.loosen(), parentUsesSize: false);
      child = childParentData.nextSibling;
    }
  }

  @override
  void paint(PaintingContext context, Offset canvasStartOffset) {
    final canvas = context.canvas;
    // canvas.translate(canvasStartOffset.dx, canvasStartOffset.dy);

    canvasBackground.paint(canvas, _offset, size);

    // lg.i('paint ${_positions}');

    RenderBox? child = firstChild;
    int idx = 0;
    while (child != null) {
      final _CanvasParentData childParentData = child.parentData! as _CanvasParentData;
      context.paintChild(child, _offset + _positions[idx].toOffset());
      child = childParentData.nextSibling;
      idx++;
    }
  }

  // @override
  // bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
  //   RenderBox? child = lastChild;
  //   while (child != null) {
  //     final _CanvasParentData childParentData = child.parentData! as _CanvasParentData;
  //     if (child.hitTest(result, position: position - childParentData.offset)) {
  //       return true;
  //     }
  //     child = childParentData.previousSibling;
  //   }
  //   return false;
  // }
}
