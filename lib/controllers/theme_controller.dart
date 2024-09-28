import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find();

  static const defaultColor = Color(0xff769CDF);
  final _colorScheme = ColorScheme.fromSeed(seedColor: defaultColor).obs;

  ColorScheme get colorScheme => _colorScheme.value;
  Color lastSettingsColor = defaultColor;

  ColorScheme updateColor(Color seedColor) {
    lastSettingsColor = seedColor;
    _colorScheme.value = ColorScheme.fromSeed(seedColor: seedColor);
    return _colorScheme.value;
  }

  static const containerPadding = EdgeInsets.all(16.0);
  static const containerBorderRadius = BorderRadius.all(Radius.circular(16.0));
  static const edgePadding = EdgeInsets.symmetric(horizontal: 8.0);
  static const defaultBoxDecoration = BoxDecoration(
    borderRadius: containerBorderRadius,
  );
}
