part of 'flash_training_bloc.dart';

// initialization of data

class FlashTrainingState {
  TrainingModel? trainingModel;
  TrainMode mode;
  FlashCard? nowTrainingFlash;

  FlashTrainingState({this.trainingModel, required this.mode});

  // default state
  factory FlashTrainingState.emptyInit() =>
      FlashTrainingState(mode: TrainMode.all);

  /// ===============================================================[Initialization]===============================================================
  FlashTrainingState copyWith({
    required TrainingModel trainingModel,
  }) {
    return FlashTrainingState(
      trainingModel: trainingModel,
      mode: mode,
    );
  }

  FlashTrainingState selectMode(TrainMode mode) {
    return FlashTrainingState(
      // training model must be initialized
      trainingModel: trainingModel,
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
  Future<FlashTrainingState> trainFlashCard(bool isAnswerCorrect) async{
    if (nowTrainingFlash == null) return this;
    await trainingModel!.trainFlashCardAsync(nowTrainingFlash!, isAnswerCorrect);
    return this;
  }

  /// ===============================================================[GETTERS]===============================================================
  /// is training finished
  bool get isTrainingFinished => trainingModel!.isTrainingFinished;

  /// is collection empty
  bool get isCollectionEmpty => trainingModel!.isEmpty;

  /// =============================================================[OVERRIDES]===================================
  @override
  String toString() {
    return 'FlashTrainingState{trainingModel: $trainingModel, mode: $mode, nowTrainingFlash: $nowTrainingFlash}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlashTrainingState &&
          runtimeType == other.runtimeType &&
          trainingModel == other.trainingModel &&
          mode == other.mode &&
          nowTrainingFlash == other.nowTrainingFlash;

  @override
  int get hashCode =>
      trainingModel.hashCode ^ mode.hashCode ^ nowTrainingFlash.hashCode;

}
