import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsController extends GetxController {
  static PermissionsController get to => Get.find();

  // storage
  final _loadingStorage = true.obs;
  final _hasStorage = false.obs;
  final _storagePermad = false.obs;

  // since you should not be modifying the values of the observables directly
  bool get loadingStorage => _loadingStorage.value;
  bool get hasStorage => _hasStorage.value;
  bool get storagePermad => _storagePermad.value;

  void checkStoragePermission() async {
    _loadingStorage.value = true;
    final status = await Permission.manageExternalStorage.status;
    _hasStorage.value = status.isGranted;
    _storagePermad.value = status.isPermanentlyDenied;
    _loadingStorage.value = false;
  }

  Future<bool> requestStoragePermission() async {
    final status = await Permission.manageExternalStorage.request();
    _hasStorage.value = status.isGranted;
    return _hasStorage.value;
  }

  Future<bool> openAppSettings() async {
    return await openAppSettings();
  }

  @override
  void onInit() {
    super.onInit();
    checkStoragePermission();
  }
}
