import 'package:flashcards_reader/database/core/table_methods.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';

class AddWordCollectionProvider {
  static FlashCardCollection _selectedFc =
      FlashcardDatabaseProvider.getSelectedCollection();

  static FlashCardCollection get selectedFc => _selectedFc;

  static set selectedFc(FlashCardCollection fc) {
    _selectedFc = fc;
    FlashcardDatabaseProvider.saveSelectedCollection(fc);
  }
}

class WordCreatingUIProvider {
  static FlashCard _tmpFlashCard = FlashCard.fixture();
  static clear() {
    _tmpFlashCard = FlashCard.fixture();
  }

  static FlashCard get tmpFlashCard => _tmpFlashCard;

  static void setQuestionLanguage(String language) {
    _tmpFlashCard.questionLanguage = language;
  }

  static void setAnswerLanguage(String language) {
    _tmpFlashCard.answerLanguage = language;
  }

  static void setQuestion(String question) {
    _tmpFlashCard.question = question;
  }

  static void setAnswer(String answer) {
    _tmpFlashCard.answer = answer;
  }
}
