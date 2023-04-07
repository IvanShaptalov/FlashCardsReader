import 'package:flashcards_reader/database/core/table_methods.dart';
import 'package:flashcards_reader/model/flashcards/flashcards_model.dart';

class FlashCardCollectionProvider {
  static List<FlashCardCollection> getFlashCards() {
    return FlashcardDatabaseProvider.getAll();
  }

  static Future<bool> addEditFlashCardCollectionAsync(
      FlashCardCollection flashCardCollection) async {
    return await FlashcardDatabaseProvider.writeEditAsync(flashCardCollection);
  }

  static Future<bool> deleteFlashCardCollectionAsync(
      FlashCardCollection flashCardCollection) async {
    return await FlashcardDatabaseProvider.deleteAsync(flashCardCollection.id);
  }

  static Future<bool> mergeFlashCardsCollectionAsync(
      List<FlashCardCollection> mergedFlashCards,
      FlashCardCollection receiverFlashcard) async {
    return await FlashcardDatabaseProvider.mergeAsync(
        mergedFlashCards, receiverFlashcard);
  }
}
