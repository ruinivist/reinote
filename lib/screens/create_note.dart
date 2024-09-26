import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_tl_app/markdown/split_pane_editor.dart';
import 'package:local_tl_app/note/note_utils.dart';
import 'package:local_tl_app/widgets/editor/inline_preview_editor/inline_preview_editor.dart';

import '../markdown/editor_controller.dart';
import '../utils/log.dart';

class CreateNote extends StatefulWidget {
  const CreateNote({super.key});

  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: LiveMdView());
  }
}

class LiveMdView extends StatefulWidget {
  const LiveMdView({super.key});

  @override
  State<LiveMdView> createState() => _LiveMdViewState();
}

class _LiveMdViewState extends State<LiveMdView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(EditorController());
    return Column(
      children: [
        Text('Live Markdown View'),
        Expanded(child: InlinePreviewEditor()),
        TextButton(
            onPressed: () {
              final x = NoteUtils.parseNoteProperties(EditorController.to.textEditingController.text);
              lg.d(x);
            },
            child: Text("f1")),
      ],
    );
  }
}
