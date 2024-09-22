import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:local_tl_app/markdown/editor_controller.dart';
import 'package:markdown/markdown.dart' as md;

import '../utils/log.dart';

class EditorView extends StatelessWidget {
  // passing it directly because magic where the widget picks up automatically from god knows where ( as in Get.find )
  // would make thins harder to understand
  final EditorController controller;

  const EditorView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Markdown(
        controller: controller.scrollController,
        selectable: true,
        data: controller.markdownText,
        extensionSet: md.ExtensionSet(
          md.ExtensionSet.gitHubFlavored.blockSyntaxes,
          <md.InlineSyntax>[md.EmojiSyntax(), ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes],
        ),
      ),
    );
  }
}
