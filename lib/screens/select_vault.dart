import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_tl_app/canvas/canvas_background.dart';
import 'package:local_tl_app/controllers/filesystem.dart';
import 'package:local_tl_app/controllers/permissions_controller.dart';
import 'package:local_tl_app/controllers/theme_controller.dart';
import 'package:local_tl_app/utils/snackbars.dart';
import 'package:local_tl_app/widgets/rn_container.dart';

import '../widgets/backround_painters.dart';

class SelectVault extends StatefulWidget {
  const SelectVault({super.key});

  @override
  State<SelectVault> createState() => _SelectVaultState();
}

class _SelectVaultState extends State<SelectVault> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  final background = const DotGridBackround();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(-background.spacing, background.spacing),
    ).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Get.dialog(
            const AlertDialog(
              title: Text("ReiNote"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("v 0.1"),
                  Text("idk how but its gonna be cool hopefully"),
                ],
              ),
            ),
          );
        },
        child: const Icon(Icons.info_outline),
      ),
      body: CustomPaint(
        painter: AnimatedOffsetBackground(background: background, animation: _animation),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: RnContainer(
                    color: ThemeController.to.colorScheme.primaryContainer.withOpacity(0.6),
                    child: Obx(() {
                      final perms = PermissionsController.to;
                      if (perms.loadingStorage) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!perms.hasStorage) {
                        return Column(
                          children: [
                            Text(
                              "Storage permission is required to store notes",
                              style: Get.textTheme.headlineSmall!.copyWith(
                                color: ThemeController.to.colorScheme.onPrimaryContainer,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Obx(() {
                              if (perms.storagePermad) {
                                return Column(
                                  children: [
                                    Text(
                                      "Storage permission is permanently denied. Enable it in settings then click the try again",
                                      style: Get.textTheme.bodyMedium!.copyWith(
                                        color: ThemeController.to.colorScheme.onPrimaryContainer,
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: perms.openAppSettings,
                                      child: const Text("Open settings"),
                                    ),
                                    ElevatedButton(
                                      onPressed: perms.requestStoragePermission,
                                      child: const Text("Try again"),
                                    ),
                                  ],
                                );
                              }
                              return ElevatedButton(
                                onPressed: perms.requestStoragePermission,
                                child: const Text("Request permission"),
                              );
                            }),
                          ],
                        );
                      }
                      return Column(
                        children: [
                          Text(
                            "Select a vault to open or create a new one",
                            style: Get.textTheme.headlineSmall!.copyWith(
                              color: ThemeController.to.colorScheme.onPrimaryContainer,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () async {
                              String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
                              if (selectedDirectory != null) {
                                FileSystemController.to.vaultPath = selectedDirectory;
                                Get.offNamed("/home");
                              } else {
                                Snackbars.error(
                                  title: "No directory selected",
                                  message: "Select a directory to continue",
                                );
                              }
                            },
                            child: const Text("Open folder"),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
