import 'dart:math';

import 'package:hive/hive.dart';
part 'flashcards_model.g.dart';

@HiveType(typeId: 1)
class FlashCard {
  @HiveField(0)
  String questionLanguage;
  @HiveField(1)
  String answerLanguage;
  @HiveField(2)
  String questionWords;
  @HiveField(3)
  String answerWords;
  @HiveField(4)
  DateTime lastTested;
  @HiveField(5)
  int correctAnswers;
  @HiveField(6)
  int wrongAnswers;
  @HiveField(7)
  bool isLearned;

  void markAsLearned() {
    isLearned = true;
  }

  void reset() {
    correctAnswers = 0;
    wrongAnswers = 0;
    isLearned = false;
  }

  double get successRate =>
      correctAnswers / (correctAnswers + wrongAnswers + 1);

  bool get isValid =>
      questionWords.isNotEmpty &&
      answerWords.isNotEmpty &&
      questionLanguage.isNotEmpty &&
      answerLanguage.isNotEmpty;

  static FlashCard fixture() {
    return FlashCard(
        questionLanguage: 'English',
        answerLanguage: 'German',
        questionWords: 'Hello${Random().nextInt(100)}',
        answerWords: 'Hallo',
        lastTested: DateTime.now(),
        correctAnswers: 0,
        wrongAnswers: 0,
        isLearned: false);
  }

  FlashCard(
      {required this.questionLanguage,
      required this.answerLanguage,
      required this.questionWords,
      required this.answerWords,
      required this.lastTested,
      required this.correctAnswers,
      required this.wrongAnswers,
      required this.isLearned});

  /// returns true if the test date was delayed, change the next test date

  @override
  String toString() {
    return 'FlashCard{fromLanguage: $questionLanguage, toLanguage: $answerLanguage, questionWords: $questionWords, answerWords: $answerWords}';
  }

  @override
  int get hashCode => toString().hashCode;

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
      questionLanguage == other.questionLanguage &&
      answerLanguage == other.answerLanguage;

  /// returns true if the languages are the same but reversed
  bool reversedLanguageCheck(FlashCard other) =>
      questionLanguage == other.answerLanguage &&
      answerLanguage == other.questionLanguage;

  bool fullEqualCheck(FlashCard other) =>
      wordCheck(other) && languageCheck(other);

  bool fullReverseEqualCheck(FlashCard other) =>
      reverseWordCheck(other) && reversedLanguageCheck(other);
  @override
  bool operator ==(Object other) {
    // check if the hashcodes are the same, return true if they are
    bool fastCheck = other is FlashCard && (hashCheck(other));
    if (fastCheck) return true;
    bool slowCheck = other is FlashCard &&
        // check if the words and languages are the same
        (fullEqualCheck(other) ||
            // check if the words and languages are the same but reversed
            fullReverseEqualCheck(other));
    return slowCheck;
  }
}

@HiveType(typeId: 2)
class FlashCardCollection {
  FlashCardCollection(this.id,
      {required this.title,
      required this.flashCardSet,
      required this.createdAt,
      this.isDeleted = false,
      required this.questionLanguage,
      required this.answerLanguage});

  FlashCardCollection copy() {
    return FlashCardCollection(id,
        title: title,
        // copy the flashcard set
        flashCardSet: Set.from(flashCardSet),
        createdAt: createdAt,
        isDeleted: isDeleted,
        questionLanguage: questionLanguage,
        answerLanguage: answerLanguage);
  }

  @HiveField(0)
  String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  Set<FlashCard> flashCardSet;
  @HiveField(3)
  DateTime createdAt;
  @HiveField(4)
  bool? isDeleted;
  @HiveField(5)
  String questionLanguage;
  @HiveField(6)
  String answerLanguage;
  @override
  String toString() {
    return 'FlashCardCollection{title: $title, flashCards: $flashCardSet , createdAt: $createdAt}, isDeleted: $isDeleted';
  }

  // ignore: unnecessary_null_comparison
  bool get isValid =>
      title.isNotEmpty &&
      flashCardSet.isNotEmpty &&
      id.isNotEmpty &&
      questionLanguage.isNotEmpty &&
      answerLanguage.isNotEmpty &&
      // ignore: unnecessary_null_comparison
      createdAt != null;

  static List<FlashCardCollection> sortedByDate(
      Set<FlashCardCollection> setFlashcards) {
    List<FlashCardCollection> flist = setFlashcards.toList();
    flist.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return flist;
  }

  /// ====================================================[SORTING TO TRAINING]====================================================
  ///
  List<FlashCard> sortedByDateAscending() {
    List<FlashCard> flist = flashCardSet.toList();
    flist.sort((a, b) => b.lastTested.compareTo(a.lastTested));
    return flist;
  }

  List<FlashCard> sortedByDateDescending() {
    List<FlashCard> flist = flashCardSet.toList();
    flist.sort((a, b) => a.lastTested.compareTo(b.lastTested));
    return flist;
  }

  List<FlashCard> sortedBySuccessRateFromMostSimple() {
    List<FlashCard> flist = flashCardSet.toList();
    flist.sort((a, b) => a.successRate.compareTo(b.successRate));
    return flist;
  }

  List<FlashCard> sortedBySuccessRateFromMostDifficult() {
    List<FlashCard> flist = flashCardSet.toList();
    flist.sort((a, b) => b.successRate.compareTo(a.successRate));
    return flist;
  }

  List<FlashCard> filteredFromLearned() {
    List<FlashCard> flist = flashCardSet.toList();
    flist.removeWhere((element) => element.isLearned);
    return flist;
  }

  List<FlashCard> filteredFromNotLearned() {
    List<FlashCard> flist = flashCardSet.toList();
    flist.removeWhere((element) => !element.isLearned);
    return flist;
  }

  List<FlashCard> randomized() {
    List<FlashCard> flist = flashCardSet.toList();
    flist.shuffle();
    return flist;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) {
    return other is FlashCardCollection &&
        other.id == id &&
        other.title == title &&
        flashCardSet == other.flashCardSet;
  }
}
