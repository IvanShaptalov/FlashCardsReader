import 'package:flashcards_reader/util/constants.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/views/menu/bottom_nav_bar.dart';
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
      BottomNavBar.setPageIndex(BottomNavPages.quiz);
      return BottomNavBar();
    } else {
      return child;
    }
  }
}
