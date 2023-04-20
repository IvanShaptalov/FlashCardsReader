import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/model/entities/flashcards/training_model.dart';
import 'package:flashcards_reader/util/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'flash_training_event.dart';

part 'flash_training_state.dart';

class FlashTrainingBloc extends Bloc<FlashTrainingEvent, FlashTrainingState> {
  FlashTrainingBloc() : super(FlashTrainingState.emptyInit()) {
    on<InitTrainingModelEvent>((event, emit) => _initTraining(event, emit));
    on<SelectTrainingModeEvent>((event, emit) => _selectMode(event, emit));
    on<GetToTrainEvent>((event, emit) => _getToTrain(event, emit));
    on<TrainFlashCardEvent>((event, emit) => _trainFlashCard(event, emit));
  }

  /// initialize the training model to current flashcard collection
  _initTraining(
      InitTrainingModelEvent event, Emitter<FlashTrainingState> emit) {
    emit(state.copyWith(trainingModel: event.trainingModel));
  }

  _selectMode(SelectTrainingModeEvent event, Emitter<FlashTrainingState> emit) {
    emit(state.selectMode(event.mode));
  }

  _getToTrain(GetToTrainEvent event, Emitter<FlashTrainingState> emit) {
    emit(state.getToTrain());
  }

  _trainFlashCard(TrainFlashCardEvent event, Emitter<FlashTrainingState> emit) async{
    emit(await state.trainFlashCard(event.isAnswerCorrect));
  }
}
