part of 'quiz_bloc.dart';

abstract class QuizState {}

// ignore: must_be_immutable
class QuizInitial extends QuizState {
  final String stateId;

  late QuizModel quizModel;

  /// notice, you must manually set [currentCard], else it will be null
  QuizInitial copyWith({
    String? stateId,
    FlashCardCollection? flashCardsCollection,
    FlashCard? currentCard,
    int? cFlashIndex,
    QuizMode? mode,
    int? numberOfFlashCards,
  }) {
    return QuizInitial(
      stateId: stateId ?? this.stateId,
      flashCardsCollection:
          flashCardsCollection ?? quizModel.flashCardsCollection,
      // can copy with null
      currentFlashCard: currentCard,
      flashIndex: cFlashIndex ?? quizModel.flashIndex,
      mode: mode ?? quizModel.mode,
    );
  }

  /// notice, you must manually set [currentCard], else it will be null
  QuizInitial(
      {required this.stateId,
      flashCardsCollection,
      numberOfFlashCards,
      flashIndex,
      currentFlashCard,
      mode}) {
    quizModel = QuizModel(
        flashCardsCollection: flashCardsCollection,
        flashIndex: flashIndex,
        currentFCard: currentFlashCard,
        mode: mode);
  }

  /// ==============================================[METHODS]==============================================
  QuizInitial changeCollection(FlashCardCollection fCollection) {
    return copyWith(
        stateId: uuid.v4(),
        flashCardsCollection: fCollection,
        currentCard: quizModel.currentFCard);
  }

  QuizInitial nextFlash() {
    // return state with next card or null if no more cards
    print('now, when copyWith current Card is :$quizModel.currentCard');
    return copyWith(
      currentCard: quizModel.getNextFlash(),
      stateId: uuid.v4(),
      mode: quizModel.mode,
    );
  }

  Future<QuizInitial> answerFlash(
      bool isAnswerCorrect, FlashCard? flash) async {
    if (flash != null) {
      quizModel.quizFlashCardAsync(flash, isAnswerCorrect);
    }

    // return state with deleted current card from training
    return copyWith(stateId: uuid.v4(), currentCard: quizModel.getNextFlash());
  }

  QuizInitial finishQuiz() {
    // return state with deleted current card from training
    return copyWith(
        currentCard: null,
        flashCardsCollection: flashExample(),
        stateId: uuid.v4());
  }

  QuizInitial changeQuizMode(QuizMode mode) {
    return copyWith(stateId: uuid.v4(), mode: mode);
  }
}
