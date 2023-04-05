import 'package:flashcards_reader/model/flashcards/flashcards.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DataBase {
  static Box<FlashCardCollection>? flashcardsSession;
  static Box<String>? themeSession;
  static Box<Map<String, dynamic>>? settingsSession;

  static Future<bool> initAsync() async {
    try {
      await Hive.initFlutter();
      flashcardsSession = await Hive.openBox<FlashCardCollection>('flashCards');
      themeSession = await Hive.openBox<String>('theme');
      settingsSession = await Hive.openBox<Map<String, dynamic>>('settings');
      debugPrint('Hive initialized');
    } catch (e) {
      debugPrint('Error initializing Hive: $e');
      return false;
    }
    return true;
  }

  static Future<bool> registerAdapters() async {
    try {
      Hive.registerAdapter(FlashCardCollectionAdapter());
      Hive.registerAdapter(FlashCardAdapter());
      debugPrint('Hive adapters registered');
    } catch (e) {
      debugPrint('Error registering Hive adapters: $e');
      return false;
    }
    return true;
  }
}
