import 'package:flashcards_reader/main.dart';
import 'package:flashcards_reader/model/entities/flashcards/training_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Flashcard training', () {
    test('Initialized', () async {
      var collection = flashFixture();
      var tModel = TrainingModel(
        flashCardsCollection: collection,
        numberOfFlashCards: collection.flashCardSet.length,
      );

      expect(tModel.isTrainingFinished, false);

      tModel.flashCardsCollection.flashCardSet = {};

      expect(tModel.isTrainingFinished, true);
      expect(tModel.isEmpty, true);
      expect(collection.flashCardSet.isEmpty, true);
    });

    test('Empty train collection', () async {
      var collection = flashFixture();
      var tModel = TrainingModel(
        flashCardsCollection: collection,
        numberOfFlashCards: collection.flashCardSet.length,
      );

      tModel.flashCardsCollection.flashCardSet = {};

      expect(tModel.isTrainingFinished, true);
      expect(tModel.isEmpty, true);
      expect(collection.flashCardSet.isEmpty, true);
    });

    test('train words - correct', () async {
      var collection = flashFixture();
      var tModel = TrainingModel(
        flashCardsCollection: collection,
        numberOfFlashCards: collection.flashCardSet.length,
      );

      var tFlash = tModel.getToTrain();

      tModel.trainFlashCardAsync(tFlash!, true);

      expect(tFlash.correctAnswers, 1);

      tModel.trainFlashCardAsync(tFlash, true);

      expect(tFlash.correctAnswers, 2);
      expect(tFlash.wrongAnswers, 0);
    });

    test('train words - correct', () async {
      var collection = flashFixture();
      var tModel = TrainingModel(
        flashCardsCollection: collection,
        numberOfFlashCards: collection.flashCardSet.length,
      );

      var tFlash = tModel.getToTrain();

      tModel.trainFlashCardAsync(tFlash!, true);

      expect(tFlash.correctAnswers, 1);

      tModel.trainFlashCardAsync(tFlash, true);

      expect(tFlash.correctAnswers, 2);
      expect(tFlash.wrongAnswers, 0);
    });

    test('train words - incorrect', () async {
      var collection = flashFixture();
      var tModel = TrainingModel(
        flashCardsCollection: collection,
        numberOfFlashCards: collection.flashCardSet.length,
      );

      var tFlash = tModel.getToTrain();

      assert(tFlash != null);
      tModel.trainFlashCardAsync(tFlash!, false);

      expect(tFlash.wrongAnswers, 1);

      tModel.trainFlashCardAsync(tFlash, false);

      expect(tFlash.correctAnswers, 0);
      expect(tFlash.wrongAnswers, 2);
    });

    test('flashcards learned test', () async {
      var collection = flashFixture();
      var tModel = TrainingModel(
        flashCardsCollection: collection,
        numberOfFlashCards: collection.flashCardSet.length,
      );

      // get flashcard

      for (int i = 0; i <= 10; i++) {
        var tFlash = tModel.getToTrain();

        if (tFlash != null) {
          tModel.trainFlashCardAsync(tFlash, true);
        }
      }
      expect(tModel.getToTrain(), null);
      expect(tModel.isTrainingFinished, true);
    });
  });
}
