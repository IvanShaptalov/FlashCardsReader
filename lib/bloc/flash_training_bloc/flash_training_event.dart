part of 'flash_training_bloc.dart';

abstract class FlashTrainingEvent {}

class InitTrainingModelEvent extends FlashTrainingEvent {
  final FlashCardTrainingModel trainingModel;

  InitTrainingModelEvent({required this.trainingModel});
}

class SelectTrainingModeEvent extends FlashTrainingEvent {
  final FlashCardTrainingMode mode;

  SelectTrainingModeEvent({required this.mode});
}

class GetToTrainEvent extends FlashTrainingEvent {}

class TrainFlashCardEvent extends FlashTrainingEvent {
  final bool isAnswerCorrect;

  TrainFlashCardEvent({required this.isAnswerCorrect});
}
