part of 'flashcards_bloc.dart';

// initialization of data

class FlashcardsState {
  List<FlashCardCollection> flashCards = <FlashCardCollection>[];
  bool isDeleted;

  FlashcardsState({required this.isDeleted, this.flashCards = const []});

  // default state
  factory FlashcardsState.initial() => FlashcardsState(
      isDeleted: false, flashCards: FlashcardDatabaseProvider.getAll());

  /// ===============================================================[PROVIDER METHODS]===============================================================
  FlashcardsState copyWith(
      {List<FlashCardCollection>? flashCards, bool isDeletedP = false}) {
    return FlashcardsState(
        isDeleted: isDeletedP,
        flashCards: FlashcardDatabaseProvider.getAllFromTrash(isDeletedP));
  }

  Future<FlashcardsState> deleteFromTrashAllAsync() async {
    var deletedFlashCards = FlashcardDatabaseProvider.getAllFromTrash(true);
    await FlashcardDatabaseProvider.deleteFlashCardsAsync(deletedFlashCards);
    return FlashcardsState.initial().copyWith(isDeletedP: true);
  }

  Future<FlashcardsState> restoreFlashCardCollectionAsync(
      FlashCardCollection flashCardCollection) async {
    await FlashcardDatabaseProvider.writeEditAsync(
        flashCardCollection..isDeleted = false);

    return FlashcardsState.initial().copyWith(isDeletedP: false);
  }
}
