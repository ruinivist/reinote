import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:local_tl_app/note/note_data.dart';

import 'app.dart';

Future<void> main() async {
  connect();
  await GetStorage.init();
  runApp(const App());
}
