import 'dart:async';
// import 'dart:ffi';
import 'dart:io';

import 'package:flashcards_reader/constants.dart';
import 'package:flashcards_reader/database/core/table_methods.dart';
import 'package:flashcards_reader/model/entities/reader/book_parser/epub.dart';
import 'package:flashcards_reader/model/entities/reader/book_parser/fb2.dart';
import 'package:flashcards_reader/model/entities/reader/book_parser/pdf.dart';
import 'package:flashcards_reader/model/entities/reader/book_parser/txt.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/util/extension_check.dart';
import 'package:permission_handler/permission_handler.dart';

import 'book_model.dart';

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
    Directory dir = Directory(androidBasePath);
    var files = await dirContents(dir);
    if (await getFilePermission()) {
      // here we should bind books to the database
      bindBooks(files);
    } else {
      try {
        bindBooks(files);
      } catch (e) {
        debugPrintIt('Permission not granted: $e');
      }
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
            // debugPrintIt('Download');
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
    debugPrintIt('Binding books to the database');
    for (var fileEntity in files) {
      File file = File(fileEntity.path);
      // TODO scan in c++ for performance in the future
      String extension = getExtension(file.path);
      BookModel? model;
      switch (extension) {
        case '.epub':
          try {
            model = await BinderEpub().bind(file);
          } catch (e) {
            debugPrintIt('$e error in epub');
          }

          break;

        case '.pdf':
          try {
            model = await BinderPdf.bind(file);
          } catch (e) {
            debugPrintIt('$e error in pdf');
          }
          break;

        case '.fb2':
          try {
            model = await BinderFB2().bind(file);
          } catch (e) {
            debugPrintIt('$e error in fb2');
          }
          break;

        case '.zip':
          try {
            model = await BinderFB2().bind(file);
          } catch (e) {
            debugPrintIt('$e error in fb2 zip');
          }
          break;

        case '.txt':
          try {
            model = await BinderTxt.bind(file);
          } catch (e) {
            debugPrintIt('$e error in txt');
          }
          break;
        default:
          break;
      }
      if (model != null && !BookDatabaseProvider.getAll().contains(model)) {
        BookDatabaseProvider.writeEditAsync(model);
      }
    }
    debugPrintIt('================book models');
    debugPrintIt(BookDatabaseProvider.getAll());
    debugPrintIt(BookDatabaseProvider.getAll().length);
  }
}
