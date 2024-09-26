import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';

import '../utils/log.dart';

class FileSystemController extends GetxController {
  static FileSystemController get to => Get.find();

  late Directory _localTlDirectory;

  @override
  void onInit() {
    super.onInit();
    _initializeDirectory();
  }

  Future<void> _initializeDirectory() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    _localTlDirectory = Directory(path.join(appDocDir!.path, 'local_tl'));
    lg.i(_localTlDirectory.path);
    if (!await _localTlDirectory.exists()) {
      await _localTlDirectory.create(recursive: true);
    }
  }

  // Get the path of the local_tl directory
  Future<String> getLocalTlPath() async {
    await _initializeDirectory();
    return _localTlDirectory.path;
  }

  // List all files and directories in local_tl (non-recursive)
  Future<List<FileSystemEntity>> listContents() async {
    await _initializeDirectory();
    return _localTlDirectory.list().toList();
  }

  // List all files in local_tl recursively
  Future<List<File>> listFilesRecursively() async {
    await _initializeDirectory();
    List<File> files = [];
    await for (var entity in _localTlDirectory.list(recursive: true, followLinks: false)) {
      if (entity is File) {
        files.add(entity);
      }
    }
    return files;
  }

  // Create a new file
  Future<File> createFile(String relativePath, String content) async {
    await _initializeDirectory();
    final file = File(path.join(_localTlDirectory.path, relativePath));
    await file.create(recursive: true);
    return file.writeAsString(content);
  }

  // Read a file
  Future<String> readFile(String relativePath) async {
    await _initializeDirectory();
    final file = File(path.join(_localTlDirectory.path, relativePath));
    return file.readAsString();
  }

  // Update a file
  Future<File> updateFile(String relativePath, String content) async {
    await _initializeDirectory();
    final file = File(path.join(_localTlDirectory.path, relativePath));
    return file.writeAsString(content);
  }

  // Delete a file
  Future<void> deleteFile(String relativePath) async {
    await _initializeDirectory();
    final file = File(path.join(_localTlDirectory.path, relativePath));
    if (await file.exists()) {
      await file.delete();
    }
  }

  // Create a new directory
  Future<Directory> createDirectory(String relativePath) async {
    await _initializeDirectory();
    final directory = Directory(path.join(_localTlDirectory.path, relativePath));
    return directory.create(recursive: true);
  }

  // Delete a directory
  Future<void> deleteDirectory(String relativePath) async {
    await _initializeDirectory();
    final directory = Directory(path.join(_localTlDirectory.path, relativePath));
    if (await directory.exists()) {
      await directory.delete(recursive: true);
    }
  }

  // Check if a file or directory exists
  Future<bool> exists(String relativePath) async {
    await _initializeDirectory();
    final entity = FileSystemEntity.typeSync(path.join(_localTlDirectory.path, relativePath));
    return entity != FileSystemEntityType.notFound;
  }

  // Rename a file or directory
  // Future<void> rename(String oldPath, String newPath) async {
  //   await _initializeDirectory();
  //   final oldEntity = FileSystemEntity(path.join(_localTlDirectory.path, oldPath));
  //   final newEntity = FileSystemEntity(path.join(_localTlDirectory.path, newPath));
  //   await oldEntity.rename(newEntity.path);
  // }

  // // Get file or directory information
  // Future<FileStat> getInfo(String relativePath) async {
  //   await _initializeDirectory();
  //   final entity = FileSystemEntity(path.join(_localTlDirectory.path, relativePath));
  //   return entity.stat();
  // }

  // Search for files with a specific extension
  Future<List<File>> findFilesByExtension(String extension) async {
    List<File> allFiles = await listFilesRecursively();
    return allFiles.where((file) => path.extension(file.path) == extension).toList();
  }

  // Search for files containing a specific string in their name
  Future<List<File>> findFilesByName(String searchString) async {
    List<File> allFiles = await listFilesRecursively();
    return allFiles.where((file) => path.basename(file.path).contains(searchString)).toList();
  }
}
