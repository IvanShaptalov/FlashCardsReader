import 'dart:async';
import 'dart:io';

import 'package:flashcards_reader/constants.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/util/extension_check.dart';
import 'package:flashcards_reader/views/overlay_notification.dart';
import 'package:permission_handler/permission_handler.dart';

// TODO test on old android device
class BookScanner {
  static Future<bool> getFilePermission() async {
    var status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
      await Permission.manageExternalStorage.request();
    }
    return status.isGranted;
  }

  static Future<void> scan() async {
    if (await getFilePermission()) {
      debugPrintIt('Permission not granted');
      OverlayNotificationProvider.showOverlayNotification(
          'Permission not granted');

      Directory dir = Directory(androidBasePath);
      var files = await dirContents(dir);

      debugPrintIt(files);

      // here we should bind books to the database
      bindBooks();
    }
  }

  static Future<List<FileSystemEntity>> dirContents(Directory dir) {
    var files = <FileSystemEntity>[];
    var completer = Completer<List<FileSystemEntity>>();
    var lister = dir.list(recursive: true);
    lister.listen((file) {
      try {
        if (file is File) {
          String extension = getExtension(file.path);
          if (file.path.contains('Download')) {
            debugPrintIt('Download');
          }
          // debugPrintIt(file.path + ' --- ' + extension);
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

  static Future<void> bindBooks() async {
    
  }
}
