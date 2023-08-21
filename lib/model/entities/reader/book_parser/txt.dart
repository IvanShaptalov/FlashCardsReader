import 'dart:convert';
import 'dart:io';

import 'package:flashcards_reader/model/entities/reader/book_model.dart';
import 'package:flashcards_reader/util/checker.dart';

class BinderTxt {
  static Future<BookModel> bind(File file) async {
    String ext = Checker.getExtension(file.path);
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
        lastAccess: DateTime.now(),
        textSnippet: snippet,
        status: BookStatus.falseStatus(),
        pdfSettings: PDFSettings.asset(),
        fileMeta: BookFileMeta(
          size: file.lengthSync(),
          ext: ext,
          lastModified: DateTime.now(),
          path: file.path,
        ),
        author: '',
        coverPath: 'assets/images/empty.png',
        description: snippet,
        language: '',
        pageCount: 0,
        bookSettings: BookSettings.asset());
    return txtBook;
  }
}
