import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Flashcard comparing', () {
    test('hashes same', () async {
      FlashCard flash1 = FlashCard(
        questionLanguage: 'English',
        answerLanguage: 'German',
        question: 'Hello',
        answer: 'Hallo',
        lastTested: DateTime.now(),
        correctAnswers: 0,
        wrongAnswers: 0,
      );
      FlashCard flash2 = FlashCard(
        questionLanguage: 'English',
        answerLanguage: 'German',
        question: 'Hello',
        answer: 'Hallo',
        lastTested: DateTime.now(),
        correctAnswers: 0,
        wrongAnswers: 0,
      );
      expect(flash1.hashCode == flash2.hashCode, true);
    });
    test('are same', () async {
      FlashCard flash1 = FlashCard(
        questionLanguage: 'English',
        answerLanguage: 'German',
        question: 'Hello',
        answer: 'Hallo',
        lastTested: DateTime.now(),
        correctAnswers: 0,
        wrongAnswers: 0,
      );
      FlashCard flash2 = FlashCard(
        questionLanguage: 'English',
        answerLanguage: 'German',
        question: 'Hello',
        answer: 'Hallo',
        lastTested: DateTime.now(),
        correctAnswers: 0,
        wrongAnswers: 0,
      );
      expect(flash1 == flash2, true);
    });

    test('reorder languages are not same', () async {
      FlashCard flash1 = FlashCard(
        questionLanguage: 'German',
        answerLanguage: 'English',
        question: 'Hello',
        answer: 'Hallo',
        lastTested: DateTime.now(),
        correctAnswers: 0,
        wrongAnswers: 0,
      );
      FlashCard flash2 = FlashCard(
        questionLanguage: 'English',
        answerLanguage: 'German',
        question: 'Hello',
        answer: 'Hallo',
        lastTested: DateTime.now(),
        correctAnswers: 0,
        wrongAnswers: 0,
        
      );
      expect(flash1 == flash2, false);
    });
    test('reorder words and language same', () async {
      FlashCard flash1 = FlashCard(
        questionLanguage: 'German',
        answerLanguage: 'English',
        question: 'Hallo',
        answer: 'Hello',
        lastTested: DateTime.now(),
        correctAnswers: 0,
        wrongAnswers: 0,
        
      );
      FlashCard flash2 = FlashCard(
        questionLanguage: 'English',
        answerLanguage: 'German',
        question: 'Hello',
        answer: 'Hallo',
        lastTested: DateTime.now(),
        correctAnswers: 0,
        wrongAnswers: 0,
        
      );
      expect(flash1 == flash2, true);
    });
    test('reorder words and languages same', () async {
      FlashCard flash1 = FlashCard(
        questionLanguage: 'English',
        answerLanguage: 'German',
        question: 'Hallo',
        answer: 'Hello',
        lastTested: DateTime.now(),
        correctAnswers: 0,
        wrongAnswers: 0,
        
      );
      FlashCard flash2 = FlashCard(
        questionLanguage: 'English',
        answerLanguage: 'German',
        question: 'Hallo',
        answer: 'Hello',
        lastTested: DateTime.now(),
        correctAnswers: 0,
        wrongAnswers: 0,
        
      );
      expect(flash1 == flash2, true);
    });
    test('reorder words but different languages are not same', () async {
      FlashCard flash1 = FlashCard(
        questionLanguage: 'English',
        answerLanguage: 'German',
        question: 'Hallo',
        answer: 'Hello',
        lastTested: DateTime.now(),
        correctAnswers: 0,
        wrongAnswers: 0,
        
      );
      FlashCard flash2 = FlashCard(
        questionLanguage: 'English',
        answerLanguage: 'NotGerman',
        question: 'Hello',
        answer: 'Hallo',
        lastTested: DateTime.now(),
        correctAnswers: 0,
        wrongAnswers: 0,
        
      );
      expect(flash1 == flash2, false);
    });
  });
}
