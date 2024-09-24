import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_tl_app/markdown/split_pane_editor.dart';

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
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Live Markdown View'),
        CustomEditableText(),
        // Expanded(
        //   child: SizedBox(
        //     height: 300,
        //     width: 300,
        //     child: EditableText(
        //       controller: controller,
        //       focusNode: FocusNode(),
        //       style: Get.textTheme.displayLarge!,
        //       cursorColor: Colors.red,
        //       backgroundCursorColor: Colors.orange,
        //       maxLines: null,
        //       expands: true,
        //     ),
        //   ),
        // )
      ],
    );
  }
}

class CustomEditableText extends EditableText {
  CustomEditableText()
      : super(
          focusNode: FocusNode(),
          controller: TextEditingController(text: "something\n# something else"),
          style: TextStyle(color: Colors.black, fontSize: 16),
          cursorColor: Colors.red,
          backgroundCursorColor: Colors.orange,
          maxLines: null,
          expands: true,
        );

  @override
  CustomEditableTextState createState() => new CustomEditableTextState();
}

class CustomEditableTextState extends EditableTextState {
  @override
  CustomEditableText get widget => super.widget as CustomEditableText;

  @override
  TextSpan buildTextSpan() {
    final String text = textEditingValue.text;

    // split on /n
    final lines = text.split('\n');
    lg.i(lines);

    final List<TextSpan> children = <TextSpan>[];
    for (final line in lines) {
      if (line.startsWith("# ")) {
        children.add(TextSpan(
          text: line,
          style: TextStyle(color: Colors.red, fontSize: 24),
        ));
      } else if (line.startsWith("## ")) {
        children.add(TextSpan(
          text: line,
          style: TextStyle(color: Colors.blue, fontSize: 20),
        ));
      } else {
        children.add(TextSpan(
          text: line,
          style: TextStyle(color: Colors.black, fontSize: 16),
        ));
      }

      children.add(TextSpan(text: '\n'));
    }

    return TextSpan(style: TextStyle(color: Colors.black, fontSize: 16), children: children);
  }
}
