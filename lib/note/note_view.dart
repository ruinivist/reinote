import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:local_tl_app/widgets/editor/md_config.dart';

class NoteView extends StatefulWidget {
  final String text;
  const NoteView({required this.text, super.key});

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Markdown(
        data: widget.text,
        selectable: true,
        styleSheet: MdConfig.to.styleSheet,
      ),
    );
  }
}
