import 'package:flashcards_reader/util/constants.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/views/flashcards/new_word/new_word_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quick_actions/quick_actions.dart';

import 'flashcards/quiz/quiz_menu.dart';
import 'menu/drawer_menu.dart';

class BaseStatelessScreen extends StatelessWidget {
  final Widget page;
  const BaseStatelessScreen({required this.page, super.key});

  @override
  Widget build(BuildContext context) {
    return page;
  }
}

class BaseStatefulScreen extends StatefulWidget {
  BaseStatefulScreen({required this.page, super.key});
  final Widget page;
  String shortcut = 'no action set';
  @override
  BaseStatefulScreenState createState() => BaseStatefulScreenState();
}

class BaseStatefulScreenState extends State<BaseStatefulScreen> {
  @override
  void initState() {
    debugPrintIt('load shortcut actions in initState()');
    const QuickActions quickActions = QuickActions();
    quickActions.initialize((String shortcutType) {
      setState(() {
        widget.shortcut = shortcutType;
      });
    });

    quickActions.setShortcutItems(<ShortcutItem>[
      // NOTE: This first action icon will only work on iOS.
      // In a real world project keep the same file name for both platforms.
      const ShortcutItem(
        type: addWordAction,
        localizedTitle: addWordAction,
        icon: 'add_circle',
      ),
      // NOTE: This second action icon will only work on Android.
      // In a real world project keep the same file name for both platforms.
      const ShortcutItem(
          type: quizAction, localizedTitle: quizAction, icon: 'quiz'),
    ]).then((void _) {
      setState(() {
        if (widget.shortcut == 'no action set') {
          widget.shortcut = 'actions ready';
        }
      });
    });

    super.initState();
  }

  Widget shortCutWrapper() {
    if (widget.shortcut == addWordAction) {
      return AddWordFastScreen();
    } else if (widget.shortcut == quizAction) {
      return const QuizMenu();
    } else {
      return widget.page;
    }
  }

  @override
  Widget build(BuildContext context) {
    return shortCutWrapper();
  }
}
