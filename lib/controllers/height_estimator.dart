import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:local_tl_app/widgets/editor/md_config.dart';

class MarkdownHeightEstimatorController extends GetxController {
  static MarkdownHeightEstimatorController get to => Get.find();

  MdConfig get mdConfig => MdConfig.to;
  final RxDouble width = 400.0.obs;

  MarkdownHeightEstimatorController();

  double estimateMarkdownHeight(String markdown) {
    if (width.value <= 0) {
      throw Exception('Width must be set before estimating height');
    }

    List<String> lines = markdown.split('\n\n');
    // split \\n
    lines = lines.expand((line) => line.split('\n')).toList(); // todo: this is not efficient but im lazy
    double totalHeight = 0;

    for (final line in lines) {
      if (line.startsWith('# ')) {
        totalHeight += _estimateLineHeight(mdConfig.h1.fontSize!, line.length - 2);
      } else if (line.startsWith('## ')) {
        totalHeight += _estimateLineHeight(mdConfig.h2.fontSize!, line.length - 3);
      } else if (line.startsWith('### ')) {
        totalHeight += _estimateLineHeight(mdConfig.h3.fontSize!, line.length - 4);
      } else {
        totalHeight += _estimateLineHeight(mdConfig.body.fontSize!, line.length);
      }
    }

    return max(120, totalHeight);
  }

  double _estimateLineHeight(double fontSize, int charCount) {
    int charsInOneLine = width.value ~/ fontSize;
    return fontSize * 2 * ((charCount / charsInOneLine).ceil());
  }
}
