import 'package:flutter/material.dart';

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
      width: 120,
      height: 80,
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
