import 'package:flashcards_reader/bloc/providers/word_collection_provider.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/model/entities/reader/book_model.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flashcards_reader/views/menu/side_menu.dart';
import 'package:flutter/material.dart';

class FastCardListProvider {
  static ScrollController scrollController = ScrollController();
  static void putSelectedCardToFirstPosition(
      List<FlashCardCollection> collection) {
    var selected = FlashCardProvider.fc;
    var index = collection.indexWhere((element) => element == selected);
    if (index != -1) {
      collection.removeAt(index);
      collection.insert(0, selected);
    }
  }

  static void putSelectedCardToFirstPositionBookMenu(
      List<FlashCardCollection> collection, BookModel book) {
    var bookFlashId = book.flashCardId;
    var index = collection.indexWhere((element) => element.id == bookFlashId);
    if (index != -1) {
      var card = collection[index].copy();

      collection.removeAt(index);
      collection.insert(0, card);
    }
  }

  static void backElementToStart() {
    scrollController.animateTo(
      0.toDouble(),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}

class BaseScreenNewWord {
  String oldWord = '';

  dynamic widget;
  BaseScreenNewWord(this.widget);
  double appBarHeight = 0;

  AppBar getAppBar(flashCardCollection) {
    return AppBar(
      title: const Text(
        'Add word',
        style: FontConfigs.pageNameTextStyle,
      ),
    );
  }

  Widget? getDrawer() {
    return SideMenu(appBarHeight);
  }
}
