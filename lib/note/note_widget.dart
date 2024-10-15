import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_tl_app/controllers/position_controller.dart';
import 'package:local_tl_app/markdown/editor_view.dart';
import 'package:local_tl_app/screens/create_note.dart';

import '../controllers/note_controller.dart';
import '../utils/log.dart';
import 'note_model.dart';

class NoteWidget extends StatefulWidget {
  final Note note;
  const NoteWidget({required this.note, super.key});

  @override
  State<NoteWidget> createState() => _NoteWidgetState();
}

class _NoteWidgetState extends State<NoteWidget> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool active = PositionController.to.selectedNoteId.value == widget.note.id;
      return GestureDetector(
        onTap: () {
          PositionController.to.selectedNoteId.value = active ? -1 : widget.note.id;
        },
        onHorizontalDragEnd: active
            ? (details) {
                if (details.primaryVelocity! < 0) {
                  // swipe left, add to right
                  Get.to(CreateNote(
                    note: widget.note,
                    direction: Direction.right,
                  ));
                }
              }
            : null,
        child: Container(
          width: 400,
          height: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: active ? Get.theme.colorScheme.primary : Get.theme.colorScheme.primaryContainer,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.zero,
          child: EditorView(text: widget.note.content, isScrollable: active),
        ),
      );
    });
  }
}
