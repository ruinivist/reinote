import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:local_tl_app/controllers/theme_controller.dart';
import 'package:local_tl_app/utils/log.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: ColorPicker(
          pickerColor: ThemeController.to.lastSettingsColor,
          onColorChanged: (Color newColor) {
            lg.i('newColor: $newColor');
            ThemeController.to.updateColor(newColor);
          },
        ),
      ),
    );
  }
}
