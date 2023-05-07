import 'dart:async';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechService {
  static final TextToSpeechService _instance = TextToSpeechService._internal();
  factory TextToSpeechService() => _instance;
  TextToSpeechService._internal();

  Future<bool> initTtsEngineAsync() async {
    try {
      await flutterTts.setEngine(await flutterTts.getDefaultEngine);
      return true;
    } catch (e) {
      debugPrintIt(e);
      return false;
    }
  }

  static FlutterTts flutterTts = FlutterTts();

  static Future<bool> speak(String text, String languageCode) async {
    try {
      print('try');
      await flutterTts.setLanguage(languageCode);
      await flutterTts.setPitch(1);
      await flutterTts.setSpeechRate(0.4);
      await flutterTts.speak(text);
    } catch (e) {
      debugPrintIt(e);
      return false;
    }
    return true;
  }
}
