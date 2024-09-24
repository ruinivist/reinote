import 'package:flutter/material.dart';
import 'package:local_tl_app/controllers/position_controller.dart';

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
    return SizedBox(
      width: PositionController.to.noteSize.width,
      height: PositionController.to.noteSize.height,
      child: GestureDetector(
        onTap: () {},
        child: Card(
          margin: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.note.title),
              Text(widget.note.description),
            ],
          ),
        ),
      ),
    );
  }
}
