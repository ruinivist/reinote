import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_tl_app/canvas/canvas_view.dart';

import '../controllers/position_controller.dart';
import '../utils/log.dart';
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
  final posCont = PositionController.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(CreateNote.routeName);
        },
        child: const Icon(Icons.add),
      ),
      // TODO: there's a 2x render bug here, see similar comment in Canvas view
      // you need to make the offset state common
      body: Obx(
        () => CanvasView(
          positions: posCont.positions,
          offset: posCont.offset,
          scale: posCont.scale,
          handleScaleUpdate: posCont.handleScaleUpdate,
          handleScaleStart: posCont.handleScaleStart,
          children: posCont.children,
        ),
      ),
    );
  }
}
