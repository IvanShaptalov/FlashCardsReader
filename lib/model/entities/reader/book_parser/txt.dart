import 'dart:convert';
import 'dart:io';

import 'package:flashcards_reader/model/entities/reader/book_model.dart';
import 'package:flashcards_reader/util/enums.dart';
import 'package:flashcards_reader/util/checker.dart';

class BinderTxt {
  static Future<BookModel> bind(File file) async {
    String extension = Checker.getExtension(file.path);
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
      title: Checker.getName(file.path),
      path: file.path,
      lastAccess: DateTime.now(),
      textSnippet: snippet,
      status: BookStatus(
        readingPrivate: false,
        readPrivate: false,
        toRead: false,
        favourite: false,
        inTrash: false,
        onPage: 0,
      ),
      settings: BookSettings(
        theme: BookThemes.light,
      ),
      file: BookFileMeta(
          size: file.lengthSync(),
          extension: extension,
          lastModified: DateTime.now().toIso8601String(),
          name: Checker.getName(file.path)),
      author: '',
      coverPath: 'assets/images/empty.png',
      description: snippet,
      isBinded: true,
      language: '',
      pageCount: 0,
    );
    return txtBook;
  }
}
