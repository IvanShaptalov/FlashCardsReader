import 'package:bloc/bloc.dart';
import 'package:flashcards_reader/main.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/model/entities/flashcards/quiz_model.dart';
import 'package:flashcards_reader/util/enums.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizInitial> {
  QuizBloc()
      : super(QuizInitial(
          id: uuid.v4(),
          flashCardsCollection: flashFixture(),
        )) {
    on<StartQuizEvent>((event, emit) {
      emit(QuizInitial(
          id: uuid.v4(), flashCardsCollection: event.flashCardsCollection));
    });
    on<NextFlashEvent>((event, emit) {
      emit(state.nextFlash());
    });
    on<AnswerFlashEvent>((event, emit) async {
      emit(await state.answerFlash(event.isAnswerCorrect, state.currentCard));
    });
    on<FinishQuizEvent>((event, emit) {
      emit(state.finishQuiz());
    });
    on<InitQuizEvent>((event, emit) {
      emit(QuizInitial(
          id: uuid.v4(), flashCardsCollection: event.flashCardsCollection));
    });

    on<ChangeQuizModeEvent>((event, emit) {
      emit(state.changeQuizMode(event.mode));
    });
  }
}
