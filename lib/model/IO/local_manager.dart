import 'dart:io' show Directory, File, FileMode;
import 'package:external_path/external_path.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

class LocalManager {
  /// ===========================[ROOT]=========================================
  static String? appDirectoryPath;

  static Directory? deviceRootDirectory;

  /// ============================[UTIL]========================================
  static bool dirExists(String? dirPath) {
    if (dirPath == null) {
      return false;
    } else {
      return Directory(dirPath).existsSync();
    }
  }

  static bool fileExists(String? filePath) {
    if (filePath == null) {
      return false;
    } else {
      return File(filePath).existsSync();
    }
  }

  static String joinPaths(List<String> pathParts) {
    String newPath = '';

    for (String part in pathParts) {
      newPath = join(newPath, part);
    }
    return newPath;
  }

  /// ==========================[INITIALIZATION]============================

  static bool get initialized {
    return
        // DIRECTORIES EXISTS
        dirExists(appDirectoryPath);
  }

  static Future<String> createAppDirectoryPath() async {
    // var externalDir = await getExternalStorageDirectory();
    var appDir = await getTemporaryDirectory();
    // var appDir = externalDir ?? (await getApplicationSupportDirectory());
    bool created = createDirectory(appDir.path);
    var rootPath = await ExternalPath.getExternalStorageDirectories();
    deviceRootDirectory = Directory(rootPath.first);
    assert(created, true);
    return appDir.path;
  }

  static Future<bool> mountPathsAsync() async {
    appDirectoryPath = await createAppDirectoryPath();
    assert(appDirectoryPath != null);

    assert(initialized == true);
    return initialized;
  }

  /// init file tree if not initialized, use only await initAsync();
  static Future<bool> initAsync() async {
    if (!initialized) {
      await mountPathsAsync();
    }
    assert(initialized == true);
    return initialized;
  }

  /// ===========================[CRUD]=====================================
  static bool createDirectory(String path) {
    var dir = Directory(path);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    return dir.existsSync();
  }

  static bool createFile(String path) {
    var file = File(path);
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }
    return file.existsSync();
  }

  static Future<bool> writeToFile(String path, String data,
      {FileMode fileMode = FileMode.write}) async {
    // init if not initialized
    await initAsync();

    await File(path).writeAsString(data, mode: fileMode);

    if (kDebugMode) {
      print('file to write: $data \npatj" $path');
    }

    return true;
  }

  static Future<String?> readFile(String path) async {
    // init if not initialized
    await initAsync();
    var file = File(path);
    var result = await file.readAsString();
    return result != "" ? result : null;
  }
}
