import 'package:hive/hive.dart';
part 'flashcards.g.dart';

@HiveType(typeId: 1)
class FlashCard {
  @HiveField(0)
  String? fromLanguage;
  @HiveField(1)
  String? toLanguage;
  @HiveField(2)
  String? questionWords;
  @HiveField(3)
  String? answerWords;
  @HiveField(4)
  DateTime? lastTested;
  @HiveField(5)
  DateTime? nextTest;
  @HiveField(6)
  int? correctAnswers;
  @HiveField(7)
  int? wrongAnswers;
  @HiveField(8)
  bool? isDeleted;

  bool isValid() {
    return fromLanguage != null &&
        toLanguage != null &&
        questionWords != null &&
        answerWords != null &&
        lastTested != null &&
        nextTest != null &&
        correctAnswers != null &&
        wrongAnswers != null &&
        isDeleted != null;
  }

  FlashCard(
      {this.fromLanguage,
      this.toLanguage,
      this.questionWords,
      this.answerWords,
      this.lastTested,
      this.nextTest,
      this.correctAnswers,
      this.wrongAnswers,
      this.isDeleted});

  /// returns true if the answer was correct, change correct and wrong answers and delay the next test date
  bool answeredCorrectly() {
    correctAnswers = correctAnswers! + 1;
    wrongAnswers = wrongAnswers! - 1 != 0 ? wrongAnswers! - 1 : 0;
    delayTestDate(correctAnswers!);
    return true;
  }

  /// returns true if the answer was wrong, change correct and wrong answers and delay the next test date to today
  bool answeredWrong() {
    wrongAnswers = wrongAnswers! + 1;
    correctAnswers = correctAnswers! - 1 != 0 ? correctAnswers! - 1 : 0;
    // delay test date by today for wrong answers
    delayTestDate(0);
    return true;
  }

  /// returns true if the test date was delayed, change the next test date
  bool delayTestDate(int days) {
    lastTested = DateTime.now();
    nextTest = nextTest!.add(Duration(days: days));
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

  @override
  bool operator ==(Object other) {
    return other is FlashCard && other.hashCode == hashCode;
  }
}

@HiveType(typeId: 2)
class FlashCardCollection {
  FlashCardCollection(this.id, {this.title, this.flashCards, this.createdAt});
  @HiveField(0)
  String id;
  @HiveField(1)
  String? title;
  @HiveField(2)
  List<FlashCard>? flashCards;
  @HiveField(3)
  DateTime? createdAt;
  @override
  String toString() {
    return 'FlashCardCollection{title: $title, flashCards: $flashCards , createdAt: $createdAt}';
  }

  static List<FlashCardCollection> sortedByDate(List<FlashCardCollection> list) {
    list.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
    return list;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) {
    return other is FlashCardCollection && other.id == id;
  }

  bool isValid() {
    return title != null && flashCards != null;
  }
}
