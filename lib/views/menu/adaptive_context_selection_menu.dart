import 'package:flashcards_reader/bloc/flashcards_bloc/flashcards_bloc.dart';
import 'package:flashcards_reader/bloc/providers/word_collection_provider.dart';
import 'package:flashcards_reader/bloc/translator_bloc/translator_bloc.dart';
import 'package:flashcards_reader/constants.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flashcards_reader/views/flashcards/new_word/base_new_word_widget.dart';
import 'package:flashcards_reader/views/reader/open_books/view_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

class FlashReaderAdaptiveContextSelectionMenu extends StatelessWidget {
  final SelectableRegionState selectableRegionState;
  const FlashReaderAdaptiveContextSelectionMenu(
      {Key? key, required this.selectableRegionState})
      : super(key: key);

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

                          showUpdateFlashCardMenu(context);
                        },
                        icon: const Icon(Icons.translate)),
                    IconButton(
                        onPressed: () {
                          Share.share('''${TextBookViewProvider.selectedText}
                              Read, translate and learn with flashReader! $googlePlayLink''');
                        },
                        icon: const Icon(Icons.share)),
                  ],
                )
              ],
            )));
  }

  void showUpdateFlashCardMenu(BuildContext context) async {
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
                            child: const BaseNewWordWrapper())),
                  ),
                ],
              ),
            );
          });
        });
  }
}

class BaseNewWordWrapper extends StatefulWidget {
  const BaseNewWordWrapper({super.key});

  @override
  State<BaseNewWordWrapper> createState() => _BaseNewWordWrapperState();
}

class _BaseNewWordWrapperState extends State<BaseNewWordWrapper> {
  void callback() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

    @override
  void dispose() {
    BaseNewWordWidgetService.dispose();}

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
        context: context, callback: callback);
  }
}
