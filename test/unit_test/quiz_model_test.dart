import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/model/entities/flashcards/quiz_model.dart';
import 'package:flashcards_reader/util/enums.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  FlashCardCollection flashFixture() {
  final FlashCard flashCard1 = FlashCard(
    questionLanguage: 'English',
    answerLanguage: 'German',
    questionWords: 'Hello',
    answerWords: 'Hallo',
    lastTested: DateTime.now(),
    correctAnswers: 0,
    wrongAnswers: 0,
  );
  final FlashCard flashCard2 = FlashCard(
    questionLanguage: 'English',
    answerLanguage: 'German',
    questionWords: 'Goodbye',
    answerWords: 'Auf Wiedersehen',
    lastTested: DateTime.now(),
    correctAnswers: 0,
    wrongAnswers: 0,
  );
  final FlashCardCollection testFlashCardCollection = FlashCardCollection(
      uuid.v4().toString(),
      title: 'Fixture Collection',
      flashCardSet: {flashCard1, flashCard2},
      createdAt: DateTime.now(),
      isDeleted: false,
      questionLanguage: 'English',
      answerLanguage: 'German');
  return testFlashCardCollection;
}
  group('Flashcard quiz', () {
    test('Initialized', () async {
      var collection = flashFixture();
      var qModel = QuizModel(
        flashCardsCollection: collection,
        flashIndex: 0,
        mode: QuizMode.all,
      );

      expect(qModel.isQuizFinished, false);

      qModel.flashCardsCollection.flashCardSet = {};

      expect(qModel.isEmpty, true);
      expect(collection.flashCardSet.isEmpty, true);
    });

    test('Empty train collection', () async {
      var collection = flashFixture();
      var qModel = QuizModel(
        flashCardsCollection: collection,
        flashIndex: 0,
        mode: QuizMode.all,
      );

      qModel.flashCardsCollection.flashCardSet = {};

      expect(qModel.isEmpty, true);
      expect(collection.flashCardSet.isEmpty, true);
    });

    test('train words - correct', () async {
      var collection = flashFixture();
      var qModel = QuizModel(
        flashCardsCollection: collection,
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
