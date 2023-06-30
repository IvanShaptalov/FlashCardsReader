import 'dart:async';
import 'dart:io';

import 'package:flashcards_reader/constants.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/util/extension_check.dart';
import 'package:permission_handler/permission_handler.dart';

class BookScanner {
  static Future<bool> getFilePermission() async {
    var status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
      await Permission.manageExternalStorage.request();
      // openAppSettings();
    }
    return status.isGranted;
  }

  static Future<void> scan() async {
    if (await getFilePermission()) {
      print('Permission not granted');

      Directory dir = Directory('/storage/emulated/0');
      var files = await dirContents(dir);

      print(files);
    }
  }

  static Future<List<FileSystemEntity>> dirContents(Directory dir) {
    var files = <FileSystemEntity>[];
    int counter = 0;
    var completer = Completer<List<FileSystemEntity>>();
    var lister = dir.list(recursive: true);
    lister.listen((file) {
      try {
        print('-----$file ---------');
        counter++;

        if (counter % 10 == 0) {
          print('-----$counter ---------');
        }
        if (file is File) {
          String extension = getExtension(file.path);
          if (file.path.contains('Download')) {
            debugPrintIt('Download');
          }
          print(file.path + ' --- ' + extension);
          if (allowedBookExtensions.contains(extension)) {
            files.add(file);
          }
        }
      } catch (e) {
        debugPrintIt(e);
      }
    },
        // should also register onError
        onDone: () => completer.complete(files));
    return completer.future;
  }
}
