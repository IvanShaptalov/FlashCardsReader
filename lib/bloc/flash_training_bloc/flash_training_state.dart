part of 'flash_training_bloc.dart';

// initialization of data

class FlashTrainingState {
  FlashCardTrainingModel? trainingModel;
  FlashCardTrainingMode mode;
  FlashCard? nowTrainingFlash;

  FlashTrainingState({this.trainingModel, required this.mode});

  // default state
  factory FlashTrainingState.emptyInit() =>
      FlashTrainingState(mode: FlashCardTrainingMode.all);

  /// ===============================================================[PROVIDER METHODS]===============================================================
  FlashTrainingState init({
    FlashCardTrainingModel? trainingModel,
  }) {
    return FlashTrainingState(
      trainingModel: trainingModel ?? this.trainingModel,
      mode: mode,
    );
  }

  FlashTrainingState selectMode(FlashCardTrainingMode mode) {
    return FlashTrainingState(
      // training model must be initialized
      trainingModel: trainingModel!,
      mode: mode,
    );
  }

  /// ===============================================================[TRAINING METHODS]===============================================================
  /// get the next flash card to train
  FlashTrainingState getToTrain() {
    FlashCard? flashCard = trainingModel!.getToTrain(mode: mode);
    nowTrainingFlash = flashCard;
    return this;
  }

  /// train the flash card
  FlashTrainingState trainFlashCard(bool isAnswerCorrect) {
    trainingModel!.trainFlashCard(nowTrainingFlash!, isAnswerCorrect);
    return this;
  }

  /// ===============================================================[GETTERS]===============================================================
  /// is training finished
  bool get isTrainingFinished => trainingModel!.isTrainingFinished;

  /// is collection empty
  bool get isCollectionEmpty => trainingModel!.isEmpty;
}
