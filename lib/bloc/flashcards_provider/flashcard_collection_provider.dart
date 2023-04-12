import 'package:flashcards_reader/database/core/table_methods.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flutter/foundation.dart';

class FlashCardCollectionProvider {
  /// get flashcards or deleted flashcards, not deleted by default
  static List<FlashCardCollection> getFlashCards({bool? isDeleted}) {
    isDeleted ??= false;
    return FlashcardDatabaseProvider.getAllFromTrash(isDeleted = isDeleted);
  }

  static Future<bool> addEditFlashCardCollectionAsync(
      FlashCardCollection flashCardCollection) async {
    return await FlashcardDatabaseProvider.writeEditAsync(flashCardCollection);
  }

  static Future<bool> deleteFlashCardCollectionAsync(
      FlashCardCollection flashCardCollection) async {
    return await FlashcardDatabaseProvider.deleteAsync(flashCardCollection.id);
  }

  static Future<bool> deleteFromTrashAllAsync() async {
    var deletedFlashCards = FlashcardDatabaseProvider.getAllFromTrash(true);
    return await FlashcardDatabaseProvider.deleteFlashCardsAsync(
        deletedFlashCards);
  }

  static Future<bool> moveToTrashAsync(
      FlashCardCollection flashCardCollection) async {
    return await FlashcardDatabaseProvider.writeEditAsync(
        flashCardCollection..isDeleted = true);
  }

  static Future<bool> restoreFlashCardCollectionAsync(
      FlashCardCollection flashCardCollection) async {
    return await FlashcardDatabaseProvider.writeEditAsync(
        flashCardCollection..isDeleted = false);
  }

  static Future<bool> mergeFlashCardsCollectionAsync(
      List<FlashCardCollection> mergedFlashCards,
      FlashCardCollection receiverFlashcard) async {
    return await FlashcardDatabaseProvider.mergeAsync(
        mergedFlashCards, receiverFlashcard);
  }

  static bool _isMergeMode = false;
  static bool get isMergeModeStarted => _isMergeMode;
  static List<FlashCardCollection> flashcardsToMerge = [];
  static FlashCardCollection? targetFlashCard;

  static void deactivateMergeMode() {
    debugPrint("deactivateMergeMode");
    _isMergeMode = false;
    flashcardsToMerge.clear();
    targetFlashCard = null;
  }

  static void activateMergeMode(FlashCardCollection target) {
    debugPrint("activateMergeMode");
    _isMergeMode = true;
    flashcardsToMerge.clear();
    targetFlashCard = target;
  }

  static bool mergeModeCondition() =>
      isMergeModeStarted &&
      targetFlashCard != null &&
      flashcardsToMerge.isNotEmpty;
}