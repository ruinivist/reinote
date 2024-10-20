import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:local_tl_app/markdown/editor_controller.dart';

import '../md_config.dart';

/// this widget expands so sizes must be set by parent
/// this must be rendered within context of an EditorController
class InlinePreviewEditor extends StatelessWidget {
  const InlinePreviewEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return ExtendedTextField(
      controller: EditorController.to.textEditingController,
      scrollController: EditorController.to.scrollController,
      maxLines: null,
      expands: true,
      cursorColor: Colors.red,
      style: MdConfig.to.body,
      specialTextSpanBuilder: MdTextSpandBuilder(),
    );
  }
}

class MdTextSpandBuilder extends RegExpSpecialTextSpanBuilder {
  @override
  List<RegExpSpecialText> get regExps => [
        H3(),
        H2(),
        H1(),
        Bold(),
        Italics(),
        HorizontalRule(),
        OrderedListItem(),
        UnorderedListItem(),
        Image(),
        Link(),
      ];
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
    return SpecialTextSpan(
      text: (match[0]!).substring(2),
      actualText: match[0]!,
      start: start,
      style: MdConfig.to.h1,
      deleteAll: false,
    );
  }
}

class H2 extends RegExpSpecialText {
  @override
  RegExp get regExp => RegExp(r'^## .*$', multiLine: true);

  @override
  InlineSpan finishText(
    int start,
    Match match, {
    TextStyle? textStyle,
    SpecialTextGestureTapCallback? onTap,
  }) {
    return SpecialTextSpan(
      text: (match[0]!).substring(3),
      actualText: match[0]!,
      start: start,
      style: MdConfig.to.h2,
      deleteAll: false,
    );
  }
}

class H3 extends RegExpSpecialText {
  @override
  RegExp get regExp => RegExp(r'^### .*$', multiLine: true);

  @override
  InlineSpan finishText(
    int start,
    Match match, {
    TextStyle? textStyle,
    SpecialTextGestureTapCallback? onTap,
  }) {
    return SpecialTextSpan(
      text: (match[0]!).substring(4),
      actualText: match[0]!,
      start: start,
      style: MdConfig.to.h3,
      deleteAll: false,
    );
  }
}

class Bold extends RegExpSpecialText {
  @override
  RegExp get regExp => RegExp(r'\*\*.*\*\*');

  @override
  InlineSpan finishText(
    int start,
    Match match, {
    TextStyle? textStyle,
    SpecialTextGestureTapCallback? onTap,
  }) {
    return SpecialTextSpan(
      text: (match[0]!).substring(2, match[0]!.length - 2),
      actualText: match[0]!,
      start: start,
      style: textStyle!.copyWith(fontWeight: FontWeight.bold),
      deleteAll: false,
    );
  }
}

class Italics extends RegExpSpecialText {
  @override
  RegExp get regExp => RegExp(r'\*.*\*');

  @override
  InlineSpan finishText(
    int start,
    Match match, {
    TextStyle? textStyle,
    SpecialTextGestureTapCallback? onTap,
  }) {
    return SpecialTextSpan(
      text: (match[0]!).substring(1, match[0]!.length - 1),
      actualText: match[0]!,
      start: start,
      style: textStyle!.copyWith(fontStyle: FontStyle.italic),
      deleteAll: false,
    );
  }
}

class HorizontalRule extends RegExpSpecialText {
  @override
  RegExp get regExp => RegExp(r'^---$', multiLine: true);

  @override
  InlineSpan finishText(
    int start,
    Match match, {
    TextStyle? textStyle,
    SpecialTextGestureTapCallback? onTap,
  }) {
    return SpecialTextSpan(
      actualText: match[0]!,
      text: match[0]!,
      start: start,
      style: textStyle!.copyWith(color: Colors.grey),
      deleteAll: false,
    );
  }
}

class OrderedListItem extends RegExpSpecialText {
  @override
  RegExp get regExp => RegExp(r'^\d+\. .*$', multiLine: true);

  @override
  InlineSpan finishText(
    int start,
    Match match, {
    TextStyle? textStyle,
    SpecialTextGestureTapCallback? onTap,
  }) {
    return SpecialTextSpan(
      text: "\t${match[0]!}",
      actualText: match[0]!,
      start: start,
      style: textStyle,
      deleteAll: false,
    );
  }
}

class UnorderedListItem extends RegExpSpecialText {
  @override
  RegExp get regExp => RegExp(r'^- .*$', multiLine: true);

  @override
  InlineSpan finishText(
    int start,
    Match match, {
    TextStyle? textStyle,
    SpecialTextGestureTapCallback? onTap,
  }) {
    return SpecialTextSpan(
      text: "\t${match[0]!}",
      actualText: match[0]!,
      start: start,
      style: textStyle,
      deleteAll: false,
    );
  }
}

class Link extends RegExpSpecialText {
  @override
  RegExp get regExp => RegExp(r'\[.*\]\(.*\)');

  @override
  InlineSpan finishText(
    int start,
    Match match, {
    TextStyle? textStyle,
    SpecialTextGestureTapCallback? onTap,
  }) {
    final text = match[0]!;
    final linkText = text.substring(1, text.indexOf(']'));
    final link = text.substring(text.indexOf('(') + 1, text.indexOf(')'));
    return SpecialTextSpan(
      text: linkText,
      actualText: text,
      start: start,
      // TODO: change color, add on tap
      style: textStyle!.copyWith(color: Colors.blue),
      deleteAll: false,
    );
  }
}

class Image extends RegExpSpecialText {
  @override
  RegExp get regExp => RegExp(r'!\[.*\]\(.*\)');

  @override
  InlineSpan finishText(
    int start,
    Match match, {
    TextStyle? textStyle,
    SpecialTextGestureTapCallback? onTap,
  }) {
    final text = match[0]!;
    final linkText = text.substring(2, text.indexOf(']'));
    final link = text.substring(text.indexOf('(') + 1, text.indexOf(')'));
    return SpecialTextSpan(
      text: linkText,
      actualText: text,
      start: start,
      // TODO: change color, add on tap
      style: textStyle!.copyWith(color: Colors.blue),
      deleteAll: false,
    );
  }
}
