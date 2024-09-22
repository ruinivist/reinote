import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:local_tl_app/markdown/editor_view.dart';
import 'package:markdown/markdown.dart' as md;

import 'editor_controller.dart';

class SplitPaneEditor extends StatefulWidget {
  const SplitPaneEditor({super.key});

  @override
  _SplitPaneEditorState createState() => _SplitPaneEditorState();
}

class _SplitPaneEditorState extends State<SplitPaneEditor> {
  // This variable controls the height ratio between the two panes.
  double splitRatio = 0.5; // Initially equal height for both panes.

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditorController());

    return Column(
      children: [
        Expanded(
          flex: (splitRatio * 100).toInt(), // Top pane gets a fraction of the space
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              maxLines: null,
              minLines: 4,
              keyboardType: TextInputType.multiline,
              onChanged: controller.updateText,
              decoration: InputDecoration(
                hintText: 'Enter your markdown here',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
        // Draggable Slider
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onPanUpdate: (details) {
            setState(() {
              splitRatio += details.delta.dy / context.size!.height;
              splitRatio = splitRatio.clamp(0.1, 0.9); // Limits the split ratio between 10% and 90%
            });
          },
          child: Container(
            height: 10,
            color: Colors.grey,
            alignment: Alignment.center,
            child: Icon(Icons.drag_handle),
          ),
        ),
        Expanded(
          flex: ((1 - splitRatio) * 100).toInt(), // Bottom pane gets the remaining space
          child: EditorView(controller: controller),
        ),
      ],
    );
  }
}
