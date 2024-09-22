import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:local_tl_app/canvas/canvas_background.dart';
import 'package:local_tl_app/canvas/canvas_view.dart';
import 'package:local_tl_app/controllers/filesystem.dart';
import 'package:local_tl_app/markdown/editor_view.dart';
import 'package:local_tl_app/markdown/split_pane_editor.dart';
import 'package:local_tl_app/note/note_model.dart';

import 'screens/home.dart';
import 'utils/log.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class SampleScaffold extends StatelessWidget {
  const SampleScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample Scaffold'),
        actions: [
          // settings
          // IconButton(
          //   icon: const Icon(Icons.settings),
          //   onPressed: () {
          //     Get.to(() => Settings());
          //   },
          // ),
        ],
      ),
      body: SplitPaneEditor(),
    );
  }
}

class MyruiadOfButtojns extends StatelessWidget {
  const MyruiadOfButtojns({super.key});

  @override
  Widget build(BuildContext context) {
    final fs = Get.put(FileSystemController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('buttons'),
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: () async {
              final x = await fs.listFilesRecursively();
              lg.i(x);
            },
            child: Text("sd"),
          ),
          TextButton(
            onPressed: () async {
              final x = await fs.createFile("test.md", "content");
              lg.i(x);
            },
            child: Text("sd"),
          )
        ],
      ),
    );
  }
}
