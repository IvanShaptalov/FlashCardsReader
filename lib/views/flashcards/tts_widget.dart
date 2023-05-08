import 'package:flashcards_reader/model/entities/tts/core.dart';
import 'package:flashcards_reader/util/constants.dart';

import 'package:flashcards_reader/util/internet_checker.dart';
import 'package:flashcards_reader/views/overlay_notification.dart';

class TextToSpeechWrapper {
  static void dispose() {
    TextToSpeechService.flutterTts.stop();
  }

  static void onPressed(text, language) async {
    if (text.isNotEmpty) {
      if (await InternetChecker.hasConnection()) {
        if (text.length <= ttsMaxLength) {
          await TextToSpeechService.speak(text, language);
        } else {
          OverlayNotificationProvider.showOverlayNotification('text too long',
              status: NotificationStatus.info);
        }
      } else {
        OverlayNotificationProvider.showOverlayNotification(
            'check internet connection',
            status: NotificationStatus.info);
      }
    } else {
      OverlayNotificationProvider.showOverlayNotification('add word first',
          status: NotificationStatus.info);
    }
  }
}
