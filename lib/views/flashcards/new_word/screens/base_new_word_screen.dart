import 'package:flashcards_reader/bloc/providers/word_collection_provider.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/model/entities/reader/book_model.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flashcards_reader/views/menu/side_menu.dart';
import 'package:flutter/material.dart';

class FastCardListProvider {
  static ScrollController scrollController = ScrollController();
  static FlashCardCollection putSelectedCardToFirstPosition(
      List<FlashCardCollection> collection) {
    var selected = FlashCardProvider.fc;
    var index = collection.indexWhere((element) => element == selected);
    if (index != -1) {
      collection.removeAt(index);
      collection.insert(0, selected);
    }
    return selected;
  }

  /// return true if reordered
  static bool putSelectedCardToFirstPositionBookMenu(
      List<FlashCardCollection> collection, BookModel book) {
    var bookFlashId = book.flashCardId;
    var index = collection.indexWhere((fc) => fc.id == bookFlashId && !fc.isDeleted);
    if (index != -1) {
      var card = collection[index].copy();

      collection.removeAt(index);
      collection.insert(0, card);
      // set card to selected and provide to interact
      FlashCardProvider.fc = card;
      return true;
    }
    return false;
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
