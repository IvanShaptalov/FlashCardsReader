import 'package:flashcards_reader/model/entities/reader/book_model.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flutter/material.dart';

class Page {
  List<String> words = [];
}

class PagePaginator {
  static BookModel _book = BookModel.asset();
  static set book(book) => _book = book;
  static BookSettings get bookSettings => _book.settings;
  List<Page> pages = [];
  static String bookText = '';

  static int setupPages(BuildContext context, double appBarHeigth) {
    int charCount = bookText.length;
    double pageWidgth = SizeConfig.getMediaWidth(context);
    double pageHeigth = SizeConfig.getMediaHeight(context) - appBarHeigth * 2;
    String font = bookSettings.fontFamily;
    double fontSize = bookSettings.fontSize.toDouble();
    double letterSpacing = bookSettings.letterSpacing;
    double lineHeigth = bookSettings.lineHeight;
    debugPrintIt('''
        PAGEWIDTH: $pageWidgth
        PAGEHEIGTH: $pageHeigth
        CHARS: $charCount
        font: $font
        fontSize: $fontSize
        letterSpacing: $letterSpacing
        lineHeigth: $lineHeigth''');
    return 10;
  }

  static Future<String>? loadBook(BuildContext context) {
    return _book.getAllTextAsync().then((value) {
      bookText = value;

      return value;
    });
  }
}
