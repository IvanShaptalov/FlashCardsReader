import 'package:flashcards_reader/model/entities/tts/core.dart';
import 'package:flashcards_reader/constants.dart';

import 'package:flashcards_reader/util/internet_checker.dart';
import 'package:flashcards_reader/views/overlay_notification.dart';

class TextToSpeechWrapper {
  static void dispose() {
    TextToSpeechService.flutterTts.stop();
  }

  static void onPressed(text, language) async {
    if (text.isNotEmpty) {
      if (await InternetConnectionChecker.connected()) {
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
