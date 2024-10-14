import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_tl_app/controllers/position_controller.dart';
import 'package:local_tl_app/note/note_properties.dart';

import '../note/note_data.dart';
import '../note/note_model.dart';

class NoteController extends GetxController {
  static NoteController get to => Get.find();

  final selectedNoteId = (-1).obs;

  Note? _root;
  bool get hasNotes => _root != null;

  void debugInitWithOneNote(Note note) {
    _root = note;
    PositionController.to.resetSource(note, Position.zero);
  }

  void debugInitWithSeedNote() {
    _root = root;
    PositionController.to.resetSource(_root!, Position.zero);
  }
}
