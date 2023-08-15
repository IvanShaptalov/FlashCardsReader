// ignore_for_file: sdk_version_since

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flashcards_reader/model/entities/reader/book_model.dart';
import 'package:flashcards_reader/util/enums.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/util/checker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xml/xml.dart';

class BinderEpub {
  String title = '';
  String author = '';
  String language = '';
  String description = '';
  String coverPath = '';
  ZipDecoder zip = ZipDecoder();

  Future<BookModel> bind(File file) async {
    // todo bind pdf file
    String extension = Checker.getExtension(file.path);
    await _unzip(file);
    BookModel epubBook = BookModel(
      isBinded: true,
      pageCount: 0,
      title: title.isEmpty ? Checker.getName(file.path) : title,
      path: file.path,
      textSnippet: '',
      description: '',
      lastAccess: DateTime.now(),
      status: BookStatus(
        readingPrivate: false,
        readPrivate: false,
        toRead: false,
        favourite: false,
        inTrash: false,
        onPage: 0,
      ),
      settings: BookSettingsToDelete(
        theme: BookThemes.light,
      ),
      file: BookFileMeta(
          name: Checker.getName(file.path),
          size: file.lengthSync(),
          extension: extension,
          lastModified: DateTime.now().toIso8601String()),
      coverPath: coverPath,
      language: language,
      author: author,
    );
    debugPrintIt(epubBook);
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
            if (meta.qualifiedName.toString().contains('description')) {
              description = meta.innerText;
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
      coverPath = items
              .firstWhere((p0) => p0.attributes
                  .where((p0) =>
                      p0.value == 'image/jpeg' ||
                      p0.value.toString().contains('cover.jpg') ||
                      p0.value.toString().contains('cover.png'))
                  .isNotEmpty)
              .attributes
              .firstOrNull
              ?.value
              .toString() ??
          '';
      // debugPrintIt(coverPath);
      if (coverPath.isNotEmpty) {
        var coverFileBytes =
            archive.files.firstWhere((p0) => p0.toString().contains(coverPath));
        coverPath = await _saveCover(
            coverFileBytes, Checker.getName(file.path.replaceAll('/', '')));
      }
    } else {
      // print('opfFile is null');
    }
  }

  Future<String> _saveCover(ArchiveFile fileBytes, String name) async {
    // print(fileBytes);
    String ext = Checker.getExtension(fileBytes.name);
    String path = (await getExternalStorageDirectory())!.path + name + ext;
    if (!File(path).existsSync()) {
      await File(path).create().then((value) => value
          .writeAsBytes(fileBytes.content)
          .then((value) => debugPrintIt('$value saved succesfully')));
    }

    debugPrintIt(File(path).existsSync());
    return path;
  }
}
