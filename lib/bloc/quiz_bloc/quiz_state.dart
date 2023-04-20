part of 'quiz_bloc.dart';

abstract class QuizState {}

// ignore: must_be_immutable
class QuizInitial extends QuizState {
  final String id;
  final FlashCardCollection flashCardsCollection;
  FlashCard? currentCard;

  late QuizModel quizModel;

  // change id to update ui, fucking bloc
  QuizInitial copyWith({
    String? id,
    FlashCardCollection? flashCardsCollection,
    FlashCard? currentCard,
    int? cFlashIndex,
  }) {
    return QuizInitial(
        id: id ?? this.id,
        flashCardsCollection: flashCardsCollection ?? this.flashCardsCollection,
        currentCard: currentCard,
        flashIndex: cFlashIndex ?? quizModel.flashIndex);
  }

  QuizInitial(
      {required this.id,
      required this.flashCardsCollection,
      this.currentCard,
      flashIndex}) {
    quizModel = QuizModel(
        flashCardsCollection: flashCardsCollection,
        numberOfFlashCards: flashCardsCollection.flashCardSet.length,
        flashIndex: flashIndex ?? 0);
  }

  /// ==============================================[METHODS]==============================================
  QuizInitial changeCollection(FlashCardCollection fCollection) {
    return copyWith(id: uuid.v4(), flashCardsCollection: fCollection);
  }

  QuizInitial nextFlash() {
    // return state with next card or null if no more cards
    print('now, when copyWith current Card is :$currentCard');
    return copyWith(
      currentCard: quizModel.getNextFlash(),
      id: uuid.v4(),
    );
  }

  Future<QuizInitial> answerFlash(
      bool isAnswerCorrect, FlashCard? flash) async {
    if (flash != null) {
      quizModel.quizFlashCardAsync(flash, isAnswerCorrect);
    }

    // return state with deleted current card from training
    return copyWith(id: uuid.v4(), currentCard: quizModel.getNextFlash());
  }

  QuizInitial finishQuiz() {
    // return state with deleted current card from training
    return copyWith(
        currentCard: null, flashCardsCollection: flashFixture(), id: uuid.v4());
  }
}
