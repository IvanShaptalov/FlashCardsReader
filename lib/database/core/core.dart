import 'package:flashcards_reader/model/flashcards/flashcards.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DataBase {
  static Box<FlashCardCollection>? flashcardsSession;
  static Box<String>? themeSession;
  static Box<Map<String, dynamic>>? settingsSession;

  static Box<FlashCardCollection>? flashcardsTestSession;
  static Box<Map<String, dynamic>>? settingsTestSession;
  static Box<String>? themeTestSession;

  static bool dbInitialized = false;
  static bool adaptersRegistered = false;

  static Future<bool> initAsync() async {
    try {
      await Hive.initFlutter();
      // open session boxes
      flashcardsSession = await Hive.openBox<FlashCardCollection>('flashCards');
      flashcardsTestSession =
          await Hive.openBox<FlashCardCollection>('flashCardsTest');
      themeSession = await Hive.openBox<String>('theme');
      themeTestSession = await Hive.openBox<String>('testTheme');
      settingsSession = await Hive.openBox<Map<String, dynamic>>('settings');
      settingsTestSession =
          await Hive.openBox<Map<String, dynamic>>('testSettings');

      // register adapters
      await registerAdapters();

      // database initialized
      dbInitialized = true;
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
    adaptersRegistered = true;
    return true;
  }
}
