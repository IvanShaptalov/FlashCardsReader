import 'dart:convert';

import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
part 'flashcards_model.g.dart';

@HiveType(typeId: 1)
class FlashCard {
  @HiveField(0)
  String questionLanguage;
  @HiveField(1)
  String answerLanguage;
  @HiveField(2)
  String question;
  @HiveField(3)
  String answer;
  @HiveField(4)
  DateTime lastTested;
  @HiveField(5)
  int correctAnswers;
  @HiveField(6)
  int wrongAnswers;

  void reset() {
    correctAnswers = 0;
    wrongAnswers = 0;
  }

  void markAsLearned() {
    correctAnswers = learnedBound;
    wrongAnswers = 0;
  }

  static const learnedBound = 5;
  bool get isLearned => correctAnswers - wrongAnswers >= learnedBound;

  double get successRate =>
      correctAnswers / (correctAnswers + wrongAnswers + 1);

  bool get isValid =>
      question.isNotEmpty &&
      answer.isNotEmpty &&
      questionLanguage.isNotEmpty &&
      answerLanguage.isNotEmpty;

  static FlashCard fixture() {
    return FlashCard(
        questionLanguage: 'English',
        answerLanguage: 'Ukrainian',
        question: '',
        answer: '',
        lastTested: DateTime.now(),
        correctAnswers: 0,
        wrongAnswers: 0);
  }

  FlashCard(
      {required this.questionLanguage,
      required this.answerLanguage,
      required this.question,
      required this.answer,
      required this.lastTested,
      required this.correctAnswers,
      required this.wrongAnswers});

  /// returns true if the test date was delayed, change the next test date

  @override
  String toString() {
    return '''FlashCard{fromLanguage: $questionLanguage, toLanguage: $answerLanguage, questionWords: $question, answerWords: $answer}''';
  }

  @override
  int get hashCode => toString().hashCode;

  /// returns true if the hashcodes are the same
  bool hashCheck(FlashCard other) => other.hashCode == hashCode;

  /// returns true if the words are the same
  bool wordCheck(FlashCard other) =>
      question + answer == other.question + other.answer;

  /// returns true if the words are the same but reversed
  bool reverseWordCheck(FlashCard other) =>
      (question + answer == other.answer + other.question);

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

  String toJson() => jsonEncode({
        'questionLanguage': questionLanguage,
        'answerLanguage': answerLanguage,
        'question': question,
        'answer': answer,
        'lastTested': lastTested.toIso8601String(),
        'correctAnswers': correctAnswers,
        'wrongAnswers': wrongAnswers,
      });

  static FlashCard fromJson(String jsonString) {
    Map<String, dynamic> json = jsonDecode(jsonString);
    return FlashCard(
        questionLanguage: json['questionLanguage'],
        answerLanguage: json['answerLanguage'],
        question: json['question'],
        answer: json['answer'],
        lastTested: DateTime.parse(json['lastTested']),
        correctAnswers: json['correctAnswers'],
        wrongAnswers: json['wrongAnswers']);
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

  int get correctAnswers => flashCardSet
      .map((e) => e.correctAnswers)
      .reduce((value, element) => value + element);

  int get wrongAnswers => flashCardSet
      .map((e) => e.wrongAnswers)
      .reduce((value, element) => value + element);

  bool get isLearned => flashCardSet.every((element) => element.isLearned);

  bool get isEmpty => flashCardSet.isEmpty;

  bool get hasLearned => flashCardSet.any((element) => element.isLearned);

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

  int learnedCount() {
    return flashCardSet.where((element) => element.isLearned).length;
  }

  int learnedPercent() {
    if (flashCardSet.isEmpty || learnedCount() == 0) return 0;
    return (learnedCount() / flashCardSet.length * 100).round();
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
  bool isDeleted;
  @HiveField(5)
  String questionLanguage;
  @HiveField(6)
  String answerLanguage;
  @override
  String toString() {
    return '''FlashCardCollection{title: $title, flashCards: $flashCardSet , createdAt: $createdAt}, isDeleted: $isDeleted''';
  }

  bool get isValid =>
      title.isNotEmpty &&
      flashCardSet.isNotEmpty && 
      id.isNotEmpty &&
      questionLanguage.isNotEmpty &&
      answerLanguage.isNotEmpty;

  static List<FlashCardCollection> sortedByDate(
      Set<FlashCardCollection> setFlashcards) {
    List<FlashCardCollection> flist = setFlashcards.toList();
    flist.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return flist;
  }

  /// ====================================================[SORTING TO TRAINING]=
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

  List<FlashCard> learnedCards() {
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
        setEquals(flashCardSet, other.flashCardSet);
  }

  /// returns true if the words are the same
  bool compareWithoutId(FlashCardCollection other) {
    return other.title == title &&
        answerLanguage == other.answerLanguage &&
        questionLanguage == other.questionLanguage;
  }

  void switchLanguages() {
    final String tmp = questionLanguage;
    questionLanguage = answerLanguage;
    answerLanguage = tmp;
    if (flashCardSet.isNotEmpty) {
      for (var f in flashCardSet) {
        debugPrintIt('switch languages for flashcard: $f ...');

        final String tmpLang = f.questionLanguage;
        f.questionLanguage = f.answerLanguage;
        f.answerLanguage = tmpLang;

        final String tmpWord = f.question;
        f.question = f.answer;
        f.answer = tmpWord;

        debugPrintIt('switched languages for flashcard: $f');
      }
    }
    debugPrintIt(flashCardSet);
  }

  String toJson() {
    return jsonEncode({
      'id': id,
      'title': title,
      'flashCardSet': flashCardSet.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'isDeleted': isDeleted,
      'questionLanguage': questionLanguage,
      'answerLanguage': answerLanguage,
    });
  }

  static FlashCardCollection fromJson(String jsonString) {
    Map<String, dynamic> json = jsonDecode(jsonString);
    var flashCardSet = Set.from(json['flashCardSet'])
        .map((e) => FlashCard.fromJson(e))
        .toSet();
    return FlashCardCollection(json['id'],
        title: json['title'],
        flashCardSet: flashCardSet,
        createdAt: DateTime.parse(json['createdAt']),
        isDeleted: json['isDeleted'],
        questionLanguage: json['questionLanguage'],
        answerLanguage: json['answerLanguage']);
  }
}
