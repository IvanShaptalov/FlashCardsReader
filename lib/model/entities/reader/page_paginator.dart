import 'dart:ui';

import 'package:flashcards_reader/bloc/book_listing_bloc/book_listing_bloc.dart';
import 'package:flashcards_reader/model/entities/reader/book_model.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PagePaginatorProvider {
  static bool needToSetupPages = false;
  static TextStyle get getTextStyle => TextStyle(
      fontSize: bookSettings.fontSize.toDouble(),
      fontFamily: bookSettings.fontFamily);

  static set textStyle(TextStyle style) {
    if (style.fontSize != null) {
      bookSettings.fontSize = style.fontSize!.toInt();
    }
    if (style.fontSize != null) {
      bookSettings.fontFamily = style.fontFamily!;
    }
  }

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
  static List<String> pages = [];
  static String bookText = '';

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

  static int setupPages(Size pageSize) {
    pages = [];

    final textSpan = TextSpan(
      text: bookText,
      style: getTextStyle,
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
        final pageText =
            bookText.substring(currentPageStartIndex, currentPageEndIndex);
        pages.add(pageText);

        currentPageStartIndex = currentPageEndIndex;
        currentPageBottom = top + pageSize.height;
      }
    }

    final lastPageText = bookText.substring(currentPageStartIndex);
    pages.add(lastPageText);

    return pages.length;
  }

  static Future<String>? loadBook(BuildContext context) {
    return book.getAllTextAsync().then((value) {
      bookText = value;

      return value;
    });
  }
}
