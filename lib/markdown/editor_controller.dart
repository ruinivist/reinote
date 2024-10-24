import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditorController extends GetxController {
  static EditorController get to => Get.find();

  late TextEditingController textEditingController;
  EditorController({String? initialText}) {
    textEditingController = TextEditingController(text: initialText);
  }

  ScrollController scrollController = ScrollController();

  final _text = "".obs;
  String get text => _text.value;

  @override
  void onInit() {
    super.onInit();
    textEditingController.addListener(() {
      _text.value = textEditingController.text;
    });
  }
}

String dummyMarkdown = '''
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
''';
