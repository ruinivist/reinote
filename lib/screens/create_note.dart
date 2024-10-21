import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_tl_app/controllers/note_controller.dart';
import 'package:local_tl_app/markdown/editor_view.dart';
import 'package:local_tl_app/widgets/editor/inline_preview_editor/inline_preview_editor.dart';

import '../controllers/theme_controller.dart';
import '../markdown/editor_controller.dart';
import '../note/note_model.dart';

/// just note => edit mode.
/// note + direction => add note in that direction to the note.
/// no note => append to global "end" of notes.
class CreateNote extends StatefulWidget {
  static const routeName = '/create_note';
  final Note? note;
  final Direction? direction;
  const CreateNote({this.note, this.direction, super.key});

  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 2, vsync: this);
  bool get editing => widget.note != null && widget.direction == null;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(EditorController(initialText: widget.note?.content ?? ""));
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: editing ? editNote : newNote,
          child: editing ? const Icon(Icons.edit) : const Icon(Icons.add),
        ),
        body: CustomScrollView(
          hitTestBehavior: HitTestBehavior.deferToChild,
          slivers: <Widget>[
            SliverAppBar(
              floating: true,
              snap: true,
              leading: IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  Get.back();
                },
              ),
              actions: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Get.theme.colorScheme.primaryContainer),
                    color: Get.theme.colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Get.theme.colorScheme.shadow.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(4),
                  child: SizedBox(
                    width: 110,
                    height: 28,
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Get.theme.colorScheme.primaryContainer,
                      ),
                      labelColor: Get.theme.colorScheme.onPrimaryContainer, // Color of the selected tab text
                      unselectedLabelColor: Get.theme.colorScheme.outline, // Color of the unselected tab text
                      tabs: const ["Edit", "View"].map((e) {
                        return Tab(
                          child: SizedBox(
                            width: 100,
                            child: Center(
                              child: Text(e),
                            ),
                          ),
                        );
                      }).toList(),
                      padding: EdgeInsets.zero,
                      labelPadding: EdgeInsets.zero,
                      indicatorPadding: EdgeInsets.zero,
                      dividerColor: Colors.transparent,
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
            SliverFillRemaining(
              child: TabBarView(
                controller: _tabController,
                children: [
                  const Padding(
                    padding: ThemeController.edgePadding,
                    child: InlinePreviewEditor(),
                  ),
                  Obx(() => EditorView(text: EditorController.to.text)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void newNote() async {
    final newNote = NoteFactory.to.newNote(
      title: "New Note",
      content: EditorController.to.text,
    );

    await NoteController.to.addNote(
      newNote,
      dir: widget.direction,
      addTo: widget.note,
    );
    Get.back();
  }

  void editNote() async {
    final newNote = NoteFactory.to.newNote(
      title: "New Note",
      content: EditorController.to.text,
    );

    await NoteController.to.editNote(
      widget.note!,
      newNote,
    );
    Get.back();
  }
}
