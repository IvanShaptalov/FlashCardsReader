import 'dart:async';
import 'dart:convert';
// import 'dart:ffi';
import 'dart:io';

import 'package:flashcards_reader/constants.dart';
import 'package:flashcards_reader/model/entities/reader/book_model.dart';
import 'package:flashcards_reader/util/enums.dart';
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

      Directory dir = Directory(androidBasePath);
      var files = await dirContents(dir);

      debugPrintIt(files);

      // here we should bind books to the database
      bindBooks(files);
    } else {
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
            await Binding.bindEpubFile(file);
          } catch (e) {
            debugPrintIt('$e error in epub');
          }

          break;

        case '.pdf':
          try {
            await Binding.bindPdfFile(file);
          } catch (e) {
            debugPrintIt('$e error in pdf');
          }
          break;

        case '.fb2':
          try {
            await Binding.bindFb2File(file);
          } catch (e) {
            debugPrintIt('$e error in fb2');
          }
          break;
        case '.mobi':
          try {
            await Binding.bindMobiFile(file);
          } catch (e) {
            debugPrintIt('$e error in mobi');
          }
          break;
        case '.txt':
          try {
            await Binding.bindTxtFile(file);
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

class Binding {
  static Future<BookModel> bindFb2File(File file) async {
    // todo bind pdf file
    String extension = getExtension(file.path);
    BookModel fb2Book = BookModel(
        title: getName(file.path),
        path: file.path,
        textSnippet: '',
        status: BookStatus(
          reading: false,
          read: false,
          wantToRead: false,
          favourite: false,
          onPage: 0,
        ),
        settings: BookSettings(
          theme: BookThemes.light,
        ),
        file: BookFile(
          size: file.lengthSync(),
          extension: extension,
        ));
    return fb2Book;
  }

  static Future<BookModel> bindMobiFile(File file) async {
    // todo bind pdf file
    String extension = getExtension(file.path);
    BookModel mobiBook = BookModel(
        title: getName(file.path),
        path: file.path,
        textSnippet: '',
        status: BookStatus(
          reading: false,
          read: false,
          wantToRead: false,
          favourite: false,
          onPage: 0,
        ),
        settings: BookSettings(
          theme: BookThemes.light,
        ),
        file: BookFile(
          size: file.lengthSync(),
          extension: extension,
        ));
    return mobiBook;
  }

  static Future<BookModel> bindEpubFile(File file) async {
    // todo bind pdf file
    String extension = getExtension(file.path);
    BookModel epubBook = BookModel(
        title: getName(file.path),
        path: file.path,
        textSnippet: '',
        status: BookStatus(
          reading: false,
          read: false,
          wantToRead: false,
          favourite: false,
          onPage: 0,
        ),
        settings: BookSettings(
          theme: BookThemes.light,
        ),
        file: BookFile(
          size: file.lengthSync(),
          extension: extension,
        ));
    return epubBook;
  }

  static Future<BookModel> bindPdfFile(File file) async {
    // todo bind pdf file
    String extension = getExtension(file.path);
    BookModel pdfBook = BookModel(
        title: getName(file.path),
        path: file.path,
        textSnippet: '',
        status: BookStatus(
          reading: false,
          read: false,
          wantToRead: false,
          favourite: false,
          onPage: 0,
        ),
        settings: BookSettings(
          theme: BookThemes.light,
        ),
        file: BookFile(
          size: file.lengthSync(),
          extension: extension,
        ));
    return pdfBook;
  }

  static Future<BookModel> bindTxtFile(File file) async {
    String extension = getExtension(file.path);
    StringBuffer buffer = StringBuffer();
    file.openRead();
    int counter = 0;
    await for (var line in file.openRead()) {
      if (counter++ > 3) {
        break;
      }
      buffer.write(utf8.decode(line));
    }
    String snippet = '';
    if (buffer.length > 100) {
      snippet = StringBuffer(buffer.toString().substring(0, 100)).toString();
    }
    snippet = buffer.toString();

    // model binding to ram
    BookModel txtBook = BookModel(
        title: getName(file.path),
        path: file.path,
        textSnippet: snippet,
        status: BookStatus(
          reading: false,
          read: false,
          wantToRead: false,
          favourite: false,
          onPage: 0,
        ),
        settings: BookSettings(
          theme: BookThemes.light,
        ),
        file: BookFile(
          size: file.lengthSync(),
          extension: extension,
        ));
    return txtBook;
  }
}
