import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_tl_app/note/note_model.dart';
import 'package:local_tl_app/note/note_widget.dart';

import '../utils/log.dart';

class Position {
  final double x;
  final double y;

  Position(this.x, this.y);
  Position.fromOffset(Offset offset)
      : x = offset.dx,
        y = offset.dy;

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
class PositionController extends GetxController {
  static PositionController get to => Get.find();

  Rx<Offset> offset = Offset.zero.obs;
  Note sourceNote;
  Position sourcePosition; // at (0,0) offset whats gonna be the source position

  final noteSize = const Size(120, 80);
  final Size screen;

  PositionController({required this.sourceNote, required this.sourcePosition, required this.screen}) {
    _buildPositions();
  }

  late List<Position> _positions;
  late List<Note> _notes;

  void _buildPositions() {
    // lg.i('building positions');
    _positions = [];
    _notes = [];

    List<(Note, Position)> stack = [(sourceNote, sourcePosition)];
    Set<Note> visited = {};

    while (stack.isNotEmpty) {
      final current = stack.removeLast();

      final (curNote, curPos) = current;
      visited.add(curNote);

      _notes.add(curNote);
      _positions.add(curPos);

      // stop if note is out of bounds
      final extra = Offset.zero;
      final onScreen = offset.value + curPos.toOffset();
      Offset topLeft = offset.value - extra;
      Offset bottomRight = offset.value + Offset(screen.width, screen.height) + extra;
      // lg.i('onScreen: $onScreen');
      // lg.i('topLeft: $topLeft');
      // lg.i('bottomRight: $bottomRight');
      //if this point in the rect
      if (onScreen.dx < topLeft.dx ||
          onScreen.dx > bottomRight.dx ||
          onScreen.dy < topLeft.dy ||
          onScreen.dy > bottomRight.dy) {
        continue;
      }

      // up
      if (curNote.hasUp && !visited.contains(curNote.up)) {
        stack.add((curNote.up as Note, curPos - Position(0, noteSize.height)));
      }

      // down
      if (curNote.hasDown && !visited.contains(curNote.down)) {
        stack.add((curNote.down as Note, curPos + Position(0, noteSize.height)));
      }

      // left
      if (curNote.hasLeft && !visited.contains(curNote.left)) {
        stack.add((curNote.left as Note, curPos - Position(noteSize.width, 0)));
      }

      // right
      if (curNote.hasRight && !visited.contains(curNote.right)) {
        stack.add((curNote.right as Note, curPos + Position(noteSize.width, 0)));
      }
    }

    // lg.i('Positions: $_positions');
  }

  List<Position> get positions => _positions;
  List<Note> get notes => _notes;
  List<Widget> get children => _notes
      .map<NoteWidget>((note) => NoteWidget(
            note: note,
            key: Key(note.title),
          ))
      .toList();

  late Worker onOffsetChange;

  Offset get center => offset.value + Offset(Get.width / 2, Get.height / 2);

  void _setNewSource() {
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

    sourceNote = _notes[minIndex];
    sourcePosition = _positions[minIndex];
  }

  @override
  void onInit() {
    super.onInit();

    onOffsetChange = ever(offset, (_) {
      // lg.i('Offset: $offset');
      // lg.i('Center: $center');
      _setNewSource();
      _buildPositions();
    });
  }
}
