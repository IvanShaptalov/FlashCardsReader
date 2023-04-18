import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';

class FlashCardTrainingModel {
  /// ==============================================[FIELDS AND CONSTRUCTOR]============================================
  final FlashCardCollection flashCardsCollection;
  int _currentFlashCardIndex = 0;
  final int numberOfFlashCards;

  // training is finished when the current flash card index is greater than the number of flash cards in the collection
  bool get isTrainingFinished =>
      _currentFlashCardIndex >= flashCardsCollection.flashCardSet.length ||
      _currentFlashCardIndex >= numberOfFlashCards ||
      isEmpty;

  bool get isEmpty => flashCardsCollection.flashCardSet.isEmpty;

  /// level of learned flash cards, if upper than this value, the flash card considered as learned
  final int _learnedBound = 5;

  FlashCardTrainingModel({
    required this.flashCardsCollection,
    required this.numberOfFlashCards,
  });

  FlashCardTrainingModel copyWith({
    FlashCardCollection? flashCardsCollection,
    int? currentFlashCardIndex,
    int? numberOfFlashCards,
  }) {
    return FlashCardTrainingModel(
      flashCardsCollection: flashCardsCollection ?? this.flashCardsCollection,
      numberOfFlashCards: numberOfFlashCards ?? this.numberOfFlashCards,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlashCardTrainingModel &&
          runtimeType == other.runtimeType &&
          flashCardsCollection == other.flashCardsCollection &&
          _currentFlashCardIndex == other._currentFlashCardIndex &&
          isTrainingFinished == other.isTrainingFinished;

  @override
  int get hashCode =>
      flashCardsCollection.hashCode ^
      _currentFlashCardIndex.hashCode ^
      isTrainingFinished.hashCode;

  @override
  String toString() {
    return 'FlashCardTrainingModel{flashCards: $flashCardsCollection, currentFlashCardIndex: $_currentFlashCardIndex, isTrainingFinished: $isTrainingFinished}';
  }

  /// ================================================[TRAINIG METHODS]================================================
  /// Train a flash card collection
  FlashCard? getToTrain() {
    // check if the training is finished
    if (_currentFlashCardIndex > numberOfFlashCards || isTrainingFinished) {
      return null;
    }
    // if learned - get the next flash card
    if (isFlashCardLearned(
        flashCardsCollection.flashCardSet.elementAt(_currentFlashCardIndex))) {
      // increment the current flash card index and try to get the next flash card
      _currentFlashCardIndex++;
      return getToTrain();
    }

    // if not learned - get the current flash card
    return flashCardsCollection.flashCardSet.elementAt(_currentFlashCardIndex);
  }

  int trainFlashCard(FlashCard flashCard, bool correct) {
    if (correct) {
      flashCard.correctAnswers++;
    } else {
      flashCard.wrongAnswers++;
    }

    // delay next flashcard test date
    int days = delayTestDate(flashCard, correct);
    saveTrainedFlashCard(flashCard);
    return days;
  }

  bool saveTrainedFlashCard(FlashCard flashCard) {
    // remove flashcard from the collection
    flashCardsCollection.flashCardSet
        .removeWhere((element) => element == flashCard);

    // add flashcard to the collection
    return flashCardsCollection.flashCardSet.add(flashCard);
  }

  /// ================================================[HELPER METHODS]================================================

  int delayTestDate(FlashCard flashCard, bool answerIsCorrect) {
    Duration difference = flashCard.nextTest.difference(flashCard.lastTested);
    int delayedDays = 0;

    // round date to switch case

    // add 1 hour to the difference to avoid 0 days difference
    //for example 1 day difference is 23 hours 59 minutes 59 seconds 999 milliseconds - cpu execution time
    int difDays = (difference + const Duration(hours: 1)).inDays;
    if (answerIsCorrect) {
      if (difDays <= 0) {
        delayedDays = 1;
      } else if (difDays <= 2) {
        delayedDays = 3;
      } else if (difDays <= 6) {
        delayedDays = 7;
      } else if (difDays <= 13) {
        delayedDays = 14;
      } else if (difDays <= 29) {
        delayedDays = 30;
      } else {
        delayedDays = 14;
      }
    } else {
      if (difDays <= 1) {
        delayedDays = 0;
      } else if (difDays <= 3) {
        delayedDays = 1;
      } else if (difDays <= 7) {
        delayedDays = 3;
      } else if (difDays <= 14) {
        delayedDays = 7;
      } else if (difDays <= 30) {
        delayedDays = 14;
      } else {
        delayedDays = 1;
      }
    }

    flashCard.nextTest = DateTime.now().add(Duration(days: delayedDays));

    flashCard.lastTested = DateTime.now();
    // return delayedDays to test functionality of the method
    return delayedDays;
  }

  bool isFlashCardLearned(FlashCard flashCard) {
    return flashCard.correctAnswers - flashCard.wrongAnswers >= _learnedBound;
  }

  /// Train a flash card
  FlashCard setUpFlashCard(int index) {
    return flashCardsCollection.flashCardSet.elementAt(index);
  }
}
