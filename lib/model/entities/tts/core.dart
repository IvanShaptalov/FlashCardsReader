import 'dart:async';
import 'package:flashcards_reader/util/constants.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechService {
  static final TextToSpeechService _instance = TextToSpeechService._internal();
  factory TextToSpeechService() => _instance;
  TextToSpeechService._internal();

  static Future<bool> initTtsEngineAsync() async {
    try {
      flutterTts.setInitHandler(() {
        debugPrintIt('tts engine initialized');
      });
      await flutterTts.getEngines;
      await flutterTts.getLanguages;
      await flutterTts.setEngine(await flutterTts.getDefaultEngine);

      await flutterTts.setPitch(1);
      await flutterTts.setVolume(1);
      await flutterTts.setSpeechRate(0.35);
      debugPrintIt(await flutterTts.getLanguages);
      var copyOfFlutterTts = FlutterTts().setErrorHandler((message) {
        debugPrintIt(message);
      });
      return true;
    } catch (e) {
      debugPrintIt(e);
      return false;
    }
  }

  static FlutterTts flutterTts = FlutterTts();

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

      await flutterTts
          .speak(text)
          .then((value) => debugPrintIt('ready to speak'));
      return;
    } catch (e) {
      await initTtsEngineAsync();
      debugPrintIt(e);
      return;
    }
  }
}
