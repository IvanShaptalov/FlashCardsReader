import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/util/enums.dart';

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

class FlashCardProvider {
  static FlashCardCollection fc = flashExample();

  static clear() {
    fc = flashExample();
    WordCreatingUIProvider.clear();
  }
}

FlashCardCollection flashExample() {
  final FlashCardCollection testFlashCardCollection = FlashCardCollection(
      uuid.v4().toString(),
      title: 'FlashCard Collection',
      flashCardSet: {},
      createdAt: DateTime.now(),
      isDeleted: false,
      questionLanguage: 'English',
      answerLanguage: 'Ukrainian');
  return testFlashCardCollection;
}

