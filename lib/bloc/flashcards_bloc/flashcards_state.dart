part of 'flashcards_bloc.dart';

// initialization of data

class FlashCardsState {
  List<FlashCardCollection>? flashCards = <FlashCardCollection>[];
  bool isDeleted;

  FlashCardsState({required this.isDeleted, this.flashCards});

  // default state
  factory FlashCardsState.initial() => FlashCardsState(
      isDeleted: false, flashCards: FlashcardDatabaseProvider.getAll());

  FlashCardsState copyWith(
      {List<FlashCardCollection>? flashCards, bool isDeletedP = false}) {
    return FlashCardsState(
        isDeleted: isDeletedP,
        flashCards: FlashcardDatabaseProvider.getAllFromTrash(isDeletedP));
  }
}
