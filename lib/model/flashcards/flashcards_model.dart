import 'package:hive/hive.dart';
part 'flashcards_model.g.dart';

@HiveType(typeId: 1)
class FlashCard {
  @HiveField(0)
  String fromLanguage;
  @HiveField(1)
  String toLanguage;
  @HiveField(2)
  String questionWords;
  @HiveField(3)
  String answerWords;
  @HiveField(4)
  DateTime lastTested;
  @HiveField(5)
  DateTime nextTest;
  @HiveField(6)
  int correctAnswers;
  @HiveField(7)
  int wrongAnswers;
  @HiveField(8)
  bool isDeleted;

  FlashCard(
      {required this.fromLanguage,
      required this.toLanguage,
      required this.questionWords,
      required this.answerWords,
      required this.lastTested,
      required this.nextTest,
      required this.correctAnswers,
      required this.wrongAnswers,
      required this.isDeleted});

  /// returns true if the answer was correct, change correct and wrong answers and delay the next test date
  bool answeredCorrectly() {
    correctAnswers = correctAnswers + 1;
    wrongAnswers = wrongAnswers - 1 != 0 ? wrongAnswers - 1 : 0;
    delayTestDate(correctAnswers);
    return true;
  }

  /// returns true if the answer was wrong, change correct and wrong answers and delay the next test date to today
  bool answeredWrong() {
    wrongAnswers = wrongAnswers + 1;
    correctAnswers = correctAnswers - 1 != 0 ? correctAnswers - 1 : 0;
    // delay test date by today for wrong answers
    delayTestDate(0);
    return true;
  }

  /// returns true if the test date was delayed, change the next test date
  bool delayTestDate(int days) {
    lastTested = DateTime.now();
    nextTest = nextTest.add(Duration(days: days));
    return true;
  }

  @override
  String toString() {
    return 'FlashCard{fromLanguage: $fromLanguage, toLanguage: $toLanguage, questionWords: $questionWords, answerWords: $answerWords, lastTested: $lastTested, nextTest: $nextTest, correctAnswers: $correctAnswers, wrongAnswers: $wrongAnswers, isDeleted: $isDeleted}';
  }

  @override
  int get hashCode =>
      fromLanguage.hashCode ^
      toLanguage.hashCode ^
      questionWords.hashCode ^
      answerWords.hashCode;

  /// returns true if the hashcodes are the same
  bool hashCheck(FlashCard other) => other.hashCode == hashCode;

  /// returns true if the words are the same
  bool wordCheck(FlashCard other) =>
      questionWords + answerWords == other.questionWords + other.answerWords;

  /// returns true if the words are the same but reversed
  bool reverseWordCheck(FlashCard other) =>
      (questionWords + answerWords == other.answerWords + other.questionWords);

  /// returns true if the languages are the same
  bool languageCheck(FlashCard other) =>
      fromLanguage == other.fromLanguage && toLanguage == other.toLanguage;

  /// returns true if the languages are the same but reversed
  bool reversedLanguageCheck(FlashCard other) =>
      fromLanguage == other.toLanguage && toLanguage == other.fromLanguage;

  /// returns true if the words same or reversed words are the same
  bool fullWordCheck(FlashCard other) =>
      wordCheck(other) || reverseWordCheck(other);

  /// returns true if the languages are the same or reversed languages are the same
  bool fullLanguageCheck(FlashCard other) =>
      languageCheck(other) || reversedLanguageCheck(other);

  @override
  bool operator ==(Object other) {
    // check if the hashcodes are the same, return true if they are
    bool fastCheck = other is FlashCard && (hashCheck(other));
    if (fastCheck) return true;
    bool slowCheck = other is FlashCard &&
        (fullWordCheck(other) && fullLanguageCheck(other));
    return slowCheck;
  }
}

@HiveType(typeId: 2)
class FlashCardCollection {
  FlashCardCollection(this.id,
      {required this.title,
      required this.flashCardSet,
      required this.createdAt});
  @HiveField(0)
  String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  Set<FlashCard> flashCardSet;
  @HiveField(3)
  DateTime createdAt;
  @override
  String toString() {
    return 'FlashCardCollection{title: $title, flashCards: $flashCardSet , createdAt: $createdAt}';
  }

  static List<FlashCardCollection> sortedByDate(
      Set<FlashCardCollection> setFlashcards) {
    List<FlashCardCollection> flist = setFlashcards.toList();
    flist.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return flist;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) {
    return other is FlashCardCollection && other.id == id;
  }
}
