// ignore_for_file: must_be_immutable

import 'package:flashcards_reader/bloc/flashcards_bloc/flashcards_bloc.dart';
import 'package:flashcards_reader/bloc/translator_bloc/translator_bloc.dart';
import 'package:flashcards_reader/main.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/model/entities/translator/api.dart';
import 'package:flashcards_reader/util/constants.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/util/router.dart';
import 'package:flashcards_reader/views/flashcards/new_word/add_word_collection_provider.dart';
import 'package:flashcards_reader/views/flashcards/new_word/add_word_collection_widget.dart';
import 'package:flashcards_reader/views/flashcards/new_word/screens/base_new_word_screen.dart';
import 'package:flashcards_reader/views/flashcards/new_word/screens/landscape.dart';
import 'package:flashcards_reader/views/flashcards/new_word/screens/landscape_small.dart';
import 'package:flashcards_reader/views/flashcards/new_word/screens/portrait.dart';
import 'package:flashcards_reader/views/flashcards/new_word/screens/portrait_small.dart';
import 'package:flashcards_reader/views/flashcards/quiz/quiz_menu.dart';
import 'package:flashcards_reader/views/flashcards/translate.dart';
import 'package:flashcards_reader/views/flashcards/tts_widget.dart';
import 'package:flashcards_reader/views/menu/drawer_menu.dart';
import 'package:flashcards_reader/views/overlay_notification.dart';
import 'package:flashcards_reader/views/parent_screen.dart';
import 'package:flashcards_reader/views/view_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class WordFormContoller {
  TextEditingController questionController = TextEditingController();
  TextEditingController answerController = TextEditingController();

  void setUp(FlashCard flashCard, context) {
    // update controller text
    questionController.text = flashCard.question;
    answerController.text =
        BlocProvider.of<TranslatorBloc>(context).state.result;

    // set cursor to the end of the text

    questionController.selection = TextSelection.fromPosition(
        TextPosition(offset: flashCard.question.length));
    answerController.selection = TextSelection.fromPosition(
        TextPosition(offset: flashCard.answer.length));
  }
}

class AddWordFastScreen extends ParentStatefulWidget {
  AddWordFastScreen({super.key});
  ScrollController scrollController = ScrollController();
  WordFormContoller wordFormContoller = WordFormContoller();
  GoogleTranslatorApiWrapper translator = GoogleTranslatorApiWrapper();

  @override
  ParentState<AddWordFastScreen> createState() => _AddWordFastScreenState();
}

class _AddWordFastScreenState extends ParentState<AddWordFastScreen> {
  void callback() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    widget.portraitPage = BlocProvider(
        create: (_) => FlashCardBloc(),
        child: BlocProvider(
          create: (_) => TranslatorBloc(),
          child: AddWordView(
            scrollController: widget.scrollController,
            wordFormContoller: widget.wordFormContoller,
            translator: widget.translator,
            callback: callback,
          ),
        ));
    bindAllPages(widget.portraitPage);
    return super.build(context);
  }
}

class AddWordView extends StatefulWidget {
  AddWordView(
      {required this.scrollController,
      required this.wordFormContoller,
      required this.translator,
      required this.callback,
      super.key});
  Duration cardAppearDuration = const Duration(milliseconds: 375);
  Function callback;
  ScrollController scrollController;
  WordFormContoller wordFormContoller;
  GoogleTranslatorApiWrapper translator;

  @override
  State<AddWordView> createState() => _AddWordViewState();
}

class _AddWordViewState extends State<AddWordView> {
  double appBarHeight = 0;
  bool isPressed = false;
  bool oldPress = false;

  @override
  void initState() {
    super.initState();
    var collection = BlocProvider.of<FlashCardBloc>(context)
        .state
        .copyWith(fromTrash: false)
        .flashCards;

    FlashCardCollection? selected = AddWordCollectionProvider.selectedFc;
    if (collection.isNotEmpty && selected.compareWithoutId(flashExample())) {
      selected = collection.first;
      AddWordCollectionProvider.selectedFc = selected;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget screen;
    switch (DesignIdentifier.identifyScreenDesign(context)) {
      case ScreenDesign.portrait:
        screen = PortraitNewWord(widget,
                isPressed: isPressed,
                callback: widget.callback,
                loadTranslate: loadTranslate)
            .loadScreen();
        break;
      case ScreenDesign.portraitSmall:
        screen = PortraitSmallNewWord(widget,
                isPressed: isPressed,
                callback: widget.callback,
                loadTranslate: loadTranslate)
            .loadScreen();
        break;
      case ScreenDesign.landscape:
        screen = LandscapeNewWord(widget,
                isPressed: isPressed,
                callback: widget.callback,
                loadTranslate: loadTranslate)
            .loadScreen();
        break;
      case ScreenDesign.landscapeSmall:
        screen = LandscapeSmallNewWord(widget,
                isPressed: isPressed,
                callback: widget.callback,
                loadTranslate: loadTranslate)
            .loadScreen();
        break;
      default:
        screen = PortraitNewWord(widget,
                isPressed: isPressed,
                callback: widget.callback,
                loadTranslate: loadTranslate)
            .loadScreen();
    }

    return screen;
  }

  Widget loadTranslate() {
    if (isPressed != oldPress) {
      oldPress = isPressed;
      return TranslateButton(
          flashCardCollection: AddWordCollectionProvider.selectedFc,
          callback: widget.callback);
    }
    return const Icon(Icons.translate);
  }
}
