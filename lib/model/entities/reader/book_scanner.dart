import 'dart:async';
// import 'dart:ffi';
import 'dart:io';

import 'package:flashcards_reader/constants.dart';
import 'package:flashcards_reader/model/entities/reader/book_parser/epub.dart';
import 'package:flashcards_reader/model/entities/reader/book_parser/fb2.dart';
import 'package:flashcards_reader/model/entities/reader/book_parser/mobi.dart';
import 'package:flashcards_reader/model/entities/reader/book_parser/pdf.dart';
import 'package:flashcards_reader/model/entities/reader/book_parser/txt.dart';
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
      Directory dir = Directory(androidBasePath);
      var files = await dirContents(dir);

      // here we should bind books to the database
      bindBooks(files);
    } else {
      debugPrintIt('Permission not granted');

      OverlayNotificationProvider.showOverlayNotification(
          'Permission not granted');
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

  static Future<void> bindBooks(List<FileSystemEntity> files) async {
    // TODO bind books to the database
    debugPrintIt('Binding books to the database');
    for (var fileEntity in files) {
      File file = File(fileEntity.path);
      // TODO scan in c++ for performance in the future
      String extension = getExtension(file.path);

      switch (extension) {
        case '.epub':
          try {
            await BinderEpub().bind(file);
          } catch (e) {
            debugPrintIt('$e error in epub');
          }

          break;

        case '.pdf':
          try {
            await BinderPdf.bind(file);
          } catch (e) {
            debugPrintIt('$e error in pdf');
          }
          break;

        case '.fb2':
          try {
            await BinderFB2.bind(file);
          } catch (e) {
            debugPrintIt('$e error in fb2');
          }
          break;
        case '.mobi':
          try {
            await BinderMobi.bind(file);
          } catch (e) {
            debugPrintIt('$e error in mobi');
          }
          break;
        case '.txt':
          try {
            await BinderTxt.bind(file);
          } catch (e) {
            debugPrintIt('$e error in txt');
          }
          break;
        default:
          break;
      }
    }
  }
}
