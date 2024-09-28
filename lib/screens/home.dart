import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'create_note.dart';

/// check if a vault exists and create one here
/// otherwise this is the feed
class Home extends StatefulWidget {
  static const routeName = '/home';
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(CreateNote.routeName);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
