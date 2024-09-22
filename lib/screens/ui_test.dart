import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_tl_app/screens/settings.dart';

class UiTest extends StatelessWidget {
  const UiTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.colorScheme.surface,
      appBar: AppBar(
        title: Text("Ui test"),
        actions: [IconButton(onPressed: () => Get.to(() => Settings()), icon: Icon(Icons.settings))],
      ),
      body: Column(
        children: [
          Container(height: 400, width: 400, color: Theme.of(context).colorScheme.primary),
        ],
      ),
    );
  }
}
