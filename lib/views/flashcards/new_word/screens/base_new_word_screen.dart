import 'package:flashcards_reader/bloc/providers/word_collection_provider.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flashcards_reader/views/menu/side_menu.dart';
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
      title: const Text(
        'Add word',
        style: FontConfigs.pageNameTextStyle,
      ),
    );
  }

  Widget? getDrawer() {
    return SideMenu(appBarHeight);
  }

  void backToStartCallback() {
    widget.scrollController.animateTo(
      0.toDouble(),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}
