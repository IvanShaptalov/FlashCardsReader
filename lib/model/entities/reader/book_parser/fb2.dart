import 'dart:io';

import 'package:flashcards_reader/model/entities/reader/book_model.dart';
import 'package:flashcards_reader/util/enums.dart';
import 'package:flashcards_reader/util/extension_check.dart';

class BinderFB2 {
  static Future<BookModel> bind(File file) async {
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
}
