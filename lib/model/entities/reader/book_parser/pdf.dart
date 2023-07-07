import 'dart:io';

import 'package:flashcards_reader/model/entities/reader/book_model.dart';
import 'package:flashcards_reader/util/enums.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/util/extension_check.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';

class BinderPdf {
  static Future<BookModel> bind(File file) async {
    String ext = getExtension(file.path);

    final document = await PdfDocument.openFile(file.path);
    final page = await document.getPage(1);
    PdfPageImage? pageImage =
        await page.render(width: page.width, height: page.height);
    if (pageImage != null) {
      String path = (await getExternalStorageDirectory())!.path +
          uuid.v4() +
          pageImage.format.toString();

      File(path).create().then((value) => value
          .writeAsBytes(pageImage.bytes)
          .then((value) => debugPrintIt('$value saved succesfully')));
    }

    // model binding to ram
    BookModel pdfBook = BookModel(
        title: getName(file.path),
        path: file.path,
        textSnippet: '',
        lastAccess: DateTime.now(),
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
          extension: ext,
        ));
    return pdfBook;
  }
}
