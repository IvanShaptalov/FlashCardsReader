import 'package:flashcards_reader/main.dart';
import 'package:flashcards_reader/model/entities/flashcards/training_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Flashcard training', () {
    test('Initialized', () async {
      var collection = flashFixture();
      var tModel = FlashCardTrainingModel(
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
      var tModel = FlashCardTrainingModel(
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
      var tModel = FlashCardTrainingModel(
        flashCardsCollection: collection,
        numberOfFlashCards: collection.flashCardSet.length,
      );

      var tFlash = tModel.getToTrain();

      tModel.trainFlashCard(tFlash!, true);

      expect(tFlash.correctAnswers, 1);

      tModel.trainFlashCard(tFlash, true);

      expect(tFlash.correctAnswers, 2);
      expect(tFlash.wrongAnswers, 0);
    });

    test('train words - correct', () async {
      var collection = flashFixture();
      var tModel = FlashCardTrainingModel(
        flashCardsCollection: collection,
        numberOfFlashCards: collection.flashCardSet.length,
      );

      var tFlash = tModel.getToTrain();

      tModel.trainFlashCard(tFlash!, true);

      expect(tFlash.correctAnswers, 1);

      tModel.trainFlashCard(tFlash, true);

      expect(tFlash.correctAnswers, 2);
      expect(tFlash.wrongAnswers, 0);
    });

    test('train words - incorrect', () async {
      var collection = flashFixture();
      var tModel = FlashCardTrainingModel(
        flashCardsCollection: collection,
        numberOfFlashCards: collection.flashCardSet.length,
      );

      var tFlash = tModel.getToTrain();

      assert(tFlash != null);
      tModel.trainFlashCard(tFlash!, false);

      expect(tFlash.wrongAnswers, 1);

      tModel.trainFlashCard(tFlash, false);

      expect(tFlash.correctAnswers, 0);
      expect(tFlash.wrongAnswers, 2);
    });

    test('train words - correct delays', () async {
      var collection = flashFixture();
      var tModel = FlashCardTrainingModel(
        flashCardsCollection: collection,
        numberOfFlashCards: collection.flashCardSet.length,
      );

      // get flashcard
      var tFlash = tModel.getToTrain();

      // delayed to 1 days
      expect(tModel.trainFlashCard(tFlash!, true), 1);
      // delayed to 3 days
      expect(tModel.trainFlashCard(tFlash, true), 3);
      // delayed to 7 days
      expect(tModel.trainFlashCard(tFlash, true), 7);
      // delayed to 14 days
      expect(tModel.trainFlashCard(tFlash, true), 14);
      // delayed to 30 days
      expect(tModel.trainFlashCard(tFlash, true), 30);

      expect(tFlash.wrongAnswers, 0);
      expect(tFlash.correctAnswers, 5);
    });

    test('train words - correct , then incorrect in delays', () async {
      var collection = flashFixture();
      var tModel = FlashCardTrainingModel(
        flashCardsCollection: collection,
        numberOfFlashCards: collection.flashCardSet.length,
      );

      // get flashcard
      var tFlash = tModel.getToTrain();

      // delayed to 1 days
      expect(tModel.trainFlashCard(tFlash!, true), 1);
      // delayed to 3 days
      expect(tModel.trainFlashCard(tFlash, true), 3);
      // delayed to 7 days
      expect(tModel.trainFlashCard(tFlash, true), 7);
      // delayed to 14 days
      expect(tModel.trainFlashCard(tFlash, true), 14);
      // delayed to 30 days
      expect(tModel.trainFlashCard(tFlash, true), 30);

      // expect that flashcard is learned
      expect(tModel.isFlashCardLearned(tFlash), true);

      // start wrong
      // delayed to 14 days
      expect(tModel.trainFlashCard(tFlash, false), 14);
      // delayed to 7 days
      expect(tModel.trainFlashCard(tFlash, false), 7);
      // delayed to 3 days
      expect(tModel.trainFlashCard(tFlash, false), 3);
      // delayed to 1 day
      expect(tModel.trainFlashCard(tFlash, false), 1);
      // delayed to 1 day
      expect(tModel.trainFlashCard(tFlash, false), 0);

      // expect that flashcard is not learned
      expect(tModel.isFlashCardLearned(tFlash), false);

      expect(tFlash.wrongAnswers, 5);
      expect(tFlash.correctAnswers, 5);

      expect(tModel.trainFlashCard(tFlash, true), 1);
      expect(tModel.trainFlashCard(tFlash, false), 0);
      expect(tModel.trainFlashCard(tFlash, true), 1);
      expect(tModel.trainFlashCard(tFlash, true), 3);
    });

    test('delay up down 3 times', () async {
      var collection = flashFixture();
      var tModel = FlashCardTrainingModel(
        flashCardsCollection: collection,
        numberOfFlashCards: collection.flashCardSet.length,
      );

      // get flashcard
      var tFlash = tModel.getToTrain();

      for (int i = 0; i < 3; i++) {
        for (int dayDelay in [1, 3, 7, 14, 30]) {
          expect(tModel.trainFlashCard(tFlash!, true), dayDelay);
        }
        for (int dayDelay in [14, 7, 3, 1, 0]) {
          expect(tModel.trainFlashCard(tFlash!, false), dayDelay);
        }
      }
    });
  });
}
