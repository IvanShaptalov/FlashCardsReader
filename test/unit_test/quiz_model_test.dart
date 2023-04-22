import 'package:flashcards_reader/main.dart';
import 'package:flashcards_reader/model/entities/flashcards/quiz_model.dart';
import 'package:flashcards_reader/util/enums.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Flashcard quiz', () {
    test('Initialized', () async {
      var collection = flashFixture();
      var qModel = QuizModel(
        flashCardsCollection: collection,
        numberOfFlashCards: collection.flashCardSet.length,
        flashIndex: 0,
        mode: QuizMode.all,
      );

      expect(qModel.isQuizFinished, false);

      qModel.flashCardsCollection.flashCardSet = {};

      expect(qModel.isQuizFinished, true);
      expect(qModel.isEmpty, true);
      expect(collection.flashCardSet.isEmpty, true);
    });

    test('Empty train collection', () async {
      var collection = flashFixture();
      var qModel = QuizModel(
        flashCardsCollection: collection,
        numberOfFlashCards: collection.flashCardSet.length,
        flashIndex: 0,
        mode: QuizMode.all,
      );

      qModel.flashCardsCollection.flashCardSet = {};

      expect(qModel.isQuizFinished, true);
      expect(qModel.isEmpty, true);
      expect(collection.flashCardSet.isEmpty, true);
    });

    test('train words - correct', () async {
      var collection = flashFixture();
      var qModel = QuizModel(
        flashCardsCollection: collection,
        numberOfFlashCards: collection.flashCardSet.length,
        flashIndex: 0,
        mode: QuizMode.all,
      );

      var qFlash = qModel.getNextFlash();

      qModel.quizFlashCardAsync(qFlash!, true);

      expect(qFlash.correctAnswers, 1);

      qModel.quizFlashCardAsync(qFlash, true);

      expect(qFlash.correctAnswers, 2);
      expect(qFlash.wrongAnswers, 0);
    });

    test('train words - correct', () async {
      var collection = flashFixture();
      var qModel = QuizModel(
        flashCardsCollection: collection,
        numberOfFlashCards: collection.flashCardSet.length,
        flashIndex: 0,
        mode: QuizMode.all,
      );

      var qFlash = qModel.getNextFlash();

      qModel.quizFlashCardAsync(qFlash!, true);

      expect(qFlash.correctAnswers, 1);

      qModel.quizFlashCardAsync(qFlash, true);

      expect(qFlash.correctAnswers, 2);
      expect(qFlash.wrongAnswers, 0);
    });

    test('train words - incorrect', () async {
      var collection = flashFixture();
      var qModel = QuizModel(
        flashCardsCollection: collection,
        numberOfFlashCards: collection.flashCardSet.length,
        flashIndex: 0,
        mode: QuizMode.all,
      );

      var qFlash = qModel.getNextFlash();

      assert(qFlash != null);
      qModel.quizFlashCardAsync(qFlash!, false);

      expect(qFlash.wrongAnswers, 1);

      qModel.quizFlashCardAsync(qFlash, false);

      expect(qFlash.correctAnswers, 0);
      expect(qFlash.wrongAnswers, 2);
    });

    test('flashcards learned test', () async {
      var collection = flashFixture();
      var qModel = QuizModel(
        flashCardsCollection: collection,
        numberOfFlashCards: collection.flashCardSet.length,
        flashIndex: 0,
        mode: QuizMode.all,
      );

      // get flashcard

      for (int i = 0; i <= 10; i++) {
        var qFlash = qModel.getNextFlash();

        if (qFlash != null) {
          qModel.quizFlashCardAsync(qFlash, true);
        }
      }
      expect(qModel.getNextFlash(), null);
      expect(qModel.isQuizFinished, true);
    });
  });
}
