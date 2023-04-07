import 'package:flashcards_reader/database/core/core.dart';
import 'package:flashcards_reader/model/flashcards/flashcards.dart';
import 'package:flashcards_reader/util/enums.dart';
import 'package:flashcards_reader/util/error_handler.dart';

class FlashcardDatabaseProvider {
  static var currentSession = DataBase.flashcardsSession;

  static void selectSession(bool isTest) {
    if (isTest) {
      debugPrint('test session selected');
      currentSession = DataBase.flashcardsTestSession;
    } else {
      debugPrint('normal session selected');
      currentSession = DataBase.flashcardsSession;
    }
  }

  /// write flashcardcollection object to hive database in flashcards box
  static Future<bool> writeEditAsync(FlashCardCollection flashCard,
      {bool isTest = false}) async {
    selectSession(isTest);
    try {
      await currentSession!.put(flashCard.id, flashCard);
      return true;
    } catch (e) {
      debugPrint('error while write or edit flashcardCollection $e');
      return false;
    }
  }

  // TODO test
  static Future<bool> mergeAsync(List<FlashCardCollection> mergeFlashCards,
      FlashCardCollection targetFlashCard,
      {bool isTest = false}) async {
    selectSession(isTest);
    try {
      // merge flashcards
      Set<FlashCard> flashcards = {};
      flashcards.addAll(mergeFlashCards
          .map((e) => e.flashCardSet)
          .expand((element) => element));
      flashcards.addAll(targetFlashCard.flashCardSet);

      targetFlashCard.flashCardSet = flashcards;

      // save flashcards in new collection
      await currentSession!.put(targetFlashCard.id, targetFlashCard);

      // delete old collections
      await deleteFlashCardsAsync(mergeFlashCards, isTest: isTest);
      return true;
    } catch (e) {
      debugPrint('error while write or edit flashcardCollection $e');
      return false;
    }
  }

  // TODO test
  static Future<bool> deleteFlashCardsAsync(
      List<FlashCardCollection> flashCards,
      {bool isTest = false}) async {
    selectSession(isTest);

    try {
      List<String> ids = [];
      for (var flashCard in flashCards) {
        ids.add(flashCard.id);
      }
      await currentSession!.deleteAll(ids);
      return true;
    } catch (e) {
      debugPrint('error while write or edit flashcardCollection $e');
      return false;
    }
  }

  static Future<bool> deleteAllAsync({bool isTest = false}) async {
    selectSession(isTest);

    try {
      var flashCards = getAll(isTest: isTest);
      List<String> ids = [];
      for (var flashCard in flashCards) {
        ids.add(flashCard.id);
      }
      await currentSession!.deleteAll(ids);
      return true;
    } catch (e) {
      debugPrint('error while write or edit flashcardCollection $e');
      return false;
    }
  }

  static Future<bool> deleteAsync(String id, {bool isTest = false}) async {
    selectSession(isTest);
    try {
      await currentSession!.delete(id);
      return true;
    } catch (e) {
      debugPrint('error while delete flashcardCollection $e');
      return false;
    }
  }

  static List<FlashCardCollection> getAll({bool isTest = false}) {
    selectSession(isTest);
    try {
      return FlashCardCollection.sortedByDate(currentSession!.values.toSet()).toList();
    } catch (e) {
      debugPrint('error while get flashcardCollection $e');
      return [];
    }
  }

  static FlashCardCollection? getById(String collectionId,
      {bool isTest = false}) {
    selectSession(isTest);

    try {
      return currentSession!.get(collectionId);
    } catch (e) {
      debugPrint('error while get flashcardCollection $e');
      return null;
    }
  }
}

class ThemeDatabaseProvider {
  static var currentSession = DataBase.settingsSession;

  static void selectSession(bool isTest) {
    if (isTest) {
      debugPrint('test session selected');
      currentSession = DataBase.settingsTestSession;
    } else {
      debugPrint('normal session selected');
      currentSession = DataBase.settingsSession;
    }
  }

  /// write flashcardcollection object to hive database in flashcards box
  static Future<bool> writeEditAsync(Themes theme,
      {bool isTest = false}) async {
    selectSession(isTest);
    try {
      await currentSession!.put('theme', theme);
      return true;
    } catch (e) {
      debugPrint('error while write or edit flashcardCollection $e');
      return false;
    }
  }

  static Future<Themes> getAsync({bool isTest = false}) async {
    selectSession(isTest);

    var themeObj = currentSession!.get('theme');
    if (themeObj == null) {
      await writeEditAsync(Themes.light, isTest: isTest);
      return Themes.light;
    } else {
      return themeObj;
    }
  }

  static Future<bool> deleteAsync({bool isTest = false}) async {
    selectSession(isTest);
    try {
      await currentSession!.delete('theme');
      return true;
    } catch (e) {
      debugPrint('error while delete flashcardCollection $e');
      return false;
    }
  }
}
