// ignore_for_file: must_be_immutable

import 'package:flashcards_reader/model/entities/tts/core.dart';
import 'package:flashcards_reader/util/constants.dart';
import 'package:flashcards_reader/util/internet_checker.dart';
import 'package:flashcards_reader/views/overlay_notification.dart';
import 'package:flutter/material.dart';

class TextToSpeechWidget extends StatefulWidget {
  String text;
  String language;
  TextToSpeechWidget({Key? key, required this.text, required this.language})
      : super(key: key);

  @override
  State<TextToSpeechWidget> createState() => _TextToSpeechWidgetState();
}

class _TextToSpeechWidgetState extends State<TextToSpeechWidget> {
  @override
  void dispose() {
    super.dispose();
    TextToSpeechService.flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          if (widget.text.isNotEmpty) {
            if (await InternetChecker.hasConnection()) {
              if (widget.text.length <= ttsMaxLength) {
                await TextToSpeechService.speak(widget.text, widget.language);
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
