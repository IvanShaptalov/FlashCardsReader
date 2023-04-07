import 'package:flashcards_reader/model/flashcards/flashcards_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Flashcard comparing', () {
     test('hashes same', () async {
      FlashCard flash1 = FlashCard(
        questionLanguage: 'English',
        answerLanguage: 'German',
        questionWords: 'Hello',
        answerWords: 'Hallo',
        nextTest: DateTime.now().add(const Duration(days: 1)),
        lastTested: DateTime.now(),
        correctAnswers: 0,
        wrongAnswers: 0,
        isDeleted: false,
      );
      FlashCard flash2 =  FlashCard(
        questionLanguage: 'English',
        answerLanguage: 'German',
        questionWords: 'Hello',
        answerWords: 'Hallo',
        nextTest: DateTime.now().add(const Duration(days: 1)),
        lastTested: DateTime.now(),
        correctAnswers: 0,
        wrongAnswers: 0,
        isDeleted: false,
      );
      expect(flash1.hashCode == flash2.hashCode, true);
    });
    test('are same', () async {
      FlashCard flash1 = FlashCard(
        questionLanguage: 'English',
        answerLanguage: 'German',
        questionWords: 'Hello',
        answerWords: 'Hallo',
        nextTest: DateTime.now().add(const Duration(days: 1)),
        lastTested: DateTime.now(),
        correctAnswers: 0,
        wrongAnswers: 0,
        isDeleted: false,
      );
      FlashCard flash2 = FlashCard(
        questionLanguage: 'English',
        answerLanguage: 'German',
        questionWords: 'Hello',
        answerWords: 'Hallo',
        nextTest: DateTime.now().add(const Duration(days: 1)),
        lastTested: DateTime.now(),
        correctAnswers: 0,
        wrongAnswers: 0,
        isDeleted: false,
      );
      expect(flash1 == flash2, true);
    });

    test('reorder languages are not same', () async {
      FlashCard flash1 = FlashCard(
        questionLanguage: 'German',
        answerLanguage: 'English',
        questionWords: 'Hello',
        answerWords: 'Hallo',
        nextTest: DateTime.now().add(const Duration(days: 1)),
        lastTested: DateTime.now(),
        correctAnswers: 0,
        wrongAnswers: 0,
        isDeleted: false,
      );
      FlashCard flash2 = FlashCard(
        questionLanguage: 'English',
        answerLanguage: 'German',
        questionWords: 'Hello',
        answerWords: 'Hallo',
        nextTest: DateTime.now().add(const Duration(days: 1)),
        lastTested: DateTime.now(),
        correctAnswers: 0,
        wrongAnswers: 0,
        isDeleted: false,
      );
      expect(flash1 == flash2, false);
    });
    test('reorder words and language same', () async {
      FlashCard flash1 = FlashCard(
        questionLanguage: 'German',
        answerLanguage: 'English',
        questionWords: 'Hallo',
        answerWords: 'Hello',
        nextTest: DateTime.now().add(const Duration(days: 1)),
        lastTested: DateTime.now(),
        correctAnswers: 0,
        wrongAnswers: 0,
        isDeleted: false,
      );
      FlashCard flash2 = FlashCard(
        questionLanguage: 'English',
        answerLanguage: 'German',
        questionWords: 'Hello',
        answerWords: 'Hallo',
        nextTest: DateTime.now().add(const Duration(days: 1)),
        lastTested: DateTime.now(),
        correctAnswers: 0,
        wrongAnswers: 0,
        isDeleted: false,
      );
      expect(flash1 == flash2, true);
    });
    test('reorder words and languages same', () async {
      FlashCard flash1 = FlashCard(
        questionLanguage: 'English',
        answerLanguage: 'German',
        questionWords: 'Hallo',
        answerWords: 'Hello',
        nextTest: DateTime.now().add(const Duration(days: 1)),
        lastTested: DateTime.now(),
        correctAnswers: 0,
        wrongAnswers: 0,
        isDeleted: false,
      );
      FlashCard flash2 = FlashCard(
        questionLanguage: 'English',
        answerLanguage: 'German',
        questionWords: 'Hallo',
        answerWords: 'Hello',
        nextTest: DateTime.now().add(const Duration(days: 1)),
        lastTested: DateTime.now(),
        correctAnswers: 0,
        wrongAnswers: 0,
        isDeleted: false,
      );
      expect(flash1 == flash2, true);
    });
    test('reorder words but different languages are not same', () async {
      FlashCard flash1 = FlashCard(
        questionLanguage: 'English',
        answerLanguage: 'German',
        questionWords: 'Hallo',
        answerWords: 'Hello',
        nextTest: DateTime.now().add(const Duration(days: 1)),
        lastTested: DateTime.now(),
        correctAnswers: 0,
        wrongAnswers: 0,
        isDeleted: false,
      );
      FlashCard flash2 = FlashCard(
        questionLanguage: 'English',
        answerLanguage: 'NotGerman',
        questionWords: 'Hello',
        answerWords: 'Hallo',
        nextTest: DateTime.now().add(const Duration(days: 1)),
        lastTested: DateTime.now(),
        correctAnswers: 0,
        wrongAnswers: 0,
        isDeleted: false,
      );
      expect(flash1 == flash2, false);
    });
  });
}
