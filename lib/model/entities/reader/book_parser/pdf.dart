import 'dart:io';

import 'package:flashcards_reader/model/entities/reader/book_model.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/util/checker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';

class BinderPdf {
  static Future<BookModel> bind(File file) async {
    String ext = Checker.getExtension(file.path);
    String coverPath = '';
    final document = await PdfDocument.openFile(file.path);
    final page = await document.getPage(1);
    PdfPageImage? pageImage =
        await page.render(width: page.width, height: page.height);
    if (pageImage != null) {
      coverPath = (await getExternalStorageDirectory())!.path +
          Checker.getName(file.path.replaceAll('/', '').replaceAll('\'', '')) +
          pageImage.format.toString();
      if (!File(coverPath).existsSync()) {
        File(coverPath).create().then((value) => value
            .writeAsBytes(pageImage.bytes)
            .then((value) => debugPrintIt('$value saved succesfully')));
      }
    }

    // model binding to ram
    BookModel pdfBook = BookModel(
        author: '',
        description: '',
        title: Checker.getName(file.path),
        coverPath: coverPath,
        lastAccess: DateTime.now(),
        bookNotes: BookNotes.asset(),

        status: BookStatus.falseStatus(),
        pdfSettings: PDFSettings.asset(),
        fileMeta: BookFileMeta(
            size: file.lengthSync(),
            ext: ext,
            path: file.path,
            lastModified: DateTime.now()),
        language: '',
        
        settings: BookSettings.asset(),);
    return pdfBook;
  }
}
