import 'package:flutter/material.dart';
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
      onTap: () => lg.i("NoteWidget tapped"),
      child: SizedBox(
        width: 400,
        height: 300,
        child: Card(
          margin: EdgeInsets.zero,
          child: SizedBox(
            width: 400,
            height: 400,
            child: EditorView(text: widget.note.content),
          ),
        ),
      ),
    );
  }
}
