import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_tl_app/canvas/canvas_view.dart';
import 'package:local_tl_app/controllers/note_controller.dart';

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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        NoteController.to.selectedNoteId.value = -1;
      },
      child: Scaffold(
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'zoomIn',
              onPressed: () {
                PositionController.to.deltaUpdateScaleCentered(0.25);
              },
              child: const Icon(Icons.zoom_in),
            ),
            SizedBox(height: 10),
            FloatingActionButton(
              heroTag: 'zoomOut',
              onPressed: () {
                PositionController.to.deltaUpdateScaleCentered(-0.25);
              },
              child: const Icon(Icons.zoom_out),
            ),
            SizedBox(height: 10),
            FloatingActionButton(
              heroTag: 'addNote',
              onPressed: () {
                Get.toNamed(CreateNote.routeName);
              },
              child: const Icon(Icons.add),
            ),
          ],
        ),
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
      ),
    );
  }
}
