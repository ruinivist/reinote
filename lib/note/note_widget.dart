import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_tl_app/controllers/height_estimator.dart';
import 'package:local_tl_app/controllers/position_controller.dart';
import 'package:local_tl_app/markdown/editor_view.dart';
import 'package:local_tl_app/screens/create_note.dart';

import '../controllers/note_controller.dart';
import 'note_model.dart';

class NoteWidget extends StatelessWidget {
  final Note note;
  const NoteWidget({required this.note, super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool active = PositionController.to.selectedNoteId.value == note.id;
      return GestureDetector(
        onTap: () {
          PositionController.to.selectedNoteId.value = active ? "" : note.id;
        },
        onDoubleTap: () {
          // edit mode
          Get.to(CreateNote(
            note: note,
          ));
        },
        onHorizontalDragEnd: active
            ? (details) {
                if (details.primaryVelocity! < 0) {
                  // swipe left, add to right
                  Get.to(CreateNote(
                    note: note,
                    direction: Direction.right,
                  ));
                }
                if (details.primaryVelocity! > 0) {
                  // swipe right, add to left
                  Get.to(CreateNote(
                    note: note,
                    direction: Direction.left,
                  ));
                }
              }
            : null,
        onVerticalDragEnd: active
            ? (details) {
                if (details.primaryVelocity! > 0) {
                  // swipe down, add to top
                  Get.to(CreateNote(
                    note: note,
                    direction: Direction.up,
                  ));
                }
                if (details.primaryVelocity! < 0) {
                  // swipe up, add to bottom
                  Get.to(CreateNote(
                    note: note,
                    direction: Direction.down,
                  ));
                }
              }
            : null,
        child: Obx(() {
          return Container(
            width: 400,
            height: MarkdownHeightEstimatorController.to.estimateMarkdownHeight(note.content),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: active ? Get.theme.colorScheme.primary : Get.theme.colorScheme.primaryContainer,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.zero,
            child: EditorView(text: note.content, isScrollable: active),
          );
        }),
      );
    });
  }
}
