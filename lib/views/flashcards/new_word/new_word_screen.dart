// ignore_for_file: must_be_immutable

import 'package:flashcards_reader/bloc/flashcards_bloc/flashcards_bloc.dart';
import 'package:flashcards_reader/main.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/model/entities/translator/api.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/util/router.dart';
import 'package:flashcards_reader/views/flashcards/new_word/add_word_collection_provider.dart';
import 'package:flashcards_reader/views/flashcards/new_word/add_word_collection_widget.dart';
import 'package:flashcards_reader/views/flashcards/quiz/quiz_menu.dart';
import 'package:flashcards_reader/views/flashcards/translate.dart';
import 'package:flashcards_reader/views/flashcards/tts_widget.dart';
import 'package:flashcards_reader/views/menu/drawer_menu.dart';
import 'package:flashcards_reader/views/overlay_notification.dart';
import 'package:flashcards_reader/views/view_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class WordFormContoller {
  TextEditingController questionController = TextEditingController();
  TextEditingController answerController = TextEditingController();

  void setUp(FlashCard flashCard) {
    // update controller text
    questionController.text = flashCard.question;
    answerController.text = flashCard.answer;

    // set cursor to the end of the text

    questionController.selection = TextSelection.fromPosition(
        TextPosition(offset: flashCard.question.length));
    answerController.selection = TextSelection.fromPosition(
        TextPosition(offset: flashCard.answer.length));
  }
}

class AddWordFastScreen extends StatefulWidget {
  AddWordFastScreen({super.key});
  ScrollController scrollController = ScrollController();
  WordFormContoller wordFormContoller = WordFormContoller();
  GoogleTranslatorAPIWrapper translator = GoogleTranslatorAPIWrapper();

  @override
  State<AddWordFastScreen> createState() => _AddWordFastScreenState();
}

