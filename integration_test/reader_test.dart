import 'dart:io';
import 'dart:ui';

import 'package:flashcards_reader/bloc/providers/book_pagination_provider.dart';
import 'package:flashcards_reader/database/core/table_methods.dart';
import 'package:flashcards_reader/model/entities/reader/book_model.dart';
import 'package:flashcards_reader/model/entities/reader/book_parser/epub.dart';
import 'package:flashcards_reader/model/entities/reader/book_parser/pdf.dart';
import 'package:flashcards_reader/model/entities/reader/book_parser/txt.dart';

import 'package:flashcards_reader/main.dart' as app;
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  await app.main();
  group('scanners', () {
    testWidgets('txt format', (tester) async {
      var model = await BinderTxt.bind(
          await BookModel.asset().getFileFromAssets('assets/book/quotes.txt'));
      debugPrintIt(model);
      expect(model.title, 'quotes.txt');
      expect(model.coverPath, 'assets/images/empty.png');
      expect(model.author, '');
      expect(model.fileMeta.path,
          '/data/user/0/com.example.flashcards_reader/cache/assets/book/quotes.txt');
      expect(model.fileMeta.ext, '.txt');
      expect(File(model.fileMeta.path).existsSync(), true);

      File(model.fileMeta.path).deleteSync();
      expect(File(model.fileMeta.path).existsSync(), false);
    });

    testWidgets('pdf format', (tester) async {
      var model = await BinderPdf.bind(
          await BookModel.asset().getFileFromAssets('assets/test/test.pdf'));
      debugPrintIt(model);
      expect(model.title, 'test.pdf');
      expect(model.coverPath.endsWith('.png'), true);
      expect(model.author, '');
      expect(model.fileMeta.path,
          '/data/user/0/com.example.flashcards_reader/cache/assets/test/test.pdf');
      expect(model.fileMeta.ext, '.pdf');
      expect(File(model.fileMeta.path).existsSync(), true);

      File(model.fileMeta.path).deleteSync();
      expect(File(model.fileMeta.path).existsSync(), false);
    });

    testWidgets('epub format', (tester) async {
      var model = await BinderEpub().bind(
          await BookModel.asset().getFileFromAssets('assets/test/test.epub'));
      debugPrintIt(model);
      expect(model.title, 'Thus Spake Zarathustra: A Book for All and None');
      expect(model.coverPath.endsWith('jpg'), true);
      expect(model.author, 'Friedrich Wilhelm Nietzsche');
      expect(model.fileMeta.path,
          '/data/user/0/com.example.flashcards_reader/cache/assets/test/test.epub');
      expect(model.fileMeta.ext, '.epub');
      expect(File(model.fileMeta.path).existsSync(), true);

      File(model.fileMeta.path).deleteSync();
      expect(File(model.fileMeta.path).existsSync(), false);
    });
  });

  group('book paginator', () {
    testWidgets('initialization', (tester) async {
      var bookModel = await BinderTxt.bind(
          await BookModel.asset().getFileFromAssets('assets/book/quotes.txt'));

      BookDatabaseProvider.writeEditAsync(bookModel, isTest: true);

      BookPaginationProvider.setUpBook(bookModel);

      expect(BookPaginationProvider.book, bookModel);
    });

    testWidgets('setUp pages', (tester) async {
      Size pageSize = const Size(50, 20);
      BookPaginationProvider.book.settings.currentPage = 10;

      await BookPaginationProvider.loadBook();
      BookPaginationProvider.book.settings.fontSize = 10;

      BookPaginationProvider.initPages(pageSize, null, isTest: true);
      expect(BookPaginationProvider.upperBoundPage, 57);
      expect(BookPaginationProvider.currentPage, 10);

      debugPrintIt(BookPaginationProvider.pages.length);

      debugPrintIt(BookPaginationProvider.book.settings.currentPage);

      BookPaginationProvider.updatePageFont(
          newFontFamily: BookPaginationProvider.book.settings.fontFamily,
          newFontSize: 20,
          context: null,
          pageSize: pageSize,
          isTest: true);

      expect(BookPaginationProvider.currentPage, 20);
      expect(BookPaginationProvider.upperBoundPage, 105);

      BookPaginationProvider.updatePageFont(
          newFontFamily: BookPaginationProvider.book.settings.fontFamily,
          newFontSize: 10,
          context: null,
          pageSize: pageSize,
          isTest: true);

      expect(BookPaginationProvider.currentPage, 10);
      expect(BookPaginationProvider.upperBoundPage, 57);

      BookPaginationProvider.book.settings.currentPage = 57;

      BookPaginationProvider.updatePageFont(
          newFontFamily: BookPaginationProvider.book.settings.fontFamily,
          newFontSize: 20,
          context: null,
          pageSize: pageSize,
          isTest: true);

      expect(BookPaginationProvider.currentPage, 104);
      expect(BookPaginationProvider.upperBoundPage, 105);
    });

    testWidgets('upperBound and lowerBound', (tester) async {
      Size pageSize = const Size(50, 20);
      BookPaginationProvider.book.settings.currentPage = 40;

      await BookPaginationProvider.loadBook();
      BookPaginationProvider.book.settings.fontSize = 10;

      BookPaginationProvider.initPages(pageSize, null, isTest: true);
      expect(BookPaginationProvider.upperBoundPage, 57);
      expect(BookPaginationProvider.currentPage, 40);

      BookPaginationProvider.updatePageFont(
          newFontFamily: BookPaginationProvider.book.settings.fontFamily,
          newFontSize: 5,
          context: null,
          pageSize: pageSize,
          isTest: true);

      expect(BookPaginationProvider.currentPage,
          BookPaginationProvider.upperBoundPage - 1);
    });
  });
}
