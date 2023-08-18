import 'package:flashcards_reader/bloc/flashcards_bloc/flashcards_bloc.dart';
import 'package:flashcards_reader/bloc/providers/word_collection_provider.dart';
import 'package:flashcards_reader/bloc/translator_bloc/translator_bloc.dart';
import 'package:flashcards_reader/util/checker.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/util/router.dart';
import 'package:flashcards_reader/views/flashcards/flashcards/add_flashcard_menu.dart';
import 'package:flashcards_reader/views/flashcards/flashcards/flashcards_screen.dart';
import 'package:flashcards_reader/views/flashcards/tts_widget.dart';
import 'package:flashcards_reader/views/guide_wrapper.dart';
import 'package:flashcards_reader/views/overlay_notification.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BaseNewWordWidgetService {
  static String oldWord = '';

  /// addWordMenu create widget to save words faster
  /// [callback] to update screen
  /// [widget] parent widget
  /// [oldWord] to compare words and detect that user typing or not
  static Widget addWordMenu(
      {required BuildContext context,
      required Function callback,
      bool isTutorial = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        addWordEventWidget(
            context: context, callback: callback, oldWord: oldWord),
        translateListenerWidget(
          context: context,
          callback: callback,
        ),
        addWordsButton(
            context: context, callback: callback, isTutorial: isTutorial),
      ],
    );
  }

  /// put setUp() method in
  /// @override
  /// build()
  /// method
  static WordFormController wordFormController = WordFormController();

  static Widget translateListenerWidget(
      {required BuildContext context, required Function callback}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.translate)),
        Expanded(
          child: BlocListener<TranslatorBloc, TranslatorState>(
            listener: (context, state) {
              if (WordCreatingUIProvider.tmpFlashCard.question.isEmpty) {
                debugPrintIt('empty question');
                WordCreatingUIProvider.setAnswer('');
                WordCreatingUIProvider.setQuestion('');
              }
              if (state.source !=
                  WordCreatingUIProvider.tmpFlashCard.question) {
                debugPrintIt(
                    'translation and source not equal, translate again');

                delayTranslate(
                    text: WordCreatingUIProvider.tmpFlashCard.question,
                    context: context,
                    oldWord: state.source);
              } else if (Checker.isConnected) {
                wordFormController.answerController.text = state.result;
                WordCreatingUIProvider.setAnswer(state.result);
                debugPrintIt(
                    'answer changed to ${state.result} from translate');
              }
            },
            child: TextField(
              controller: wordFormController.answerController,
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
                    onSubmitted: true, callback: callback, context: context);

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
                  FlashCardProvider.fc.answerLanguage);
            },
            icon: const Icon(Icons.volume_up_outlined)),
      ],
    );
  }

  static Widget addWordEventWidget(
      {required BuildContext context,
      required Function callback,
      required String oldWord}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        clearFieldButton(context: context, callback: callback),
        Expanded(
          child: BlocProvider(
            create: (context) => TranslatorBloc(),
            child: TextField(
              controller: wordFormController.questionController,
              decoration: InputDecoration(
                labelText: 'Add Word',
                labelStyle: FontConfigs.h3TextStyle,
              ),
              onChanged: (text) {
                delayTranslate(text: text, context: context, oldWord: oldWord);

                // update the word
              },
              onSubmitted: (value) {
                saveCollectionFromWord(
                    onSubmitted: true, callback: callback, context: context);
                BlocProvider.of<TranslatorBloc>(context)
                    .add(ClearTranslateEvent());
              },
            ),
          ),
        ),
        IconButton(
            onPressed: () {
              TextToSpeechWrapper.onPressed(
                  WordCreatingUIProvider.tmpFlashCard.question,
                  FlashCardProvider.fc.questionLanguage);
            },
            icon: const Icon(Icons.volume_up_outlined)),
      ],
    );
  }

  static Widget addWordsButton(
      {required BuildContext context,
      required Function callback,
      required bool isTutorial}) {
    return GuideProvider.wrapInGuideIfNeeded(
      child: GestureDetector(
        onTap: () {
          bool saved = saveCollectionFromWord(
            onSubmitted: false,
            callback: callback,
            context: context,
          );
          BlocProvider.of<TranslatorBloc>(context).add(ClearTranslateEvent());
          if (isTutorial && saved) {
            MyRouter.pushPage(context, const FlashCardScreen());
          }
        },
        child: Container(
          height: SizeConfig.getMediaHeight(context,
              p: [ScreenDesign.landscape, ScreenDesign.landscapeSmall]
                      .contains(ScreenIdentifier.indentify(context))
                  ? 0.1
                  : 0.07),
          width: SizeConfig.getMediaWidth(context,
              p: [ScreenDesign.landscape, ScreenDesign.landscapeSmall]
                      .contains(ScreenIdentifier.indentify(context))
                  ? 0.3
                  : 0.6),
          decoration: BoxDecoration(
            color: Palette.amber50,

            // rounded full border
            borderRadius: const BorderRadius.all(Radius.circular(25)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add_circle_outline_outlined),
              SizedBox(
                width: SizeConfig.getMediaWidth(context, p: 0.01),
              ),
              Text(
                'save word',
                style: FontConfigs.h2TextStyleBlack,
              )
            ],
          ),
        ),
      ),
      guideText: 'tap to save word in collection',
      onHighlightTap: () {},
      step: 4,
    );
  }

  static void delayTranslate(
      {required String text,
      required BuildContext context,
      required String oldWord}) {
    WordCreatingUIProvider.setQuestion(text);
    debugPrintIt('text: $text');
    // set the word
    oldWord = text;
    debugPrintIt('wait for 5 seconds');
    Future.delayed(const Duration(milliseconds: 100)).then((value) {
      debugPrintIt(FlashCardProvider.fc);
      if (oldWord == text) {
        debugPrintIt('user stopped typing');
        BlocProvider.of<TranslatorBloc>(context).add(TranslateEvent(
            text: text,
            fromLan: FlashCardProvider.fc.questionLanguage,
            toLan: FlashCardProvider.fc.answerLanguage));
      } else if (oldWord.isEmpty || text.isEmpty) {
        debugPrintIt('user cleared the text');
        BlocProvider.of<TranslatorBloc>(context).add(ClearTranslateEvent());
      } else if (oldWord != text) {
        debugPrintIt('user is still typing');
      }
    });
  }

  static bool saveCollectionFromWord(
      {required bool onSubmitted,
      required BuildContext context,
      required Function callback}) {
    updateWord(onSubmitted: onSubmitted, callback: callback, context: context);
    if (FlashCardProvider.fc.isValid) {
      context
          .read<FlashCardBloc>()
          .add(UpdateFlashCardEvent(flashCardCollection: FlashCardProvider.fc));
      callback();

      return true;
    } else {
      showValidatorMessage();
      callback();

      return false;
    }
  }

  static void showValidatorMessage() {
    if (FlashCardProvider.fc.title.isEmpty) {
      OverlayNotificationProvider.showOverlayNotification(
          'Add collection title',
          status: NotificationStatus.info);

      debugPrint('title');
    } else if (FlashCardProvider.fc.isEmpty) {
      OverlayNotificationProvider.showOverlayNotification(
          'Add at least one flashcard',
          status: NotificationStatus.info);

      debugPrint('Add at least one flashcard');
    } else if (FlashCardProvider.fc.answerLanguage.isEmpty) {
      OverlayNotificationProvider.showOverlayNotification(
          'Add question language',
          status: NotificationStatus.info);

      debugPrint('Add question language');
    } else if (FlashCardProvider.fc.answerLanguage.isEmpty) {
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

  static void updateWord(
      {bool onSubmitted = false,
      required Function callback,
      required BuildContext context}) {
    var flash = WordCreatingUIProvider.tmpFlashCard;
    if (onSubmitted && flash.answer.isEmpty && flash.question.isEmpty) {
      debugPrintIt('on submitted and word empty, do nothing');
    } else if (WordCreatingUIProvider.tmpFlashCard.isValid) {
      debugPrint('add flashcard');

      WordCreatingUIProvider.setQuestionLanguage(
          FlashCardProvider.fc.questionLanguage);
      WordCreatingUIProvider.setAnswerLanguage(
          FlashCardProvider.fc.answerLanguage);

      FlashCardProvider.fc.flashCardSet
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

  static Widget clearFieldButton(
      {required BuildContext context, required Function callback}) {
    return IconButton(
        onPressed: () {
          callback();

          WordCreatingUIProvider.clear();
          BlocProvider.of<TranslatorBloc>(context).add(ClearTranslateEvent());
        },
        icon: const Icon(Icons.auto_delete));
  }
}
