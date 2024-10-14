import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_tl_app/controllers/note_controller.dart';
import 'package:local_tl_app/controllers/position_controller.dart';
import 'package:local_tl_app/markdown/editor_view.dart';

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
    return GestureDetector(
      onTap: () {
        NoteController.to.selectedNoteId.value = widget.note.id;
      },
      child: Obx(() {
        bool active = NoteController.to.selectedNoteId.value == widget.note.id;
        return Container(
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
        );
      }),
    );
  }
}
