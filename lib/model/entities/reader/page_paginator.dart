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
  /// check that context has BookBloc
  static void updateNotes(
      {required String note, required BuildContext context}) {
    PagePaginatorProvider.book.bookNotes.notes
        .addAll({note: 'add your comment'});
    BlocProvider.of<BookBloc>(context)
        .add(UpdateBookEvent(bookModel: PagePaginatorProvider.book));
  }

  static String get getAuthor => PagePaginatorProvider.book.author.isNotEmpty
      ? PagePaginatorProvider.book.author
      : 'no author';
  static String get label =>
      '''${(_currentPage + 1).toInt()} of ${upperBoundPage + 1}''';
  static BookModel book = BookModel.asset();
  static int get _currentPage => bookSettings.currentPage;
  static set _currentPage(value) => bookSettings.currentPage = value;
  static set currentPage(value) {
    _currentPage = validatePageNumber(value);
  }

  static get currentPage => _currentPage;

  static int get upperBoundPage => pages.length - 1;
  static double lowerBoundPage = 0;
  static BookSettings get bookSettings => book.settings;
  static List<Page> pages = [];
  static String bookText = '';
  static TextStyle font = const TextStyle();

  static bool _hideBar = false;
  static get hideBar => _hideBar;
  static String selectedText = '';
  static void switchBar() {
    _hideBar = !_hideBar;
  }

  static DateTime lastPageUpdate = DateTime.now();

  static int validatePageNumber(int pageNumber) {
    return pageNumber = (pageNumber > upperBoundPage
            ? upperBoundPage
            : pageNumber < lowerBoundPage
                ? lowerBoundPage
                : pageNumber)
        .toInt();
  }

  static void updateCurrentPageWithMultiplier(
      double fontSize, double previousFontSize, BuildContext context) {
    double multiplier = (fontSize.toInt() / previousFontSize).abs();
    if (multiplier > 1) {
      multiplier = (previousFontSize / fontSize.toInt()).abs();
    }
    int newPageNumber =
        (PagePaginatorProvider.bookSettings.currentPage * multiplier).round();

    int validatedPageNumber = validatePageNumber(newPageNumber);

    PagePaginatorProvider.updateBookPage(validatedPageNumber, context,
        ignoreDuration: true);
  }

  /// use context that contains <BookBloc>
  static void updateBookPage(int value, context,
      {bool ignoreDuration = false}) {
    // if update lesser than 1 second - wait for database
    if (PagePaginatorProvider._currentPage != value.round()) {
      PagePaginatorProvider._currentPage = validatePageNumber(value.round());
    }

    if (lastPageUpdate.difference(DateTime.now()).abs() >
            const Duration(seconds: 1) &&
        !ignoreDuration) {
      debugPrintIt('request updated');
      lastPageUpdate = DateTime.now();

      debugPrintIt(
          '''save current page ${PagePaginatorProvider._currentPage} to book : ${book.title}''');
      BlocProvider.of<BookBloc>(context)
          .add(UpdateBookEvent(bookModel: PagePaginatorProvider.book));
    }
  }

  static void dispose() {
    _hideBar = false;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  static int setupPages(BuildContext context, appBarHeigth) {
    int charCount = bookText.length;
    double pageWidgth = SizeConfig.getMediaWidth(context);
    double pageHeigth = SizeConfig.getMediaHeight(context) -
        SizeConfig.getMediaHeight(context, p: 0.3) -
        appBarHeigth;
    double fontSize = bookSettings.fontSize.toDouble();
    debugPrintIt('''
        PAGEWIDTH: $pageWidgth
        PAGEHEIGTH: $pageHeigth
        CHARS: $charCount
        fontSize: $fontSize''');

    final characterHeight = fontSize;
    final characterWidth = characterHeight * 0.66;
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
