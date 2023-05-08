import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/model/entities/translator/api.dart';
import 'package:flashcards_reader/util/constants.dart';
import 'package:flashcards_reader/util/internet_checker.dart';
import 'package:flashcards_reader/views/flashcards/new_word/add_word_collection_provider.dart';
import 'package:flashcards_reader/views/overlay_notification.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TranslateButton extends StatelessWidget {
  FlashCardCollection flashCardCollection;
  Function callback;
  GoogleTranslatorAPIWrapper translator = GoogleTranslatorAPIWrapper();

  Future<bool>? translate() async {
    if (await InternetChecker.hasConnection()) {
      String questionWords = WordCreatingUIProvider.tmpFlashCard.question;
      if (questionWords.isNotEmpty) {
        TranslateResponse answerWords = await translator.translate(
            questionWords,
            from: getCode(flashCardCollection.questionLanguage),
            to: getCode(flashCardCollection.answerLanguage));
        WordCreatingUIProvider.setAnswer(answerWords.toString());
      } else {
        await Future.delayed(const Duration(milliseconds: 250));

        OverlayNotificationProvider.showOverlayNotification(
            'No word to translate',
            status: NotificationStatus.warning);
      }
    } else {
      await Future.delayed(const Duration(milliseconds: 250));
      OverlayNotificationProvider.showOverlayNotification(
          'No internet connection',
          status: NotificationStatus.warning);
    }
    callback();
    return true;
  }

  TranslateButton(
      {required this.callback, required this.flashCardCollection, super.key});
  @override
  Widget build(BuildContext context) {
    var translateIcon = const Icon(
      Icons.translate,
    );
    Future<bool>? result = translate();
    return FutureBuilder<bool>(
        future: result, // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          Widget childIcon;
          if (snapshot.hasData) {
            childIcon = snapshot.data == true ? translateIcon : translateIcon;
          } else {
            childIcon = Transform.scale(
              scale: 0.6,
              child: const CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.black,
              ),
            );
          }

          return childIcon;
        });
  }
}
