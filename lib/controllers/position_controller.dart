import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_tl_app/controllers/height_estimator.dart';
import 'package:local_tl_app/controllers/note_controller.dart';
import 'package:local_tl_app/note/note_model.dart';
import 'package:local_tl_app/note/note_widget.dart';

import '../utils/log.dart';

// ss -> screenspace
// gs -> gridspace

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

  final selectedNoteId = (-1).obs;

  Offset _offset = Offset.zero;
  Offset get offset => _offset;
  double _scale = 1.0;
  double get scale => _scale;

  Offset? _lastFocalPoint;

  /// centers the active note & resets scale
  void focusActiveNote() {
    // active note must be in positions
    if (selectedNoteId.value == -1) return;
    final activeNoteIndex = notes.indexWhere((note) => note.id == selectedNoteId.value);
    if (activeNoteIndex == -1) return;

    final activeNotePos = positions[activeNoteIndex];

    _scale = 1;
    // 2c + 300 = h where c is the distance from screen space origin vertically
    // 2e + 400 = w same but horizontally
    final noteSize =
        Size(400, MarkdownHeightEstimatorController.to.estimateMarkdownHeight(notes[activeNoteIndex].content));
    Offset ssActiveNote = Offset((Get.width - noteSize.width) / 2, (Get.height - noteSize.height) / 2);
    _offset = ssActiveNote - activeNotePos.toOffset() * _scale;

    _lastFocalPoint = Offset(Get.width / 2, Get.height / 2);
    _setNewSource();
    _buildPositions();
  }

  void handleScaleStart(ScaleStartDetails details) {
    _lastFocalPoint = details.localFocalPoint;
  }

  /// name is a bit misleading but this is what flutter uses and
  /// this is a superset of pan so handles both pan and scale
  void handleScaleUpdate(ScaleUpdateDetails details) {
    // dampended new scale
    double dampeningFactor = 0.1;
    double scaleDelta = (details.scale - 1) * dampeningFactor;
    double newScale = _scale * (1 + scaleDelta);
    newScale = newScale.clamp(0.4, 4.0);

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

  void updateScaleCentered(double newScale) {
    final focalPoint = Offset(Get.width / 2, Get.height / 2); // ss center of screen
    Offset gridFocalPoint = (focalPoint - _offset) / _scale;
    _scale = newScale;
    _offset = focalPoint - gridFocalPoint * _scale;

    _lastFocalPoint = focalPoint;

    _setNewSource();
    _buildPositions();
  }

  void deltaUpdateScaleCentered(double delta) {
    updateScaleCentered((_scale + delta).clamp(0.4, 2.0));
  }

  NoteBase _sourceNote;
  Position _gsSourcePosition; // at (0,0) offset whats gonna be the source position
  final padding = 20.0;
  final Size screen;

  // sourcePosition in the gridspace
  // lets say when it all inits, the screenspace (0,0) is grid space (0,0)
  PositionController({required NoteBase sourceNote, required Position gsSourcePosition, required this.screen})
      : _gsSourcePosition = gsSourcePosition,
        _sourceNote = sourceNote {
    _buildPositions();
  }

  final _positions = <Position>[].obs;
  final _notes = <Note>[].obs;

  /// build the positons of the notes in gridspace
  void _buildPositions() {
    if (_sourceNote is NoNote) {
      _positions.clear();
      _notes.clear();
      return;
    }

    List<Position> positions = [];
    List<Note> notes = [];

    lg.i('source note: ${(_sourceNote as Note).id} source position: $_gsSourcePosition');

    List<(Note, Note, Position, Direction)> stack = [
      (_sourceNote as Note, _sourceNote as Note, _gsSourcePosition, Direction.none)
    ];
    Set<Note> visited = {};

    final Size screenSize = MediaQuery.of(Get.context!).size;

    while (stack.isNotEmpty) {
      final current = stack.removeLast();

      final (curNote, oldNote, curPos, dir) = current;
      visited.add(curNote);

      notes.add(curNote);
      final noteSize = Size(400, MarkdownHeightEstimatorController.to.estimateMarkdownHeight(curNote.content));
      final oldNoteSize = Size(400, MarkdownHeightEstimatorController.to.estimateMarkdownHeight(oldNote.content));

      if (dir == Direction.none) {
        positions.add(curPos);
      } else if (dir == Direction.up) {
        positions.add(curPos - Position(0, noteSize.height + padding));
      } else if (dir == Direction.down) {
        positions.add(curPos + Position(0, oldNoteSize.height + padding));
      } else if (dir == Direction.left) {
        positions.add(curPos - Position(noteSize.width + padding, 0));
      } else if (dir == Direction.right) {
        positions.add(curPos + Position(oldNoteSize.width + padding, 0));
      }

      final newCurPos = positions.last;

      // Convert grid space position to screen space
      lg.i('size ofr note ${curNote.id}: $noteSize');
      final ssNotePos = curPos.toOffset() * _scale + _offset;
      final scaledNoteSize = Size(noteSize.width * _scale, noteSize.height * _scale);

      // Create screen bounds rectangle with extra padding
      Rect screenBounds =
          Rect.fromLTWH(-screenSize.width, -screenSize.height, 2 * screenSize.width, 2 * screenSize.height);

      // Check if the note is visible on screen
      if (!screenBounds
          .overlaps(Rect.fromLTWH(ssNotePos.dx, ssNotePos.dy, scaledNoteSize.width, scaledNoteSize.height))) {
        continue;
      }

      if (curNote.hasUp && !visited.contains(curNote.up)) {
        stack.add((curNote.up as Note, curNote, newCurPos, Direction.up));
      }

      // down
      if (curNote.hasDown && !visited.contains(curNote.down)) {
        stack.add((curNote.down as Note, curNote, newCurPos, Direction.down));
      }

      // left
      if (curNote.hasLeft && !visited.contains(curNote.left)) {
        stack.add((curNote.left as Note, curNote, newCurPos, Direction.left));
      }

      // right
      if (curNote.hasRight && !visited.contains(curNote.right)) {
        stack.add((curNote.right as Note, curNote, newCurPos, Direction.right));
      }
    }

    _positions.value = positions;
    _notes.value = notes;

    lg.i('Positions: $_positions');
    lg.i('Notes: $_notes');
  }

  List<Position> get positions => _positions;
  List<Note> get notes => _notes;
  List<Widget> get children => _notes
      .map<Widget>((note) => Transform.scale(
            alignment: Alignment.topLeft,
            scale: _scale,
            child: NoteWidget(
              note: note,
              key: ValueKey<int>(note.id),
            ),
          ))
      .toList();

  Offset get gsCenterOfScreen => (Offset(Get.width / 2, Get.height / 2) - _offset) / scale;

  void _setNewSource() {
    // return;
    if (_sourceNote is NoNote) return;
    // even when the offset changes the positions which are in ref to the (0,0)
    // will remain the same

    // find the index of the note which is closest to the center (euclidean distance)
    assert(_positions.isNotEmpty);

    final mid = Position.fromOffset(gsCenterOfScreen);
    double minDist = double.infinity;
    int minIndex = 0;

    // note: taking distance from the center of the note, not the top left
    for (int i = 0; i < _positions.length; i++) {
      //positions i is not the same as notes i
      final noteSize = Size(400, MarkdownHeightEstimatorController.to.estimateMarkdownHeight(_notes[i].content));
      final dist = mid.distanceSquared(_positions[i]);
      if (dist < minDist) {
        minDist = dist;
        minIndex = i;
      }
    }

    _sourceNote = _notes[minIndex];
    _gsSourcePosition = _positions[minIndex];

    lg.i('New source: ${(_sourceNote as Note).id}');
    lg.i('New source position: $_gsSourcePosition');
  }

  /// restart afresh with new source
  /// the new source is the origin of the grid space now
  void resetSource(Note sourceNote) {
    _sourceNote = sourceNote;
    _gsSourcePosition = Position.zero;

    final noteSize = Size(400, MarkdownHeightEstimatorController.to.estimateMarkdownHeight(sourceNote.content));
    Offset newSourceOffset =
        Offset((Get.width - noteSize.width * _scale) / 2, (Get.height - noteSize.height * _scale) / 2);
    _offset = newSourceOffset;

    _lastFocalPoint = Offset(Get.width / 2, Get.height / 2);
    _buildPositions();
  }
}
