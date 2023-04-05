// import 'package:isar/isar.dart';
// part 'flashcards.g.dart';

// @embedded
// class FlashCard {
//   String? fromLanguage;
//   String? toLanguage;
//   String? questionWords;
//   String? answerWords;
//   DateTime? lastTested;
//   DateTime? nextTest;
//   int? correctAnswers;
//   int? wrongAnswers;
//   bool? isDeleted;

//   FlashCard(
//       {this.fromLanguage,
//       this.toLanguage,
//       this.questionWords,
//       this.answerWords,
//       this.lastTested,
//       this.nextTest,
//       this.correctAnswers,
//       this.wrongAnswers,
//       this.isDeleted});

//   /// returns true if the answer was correct, change correct and wrong answers and delay the next test date
//   bool answeredCorrectly() {
//     // TODO implement answeredCorrectlyTest
//     correctAnswers = correctAnswers! + 1;
//     wrongAnswers = wrongAnswers! - 1 != 0 ? wrongAnswers! - 1 : 0;
//     delayTestDate(correctAnswers!);
//     return true;
//   }

//   /// returns true if the answer was wrong, change correct and wrong answers and delay the next test date to today
//   bool answeredWrong() {
//     // TODO implement answeredWrongTest
//     wrongAnswers = wrongAnswers! + 1;
//     correctAnswers = correctAnswers! - 1 != 0 ? correctAnswers! - 1 : 0;
//     // delay test date by today for wrong answers
//     delayTestDate(0);
//     return true;
//   }

//   /// returns true if the test date was delayed, change the next test date
//   bool delayTestDate(int days) {
//     // TODO: implement delayTestDate
//     lastTested = DateTime.now();
//     nextTest = nextTest!.add(Duration(days: days));
//     return true;
//   }

//   @override
//   String toString() {
//     return 'FlashCard{fromLanguage: $fromLanguage, toLanguage: $toLanguage, questionWords: $questionWords, answerWords: $answerWords, lastTested: $lastTested, nextTest: $nextTest, correctAnswers: $correctAnswers, wrongAnswers: $wrongAnswers, isDeleted: $isDeleted}';
//   }

//   @override
//   int get hashCode =>
//       fromLanguage.hashCode ^
//       toLanguage.hashCode ^
//       questionWords.hashCode ^
//       answerWords.hashCode;

//   @override
//   bool operator ==(Object other) {
//     return other is FlashCard && other.hashCode == hashCode;
//   }
// }

// class FlashCardCollection {
//   Id id = Isar.autoIncrement;

//   FlashCardCollection({this.title, this.flashCards});

//   @Index(type: IndexType.value)
//   String? title;
//   List<FlashCard>? flashCards;

//   @override
//   int get hashCode => id.hashCode;

//   @override
//   String toString() {
//     return 'FlashCardCollection{id: $id, title: $title, flashCards: $flashCards}';
//   }

//   @override
//   bool operator ==(Object other) {
//     return other is FlashCardCollection && other.id == id;
//   }
// }
