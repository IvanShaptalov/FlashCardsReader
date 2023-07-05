// ignore_for_file: sdk_version_since

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flashcards_reader/model/entities/reader/book_model.dart';
import 'package:flashcards_reader/util/enums.dart';
import 'package:flashcards_reader/util/extension_check.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xml/xml.dart';

class BinderEpub {
  String title = '';
  String author = '';
  String language = '';
  String coverPath = '';
  ZipDecoder zip = ZipDecoder();

  Future<BookModel> bind(File file) async {
    // todo bind pdf file
    String extension = getExtension(file.path);
    await _unzip(file);
    BookModel epubBook = BookModel(
      title: title.isEmpty ? getName(file.path) : title,
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
      ),
      cover: coverPath,
      language: language,
      author: author,
    );
    print(epubBook);
    return epubBook;
  }

  Future<dynamic> _unzip(File file) async {
    final bytes = file.readAsBytesSync();

// Decode the Zip file
    final archive = zip.decodeBytes(bytes);

// Extract the contents of the Zip archive to disk.
    var opfFile =
        archive.files.where((p0) => p0.toString().contains('.opf')).firstOrNull;
    // debugPrintIt('=================opfFile: $opfFile');
    if (opfFile != null) {
      final document = XmlDocument.parse(utf8.decode(opfFile.content));
      final metadata = document.findAllElements('metadata').firstOrNull;
      if (metadata != null) {
        for (final meta in metadata.children) {
          if (meta is XmlElement) {
            if (meta.qualifiedName.toString().contains('title')) {
              title = meta.innerText;
            }
            if (meta.qualifiedName.toString().contains('creator')) {
              author = meta.innerText;
            }
            if (meta.qualifiedName.toString().contains('language')) {
              language = meta.innerText;
            }
          }
        }

        // debugPrintIt('=================author: $author');
        // debugPrintIt('=================title: $title');
        // debugPrintIt('=================language: $language');
      } else {
        // print('metadata is null');
      }
      // print(document);

      final items = document.findAllElements('item');
      String? coverPath = items
          .firstWhere((p0) => p0.attributes
              .where((p0) =>
                  p0.value == 'image/jpeg' ||
                  p0.value.toString().contains('cover'))
              .isNotEmpty)
          .attributes
          .firstOrNull
          ?.value
          .toString();
      // debugPrintIt(coverPath);
      if (coverPath != null) {
        var coverFileBytes = archive.files
            .firstWhere((p0) => p0.toString().contains(coverPath!));
        coverPath = await _saveCover(coverFileBytes);
      }
    } else {
      // print('opfFile is null');
    }
  }

  Future<String> _saveCover(ArchiveFile fileBytes) async {
    // print(fileBytes);
    String ext = getExtension(fileBytes.name);
    String path =
        (await getApplicationDocumentsDirectory()).path + uuid.v4() + ext;
    await File(path).create().then((value) => value
        .writeAsBytes(fileBytes.content)
        .then((value) => print('$value saved succesfully')));
    print(File(path).existsSync());
    return path;
  }
}