class _AddWordFastScreenState extends State<AddWordFastScreen> {
  void callback() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FlashCardBloc(),
      child: AddWordView(
        scrollController: widget.scrollController,
        wordFormContoller: widget.wordFormContoller,
        translator: widget.translator,
        callback: callback,
      ),
    );
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
  GoogleTranslatorAPIWrapper translator;

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

  Widget addWordWidget() {
    return Transform.scale(
      scale: 0.9,
      child: Container(
          height: SizeConfig.getMediaHeight(context, p: 0.3),
          width: SizeConfig.getMediaWidth(context, p: 1),
          decoration: BoxDecoration(
            color: Colors.green.shade200,

            // rounded full border
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: () {
                          saveCollectionFromWord(onSubmitted: false);
                        },
                        icon: const Icon(Icons.add_circle_outlined)),
                    Expanded(
                      child: TextField(
                        controller: widget.wordFormContoller.questionController,
                        decoration: InputDecoration(
                          labelText: 'Add Word',
                          labelStyle: FontConfigs.h3TextStyle,
                        ),
                        onChanged: (text) {
                          WordCreatingUIProvider.setQuestion(text);
                          debugPrintIt(WordCreatingUIProvider.tmpFlashCard);
                          debugPrintIt('question changed to $text');
                          // translate if needed
                          TranslateButton.translate(
                              flashCardCollection:
                                  AddWordCollectionProvider.selectedFc,
                              callback: widget.callback);
                        },
                        onSubmitted: (value) {
                          saveCollectionFromWord(onSubmitted: true);
                        },
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          TextToSpeechWrapper.onPressed(
                              WordCreatingUIProvider.tmpFlashCard.question,
                              WordCreatingUIProvider
                                  .tmpFlashCard.questionLanguage);
                        },
                        icon: const Icon(Icons.volume_up_outlined)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: () {
                          isPressed = !isPressed;

                          widget.callback();
                        },
                        icon: loadTranslate()),
                    Expanded(
                      child: TextField(
                        controller: widget.wordFormContoller.answerController,
                        decoration: InputDecoration(
                          labelText: 'Add Translation',
                          labelStyle: FontConfigs.h3TextStyle,
                        ),
                        onChanged: (text) {
                          WordCreatingUIProvider.setAnswer(text);
                          debugPrintIt(WordCreatingUIProvider.tmpFlashCard);
                          debugPrintIt('answer changed to $text');
                        },
                        onSubmitted: (value) {
                          saveCollectionFromWord(onSubmitted: true);
                        },
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          TextToSpeechWrapper.onPressed(
                              WordCreatingUIProvider.tmpFlashCard.answer,
                              WordCreatingUIProvider
                                  .tmpFlashCard.answerLanguage);
                        },
                        icon: const Icon(Icons.volume_up_outlined)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Transform.scale(
                    scale: 1.5,
                    child: IconButton(
                        onPressed: () {
                          widget.callback();

                          WordCreatingUIProvider.clear();
                        },
                        icon: const Icon(Icons.delete_sweep_outlined)),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlashCardBloc, FlashcardsState>(
        builder: (context, state) {
      var flashCardCollection = state.copyWith(fromTrash: false).flashCards;
      putSelectedCardToFirstPosition(flashCardCollection);
      var appbar = getAppBar(flashCardCollection);
      appBarHeight = appbar.preferredSize.height;
      widget.wordFormContoller.setUp(WordCreatingUIProvider.tmpFlashCard);

      debugPrintIt(
          'selected collection:  ${AddWordCollectionProvider.selectedFc}');
      return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: appbar,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              addWordWidget(),
              const SizedBox.shrink(),
              Column(
                children: [
                  const Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                  AnimationLimiter(
                    child: SizedBox(
                      height: SizeConfig.getMediaHeight(context, p: 0.35),
                      width: SizeConfig.getMediaWidth(context, p: 1),
                      child: ListView.builder(
                          controller: widget.scrollController,
                          scrollDirection: Axis.horizontal,
                          itemCount: flashCardCollection.isEmpty
                              ? 1
                              : flashCardCollection.length,
                          itemBuilder: (context, index) {
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: widget.cardAppearDuration,
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                    child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: FastAddWordFCcWidget(
                                          flashCardCollection.isEmpty
                                              ? AddWordCollectionProvider
                                                  .selectedFc
                                              : flashCardCollection[index],
                                          widget.callback,
                                          backToListStart: backToStartCallback,
                                        ))),
                              ),
                            );
                          }),
                    ),
                  ),
                ],
              ),
            ],
          ),
          drawer: getDrawer(),
          bottomNavigationBar: BottomAppBar(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                /// icon buttons, analog of bottom navigation bar with flashcards, merge if merge mode is on and quiz
                children: bottomNavigationBarItems()),
          ));
    });
  }

  List<Widget> bottomNavigationBarItems() {
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

  AppBar getAppBar(flashCardCollection) {
    return AppBar(
      title: const Text('Add word'),
    );
  }

  Widget? getDrawer() {
    return MenuDrawer(appBarHeight);
  }

  void putSelectedCardToFirstPosition(List<FlashCardCollection> collection) {
    var selected = AddWordCollectionProvider.selectedFc;
    var index = collection.indexWhere((element) => element == selected);
    if (index != -1) {
      collection.removeAt(index);
      collection.insert(0, selected);
    }
  }

  void backToStartCallback() {
    widget.scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
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

  void saveCollectionFromWord({required bool onSubmitted}) {
    updateWord(onSubmitted: onSubmitted);
    if (AddWordCollectionProvider.selectedFc.isValid) {
      context.read<FlashCardBloc>().add(UpdateFlashCardEvent(
          flashCardCollection: AddWordCollectionProvider.selectedFc));
    } else {
      showValidatorMessage();
    }
    widget.callback();
  }

  void showValidatorMessage() {
    if (AddWordCollectionProvider.selectedFc.title.isEmpty) {
      OverlayNotificationProvider.showOverlayNotification(
          'Add collection title',
          status: NotificationStatus.info);

      debugPrint('title');
    } else if (AddWordCollectionProvider.selectedFc.isEmpty) {
      OverlayNotificationProvider.showOverlayNotification(
          'Add at least one flashcard',
          status: NotificationStatus.info);

      debugPrint('Add at least one flashcard');
    } else if (AddWordCollectionProvider.selectedFc.answerLanguage.isEmpty) {
      OverlayNotificationProvider.showOverlayNotification(
          'Add question language',
          status: NotificationStatus.info);

      debugPrint('Add question language');
    } else if (AddWordCollectionProvider.selectedFc.answerLanguage.isEmpty) {
      OverlayNotificationProvider.showOverlayNotification('Add answerlanguage',
          status: NotificationStatus.info);

      debugPrint('Add answerlanguage');
    } else {
      OverlayNotificationProvider.showOverlayNotification(
          'Your collection not valid',
          status: NotificationStatus.info);

      debugPrint('flash not valid');
    }
  }

  void updateWord({bool onSubmitted = false}) {
    var flash = WordCreatingUIProvider.tmpFlashCard;
    if (onSubmitted && flash.answer.isEmpty && flash.question.isEmpty) {
      debugPrintIt('on submitted and word empty, do nothing');
    } else if (WordCreatingUIProvider.tmpFlashCard.isValid) {
      debugPrint('add flashcard');

      WordCreatingUIProvider.setQuestionLanguage(
          AddWordCollectionProvider.selectedFc.questionLanguage);
      WordCreatingUIProvider.setAnswerLanguage(
          AddWordCollectionProvider.selectedFc.answerLanguage);

      AddWordCollectionProvider.selectedFc.flashCardSet
          .add(WordCreatingUIProvider.tmpFlashCard);
      WordCreatingUIProvider.clear();
      OverlayNotificationProvider.showOverlayNotification('word added',
          status: NotificationStatus.success);
    } else {
      if (WordCreatingUIProvider.tmpFlashCard.question.isEmpty) {
        OverlayNotificationProvider.showOverlayNotification('add word',
            status: NotificationStatus.info);
      } else if (WordCreatingUIProvider.tmpFlashCard.answer.isEmpty) {
        OverlayNotificationProvider.showOverlayNotification(
            'tap translate button',
            status: NotificationStatus.info);
      } else {
        // ====================[save whole collection]
      }

      debugPrint('not valid');
    }
    widget.callback();
  }
}