import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_tl_app/screens/settings.dart';

class UiTest extends StatelessWidget {
  const UiTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [IconButton(onPressed: () => Get.to(() => Settings()), icon: Icon(Icons.settings))],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned(
            left: 32,
            top: 0,
            bottom: 0,
            child: Container(
              color: Get.theme.colorScheme.primaryContainer,
              width: 2,
            ),
          )
        ],
      ),
    );
  }
}
