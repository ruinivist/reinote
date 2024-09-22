import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:local_tl_app/canvas/canvas_background.dart';
import 'package:local_tl_app/note/note_model.dart';
import 'package:local_tl_app/note/note_widget.dart';

class CanvasView extends StatefulWidget {
  final CanvasBackground canvasBackground;
  final Note rootNote;

  const CanvasView({
    required this.rootNote,
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
          rootNote: widget.rootNote,
          canvasBackground: widget.canvasBackground,
        ),
      ),
    );
  }
}

class _CanvasRenderObject extends MultiChildRenderObjectWidget {
  final Offset offset;
  final Note rootNote;
  final CanvasBackground canvasBackground;

  _CanvasRenderObject({
    required this.offset,
    required this.rootNote,
    required this.canvasBackground,
    super.key,
  }) : super(children: _buildNoteWidgets(rootNote));

  static List<Widget> _buildNoteWidgets(Note note) {
    List<Widget> widgets = [];
    NoteBase currentNote = note;
    while (currentNote is Note) {
      widgets.add(NoteWidget(note: currentNote));
      currentNote = currentNote.next;
    }
    return widgets;
  }

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _CanvasRenderBox(offset: offset, rootNote: rootNote, canvasBackground: canvasBackground);
  }

  @override
  void updateRenderObject(BuildContext context, _CanvasRenderBox renderObject) {
    renderObject
      ..offset = offset
      ..rootNote = rootNote;
  }
}

class _CanvasParentData extends ContainerBoxParentData<RenderBox> {}

class _CanvasRenderBox extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _CanvasParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _CanvasParentData> {
  CanvasBackground canvasBackground;
  Offset _offset;
  Note _rootNote;

  _CanvasRenderBox({required Offset offset, required Note rootNote, required this.canvasBackground})
      : _offset = offset,
        _rootNote = rootNote;

  set offset(Offset value) {
    if (_offset == value) return;
    _offset = value;
    markNeedsPaint();
  }

  set rootNote(Note value) {
    if (_rootNote == value) return;
    _rootNote = value;
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
    Offset childOffset = Offset(size.width / 2, size.height / 2);
    while (child != null) {
      final _CanvasParentData childParentData = child.parentData! as _CanvasParentData;
      child.layout(constraints.loosen(), parentUsesSize: true);
      childParentData.offset = childOffset;
      childOffset += Offset(0, child.size.height + 10); // Add some vertical spacing between notes
      child = childParentData.nextSibling;
    }
  }

  @override
  void paint(PaintingContext context, Offset canvasStartOffset) {
    final canvas = context.canvas;
    canvas.translate(canvasStartOffset.dx, canvasStartOffset.dy);

    canvasBackground.paint(context, _offset, size);

    RenderBox? child = firstChild;
    int childC = 0;
    while (child != null) {
      final _CanvasParentData childParentData = child.parentData! as _CanvasParentData;
      context.paintChild(child, _offset + childParentData.offset);
      child = childParentData.nextSibling;
      childC++;
      if (childC == 1) break;
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    RenderBox? child = lastChild;
    while (child != null) {
      final _CanvasParentData childParentData = child.parentData! as _CanvasParentData;
      if (child.hitTest(result, position: position - childParentData.offset)) {
        return true;
      }
      child = childParentData.previousSibling;
    }
    return false;
  }
}
