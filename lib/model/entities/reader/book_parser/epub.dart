import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:archive/archive.dart';
import 'package:flashcards_reader/model/entities/reader/book_model.dart';
import 'package:flashcards_reader/util/enums.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/util/extension_check.dart';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart';

class BinderEpub {
  String title = '';
  String author = '';
  String language = '';
  Image? cover;
  ZipDecoder zip = ZipDecoder();

  Future<dynamic> _unzip(File file) async {
    final bytes = file.readAsBytesSync();

// Decode the Zip file
    final archive = zip.decodeBytes(bytes);

// Extract the contents of the Zip archive to disk.
    var opfFile = archive.files
        .where((p0) => p0.toString().contains('content.opf'))
        .firstOrNull;
    debugPrintIt('=================opfFile: $opfFile');
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

        debugPrintIt('=================metadataAttrs: $author');
        debugPrintIt('=================metadataAttrs: $title');
        debugPrintIt('=================metadataAttrs: $language');
      } else {
        print('metadata is null');

        print(document);

        final items = document.findAllElements('item');
        final coverPath = items
            .firstWhere((p0) => p0.attributes
                .where((p0) =>
                    p0.value == 'image/jpeg' ||
                    p0.value.toString().contains('cover'))
                .isNotEmpty)
            ?.attributes
            .firstOrNull
            ?.value;
        debugPrintIt(coverPath);
        if (coverPath != null) {
          var coverFileBytes = archive.files
              .firstWhere((p0) => p0.toString().contains(coverPath));
          cover = await getCover(coverFileBytes);
        }
      }
    } else {
      print('opfFile is null');
    }
  }

  Future<Image> getCover(dynamic fileBytes) async {
    final codec = await instantiateImageCodec(fileBytes);
    final frameInfo = await codec.getNextFrame();
    return Future.value((frameInfo.image) as FutureOr<Image>?);
  }

  Future<BookModel> bind(File file) async {
    // todo bind pdf file
    String extension = getExtension(file.path);
    await _unzip(file);
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
