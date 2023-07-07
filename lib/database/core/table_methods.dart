import 'package:flashcards_reader/database/core/core.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/model/entities/reader/book_model.dart';
import 'package:flashcards_reader/util/enums.dart';
import 'package:flashcards_reader/util/error_handler.dart';

class FlashcardDatabaseProvider {
  static var currentSession = DataBase.flashcardsSession;

  static void selectSession(bool isTest) {
    if (isTest) {
      debugPrintIt('test session selected');
      currentSession = DataBase.flashcardsTestSession;
    } else {
      debugPrintIt('normal session selected');
      currentSession = DataBase.flashcardsSession;
    }
  }

  /// write flashcardcollection object to hive database in flashcards box
  static Future<bool> writeEditAsync(FlashCardCollection flashCard,
      {bool isTest = false}) async {
    if (!flashCard.isValid) {
      return false;
    }
    selectSession(isTest);
    try {
      await currentSession!.put(flashCard.id, flashCard);
      return true;
    } catch (e) {
      debugPrintIt('error while write or edit flashcardCollection $e');
      return false;
    }
  }

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
      await trashMoveFlashCardsAsync(mergeFlashCards, isTest: isTest);

      return true;
    } catch (e) {
      debugPrintIt('error while write or edit flashcardCollection $e');
      return false;
    }
  }

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
      debugPrintIt('error while write or edit List of flashcardCollections $e');
      return false;
    }
  }

  static Future<bool> trashMoveFlashCardsAsync(
      List<FlashCardCollection> flashCards,
      {bool isTest = false,
      bool toTrash = true}) async {
    selectSession(isTest);

    try {
      List<String> ids = [];
      for (var flashCard in flashCards) {
        ids.add(flashCard.id);
        flashCard.isDeleted = toTrash;
        await writeEditAsync(flashCard, isTest: isTest);
      }

      return true;
    } catch (e) {
      debugPrintIt('error move to trash flashcardCollection $e');
      return false;
    }
  }

  static Future<bool> moveToTrashAsync(
      FlashCardCollection flashCard, bool toTrash) async {
    return await writeEditAsync(flashCard..isDeleted = toTrash);
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
      debugPrintIt('error while delete flashcardCollection $e');
      return false;
    }
  }

  static Future<bool> deleteAsync(String id, {bool isTest = false}) async {
    selectSession(isTest);
    try {
      await currentSession!.delete(id);
      return true;
    } catch (e) {
      debugPrintIt('error while delete flashcardCollection $e');
      return false;
    }
  }

  static List<FlashCardCollection> getAll({bool isTest = false}) {
    selectSession(isTest);
    try {
      return FlashCardCollection.sortedByDate(currentSession!.values.toSet())
          .toList();
    } catch (e) {
      debugPrintIt('error while get flashcardCollection $e');
      return [];
    }
  }

  static List<FlashCardCollection> getAllFromTrash(bool isDeleted,
      {bool isTest = false}) {
    selectSession(isTest);
    try {
      return FlashCardCollection.sortedByDate(currentSession!.values
              .where((element) => element.isDeleted == isDeleted)
              .toSet())
          .toList();
    } catch (e) {
      debugPrintIt('error while get flashcardCollection $e');
      return [];
    }
  }

  static FlashCardCollection? getById(String collectionId,
      {bool isTest = false}) {
    selectSession(isTest);

    try {
      return currentSession!.get(collectionId);
    } catch (e) {
      debugPrintIt('error while get flashcardCollection $e');
      return null;
    }
  }
}

class ThemeDatabaseProvider {
  static var currentSession = DataBase.settingsSession;

  static void selectSession(bool isTest) {
    if (isTest) {
      debugPrintIt('test session selected');
      currentSession = DataBase.settingsTestSession;
    } else {
      debugPrintIt('normal session selected');
      currentSession = DataBase.settingsSession;
    }
  }

  /// write flashcardcollection object to hive database in flashcards box
  static Future<bool> writeEditAsync(BookThemes theme,
      {bool isTest = false}) async {
    selectSession(isTest);
    try {
      await currentSession!.put('theme', theme);
      return true;
    } catch (e) {
      debugPrintIt('error while write or edit flashcardCollection $e');
      return false;
    }
  }

  static Future<BookThemes> getAsync({bool isTest = false}) async {
    selectSession(isTest);

    var themeObj = currentSession!.get('theme');
    if (themeObj == null) {
      await writeEditAsync(BookThemes.light, isTest: isTest);
      return BookThemes.light;
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
      debugPrintIt('error while delete flashcardCollection $e');
      return false;
    }
  }
}

class BookDatabaseProvider {
  static var currentSession = DataBase.booksSession;

  static void selectSession(bool isTest) {
    if (isTest) {
      debugPrintIt('test session selected');
      currentSession = DataBase.booksSession;
    } else {
      debugPrintIt('normal session selected');
      currentSession = DataBase.testBooksSession;
    }
  }

  /// write book object to hive database in  box
  static Future<bool> writeEditAsync(BookModel book,
      {bool isTest = false}) async {
    selectSession(isTest);
    try {
      await currentSession!.put(book.id(), book);
      return true;
    } catch (e) {
      debugPrintIt('error while write or edit books $e');
      return false;
    }
  }

  static List<BookModel> getAll({bool isTest = false}) {
    selectSession(isTest);
    try {
      return BookModel.sortedByDate(currentSession!.values.toList());
    } catch (e) {
      debugPrintIt('error while get books $e');
      return [];
    }
  }

  static List<BookModel> getFiltered(
      {bool isTest = false,
      reading = false,
      read = false,
      wantToRead = false,
      favourite = false}) {
    selectSession(isTest);
    try {
      if (reading == true) {
        return BookModel.sortedByDate(currentSession!.values
            .toList()
            .where((element) => element.status.reading == true)
            .toList());
      } else if (read == true) {
        return BookModel.sortedByDate(currentSession!.values
            .toList()
            .where((element) => element.status.read == true)
            .toList());
      } else if (wantToRead == true) {
        return BookModel.sortedByDate(currentSession!.values
            .toList()
            .where((element) => element.status.wantToRead == true)
            .toList());
      } else if (favourite == true) {
        return BookModel.sortedByDate(currentSession!.values
            .toList()
            .where((element) => element.status.favourite == true)
            .toList());
      }
      return BookModel.sortedByDate(currentSession!.values.toList());
    } catch (e) {
      debugPrintIt('error while get books $e');
      return [];
    }
  }
}
