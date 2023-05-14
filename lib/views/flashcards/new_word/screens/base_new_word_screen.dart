import 'package:flashcards_reader/bloc/flashcards_bloc/flashcards_bloc.dart';
import 'package:flashcards_reader/bloc/translator_bloc/translator_bloc.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/util/router.dart';
import 'package:flashcards_reader/views/flashcards/flashcards/add_flashcard_widget.dart';
import 'package:flashcards_reader/views/flashcards/new_word/add_word_collection_provider.dart';
import 'package:flashcards_reader/views/flashcards/quiz/quiz_menu.dart';
import 'package:flashcards_reader/views/flashcards/tts_widget.dart';
import 'package:flashcards_reader/views/menu/drawer_menu.dart';
import 'package:flashcards_reader/views/overlay_notification.dart';
import 'package:flashcards_reader/views/view_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BaseScreenNewWord {
  String oldWord = '';

  dynamic widget;
  BaseScreenNewWord(this.widget);
  double appBarHeight = 0;
  void putSelectedCardToFirstPosition(List<FlashCardCollection> collection) {
    var selected = FlashCardCreatingUIProvider.fc;
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

  Widget clearFieldButton({required BuildContext context}) {
    return IconButton(
        onPressed: () {
          widget.callback();

          WordCreatingUIProvider.clear();
          BlocProvider.of<TranslatorBloc>(context).add(ClearTranslateEvent());
        },
        icon: const Icon(Icons.auto_delete));
  }

  Widget addWordsButton(
      {required BuildContext context, required Function callback}) {
    return GestureDetector(
      onTap: () {
        saveCollectionFromWord(
            onSubmitted: false,
            callback: callback,
            context: context,
            widget: widget);
        BlocProvider.of<TranslatorBloc>(context).add(ClearTranslateEvent());
      },
      child: Container(
        height: SizeConfig.getMediaHeight(context,
            p: [ScreenDesign.landscape, ScreenDesign.landscapeSmall]
                    .contains(DesignIdentifier.identifyScreenDesign(context))
                ? 0.1
                : 0.07),
        width: SizeConfig.getMediaWidth(context,
            p: [ScreenDesign.landscape, ScreenDesign.landscapeSmall]
                    .contains(DesignIdentifier.identifyScreenDesign(context))
                ? 0.3
                : 0.6),
        decoration: BoxDecoration(
          color: ConfigFashAddWordView.buttonColor,

          // rounded full border
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_circle_outline_outlined),
            SizedBox(
              width: SizeConfig.getMediaWidth(context, p: 0.01),
            ),
            const Text(
              'save',
              style: FontConfigs.h2TextStyleBlack,
            )
          ],
        ),
      ),
    );
  }

  void saveCollectionFromWord(
      {required bool onSubmitted,
      required BuildContext context,
      required Function callback,
      required dynamic widget}) {
    updateWord(
        onSubmitted: onSubmitted,
        callback: callback,
        widget: widget,
        context: context);
    if (FlashCardCreatingUIProvider.fc.isValid) {
      context.read<FlashCardBloc>().add(UpdateFlashCardEvent(
          flashCardCollection: FlashCardCreatingUIProvider.fc));
    } else {
      showValidatorMessage();
    }
    callback();
  }

  Widget translateListenerWidget(
      {required BuildContext context,
      required Function callback,
      required bool isPressed}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
            onPressed: () {
              isPressed = !isPressed;

              widget.callback();
            },
            icon: const Icon(Icons.translate)),
        Expanded(
          child: BlocListener<TranslatorBloc, TranslatorInitial>(
            listener: (context, state) {
              if (WordCreatingUIProvider.tmpFlashCard.answer.isEmpty) {
                widget.wordFormContoller.answerController.text = state.result;
                WordCreatingUIProvider.setAnswer(state.result);
                debugPrintIt(
                    'answer changed to ${state.result} from translate');
              } else if (state.source !=
                      WordCreatingUIProvider.tmpFlashCard.question &&
                  WordCreatingUIProvider.tmpFlashCard.answer.isNotEmpty) {
                debugPrintIt(
                    'translation and source not equal, translate again');
                delayTranslate(
                    WordCreatingUIProvider.tmpFlashCard.question, context);
              } else {
                widget.wordFormContoller.answerController.text = state.result;
                WordCreatingUIProvider.setAnswer(state.result);
                debugPrintIt(
                    'answer changed to ${state.result} from translate');
              }
            },
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
                saveCollectionFromWord(
                    onSubmitted: true,
                    callback: callback,
                    context: context,
                    widget: widget);

                BlocProvider.of<TranslatorBloc>(context)
                    .add(ClearTranslateEvent());
              },
            ),
          ),
        ),
        IconButton(
            onPressed: () {
              TextToSpeechWrapper.onPressed(
                  WordCreatingUIProvider.tmpFlashCard.answer,
                  WordCreatingUIProvider.tmpFlashCard.answerLanguage);
            },
            icon: const Icon(Icons.volume_up_outlined)),
      ],
    );
  }

  void delayTranslate(String text, BuildContext context) {
    WordCreatingUIProvider.setQuestion(text);
    debugPrintIt('text: $text');
    // set the word
    oldWord = text;
    debugPrintIt('wait for 5 seconds');
    Future.delayed(const Duration(milliseconds: 100)).then((value) {
      debugPrintIt(FlashCardCreatingUIProvider.fc);
      if (oldWord == text) {
        debugPrintIt('user stopped typing');
        BlocProvider.of<TranslatorBloc>(context).add(TranslateEvent(
            text: text,
            fromLan: FlashCardCreatingUIProvider.fc.questionLanguage,
            toLan: FlashCardCreatingUIProvider.fc.answerLanguage));
      } else if (oldWord.isEmpty || text.isEmpty) {
        debugPrintIt('user cleared the text');
        BlocProvider.of<TranslatorBloc>(context).add(ClearTranslateEvent());
      } else if (oldWord != text) {
        debugPrintIt('user is still typing');
      }
    });
  }

  void updateWord(
      {bool onSubmitted = false,
      required Function callback,
      required dynamic widget,
      required BuildContext context}) {
    var flash = WordCreatingUIProvider.tmpFlashCard;
    if (onSubmitted && flash.answer.isEmpty && flash.question.isEmpty) {
      debugPrintIt('on submitted and word empty, do nothing');
    } else if (WordCreatingUIProvider.tmpFlashCard.isValid) {
      debugPrint('add flashcard');

      WordCreatingUIProvider.setQuestionLanguage(
          FlashCardCreatingUIProvider.fc.questionLanguage);
      WordCreatingUIProvider.setAnswerLanguage(
          FlashCardCreatingUIProvider.fc.answerLanguage);

      FlashCardCreatingUIProvider.fc.flashCardSet
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
    callback();
  }

  void showValidatorMessage() {
    if (FlashCardCreatingUIProvider.fc.title.isEmpty) {
      OverlayNotificationProvider.showOverlayNotification(
          'Add collection title',
          status: NotificationStatus.info);

      debugPrint('title');
    } else if (FlashCardCreatingUIProvider.fc.isEmpty) {
      OverlayNotificationProvider.showOverlayNotification(
          'Add at least one flashcard',
          status: NotificationStatus.info);

      debugPrint('Add at least one flashcard');
    } else if (FlashCardCreatingUIProvider.fc.answerLanguage.isEmpty) {
      OverlayNotificationProvider.showOverlayNotification(
          'Add question language',
          status: NotificationStatus.info);

      debugPrint('Add question language');
    } else if (FlashCardCreatingUIProvider.fc.answerLanguage.isEmpty) {
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
}
