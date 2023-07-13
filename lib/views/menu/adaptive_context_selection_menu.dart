import 'package:flashcards_reader/views/flashcards/new_word/base_new_word_widget.dart';
import 'package:flutter/material.dart';

class FlashReaderAdaptiveContextSelectionMenu extends StatelessWidget {
  final SelectableRegionState selectableRegionState;
  final Function callback;
  final dynamic widget;
  final String oldWord;
  const FlashReaderAdaptiveContextSelectionMenu(
      {Key? key,
      required this.selectableRegionState,
      required this.callback,
      required this.widget,
      required this.oldWord})
      : super(key: key);

  void showUpdateFlashCardMenu(BuildContext context,
      Function updateCallbackCrunch, Widget widget, String oldWord) async {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (BuildContext context, setState) {
            return BaseNewWordWidget.addWordMenu(
                context: context,
                callback: updateCallbackCrunch,
                widget: widget,
                oldWord: oldWord);
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveTextSelectionToolbar(
      anchors: selectableRegionState.contextMenuAnchors,
      children: [
        Wrap(
          spacing: 5,
          children: [
            IconButton(
                onPressed: selectableRegionState.contextMenuButtonItems
                    .firstWhere(
                        (element) => element.type == ContextMenuButtonType.copy)
                    .onPressed,
                icon: const Icon(Icons.copy)),
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.format_quote_rounded)),
            IconButton(
                onPressed: () {
                  showUpdateFlashCardMenu(context, callback, widget, oldWord);
                },
                icon: const Icon(Icons.translate)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
          ],
        )
      ],
    );
  }
}
