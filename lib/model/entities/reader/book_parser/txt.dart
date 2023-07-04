import 'dart:convert';
import 'dart:io';

import 'package:flashcards_reader/model/entities/reader/book_model.dart';
import 'package:flashcards_reader/util/enums.dart';
import 'package:flashcards_reader/util/extension_check.dart';

class BinderTxt {
  static Future<BookModel> bind(File file) async {
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
