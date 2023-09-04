import 'dart:ui';

import 'package:flashcards_reader/bloc/book_listing_bloc/book_listing_bloc.dart';
import 'package:flashcards_reader/database/core/table_methods.dart';
import 'package:flashcards_reader/model/entities/reader/book_model.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/util/regex_util.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookPaginationProvider {
  /// ===================================[HELPING FIELDS]
  static set textStyle(TextStyle style) {
    book.settings.fontSize = style.fontSize!;
    book.settings.fontFamily = style.fontFamily!;
  }

  static bool get isOnePage => upperBoundPage <= 1;

  static TextStyle get getBookTextStyle => TextStyle(
      fontSize: book.settings.fontSize.toDouble(),
      fontFamily: book.settings.fontFamily);

  static bool needToUpdatePagesFromUI = true;

  static DateTime lastPageUpdate = DateTime.now();

  static String get getAuthor =>
      book.author.isNotEmpty ? book.author : 'no author';
  static String get label =>
      '''${(_currentPage + 1).toInt()} of ${upperBoundPage.toInt()}''';

  /// ====================================[BOOK INITIALIZATION]
  static BookModel book = BookModel.asset();

  static String _loadedBookText = '';
  static String get loadedBookText => _loadedBookText;

  static void setUpBook(BookModel paramBook) {
    book = paramBook;
  }

  static Future<String>? loadBook({BuildContext? context}) {
    debugPrintIt(
        'only one load!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
    BookPaginationProvider.needToUpdatePagesFromUI = true;
    return book.getAllTextAsync().then((value) {
      _loadedBookText = regexFixParagraph(value);

      return _loadedBookText;
    }).then((value) async {
      initPages(SizeConfig.size(context!), context);
      return value;
    });
  }

  /// ====================================[WORK WITH PAGES]
  static double lowerBoundPage = 0;
  static double get upperBoundPage => _pages.length.toDouble();

  static int get _currentPage => validatePageNumber(book.settings.currentPage);
  static int get currentPage => _currentPage;

  // loaded pages
  static List<String> _pages = [];
  static List<String> get pages => _pages;

  /// ====================================[SETUP PAGES]
  /// run [loadBook()] method to setup book pages
  static void initPages(Size pageSize, BuildContext? context,
      {isTest = false}) {
    if (!isTest) {
      assert(context != null, 'context must not be null in real session');
    }

    if (_loadedBookText.isEmpty) {
      debugPrintIt('empty book');
      return;
    }
    needToUpdatePagesFromUI = false;

    _pages = [];

    final textSpan = TextSpan(
      text: _loadedBookText,
      style: getBookTextStyle,
    );
    final textPainter = TextPainter(
      textAlign: TextAlign.start,
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
      if (currentPageBottom <= bottom) {
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

    final lastPageText = _loadedBookText.substring(currentPageStartIndex);
    _pages.add(lastPageText);
    _saveBookToDB(context: context, isTest: isTest);
  }

  /// page 10 font 10, x page font 20
  /// 10x = 10 * 20
  /// x = (10 * 20) / 10
  /// x = (currentPage10 * pageFont20) / oldFont10
  /// x = 200 / 10
  /// x = 20
  /// newPage = 20;
  static void jumpToPageWithFont(
      {required double newFontSize,
      required double oldFontSize,
      required BuildContext? context,
      isTest = false}) {
    if (!isTest) {
      assert(context != null, "context must not be null in real session");
    }
    if (newFontSize != oldFontSize) {
      int newPageNumber =
          (((_currentPage == 0 ? _currentPage + 1 : currentPage) *
                      newFontSize) /
                  oldFontSize)
              .round();

      jumpToPage(context: context, pageNumber: newPageNumber, isTest: isTest);
    }

    _saveBookToDB(context: context, isTest: isTest);
  }

  static void jumpToPage(
      {required BuildContext? context,
      required int pageNumber,
      isTest = false}) {
    int validatedPageNumber = validatePageNumber(pageNumber);
    if (_currentPage != validatedPageNumber.round()) {
      book.settings.currentPage = validatedPageNumber;
      _saveBookToDB(context: context, isTest: isTest);
    }
  }

  static void updatePageFont(
      {required String newFontFamily,
      required double newFontSize,
      required BuildContext? context,
      required Size pageSize,
      isTest = false}) {
    if (!isTest) {
      assert(context != null, 'context must not be null is real session');
    }
    needToUpdatePagesFromUI = true;
    double oldFontSize = book.settings.fontSize.toDouble();
    book.settings.fontFamily = newFontFamily;
    book.settings.fontSize = newFontSize.toDouble();
    debugPrintIt('saved: ${book.settings.fontFamily}');
    debugPrintIt('font size: ${book.settings.fontSize}');

    initPages(pageSize, context, isTest: isTest);

    jumpToPageWithFont(
        newFontSize: newFontSize,
        oldFontSize: oldFontSize,
        context: context,
        isTest: isTest);
  }

  /// use context that contains <BookBloc>

  /// ===============================================[UTIL METHODS]
  static void _saveBookToDB({BuildContext? context, isTest = false}) {
    if (!isTest) {
      assert(context != null, 'context must not be null in real session');
      debugPrintIt('request updated');
      lastPageUpdate = DateTime.now();

      debugPrintIt(
          '''save current page $_currentPage to book : ${book.title}''');
      BlocProvider.of<BookBloc>(context!).add(UpdateBookEvent(bookModel: book));
    } else if (isTest) {
      BookDatabaseProvider.writeEditAsync(book);
    }
  }

  static int validatePageNumber(int pageNumber) {
    return pageNumber = (pageNumber >= upperBoundPage
            ? upperBoundPage - 1
            : pageNumber <= lowerBoundPage
                ? lowerBoundPage
                : pageNumber)
        .toInt();
  }
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
  }
}
