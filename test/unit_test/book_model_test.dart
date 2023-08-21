import 'dart:convert';

import 'package:flashcards_reader/model/entities/reader/book_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Book json test', () {
    test('book settings', () async {
      BookSettings settings = BookSettings.asset();
      String jsonMeta = jsonEncode(settings.toJson());
      BookSettings newSettings = BookSettings.fromJson(jsonDecode(jsonMeta));
      expect(settings, newSettings);
    });

    test('pdf settings', () async {
      PDFSettings settings = PDFSettings.asset();
      String jsonBook = jsonEncode(settings.toJson());
      PDFSettings newSettings = PDFSettings.fromJson(jsonDecode(jsonBook));
      expect(settings, newSettings);
    });

    test('file meta json', () async {
      BookFileMeta fileMeta = BookFileMeta.asset();
      String jsonFileMeta = jsonEncode(fileMeta.toJson());
      BookFileMeta newFileMeta =
          BookFileMeta.fromJson(jsonDecode(jsonFileMeta));
      expect(fileMeta, newFileMeta);
    });
    test('book json', () async {
      BookModel book = BookModel.asset();
      String jsonBook = jsonEncode(book.toJson());
      BookModel newBook = BookModel.fromJson(jsonDecode(jsonBook));
      expect(book, newBook);
    });
  });
}
