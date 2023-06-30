import 'package:flashcards_reader/constants.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/views/flashcards/new_word/new_word_screen.dart';
import 'package:flashcards_reader/views/flashcards/quiz/quiz_menu.dart';
import 'package:flutter/material.dart';
import 'package:quick_actions/quick_actions.dart';

// ignore: must_be_immutable
class ParentStatelessWidget extends StatelessWidget {
  // not checked for functionality
  Widget page = const Center(child: Text('no page set'));
  String shortcut = 'no action set';

  ParentStatelessWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return shortCutWrapper();
  }

  Widget shortCutWrapper() {
    if (shortcut == addWordAction) {
      return AddWordFastScreen();
    } else if (shortcut == quizAction) {
      return const QuizMenu();
    } else {
      return page;
    }
  }
}

// ignore: must_be_immutable
class ParentStatefulWidget extends StatefulWidget {
  Widget? page;
  String shortcut = 'no action set';

  ParentStatefulWidget({super.key});
  @override
  ParentState createState() => ParentState();
}

class ParentState<T extends ParentStatefulWidget> extends State<T> {
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

  void bindPage(Widget page) {
    widget.page = page;
  }

  Widget shortCutWrapper() {
    if (widget.shortcut == addWordAction) {
      return AddWordFastScreen();
    } else if (widget.shortcut == quizAction) {
      return const QuizMenu();
    } else {
      return widget.page ??
          const Center(child: Text('no page set, use bindPage() method'));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.page != null) {
      debugPrintIt('load only one page');
      return shortCutWrapper();
    }
    debugPrintIt('load selected page');
    var selectedPage = widget.page;
    widget.page = selectedPage;
    return shortCutWrapper();
  }
}
