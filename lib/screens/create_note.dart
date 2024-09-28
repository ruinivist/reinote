import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:local_tl_app/markdown/editor_view.dart';
import 'package:local_tl_app/note/note_utils.dart';
import 'package:local_tl_app/widgets/editor/inline_preview_editor/inline_preview_editor.dart';

import '../controllers/theme_controller.dart';
import '../markdown/editor_controller.dart';
import '../utils/log.dart';

class CreateNote extends StatefulWidget {
  static const routeName = '/create_note';
  const CreateNote({super.key});

  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 2, vsync: this);

  @override
  void dispose() {
    // _tabController.dispose();
    super.dispose();
  }
  //  SizedBox(
  //           height: 100,
  //           width: 200,
  //           child: TabBar(
  //             controller: _tabController,
  //             tabs: const [
  //               Tab(text: 'Edit', icon: Icon(Icons.edit)),
  //               Tab(text: 'Preview', icon: Icon(Icons.preview)),
  //             ],
  //           ),
  //         ),

  @override
  Widget build(BuildContext context) {
    Get.put(EditorController());
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
}

// class LiveMdView extends StatefulWidget {
//   const LiveMdView({super.key});

//   @override
//   State<LiveMdView> createState() => _LiveMdViewState();
// }

// class _LiveMdViewState extends State<LiveMdView> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Get.put(EditorController());
//     return Column(
//       children: [
//         Expanded(child: ()),
//         TextButton(
//           onPressed: () {
//             final x = NoteUtils.parseNoteProperties(EditorController.to.textEditingController.text);
//             lg.d(x);
//           },
//           child: Text("f1"),
//         ),
//       ],
//     );
//   }
// }
