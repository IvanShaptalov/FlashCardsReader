import 'package:flashcards_reader/util/constants.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/util/router.dart';
import 'package:flashcards_reader/views/flashcards/quiz/quiz_menu.dart';
import 'package:flutter/material.dart';

import 'views/flashcards/new_word/new_word_screen.dart';

class QuickActionProvider {
  static String shortcut = 'no action set';
  static void pushMenu(Widget page, context) {
    debugPrintIt(shortcut);
    if (shortcut == addWordAction) {
      shortcut = 'no action set';
      MyRouter.pushPageReplacement(context, AddWordFastScreen());
    } else if (shortcut == quizAction) {
      shortcut = 'no action set';
      MyRouter.pushPageReplacement(context, const QuizMenu());
    } else {
      MyRouter.pushPage(context, page);
    }
  }

  static void init() {
    //TODO later
  }
}
