import 'package:flashcards_reader/database/core/table_methods.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/model/entities/flashcards/training_model.dart';
import 'package:flashcards_reader/util/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'flash_training_event.dart';

part 'flash_training_state.dart';

class FlashTrainingBloc extends Bloc<FlashTrainingEvent, FlashTrainingState> {
  FlashTrainingBloc() : super(FlashTrainingState.emptyInit()) {
    on<InitTrainingModelEvent>((event, emit) => initTraining(event, emit));
    on<SelectTrainingModeEvent>((event, emit) => selectMode(event, emit));
    on<GetToTrainEvent>((event, emit) => getToTrain(event, emit));
    on<TrainFlashCardEvent>((event, emit) => trainFlashCard(event, emit));
  }

  /// initialize the training model to current flashcard collection
  initTraining(InitTrainingModelEvent event, Emitter<FlashTrainingState> emit) {
    emit(state.init(trainingModel: event.trainingModel));
  }

  selectMode(SelectTrainingModeEvent event, Emitter<FlashTrainingState> emit) {
    emit(state.selectMode(event.mode));
  }

  getToTrain(GetToTrainEvent event, Emitter<FlashTrainingState> emit) {
    emit(state.getToTrain());
  }

  trainFlashCard(TrainFlashCardEvent event, Emitter<FlashTrainingState> emit) {
    emit(state.trainFlashCard(event.isAnswerCorrect));
  }
}
