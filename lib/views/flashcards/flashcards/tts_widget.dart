// ignore_for_file: must_be_immutable

import 'package:flashcards_reader/model/entities/tts/core.dart';
import 'package:flashcards_reader/util/constants.dart';
import 'package:flashcards_reader/util/internet_checker.dart';
import 'package:flashcards_reader/views/overlay_notification.dart';
import 'package:flutter/material.dart';

class TextToSpeechWidget extends StatelessWidget {
  String text;
  String language;
  TextToSpeechWidget({Key? key, required this.text, required this.language})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          if (text.isNotEmpty) {
            if (await InternetChecker.hasConnection()) {
              if (text.length <= ttsMaxLength) {
                TextToSpeechService.speak(
                        text, convertLangToTextToSpeechCode(language))
                    .then((value) {
                  if (!value) {
                    OverlayNotificationProvider.showOverlayNotification(
                        'something went wrong',
                        status: NotificationStatus.error);
                  }
                });
              } else {
                OverlayNotificationProvider.showOverlayNotification(
                    'text too long',
                    status: NotificationStatus.info);
              }
            } else {
              OverlayNotificationProvider.showOverlayNotification(
                  'check internet connection',
                  status: NotificationStatus.info);
            }
          } else {
            OverlayNotificationProvider.showOverlayNotification(
                'add word first',
                status: NotificationStatus.info);
          }
        },
        icon: const Icon(Icons.play_arrow));
  }
}
