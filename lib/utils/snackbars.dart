import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Snackbars {
  static void info({required String title, required String message}) {
    generic(
      title: title,
      message: message,
      color: Get.theme.colorScheme.secondaryContainer,
      textColor: Get.theme.colorScheme.onSecondaryContainer,
    );
  }

  static void error({required String title, required String message}) {
    generic(
      title: title,
      message: message,
      color: Get.theme.colorScheme.errorContainer,
      textColor: Get.theme.colorScheme.onErrorContainer,
    );
  }

  static void generic({
    required String title,
    required String message,
    required Color color,
    required Color textColor,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: color.withOpacity(0.5),
      colorText: textColor,
      margin: const EdgeInsets.all(16),
    );
  }
}
