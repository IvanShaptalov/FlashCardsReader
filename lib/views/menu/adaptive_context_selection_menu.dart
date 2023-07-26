import 'package:flashcards_reader/bloc/flashcards_bloc/flashcards_bloc.dart';
import 'package:flashcards_reader/bloc/providers/word_collection_provider.dart';
import 'package:flashcards_reader/bloc/translator_bloc/translator_bloc.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flashcards_reader/views/flashcards/new_word/base_new_word_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlashReaderAdaptiveContextSelectionMenu extends StatelessWidget {
  final SelectableRegionState selectableRegionState;
  const FlashReaderAdaptiveContextSelectionMenu(
      {Key? key, required this.selectableRegionState, this.isTutorial = false})
      : super(key: key);

  final bool isTutorial;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => FlashCardBloc(),
        child: BlocProvider(
            create: (_) => TranslatorBloc(),
            child: AdaptiveTextSelectionToolbar(
              anchors: selectableRegionState.contextMenuAnchors,
              children: [
                Wrap(
                  spacing: 5,
                  children: [
                    IconButton(
                        onPressed: selectableRegionState.contextMenuButtonItems
                            .firstWhere((element) =>
                                element.type == ContextMenuButtonType.copy)
                            .onPressed,
                        icon: const Icon(Icons.copy)),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.format_quote_rounded)),
                    IconButton(
                        onPressed: () {
                          BaseNewWordWidgetService.wordFormController
                              .setUp(WordCreatingUIProvider.tmpFlashCard);

                          showUpdateFlashCardMenu(context, isTutorial);
                        },
                        icon: const Icon(Icons.translate)),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
                  ],
                )
              ],
            )));
  }

  void showUpdateFlashCardMenu(BuildContext context, bool isTutorial) async {
    return showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (BuildContext context, setState) {
            return SizedBox(
              height: SizeConfig.getMediaHeight(context, p: 0.6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: SizeConfig.getMediaHeight(context, p: 0.3),
                    child: BlocProvider(
                        create: (_) => FlashCardBloc(),
                        child: BlocProvider(
                            create: (_) => TranslatorBloc(),
                            child: BaseNewWordWrapper(isTutorial: isTutorial))),
                  ),
                ],
              ),
            );
          });
        });
  }
}

class BaseNewWordWrapper extends StatefulWidget {
  const BaseNewWordWrapper({super.key, required this.isTutorial});

  final bool isTutorial;
  @override
  State<BaseNewWordWrapper> createState() => _BaseNewWordWrapperState();
}

class _BaseNewWordWrapperState extends State<BaseNewWordWrapper> {
  void callback() {
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BaseNewWordWidgetService.wordFormController
        .setUp(WordCreatingUIProvider.tmpFlashCard);
    // trigger translation
    context.read<TranslatorBloc>().add(TranslateEvent(
        text: WordCreatingUIProvider.tmpFlashCard.question,
        fromLan: FlashCardProvider.fc.questionLanguage,
        toLan: FlashCardProvider.fc.answerLanguage));
    return BaseNewWordWidgetService.addWordMenu(
      context: context,
      callback: callback,
      isTutorial: widget.isTutorial
    );
  }
}
