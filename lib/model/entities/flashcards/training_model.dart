import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/util/enums.dart';

class TrainingModel {
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

  TrainingModel({
    required this.flashCardsCollection,
    required this.numberOfFlashCards,
  });

  TrainingModel copyWith({
    FlashCardCollection? flashCardsCollection,
    int? currentFlashCardIndex,
    int? numberOfFlashCards,
  }) {
    return TrainingModel(
      flashCardsCollection: flashCardsCollection ?? this.flashCardsCollection,
      numberOfFlashCards: numberOfFlashCards ?? this.numberOfFlashCards,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrainingModel &&
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
  /// get the next flash card to train
  FlashCard? getToTrain({TrainMode mode = TrainMode.all}) {
    List<FlashCard> flashList = flashCardsCollection.flashCardSet.toList();

    switch (mode) {
      case TrainMode.all:
        flashList = flashCardsCollection.flashCardSet.toList();
        break;
      case TrainMode.hard:
        flashList = flashCardsCollection.sortedBySuccessRateFromMostDifficult();
        break;
      case TrainMode.simple:
        flashList = flashCardsCollection.sortedBySuccessRateFromMostSimple();
        break;
      case TrainMode.newest:
        flashList = flashCardsCollection.sortedByDateAscending();
        break;
      case TrainMode.oldest:
        flashList = flashCardsCollection.sortedByDateDescending();
        break;
      case TrainMode.random:
        flashList = flashCardsCollection.flashCardSet.toList();
        break;

      default:
        flashList = flashCardsCollection.flashCardSet.toList();
    }

    // check if the training is finished
    if (_currentFlashCardIndex > numberOfFlashCards || isTrainingFinished) {
      return null;
    }
    // if learned - get the next flash card
    if (_isFlashCardLearned(flashList.elementAt(_currentFlashCardIndex))) {
      // increment the current flash card index and try to get the next flash card
      _currentFlashCardIndex++;

      return getToTrain(mode: mode);
    }

    // if not learned - get the current flash card
    return flashList.elementAt(_currentFlashCardIndex);
  }

  /// train and save the flash card
  Future<bool> trainFlashCardAsync(FlashCard flashCard, bool correct) async {
    if (correct) {
      flashCard.correctAnswers++;
    } else {
      flashCard.wrongAnswers++;
    }

    // delay next flashcard test date
    return await _saveTrainedFlashCardInRuntime(flashCard);
  }

  Future<bool> _saveTrainedFlashCardInRuntime(FlashCard flashCard) async {
    // remove flashcard from the collection
    flashCardsCollection.flashCardSet
        .removeWhere((element) => element == flashCard);

    // add flashcard to the collection
    return flashCardsCollection.flashCardSet.add(flashCard);
  }

  /// ================================================[HELPER METHODS]================================================

  bool _isFlashCardLearned(FlashCard flashCard) {
    return flashCard.correctAnswers - flashCard.wrongAnswers >= _learnedBound ||
        flashCard.isLearned;
  }
}
