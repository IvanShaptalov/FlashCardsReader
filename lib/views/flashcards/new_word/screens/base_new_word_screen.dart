import 'package:flashcards_reader/bloc/flashcards_bloc/flashcards_bloc.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/util/router.dart';
import 'package:flashcards_reader/views/flashcards/new_word/add_word_collection_provider.dart';
import 'package:flashcards_reader/views/flashcards/quiz/quiz_menu.dart';
import 'package:flashcards_reader/views/menu/drawer_menu.dart';
import 'package:flashcards_reader/views/overlay_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BaseScreenNewWord {
  dynamic widget;
  BaseScreenNewWord(this.widget);
  double appBarHeight = 0;
  void putSelectedCardToFirstPosition(List<FlashCardCollection> collection) {
    var selected = AddWordCollectionProvider.selectedFc;
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
    if (AddWordCollectionProvider.selectedFc.isValid) {
      context.read<FlashCardBloc>().add(UpdateFlashCardEvent(
          flashCardCollection: AddWordCollectionProvider.selectedFc));
    } else {
      showValidatorMessage();
    }
    callback();
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
    callback();
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
}
