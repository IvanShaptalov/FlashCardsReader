import 'dart:io';

import 'package:archive/archive.dart';
import 'package:fb2_parse/fb2_parse.dart';
import 'package:flashcards_reader/model/entities/reader/book_model.dart';
import 'package:flashcards_reader/util/enums.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/util/extension_check.dart';
import 'package:path_provider/path_provider.dart';

class BinderFB2 {
  String title = '';
  String snippet = '';
  String author = '';
  String language = '';
  String coverPath = '';
  ZipDecoder zip = ZipDecoder();

  Future<BookModel> bind(File file) async {
    String ext = getExtension(file.path);
    if (['.fb2', '.zip'].contains(ext)) {
      /// encode zip
      String path = file.path;
      if (ext == 'zip') {
        final bytes = file.readAsBytesSync();
        final archive = zip.decodeBytes(bytes);
        String pathOut = (await getApplicationDocumentsDirectory()).path;
        File unPackedFile = File(pathOut + archive.first.name)
          ..createSync()
          ..writeAsBytesSync(archive.first.content);
        path = unPackedFile.path;
      }

      /// parse fb2 file
      FB2Book fb2BookRaw = FB2Book(path);
      await fb2BookRaw.parse();

      title = fb2BookRaw.description.bookTitle.toString();
      snippet = fb2BookRaw.body.epigraph ?? '';
      if (fb2BookRaw.description.authors != null) {
        for (var a in fb2BookRaw.description.authors!) {
          author += '${a.firstName} ${a.lastName};';
        }
      }
      language = fb2BookRaw.description.lang ?? '';
      if (fb2BookRaw.images.isNotEmpty) {
        var image = fb2BookRaw.images.first;
        coverPath =
            '${(await getExternalStorageDirectory())!.path}${uuid.v4()}jpg';
        File(coverPath).create().then((value) => value
            .writeAsString(image.bytes)
            .then((value) => debugPrintIt('$value saved succesfully')));
      }

      // todo bind pdf file
    }
    String extension = getExtension(file.path);
    BookModel fb2Book = BookModel(
        title: getName(file.path),
        path: file.path,
        lastAccess: DateTime.now(),
        textSnippet: '',
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
        file: BookFile(
          size: file.lengthSync(),
          extension: extension,
        ));
    return fb2Book;

    /// path to the picked file
  }
}
