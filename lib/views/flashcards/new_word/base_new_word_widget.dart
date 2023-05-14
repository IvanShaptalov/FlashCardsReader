import 'package:flashcards_reader/bloc/flashcards_bloc/flashcards_bloc.dart';
import 'package:flashcards_reader/bloc/providers/word_collection_provider.dart';
import 'package:flashcards_reader/bloc/translator_bloc/translator_bloc.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/views/flashcards/tts_widget.dart';
import 'package:flashcards_reader/views/overlay_notification.dart';
import 'package:flashcards_reader/views/view_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BaseNewWordWidget {
  static Widget addWordMenu(
      {required BuildContext context,
      required Function callback,
      required dynamic widget,
      required String oldWord}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        addWordEventWidget(
            context: context,
            callback: callback,
            widget: widget,
            oldWord: oldWord),
        translateListenerWidget(
            context: context, callback: callback, widget: widget),
        addWordsButton(context: context, callback: callback, widget: widget),
      ],
    );
  }

  static Widget translateListenerWidget(
      {required BuildContext context,
      required Function callback,
      required dynamic widget}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.translate)),
        Expanded(
          child: BlocListener<TranslatorBloc, TranslatorInitial>(
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
                  FlashCardProvider.fc.answerLanguage);
            },
            icon: const Icon(Icons.volume_up_outlined)),
      ],
    );
  }

  static Widget addWordEventWidget(
      {required BuildContext context,
      required Function callback,
      required dynamic widget,
      required String oldWord}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        clearFieldButton(context: context, widget: widget, callback: callback),
        Expanded(
          child: BlocProvider(
            create: (context) => TranslatorBloc(),
            child: TextField(
              controller: widget.wordFormContoller.questionController,
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
      required dynamic widget}) {
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
          color: ConfigFastAddWordView.buttonColor,

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
            const Text(
              'save word',
              style: FontConfigs.h2TextStyleBlack,
            )
          ],
        ),
      ),
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

  static void saveCollectionFromWord(
      {required bool onSubmitted,
      required BuildContext context,
      required Function callback,
      required dynamic widget}) {
    updateWord(
        onSubmitted: onSubmitted,
        callback: callback,
        widget: widget,
        context: context);
    if (FlashCardProvider.fc.isValid) {
      context.read<FlashCardBloc>().add(UpdateFlashCardEvent(
          flashCardCollection: FlashCardProvider.fc));
    } else {
      showValidatorMessage();
    }
    callback();
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
      required dynamic widget,
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
      {required BuildContext context,
      required dynamic widget,
      required Function callback}) {
    return IconButton(
        onPressed: () {
          callback();

          WordCreatingUIProvider.clear();
          BlocProvider.of<TranslatorBloc>(context).add(ClearTranslateEvent());
        },
        icon: const Icon(Icons.auto_delete));
  }
}
