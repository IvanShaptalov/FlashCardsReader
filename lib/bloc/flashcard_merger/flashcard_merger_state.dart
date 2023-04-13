part of 'flashcard_merger_bloc.dart';

// initialization of data

class FlashcardMergerState {
  List<FlashCardCollection> flashCards = <FlashCardCollection>[];
  bool isDeleted;

  FlashcardMergerState({required this.isDeleted, this.flashCards = const []});

  // default state
  factory FlashcardMergerState.initial() => FlashcardMergerState(
      isDeleted: false, flashCards: FlashcardDatabaseProvider.getAll());

  /// ===============================================================[PROVIDER METHODS]===============================================================
  FlashcardMergerState copyWith(
      {List<FlashCardCollection>? flashCards, bool fromTrash = false}) {
    return FlashcardMergerState(
        isDeleted: fromTrash,
        flashCards: FlashcardDatabaseProvider.getAllFromTrash(fromTrash));
  }

  Future<FlashcardMergerState> deleteFromTrashAllAsync() async {
    var deletedFlashCards = FlashcardDatabaseProvider.getAllFromTrash(true);
    await FlashcardDatabaseProvider.deleteFlashCardsAsync(deletedFlashCards);
    return FlashcardMergerState.initial().copyWith(fromTrash: true);
  }

  Future<FlashcardMergerState> restoreFlashCardCollectionAsync(
      FlashCardCollection flashCardCollection) async {
    await FlashcardDatabaseProvider.writeEditAsync(
        flashCardCollection..isDeleted = false);

    return FlashcardMergerState.initial().copyWith(fromTrash: false);
  }

  Future<FlashcardMergerState> addFlashCardCollectionAsync(
      FlashCardCollection flashCardCollection) async {
    await FlashcardDatabaseProvider.writeEditAsync(flashCardCollection);
    return FlashcardMergerState.initial().copyWith(fromTrash: false);
  }

  Future<FlashcardMergerState> moveToTrashAsync(
      FlashCardCollection flashCardCollection) async {
    await FlashcardDatabaseProvider.moveToTrashAsync(flashCardCollection, true);
    return FlashcardMergerState.initial().copyWith(fromTrash: false);
  }

   // static Future<bool> deleteFlashCardCollectionAsync(
  //     FlashCardCollection flashCardCollection) async {
  //   return await FlashcardDatabaseProvider.deleteAsync(flashCardCollection.id);
  // }  
}
