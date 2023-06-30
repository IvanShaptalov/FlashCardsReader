import 'package:flashcards_reader/constants.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/views/flashcards/quiz/quiz_menu.dart';
import 'package:flutter/material.dart';

import 'views/flashcards/new_word/new_word_screen.dart';

class ShortcutsProvider {
  static String shortcut = 'no action set';

  static Widget wrapper({required Widget child}) {
    debugPrintIt(
        ' ========================================== $shortcut ==========================================');
    if (shortcut == addWordAction) {
      shortcut = 'no action set';
      return AddWordFastScreen();
    } else if (shortcut == quizAction) {
      shortcut = 'no action set';
      return const QuizMenu();
    } else {
      return child;
    }
  }
}
