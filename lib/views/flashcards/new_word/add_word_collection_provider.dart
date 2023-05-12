import 'package:flashcards_reader/main.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';

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
