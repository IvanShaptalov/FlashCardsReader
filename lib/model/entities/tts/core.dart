import 'dart:async';
import 'package:flashcards_reader/constants.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechService {
  static FlutterTts flutterTts = FlutterTts();

  static final completer = Completer<void>();
  TextToSpeechService._internal();

  static Future<bool> initTtsEngineAsync() async {
    try {
     
      await flutterTts.awaitSpeakCompletion(true);

      // await flutterTts.getEngines;
      // await flutterTts.getLanguages;
      // String? engine = await flutterTts.getDefaultEngine;
      // if (engine != null && engine.isNotEmpty) {
      //   await flutterTts.setEngine(engine);
        await flutterTts.setPitch(pitch);
        await flutterTts.setVolume(volume);
        await flutterTts.setSpeechRate(rate);
      // } else {
      //   return false;
      // }

      //  flutterTts.setInitHandler(() {
      //   debugPrintIt('tts engine initialized');
      // });

      // debugPrintIt(await flutterTts.getLanguages);

      return true;
    } catch (e) {
      debugPrintIt(e);
      return false;
    }
  }

  static Future<void> speak(String text, String language) async {
    try {
      if (await flutterTts.getDefaultEngine == null) {
        debugPrintIt('tts engine not initialized');
        await initTtsEngineAsync();
      }
      String code = convertLangToTextToSpeechCode(language);
      debugPrintIt('language code: $code');
      if (!await flutterTts.isLanguageAvailable(code)) {
        code = 'en-US';
      }
      if (!await flutterTts.isLanguageInstalled(code)) {
        debugPrintIt('language not installed');
      }
      await flutterTts.setLanguage(code);

      await flutterTts.speak(text).then((value) {
        debugPrintIt('ready to speak');
        flutterTts.setCompletionHandler(() {
          completer.complete();
        });
      });
      return;
    } catch (e) {
      await initTtsEngineAsync();
      debugPrintIt(e);
      return;
    }
  }
}
