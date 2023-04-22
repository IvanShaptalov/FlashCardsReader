import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/util/enums.dart';
import 'package:flashcards_reader/util/error_handler.dart';

class QuizModel {
  /// ==============================================[FIELDS AND CONSTRUCTOR]============================================
  final FlashCardCollection flashCardsCollection;
  int flashIndex;
  final int numberOfFlashCards;
  FlashCard? currentFCard;
  final QuizMode mode;

  // training is finished when the current flash card index is greater than the number of flash cards in the collection
  bool get isQuizFinished =>
      flashIndex >= flashCardsCollection.flashCardSet.length ||
      flashIndex >= numberOfFlashCards ||
      isEmpty;

  bool get isEmpty => flashCardsCollection.flashCardSet.isEmpty;

  /// level of learned flash cards, if upper than this value, the flash card considered as learned
  final int _learnedBound = 5;

  QuizModel(
      {required this.flashCardsCollection,
      required this.numberOfFlashCards,
      this.flashIndex = 0,
      required this.mode,
      this.currentFCard});

  QuizModel copyWith(
      {FlashCardCollection? flashCardsCollection,
      int? currentFlashCardIndex,
      int? numberOfFlashCards,
      QuizMode? mode}) {
    return QuizModel(
      flashCardsCollection: flashCardsCollection ?? this.flashCardsCollection,
      numberOfFlashCards: numberOfFlashCards ?? this.numberOfFlashCards,
      flashIndex: currentFlashCardIndex ?? this.flashIndex,
      mode: mode ?? this.mode,
      currentFCard: currentFCard
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuizModel &&
          runtimeType == other.runtimeType &&
          flashCardsCollection == other.flashCardsCollection &&
          flashIndex == other.flashIndex &&
          isQuizFinished == other.isQuizFinished;

  @override
  int get hashCode =>
      flashCardsCollection.hashCode ^
      flashIndex.hashCode ^
      isQuizFinished.hashCode;

  @override
  String toString() {
    return 'FlashCardTrainingModel{flashCards: $flashCardsCollection, currentFlashCardIndex: $flashIndex, isTrainingFinished: $isQuizFinished}';
  }

  /// ================================================[TRAINIG METHODS]================================================
  /// get the next flash card to train
  FlashCard? getNextFlash({QuizMode mode = QuizMode.all}) {
    /// sort flash cards by mode
    List<FlashCard> flashList = flashCardsCollection.flashCardSet.toList();

    switch (mode) {
      case QuizMode.all:
        flashList = flashCardsCollection.sortedByDateAscending();
        break;
      case QuizMode.hard:
        flashList = flashCardsCollection.sortedBySuccessRateFromMostDifficult();
        break;
      case QuizMode.simple:
        flashList = flashCardsCollection.sortedBySuccessRateFromMostSimple();
        break;
      case QuizMode.newest:
        flashList = flashCardsCollection.sortedByDateAscending();
        break;
      case QuizMode.oldest:
        flashList = flashCardsCollection.sortedByDateDescending();
        break;
      case QuizMode.random:
        flashList = flashCardsCollection.flashCardSet.toList();
        break;

      default:
        flashList = flashCardsCollection.flashCardSet.toList();
    }
    // check current index not out of range and quiz is not finished

    if (flashIndex + 1 <= flashList.length) {
      flashIndex++;
    } else {
      debugPrintIt(flashIndex);
      debugPrintIt('end quiz');
      return null;
    }
    debugPrintIt('current flash card index: $flashIndex');

    // if learned - get the next flash card

    if (_isFlashCardLearned(flashList.elementAt(flashIndex - 1))) {
      // increment the current flash card index and try to get the next flash card
      var flash = getNextFlash(mode: mode);
      debugPrintIt('flash: $flash');
      debugPrintIt(
          '==================================================END==================================================');

      // if the next flash null ,try to find the next flash card
      return getNextFlash(mode: mode);
    }

    // if not learned - get the current flash card and increment the current flash card index
    return flashList.elementAt(flashIndex - 1);
  }

  /// train and save the flash card
  Future<bool> quizFlashCardAsync(FlashCard flashCard, bool correct) async {
    if (correct) {
      flashCard.correctAnswers++;
    } else {
      flashCard.wrongAnswers++;
    }

    // delay next flashcard test date
    return await _saveQuizedFlashCardInRuntime(flashCard);
  }

  Future<bool> _saveQuizedFlashCardInRuntime(FlashCard flashCard) async {
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
