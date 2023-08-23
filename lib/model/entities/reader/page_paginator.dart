import 'package:flashcards_reader/model/entities/reader/book_model.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flutter/material.dart';

class Page {
  final String text;

  const Page(this.text);
}

class PagePaginator {
  static BookModel _book = BookModel.asset();
  static set book(book) => _book = book;
  static BookSettings get bookSettings => _book.settings;
  static List<Page> pages = [];
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
    double charOnLine = pageWidgth / fontSize;
    double lineCount = pageHeigth / (lineHeigth * 2 * fontSize);
    double charOnPage = charOnLine * lineCount;
    debugPrintIt('''
        charOnLine: $charOnLine
        lineCount: $lineCount
        charOnPage: $charOnPage
    ''');
    createPages(charOnPage.round());
    return 10;
  }

  static int createPages(int charOnPage) {
    pages = [];
    int pagesCount = (bookText.length / charOnPage).round();
    for (int i = 0; i < pagesCount; i++) {
      if ((i + 1) * charOnPage > bookText.length) {
        String tmpBookText = bookText.substring(i * charOnPage);
        pages.add(Page(tmpBookText));
      } else {
        String tmpBookText = bookText.substring(i * charOnPage, charOnPage);
        pages.add(Page(tmpBookText));
      }
    }
    return pagesCount;
  }

  static Future<String>? loadBook(BuildContext context) {
    return _book.getAllTextAsync().then((value) {
      bookText = value;

      return value;
    });
  }
}
