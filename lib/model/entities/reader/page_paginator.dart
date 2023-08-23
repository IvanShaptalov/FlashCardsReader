import 'package:flashcards_reader/bloc/book_listing_bloc/book_listing_bloc.dart';
import 'package:flashcards_reader/model/entities/reader/book_model.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Page {
  final String text;

  const Page(this.text);

  @override
  String toString() => text;
}

class PagePaginatorProvider {
  static BookModel book = BookModel.asset();
  static int currentPage = 1;
  static int get maxPage => pages.length-1;
  static double minPage = 0;
  static BookSettings get bookSettings => book.settings;
  static List<Page> pages = [];
  static String bookText = '';
  static TextStyle font = const TextStyle();

  static bool _hideBar = false;
  static get hideBar => _hideBar;
  static String selectedText = '';
  static void switchBar() {
    _hideBar = !_hideBar;
    if (_hideBar) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: SystemUiOverlay.values);
    }
  }

  static DateTime lastPageUpdate = DateTime.now();

  static void updateCurrentPageWithMultiplier(
      double fontSize, double previousFontSize, BuildContext context) {
    double multiplier = (fontSize.toInt() / previousFontSize).abs();
    if (multiplier > 1) {
      multiplier = (previousFontSize / fontSize.toInt()).abs();
    }
    PagePaginatorProvider.updateBookPage(
        (PagePaginatorProvider.bookSettings.currentPage * multiplier).round(),
        context);
  }

  /// use context that contains <BookBloc>
  static void updateBookPage(int value, context) {
    // if update lesser than 1 second - wait for database
    if (PagePaginatorProvider.currentPage != value.round()) {
      PagePaginatorProvider.currentPage = value.round();
    }

    if (lastPageUpdate.difference(DateTime.now()).abs() >
        const Duration(seconds: 1)) {
      debugPrintIt('request updated');
      lastPageUpdate = DateTime.now();
      debugPrintIt(
          '''save current page ${PagePaginatorProvider.currentPage} to book : ${book.title}''');
      BlocProvider.of<BookBloc>(context)
          .add(UpdateBookEvent(bookModel: PagePaginatorProvider.book));
    }
  }

  static void dispose() {
    _hideBar = false;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  static int setupPages(BuildContext context, double appBarHeigth) {
    debugPrintIt('appbarHeight: $appBarHeigth');
    int charCount = bookText.length;
    double pageWidgth = SizeConfig.getMediaWidth(context);
    double pageHeigth = SizeConfig.getMediaHeight(context) -
        SizeConfig.getMediaHeight(context, p: 0.3);
    double fontSize = bookSettings.fontSize.toDouble();
    debugPrintIt('''
        PAGEWIDTH: $pageWidgth
        PAGEHEIGTH: $pageHeigth
        CHARS: $charCount
        fontSize: $fontSize''');

    final characterHeight = fontSize;
    final characterWidth = characterHeight * 0.75;
    int charOnPage =
        ((pageHeigth * pageWidgth) / (characterHeight * characterWidth)).ceil();

    debugPrintIt('''
        charOnPage: $charOnPage
    ''');
    int pages = createPages(charOnPage);
    return pages;
  }

  static int createPages(int charOnPage) {
    pages = [];
    int pagesCount = (bookText.length / charOnPage).ceil();
    if (pagesCount <= 1) {
      pagesCount = 1;
      pages.add(Page(bookText));
      return pagesCount.toInt();
    }
    for (int i = 0; i < pagesCount; i++) {
      int start = i * charOnPage;
      int end = start + charOnPage;
      if (end > bookText.length) {
        String tmpBookText = bookText.substring(start);
        pages.add(Page(tmpBookText));
      } else {
        String tmpBookText = bookText.substring(start, end);
        pages.add(Page(tmpBookText));
      }
    }
    return pagesCount.ceil();
  }

  static Future<String>? loadBook(BuildContext context) {
    return book.getAllTextAsync().then((value) {
      bookText = value;

      return value;
    });
  }
}
