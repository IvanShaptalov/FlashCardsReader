import 'dart:io';

import 'package:flashcards_reader/model/entities/reader/book_model.dart';
import 'package:flashcards_reader/model/entities/reader/book_parser/epub.dart';
import 'package:flashcards_reader/model/entities/reader/book_parser/fb2.dart';
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
      expect(model.path,
          '/data/user/0/com.example.flashcards_reader/cache/assets/book/quotes.txt');
      expect(model.file.ext, '.txt');
      expect(File(model.path).existsSync(), true);

      File(model.path).deleteSync();
      expect(File(model.path).existsSync(), false);
    });

    testWidgets('fb2 format', (tester) async {
      var model = await BinderFB2().bind(
          await BookModel.asset().getFileFromAssets('assets/test/test.fb2'));
      debugPrintIt(model);
      expect(model.title, 'test.fb2');
      expect(model.coverPath.endsWith('.jpg'), true);
      expect(model.author, 'Андрей Первухин;');
      expect(model.path,
          '/data/user/0/com.example.flashcards_reader/cache/assets/test/test.fb2');
      expect(model.file.ext, '.fb2');
      expect(File(model.path).existsSync(), true);

      File(model.path).deleteSync();
      expect(File(model.path).existsSync(), false);
    });

    testWidgets('pdf format', (tester) async {
      var model = await BinderPdf.bind(
          await BookModel.asset().getFileFromAssets('assets/test/test.pdf'));
      debugPrintIt(model);
      expect(model.title, 'test.pdf');
      expect(model.coverPath.endsWith('.png'), true);
      expect(model.author, '');
      expect(model.path,
          '/data/user/0/com.example.flashcards_reader/cache/assets/test/test.pdf');
      expect(model.file.ext, '.pdf');
      expect(File(model.path).existsSync(), true);

      File(model.path).deleteSync();
      expect(File(model.path).existsSync(), false);
    });

    testWidgets('epub format', (tester) async {
      var model = await BinderEpub().bind(
          await BookModel.asset().getFileFromAssets('assets/test/test.epub'));
      debugPrintIt(model);
      expect(model.title, 'Thus Spake Zarathustra: A Book for All and None');
      expect(model.coverPath.endsWith('jpg'), true);
      expect(model.author, 'Friedrich Wilhelm Nietzsche');
      expect(model.path,
          '/data/user/0/com.example.flashcards_reader/cache/assets/test/test.epub');
      expect(model.file.ext, '.epub');
      expect(File(model.path).existsSync(), true);

      File(model.path).deleteSync();
      expect(File(model.path).existsSync(), false);
    });
  });
}
