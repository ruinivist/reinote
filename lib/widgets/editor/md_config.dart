import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MdConfig extends GetxController {
  static MdConfig get to => Get.find();
  Rx<TextStyle> _h1, _h2, _h3, _body;

  MdConfig({required TextStyle h1, required TextStyle h2, required TextStyle h3, required TextStyle body})
      : _h1 = h1.obs,
        _h2 = h2.obs,
        _h3 = h3.obs,
        _body = body.obs;

  MdConfig.defaults()
      : _h1 = Get.textTheme.titleLarge!.obs,
        _h2 = Get.textTheme.titleMedium!.obs,
        _h3 = Get.textTheme.titleSmall!.obs,
        _body = Get.textTheme.bodyMedium!.obs;

  TextStyle get h1 => _h1.value;
  TextStyle get h2 => _h2.value;
  TextStyle get h3 => _h3.value;
  TextStyle get body => _body.value;
}
