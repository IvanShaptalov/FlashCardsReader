part of 'flash_training_bloc.dart';

abstract class FlashTrainingEvent {}

class InitTrainingModelEvent extends FlashTrainingEvent {
  TrainingModel trainingModel;

  InitTrainingModelEvent({required this.trainingModel});
}

class SelectTrainingModeEvent extends FlashTrainingEvent {
  final TrainMode mode;

  SelectTrainingModeEvent({required this.mode});
}

class GetToTrainEvent extends FlashTrainingEvent {}

class TrainFlashCardEvent extends FlashTrainingEvent {
  final bool isAnswerCorrect;

  TrainFlashCardEvent({required this.isAnswerCorrect});
}
