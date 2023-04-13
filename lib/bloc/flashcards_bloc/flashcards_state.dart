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
      {List<FlashCardCollection>? flashCards, bool fromTrash = false}) {
    return FlashcardsState(
        isDeleted: fromTrash,
        flashCards: FlashcardDatabaseProvider.getAllFromTrash(fromTrash));
  }

  Future<FlashcardsState> deleteFromTrashAllAsync() async {
    var deletedFlashCards = FlashcardDatabaseProvider.getAllFromTrash(true);
    await FlashcardDatabaseProvider.deleteFlashCardsAsync(deletedFlashCards);
    return FlashcardsState.initial().copyWith(fromTrash: true);
  }

  Future<FlashcardsState> restoreFlashCardCollectionAsync(
      FlashCardCollection flashCardCollection) async {
    await FlashcardDatabaseProvider.writeEditAsync(
        flashCardCollection..isDeleted = false);

    return FlashcardsState.initial().copyWith(fromTrash: false);
  }

  Future<FlashcardsState> addFlashCardCollectionAsync(
      FlashCardCollection flashCardCollection) async {
    await FlashcardDatabaseProvider.writeEditAsync(flashCardCollection);
    return FlashcardsState.initial().copyWith(fromTrash: false);
  }

  Future<FlashcardsState> moveToTrashAsync(
      FlashCardCollection flashCardCollection) async {
    await FlashcardDatabaseProvider.moveToTrashAsync(flashCardCollection, true);
    return FlashcardsState.initial().copyWith(fromTrash: false);
  }
}
