import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flashcards_reader/views/reader/tabs/settings.dart';
import 'package:flutter/widgets.dart';

/// [PageCounter] split text files to pages
class PageCounter {
  static int calculatePages(String text, BookSettings settings) {
    debugPrintIt(text);
    return 3;
  }

  static int maxLines(BuildContext context, double appBarHeight, int fontSize,
      {required double lineHeight}) {
    int lines =
        (SizeConfig.getMediaHeight(context) - appBarHeight) ~/ fontSize - 3;
    debugPrintIt(lines);
    return lines;
  }
}
