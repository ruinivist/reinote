import 'package:flutter/material.dart';

import 'note_model.dart';

class NoteWidget extends StatefulWidget {
  final Note note;
  const NoteWidget({required this.note, super.key});

  @override
  State<NoteWidget> createState() => _NoteWidgetState();
}

class _NoteWidgetState extends State<NoteWidget> {
  bool big = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("tapped");
        setState(() {
          big = !big;
        });
      },
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.note.title),
            Text(widget.note.description),
            if (big && widget.note.next is Note) NoteWidget(note: widget.note.next as Note),
          ],
        ),
      ),
    );
  }
}
