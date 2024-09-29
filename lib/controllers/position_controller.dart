import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_tl_app/note/note_model.dart';
import 'package:local_tl_app/note/note_widget.dart';

import '../utils/log.dart';

class Position {
  final double x;
  final double y;

  const Position(this.x, this.y);
  Position.fromOffset(Offset offset)
      : x = offset.dx,
        y = offset.dy;

  static const zero = Position(0, 0);

  Position operator +(Position other) {
    return Position(x + other.x, y + other.y);
  }

  Position operator -(Position other) {
    return Position(x - other.x, y - other.y);
  }

  double distanceSquared(Position other) {
    double dx = x - other.x;
    double dy = y - other.y;
    return (dx * dx + dy * dy);
  }

  Offset toOffset() {
    return Offset(x, y);
  }

  @override
  toString() {
    return '($x, $y)';
  }
}

// todo: this probably does not need to extend this
// assumes the source at (0,0) and then calculates the position of everything else
/// just initialise it correctly with sources and set offset
/// rest will fall into place
class PositionController extends GetxController {
  static PositionController get to => Get.find();

  Offset _offset = Offset.zero;
  Offset get offset => _offset;
  double _scale = 1.0;
  double get scale => _scale;

  Offset? _lastFocalPoint;

  void handleScaleStart(ScaleStartDetails details) {
    _lastFocalPoint = details.localFocalPoint;
  }

  /// name is a bit misleading but this is what flutter uses and
  /// this is a superset of pan so handles both pan and scale
  void handleScaleUpdate(ScaleUpdateDetails details) {
    // dampended new scale
    // double dampeningFactor = 0.1;
    // double scaleDelta = (details.scale - 1) * dampeningFactor;
    // double newScale = _scale * (1 + scaleDelta);
    // newScale = newScale.clamp(0.1, 10.0);
    final newScale = (_scale * details.scale).clamp(0.4, 4.0);

    // focal point in the coordinate system of the grid
    Offset focalPoint = details.localFocalPoint;
    Offset gridFocalPoint = (focalPoint - _offset) / _scale;

    // new scale set
    _scale = newScale;

    // adjust offset to keep the focal point stationary
    _offset = focalPoint - gridFocalPoint * _scale;

    // panning
    if (_lastFocalPoint != null) {
      _offset += details.localFocalPoint - _lastFocalPoint!;
    }
    _lastFocalPoint = details.focalPoint;

    _setNewSource();
    _buildPositions();
  }

  NoteBase _sourceNote;
  Position _sourcePosition; // at (0,0) offset whats gonna be the source position

  final noteSize = const Size(400, 300);
  final padding = 20.0;
  final Size screen;

  PositionController({required NoteBase sourceNote, required Position sourcePosition, required this.screen})
      : _sourcePosition = sourcePosition,
        _sourceNote = sourceNote {
    _buildPositions();
  }

  final _positions = <Position>[].obs;
  final _notes = <Note>[].obs;

  void _buildPositions() {
    if (_sourceNote is NoNote) {
      _positions.clear();
      _notes.clear();
      return;
    }

    List<Position> positions = [];
    List<Note> notes = [];

    List<(Note, Position)> stack = [(_sourceNote as Note, _sourcePosition)];
    Set<Note> visited = {};

    while (stack.isNotEmpty) {
      final current = stack.removeLast();

      final (curNote, curPos) = current;
      visited.add(curNote);

      notes.add(curNote);
      positions.add(curPos);

      // stop if note is out of bounds
      const extra = Offset(400, 400);
      final onScreen = curPos.toOffset();
      Offset topLeft = offset - extra;
      Offset bottomRight = offset + Offset(screen.width, screen.height) + extra;
      //if this point in the rect
      if (onScreen.dx < topLeft.dx ||
          onScreen.dx > bottomRight.dx ||
          onScreen.dy < topLeft.dy ||
          onScreen.dy > bottomRight.dy) {
        continue;
      }

      // up
      if (curNote.hasUp && !visited.contains(curNote.up)) {
        stack.add((curNote.up as Note, curPos - Position(0, noteSize.height + padding)));
      }

      // down
      if (curNote.hasDown && !visited.contains(curNote.down)) {
        stack.add((curNote.down as Note, curPos + Position(0, noteSize.height + padding)));
      }

      // left
      if (curNote.hasLeft && !visited.contains(curNote.left)) {
        stack.add((curNote.left as Note, curPos - Position(noteSize.width + padding, 0)));
      }

      // right
      if (curNote.hasRight && !visited.contains(curNote.right)) {
        stack.add((curNote.right as Note, curPos + Position(noteSize.width + padding, 0)));
      }
    }

    _positions.value = positions;
    _notes.value = notes;
  }

  List<Position> get positions => _positions;
  List<Note> get notes => _notes;
  List<Widget> get children => _notes
      .map<Widget>((note) => Transform.scale(
            alignment: Alignment.topLeft,
            scale: _scale,
            child: NoteWidget(
              note: note,
              key: Key(note.title),
            ),
          ))
      .toList();

  Offset get center => offset + Offset(Get.width / 2, Get.height / 2);

  void _setNewSource() {
    if (_sourceNote is NoNote) return;
    // even when the offset changes the positions which are in ref to the (0,0)
    // will remain the same

    // find the index of the note which is closest to the center (euclidean distance)
    assert(_positions.isNotEmpty);

    final mid = Position.fromOffset(center);
    double minDist = double.infinity;
    int minIndex = 0;

    for (int i = 0; i < _positions.length; i++) {
      final dist = mid.distanceSquared(_positions[i]);
      if (dist < minDist) {
        minDist = dist;
        minIndex = i;
      }
    }

    _sourceNote = _notes[minIndex];
    _sourcePosition = _positions[minIndex];
  }

  /// restart afresh with new source
  void resetSource(Note sourceNote, Position sourcePosition, {Offset? offset}) {
    _sourceNote = sourceNote;
    _sourcePosition = sourcePosition;
    if (offset != null) {
      _offset = offset;
    }
    _buildPositions();
  }
}
