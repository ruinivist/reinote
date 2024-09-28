import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_tl_app/controllers/permissions_controller.dart';
import 'package:local_tl_app/controllers/theme_controller.dart';
import 'package:local_tl_app/widgets/rn_container.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/log.dart';

class SelectVault extends StatefulWidget {
  const SelectVault({super.key});

  @override
  State<SelectVault> createState() => _SelectVaultState();
}

class _SelectVaultState extends State<SelectVault> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () async {}),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RnContainer(
              color: ThemeController.to.colorScheme.primaryContainer,
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
                      onPressed: () {},
                      child: const Text("Open folder"),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
