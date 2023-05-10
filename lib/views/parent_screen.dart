import 'package:flashcards_reader/util/constants.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/views/flashcards/new_word/new_word_screen.dart';
import 'package:flashcards_reader/views/flashcards/quiz/quiz_menu.dart';
import 'package:flutter/material.dart';
import 'package:quick_actions/quick_actions.dart';

// ignore: must_be_immutable
class ParentStatefulWidget extends StatefulWidget {
  Widget page = const Center(child: Text('no page set'));
  String shortcut = 'no action set';

  ParentStatefulWidget({super.key});
  @override
  ParentStatefulWidgetState createState() => ParentStatefulWidgetState();
}

class ParentStatefulWidgetState<T extends ParentStatefulWidget>
    extends State<T> {
  // shortcut modification
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
      const ShortcutItem(
        type: addWordAction,
        localizedTitle: addWordAction,
        icon: 'add_circle',
      ),
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
    // TODO: implement build
    return shortCutWrapper();
  }
}
