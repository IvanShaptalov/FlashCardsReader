import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/model/entities/reader/book_model.dart';
import 'package:flashcards_reader/util/enums.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DataBase {
  static Box<FlashCardCollection>? flashcardsSession;
  static Box<String>? themeSession;
  static Box<BookThemes>? settingsSession;
  static Box<BookModel>? booksSession;

  static Box<FlashCardCollection>? flashcardsTestSession;
  static Box<BookThemes>? settingsTestSession;
  static Box<String>? themeTestSession;
  static Box<BookModel>? testBooksSession;

  static bool dbInitialized = false;
  static bool adaptersRegistered = false;

  static Future<bool> initAsync() async {
    try {
      await Hive.initFlutter();
      // register adapters
      await registerAdapters();
      // open session boxes
      flashcardsSession = await Hive.openBox<FlashCardCollection>('flashCards');
      flashcardsTestSession =
          await Hive.openBox<FlashCardCollection>('flashCardsTest');
      themeSession = await Hive.openBox<String>('theme');
      themeTestSession = await Hive.openBox<String>('testTheme');
      // settingsSession = await Hive.openBox<BookThemes>('settings');
      booksSession = await Hive.openBox<BookModel>('books');
      testBooksSession = await Hive.openBox<BookModel>('testBooks');

      settingsTestSession = await Hive.openBox<BookThemes>('testSettings');
      settingsSession = await Hive.openBox<BookThemes>('settings');

      // database initialized
      dbInitialized = true;
      debugPrintIt('Hive initialized');
    } catch (e) {
      debugPrintIt('Error initializing Hive: $e');
      return false;
    }
    return true;
  }

  static Future<bool> registerAdapters() async {
    try {
      Hive.registerAdapter<FlashCardCollection>(FlashCardCollectionAdapter());
      Hive.registerAdapter<FlashCard>(FlashCardAdapter());
      Hive.registerAdapter<BookModel>(BookModelAdapter());
      Hive.registerAdapter<BookStatus>(BookStatusAdapter());
      Hive.registerAdapter<BookFileMeta>(BookFileMetaAdapter());
      Hive.registerAdapter<BookThemes>(BookThemesAdapter());
      Hive.registerAdapter<PDFSettings>(PDFSettingsAdapter());
      Hive.registerAdapter<BookSettings>(BookSettingsAdapter());
      debugPrintIt('Hive adapters registered');
    } catch (e) {
      debugPrintIt('Error registering Hive adapters: $e');
      return false;
    }
    adaptersRegistered = true;
    return true;
  }
}
