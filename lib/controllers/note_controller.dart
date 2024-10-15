import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_tl_app/controllers/position_controller.dart';
import 'package:local_tl_app/note/note_properties.dart';

import '../note/note_model.dart';
import '../utils/log.dart';

enum Direction { up, down, left, right }

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

  void addNote(Note note, Direction dir, {Note? addTo}) {
    if (_root == null) {
      _root = note;
      _end = _root;

      PositionController.to.resetSource(note);
      return;
    }

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

    _end = note;
  }
}
