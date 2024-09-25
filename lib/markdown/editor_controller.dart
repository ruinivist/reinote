import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/log.dart';

class EditorController extends GetxController {
  static EditorController get to => Get.find();

  ScrollController scrollController = ScrollController();
  TextEditingController controller = TextEditingController();

  final _mdText = RxString("");

  String get markdownText => _mdText.value;

  void updateText(String text) {
    lg.d("md text updated");
    _mdText.value = text;
  }
}

String _dummyMarkdown = '''
# Markdown Example

## Sample Markdown

This is a sample markdown content.

- Item 1
- Item 2
- Item 3

**Bold Text**

*Italic Text*

```dart
void main() {
  print('Hello, World!');
}
```

[Link](https://example.com)
''';
