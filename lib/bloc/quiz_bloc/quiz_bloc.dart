import 'package:bloc/bloc.dart';
import 'package:flashcards_reader/main.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/model/entities/flashcards/quiz_model.dart';
import 'package:flashcards_reader/util/enums.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/views/flashcards/quiz/vertical_quiz_view.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';

List<FlashCard> emptyList = [];

class QuizBloc extends Bloc<QuizEvent, QuizInitial> {
  QuizBloc()
      : super(QuizInitial(
            stateId: uuid.v4(),
            flashCardsCollection: flashExample(),
            currentFlashCard: null,
            flashIndex: 0,
            mode: QuizMode.all,
            numberOfFlashCards: flashExample().flashCardSet.length,
            flashList: emptyList)) {
    on<StartQuizEvent>((event, emit) {
      emit(state.copyWith(
          stateId: uuid.v4(),
          flashCardsCollection: event.flashCardCollection,
          mode: event.mode));
      // clear the previous quiz
      SummaryFlashCardsProvider.clear();
    });
    on<NextFlashEvent>((event, emit) {
      emit(state.nextFlash());
    });
    on<AnswerFlashEvent>((event, emit) async {
      emit(await state.answerFlash(
          event.isAnswerCorrect, state.quizModel.currentFCard));
    });
    on<FinishQuizEvent>((event, emit) {
      emit(state.finishQuiz());
    });
    on<InitQuizEvent>((event, emit) {
      emit(QuizInitial(
          stateId: uuid.v4(),
          flashCardsCollection: event.flashCardsCollection,
          currentFlashCard: null,
          flashIndex: 0,
          mode: QuizMode.all,
          numberOfFlashCards: 0));
    });

    on<ChangeQuizModeEvent>((event, emit) {
      emit(state.changeQuizMode(event.mode));
    });
  }
}
