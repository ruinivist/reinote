import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

class EditorView extends StatelessWidget {
  // passing it directly because magic where the widget picks up automatically from god knows where ( as in Get.find )
  // would make thins harder to understand
  final String text;
  final bool isScrollable;
  const EditorView({super.key, required this.text, this.isScrollable = false});

  // TODO: the scroll offsets are not retained

  @override
  Widget build(BuildContext context) {
    return Markdown(
      physics: isScrollable ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
      selectable: false, // TODO if clickign on words the selectable listener picsk the event intead of scroll or drag
      data: text,
      extensionSet: md.ExtensionSet(
        md.ExtensionSet.gitHubFlavored.blockSyntaxes,
        <md.InlineSyntax>[md.EmojiSyntax(), ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes],
      ),
    );
  }
}
