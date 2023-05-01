import 'package:flashcards_reader/database/core/table_methods.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/util/enums.dart';
import 'package:flashcards_reader/util/error_handler.dart';

class QuizModel {
  /// ==============================================[FIELDS AND CONSTRUCTOR]============================================
  final FlashCardCollection flashCardsCollection;
  int flashIndex;
  FlashCard? currentFCard;
  final QuizMode mode;

  // training is finished when the current flash card index is greater than the number of flash cards in the collection
  bool get isQuizFinished =>
      flashIndex > flashCardsCollection.flashCardSet.length;

  bool get isEmpty => flashCardsCollection.flashCardSet.isEmpty;

  /// level of learned flash cards, if upper than this value, the flash card considered as learned

  QuizModel(
      {required this.flashCardsCollection,
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
        flashIndex: currentFlashCardIndex ?? flashIndex,
        mode: mode ?? this.mode,
        currentFCard: currentFCard);
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
  FlashCard? getNextFlash({List<FlashCard>? list}) {
    FlashCard? flash;

    /// sort flash cards by mode
    List<FlashCard> flashList =
        list ?? flashCardsCollection.flashCardSet.toList();
    if (list == null) {
      switch (mode) {
        case QuizMode.all:
          flashList = flashCardsCollection.sortedByDateAscending();
          break;
        case QuizMode.hard:
          flashList =
              flashCardsCollection.sortedBySuccessRateFromMostDifficult();
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
    }
    // check current index not out of range and quiz is not finished
    if (flashIndex + 1 <= flashList.length) {
      flashIndex++;
      flash = flashList.elementAt(flashIndex - 1);

      // check if flash card is learned
      if (_isFlashCardLearned(flash)){
        flash = getNextFlash(list: flashList);
      }
      // return flash card
      return flash;
    }
    // return null if quiz is finished
    flashIndex++;
    return null;
  }

  /// train and save the flash card
  Future<bool> quizFlashCardAsync(FlashCard flashCard, bool correct) async {
    if (correct) {
      flashCard.correctAnswers++;
    } else {
      flashCard.wrongAnswers++;
    }

    // delay next flashcard test date
    return await _saveQuizedFlashCard(flashCard);
  }

  Future<bool> _saveQuizedFlashCard(FlashCard flashCard) async {
    // remove flashcard from the collection
    flashCardsCollection.flashCardSet
        .removeWhere((element) => element == flashCard);

    // add flashcard to the collection
    bool result = flashCardsCollection.flashCardSet.add(flashCard);
    FlashcardDatabaseProvider.writeEditAsync(flashCardsCollection);
    return result;
  }

  /// ================================================[HELPER METHODS]================================================

  bool _isFlashCardLearned(FlashCard flashCard) {
    return flashCard.isLearned;
  }
}
