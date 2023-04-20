part of 'quiz_bloc.dart';

abstract class QuizEvent {}

class StartQuizEvent extends QuizEvent {
  final int numberOfQuestions;
  final FlashCardCollection flashCardsCollection;
  final QuizMode mode;

  StartQuizEvent({
    required this.numberOfQuestions,
    required this.mode,
    required this.flashCardsCollection
  });
}



class NextFlashEvent extends QuizEvent {}

class AnswerFlashEvent extends QuizEvent {
  final bool isAnswerCorrect;

  AnswerFlashEvent({
    required this.isAnswerCorrect,
  });
}

class FinishQuizEvent extends QuizEvent {}

class InitQuizEvent extends QuizEvent {
  final FlashCardCollection flashCardsCollection;

  InitQuizEvent({
    required this.flashCardsCollection,
  });
}
