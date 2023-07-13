import 'package:flashcards_reader/bloc/providers/word_collection_provider.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flashcards_reader/views/flashcards/new_word/base_new_word_widget.dart';
import 'package:flutter/material.dart';

class FlashReaderAdaptiveContextSelectionMenu extends StatelessWidget {
  final SelectableRegionState selectableRegionState;
  final Function callback;
  final dynamic widget;
  final BuildContext translatorContext;
  const FlashReaderAdaptiveContextSelectionMenu(
      {Key? key,
      required this.selectableRegionState,
      required this.callback,
      required this.translatorContext,
      required this.widget})
      : super(key: key);

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
                  BaseNewWordWidgetService.wordFormController.setUp(
                      WordCreatingUIProvider.tmpFlashCard..question = '1');
                  showUpdateFlashCardMenu(translatorContext, widget, '1');
                },
                icon: const Icon(Icons.translate)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
          ],
        )
      ],
    );
  }

  void showUpdateFlashCardMenu(
      BuildContext trContext, Widget widget, String oldWord) async {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        context: trContext,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (BuildContext context, setState) {
            return SizedBox(
              height: SizeConfig.getMediaHeight(context, p: 0.6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: SizeConfig.getMediaHeight(context, p: 0.3),
                    child: BaseNewWordWidgetService.addWordMenu(
                        context: trContext,
                        callback: callback,
                        oldWord: oldWord),
                  ),
                ],
              ),
            );
          });
        });
  }
}
