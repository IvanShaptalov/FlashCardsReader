part of 'flashcards_bloc.dart';

// initialization of data

class FlashcardsState {
  List<FlashCardCollection> flashCards = <FlashCardCollection>[];
  bool isDeleted;

  FlashcardsState({required this.isDeleted, this.flashCards = const []});

  // default state
  factory FlashcardsState.initial() => FlashcardsState(
      isDeleted: false, flashCards: FlashcardDatabaseProvider.getAll());

  FlashcardsState copyWith(
      {List<FlashCardCollection>? flashCards, bool isDeletedP = false}) {
    return FlashcardsState(
        isDeleted: isDeletedP,
        flashCards: FlashcardDatabaseProvider.getAllFromTrash(isDeletedP));
  }
}
