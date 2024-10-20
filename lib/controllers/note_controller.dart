import 'package:get/get.dart';
import 'package:local_tl_app/controllers/position_controller.dart';

import '../note/note_model.dart';

enum Direction { up, down, left, right, none }

class NoteController extends GetxController {
  static NoteController get to => Get.find();

  Note? _end;
  Note? _root;
  bool get hasNotes => _root != null;

  void debugInitWithOneNote(Note note) {
    _root = note;
    PositionController.to.resetSource(note);
  }

  // void debugInitWithSeedNote() {
  //   _root = root;
  //   PositionController.to.resetSource(_root!, Position.zero);
  // }

  void addNote(Note note, {Direction? dir, Note? addTo}) {
    assert(dir != null && addTo != null || dir == null && addTo == null, "If dir is null, addTo must be null");

    if (_root == null) {
      _root = note;
      _end = _root;

      PositionController.to.resetAndMarkSelected(note);
      return;
    }

    bool baseChain = addTo == null;
    assert(_end != null, "_end cannot be null if root is not null");
    addTo ??= _end;

    Note end = addTo!;

    if (dir == Direction.up) {
      end.connectUp(note);
      note.connectDown(end);
    } else if (dir == Direction.down) {
      end.connectDown(note);
      note.connectUp(end);
    } else if (dir == Direction.left) {
      end.connectLeft(note);
      note.connectRight(end);
    } else if (dir == Direction.right) {
      end.connectRight(note);
      note.connectLeft(end);
    }

    if (baseChain) _end = note;

    PositionController.to.resetAndMarkSelected(note);
  }
}
