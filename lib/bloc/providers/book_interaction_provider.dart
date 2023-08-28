import 'dart:ui';

import 'package:flashcards_reader/bloc/book_listing_bloc/book_listing_bloc.dart';
import 'package:flashcards_reader/model/entities/reader/book_model.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookInteractivityProvider {
  /// ===================================[HELPING FIELDS]
  static set textStyle(TextStyle style) {
    _book.settings.fontSize = style.fontSize!;
    _book.settings.fontFamily = style.fontFamily!;
  }

  static TextStyle get getBookTextStyle => TextStyle(
      fontSize: _book.settings.fontSize.toDouble(),
      fontFamily: _book.settings.fontFamily);

  static bool needToUpdatePagesFromUI = false;

  static DateTime lastPageUpdate = DateTime.now();

  static String get getAuthor =>
      _book.author.isNotEmpty ? _book.author : 'no author';
  static String get label =>
      '''${(_currentPage + 1).toInt()} of ${upperBoundPage + 1}''';

  /// ====================================[BOOK INITIALIZATION]
  static BookModel _book = BookModel.asset();
  static BookModel get getBook => _book;

  static String _loadedBookText = '';
  static String get loadedBookText => _loadedBookText;

  static void setUpTextBook(BookModel book) {
    _book = book;
  }

  static Future<String>? loadBook(BuildContext context) {
    return _book.getAllTextAsync().then((value) {
      _loadedBookText = value;

      return value;
    });
  }

  /// ====================================[WORK WITH PAGES]
  static num lowerBoundPage = 0;
  static num upperBoundPage = _pages.length;

  static num _currentPage = 0;
  static num get currentPage => _currentPage;

  // loaded pages
  static List<String> _pages = [];
  static get pages => _pages;

  /// ====================================[SETUPS PAGES]
  static void setupPages(Size pageSize, BuildContext context) {
    needToUpdatePagesFromUI = false;

    _pages = [];

    final textSpan = TextSpan(
      text: _loadedBookText,
      style: getBookTextStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: pageSize.width,
    );

    // https://medium.com/swlh/flutter-line-metrics-fd98ab180a64
    List<LineMetrics> lines = textPainter.computeLineMetrics();
    double currentPageBottom = pageSize.height;
    int currentPageStartIndex = 0;
    int currentPageEndIndex = 0;

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];

      final left = line.left;
      final top = line.baseline - line.ascent;
      final bottom = line.baseline + line.descent;

      // Current line overflow page
      if (currentPageBottom < bottom) {
        // https://stackoverflow.com/questions/56943994/how-to-get-the-raw-text-from-a-flutter-textbox/56943995#56943995
        currentPageEndIndex =
            textPainter.getPositionForOffset(Offset(left, top)).offset;
        final pageText = _loadedBookText.substring(
            currentPageStartIndex, currentPageEndIndex);
        _pages.add(pageText);

        currentPageStartIndex = currentPageEndIndex;
        currentPageBottom = top + pageSize.height;
      }
    }

    final lastPageText = loadedBookText.substring(currentPageStartIndex);
    _pages.add(lastPageText);
    saveBookToDB(context);
  }

  /// for example
  /// current page 100
  /// font 10
  /// new font 20
  /// 100 * 10 = 20 * x
  /// 20x = 1000
  /// x = (10 * 100) / 20
  /// x = (oldFontSize * currentPage) / fontSize
  /// x = 50
  /// new page = 50
  static void updateBookPage(
      {required double fontSize,
      required double oldFontSize,
      required BuildContext context}) {
    if (fontSize != oldFontSize) {
      int newPageNumber = ((_currentPage * oldFontSize) / fontSize).round();

      int validatedPageNumber = validatePageNumber(newPageNumber);
      if (_currentPage != validatedPageNumber.round()) {
        _currentPage = validatePageNumber(validatedPageNumber.round());
      }
    }

    saveBookToDB(context);
  }

  static void saveBookToDB(BuildContext context) {
    debugPrintIt('request updated');
    lastPageUpdate = DateTime.now();

    debugPrintIt(
        '''save current page $_currentPage to book : ${_book.title}''');
    BlocProvider.of<BookBloc>(context).add(UpdateBookEvent(bookModel: _book));
  }

  static void updatePageFont(
      {required String newFontFamily,
      required double newFontSize,
      required oldFontSize,
      required BuildContext context}) {
    needToUpdatePagesFromUI = true;

    _book.settings.fontFamily = newFontFamily;
    debugPrintIt('saved: ${_book.settings.fontFamily}');
    _book.settings.fontSize = newFontSize;

    updateBookPage(
        fontSize: newFontSize, oldFontSize: oldFontSize, context: context);
  }

  /// use context that contains <BookBloc>

  /// ===============================================[UTIL METHODS]
  static int validatePageNumber(int pageNumber) {
    return pageNumber = (pageNumber > upperBoundPage
            ? upperBoundPage
            : pageNumber < lowerBoundPage
                ? lowerBoundPage
                : pageNumber)
        .toInt();
  }

  static void changeCurrentPage(int page) => _currentPage = page;
}

class TextSelectorProvider {
  static String selectedText = '';
}

class BookNotesProvider {
  /// check that context has BookBloc
  static void updateNotes(
      {required String note,
      required BuildContext context,
      required BookModel book}) {
    book.bookNotes.notes.addAll({note: 'add your comment'});
    BlocProvider.of<BookBloc>(context).add(UpdateBookEvent(bookModel: book));
  }
}

class AppBarProvider {
  static bool _hideBar = false;
  static get hideBar => _hideBar;
  static void switchBar() {
    _hideBar = !_hideBar;
  }

  static void dispose() {
    _hideBar = false;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }
}
