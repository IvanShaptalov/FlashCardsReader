import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/util/router.dart';
import 'package:flashcards_reader/views/flashcards/flashcards/add_flashcard_widget.dart';
import 'package:flashcards_reader/views/flashcards/quiz/quiz_menu.dart';
import 'package:flashcards_reader/views/menu/drawer_menu.dart';
import 'package:flutter/material.dart';

class BaseScreenNewWord {
  String oldWord = '';

  dynamic widget;
  BaseScreenNewWord(this.widget);
  double appBarHeight = 0;
  void putSelectedCardToFirstPosition(List<FlashCardCollection> collection) {
    var selected = FlashCardProvider.fc;
    var index = collection.indexWhere((element) => element == selected);
    if (index != -1) {
      collection.removeAt(index);
      collection.insert(0, selected);
    }
  }

  AppBar getAppBar(flashCardCollection) {
    return AppBar(
      title: const Text('Add word'),
    );
  }

  Widget? getDrawer() {
    return MenuDrawer(appBarHeight);
  }

  void backToStartCallback() {
    widget.scrollController.animateTo(
      0.toDouble(),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  List<Widget> bottomNavigationBarItems(BuildContext context, dynamic widget) {
    // dont show merge button or deactivate merge mode
    return [
      IconButton(
        icon: const Icon(Icons.book),
        onPressed: () {},
      ),

      /// show merge button if merge mode is available
      IconButton(
        icon: const Icon(Icons.quiz),
        onPressed: () {
          MyRouter.pushPageReplacement(context, const QuizMenu());
        },
      ),
    ];
  }
}
