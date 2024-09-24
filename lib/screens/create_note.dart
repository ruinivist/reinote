import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/gestures.dart';
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
    controller = TextEditingController(text: "# a\n");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Live Markdown View'),
        Expanded(
          child: ExtendedTextField(
            controller: controller,
            maxLines: null,
            expands: true,
            style: TextStyle(color: Colors.black, fontSize: 16),
            cursorColor: Colors.red,
            specialTextSpanBuilder: MyReg(),
          ),
        )
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
      } else if (line.startsWith("* ")) {
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

/*
md features to support

#
##
###

* bullets

bold italics

*/

// class AtText extends SpecialText {
//   AtText(TextStyle? textStyle, SpecialTextGestureTapCallback? onTap, {this.showAtBackground = false, this.start})
//       : super(flag, ' ', textStyle, onTap: onTap);
//   static const String flag = '@';
//   final int? start;

//   /// whether show background for @somebody
//   final bool showAtBackground;

//   @override
//   InlineSpan finishText() {
//     final TextStyle? textStyle = this.textStyle?.copyWith(color: Colors.blue, fontSize: 16.0);

//     final String atText = toString();

//     return showAtBackground
//         ? BackgroundTextSpan(
//             background: Paint()..color = Colors.blue.withOpacity(0.15),
//             text: atText,
//             actualText: atText,
//             start: start!,

//             ///caret can move into special text
//             deleteAll: true,
//             style: textStyle,
//             recognizer: (TapGestureRecognizer()
//               ..onTap = () {
//                 if (onTap != null) {
//                   onTap!(atText);
//                 }
//               }))
//         : SpecialTextSpan(
//             text: atText,
//             actualText: atText,
//             start: start!,
//             style: textStyle,
//             recognizer: (TapGestureRecognizer()
//               ..onTap = () {
//                 if (onTap != null) {#
//                   onTap!(atText);
//                 }
//               }));
//   }
// }

class MySpecialTextSpanBuilder extends SpecialTextSpanBuilder {
  MySpecialTextSpanBuilder();

  @override
  SpecialText? createSpecialText(String flag,
      {TextStyle? textStyle, SpecialTextGestureTapCallback? onTap, int? index}) {
    ///index is end index of start flag, so text start index should be index-(flag.length-1)|

    if (isStart(flag, TwoHash.flag)) {
      return TwoHash();
    }
    if (isStart(flag, OneHash.flag)) {
      return OneHash();
    }

    if (isStart(flag, ThreeHash.flag)) {
      return ThreeHash();
    }
    if (isStart(flag, Bullets.flag)) {
      return Bullets();
    }

    return null;
  }
}

class OneHash extends SpecialText {
  static const String flag = '# ';
  OneHash() : super(flag, '\n', MdConfig.h1);

  @override
  InlineSpan finishText() {
    return SpecialTextSpan(text: toString().substring(2), actualText: toString(), style: textStyle);
  }
}

class TwoHash extends SpecialText {
  static const String flag = '## ';
  TwoHash() : super(flag, '\n', MdConfig.h2);

  @override
  InlineSpan finishText() {
    return SpecialTextSpan(text: toString().substring(3), actualText: toString(), style: textStyle);
  }
}

class ThreeHash extends SpecialText {
  static const String flag = '### ';
  ThreeHash() : super(flag, ' ', MdConfig.h3);

  @override
  InlineSpan finishText() {
    return SpecialTextSpan(text: toString().substring(4), actualText: toString(), style: textStyle);
  }
}

class Bullets extends SpecialText {
  static const String flag = '- ';
  Bullets() : super(flag, '\n', MdConfig.bullet);

  @override
  InlineSpan finishText() {
    return SpecialTextSpan(text: toString(), actualText: toString(), style: textStyle);
  }
}

class MdConfig {
  static const TextStyle h1 = const TextStyle(color: Colors.red, fontSize: 24);
  static const TextStyle h2 = const TextStyle(color: Colors.red, fontSize: 20);
  static const TextStyle h3 = const TextStyle(color: Colors.red, fontSize: 16);
  static const TextStyle bullet = const TextStyle(color: Colors.blue, fontSize: 16);
}

class MyReg extends RegExpSpecialTextSpanBuilder {
  @override
  List<RegExpSpecialText> get regExps => [H1()];
}

class H1 extends RegExpSpecialText {
  @override
  RegExp get regExp => RegExp(r'^# .*$', multiLine: true);

  @override
  InlineSpan finishText(
    int start,
    Match match, {
    TextStyle? textStyle,
    SpecialTextGestureTapCallback? onTap,
  }) {
    lg.i('H1 finishText');
    return SpecialTextSpan(
      text: match[0]!,
      actualText: match[0]!,
      start: start,
      style: MdConfig.h1,
      recognizer: (TapGestureRecognizer()
        ..onTap = () {
          if (onTap != null) {
            onTap(match[0]!);
          }
        }),
    );
  }
}

// todo: for me, this regex way is best. this way I can do images and also code with a custom widget