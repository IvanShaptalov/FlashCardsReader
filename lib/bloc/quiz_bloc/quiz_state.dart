part of 'quiz_bloc.dart';

abstract class QuizState {}

// ignore: must_be_immutable
class QuizInitial extends QuizState {
  final String id;
  final FlashCardCollection flashCardsCollection;
  FlashCard? currentCard;

  final QuizModel quizModel = QuizModel(
    flashCardsCollection: flashFixture(),
    numberOfFlashCards: 2,
  );

  // change id to update ui, fucking bloc
  QuizInitial copyWith({
    String? id,
    FlashCardCollection? flashCardsCollection,
    FlashCard? currentCard,
  }) {
    return QuizInitial(
      id: id ?? this.id,
      flashCardsCollection: flashCardsCollection ?? this.flashCardsCollection,
      currentCard: currentCard ?? this.currentCard,
    );
  }

  QuizInitial(
      {required this.id, required this.flashCardsCollection, this.currentCard});

  /// ==============================================[METHODS]==============================================
  factory QuizInitial.changeCollection(FlashCardCollection fCollection) {
    return QuizInitial(id: uuid.v4(), flashCardsCollection: fCollection);
  }

  // factory QuizInitial.changeNumberOfQuestions(int numberOfQuestions) {
  //   return QuizInitial(id: uuid.v4(), flashCardsCollection: flashFixture());
  // }

  QuizInitial nextFlash() {
    // return state with next card or null if no more cards
    return copyWith(
      currentCard: quizModel.getNextFlash(),
      id: uuid.v4(),
    );
  }

  Future<QuizInitial> answerFlash(bool isAnswerCorrect, FlashCard flash) async {
    quizModel.quizFlashCardAsync(flash, isAnswerCorrect);

    // return state with deleted current card from training
    return copyWith(currentCard: null, id: uuid.v4());
  }

  QuizInitial finishQuiz() {
    // return state with deleted current card from training
    return copyWith(
        currentCard: null, flashCardsCollection: flashFixture(), id: uuid.v4());
  }
}
