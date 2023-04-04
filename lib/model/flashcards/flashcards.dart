import 'package:isar/isar.dart';
part 'flashcards.g.dart';

@embedded
class FlashCard {
  String? fromLanguage;
  String? toLanguage;
  String? questionWords;
  String? answerWords;

  FlashCard(
      {this.fromLanguage,
      this.toLanguage,
      this.questionWords,
      this.answerWords});

  @override
  String toString() {
    return 'FlashCard{fromLanguage: $fromLanguage, toLanguage: $toLanguage, questionWords: $questionWords, answerWords: $answerWords}';
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

@collection
class FlashCardCollection {
  Id id = Isar.autoIncrement;

  FlashCardCollection({this.title, this.flashCards});

  @Index(type: IndexType.value)
  String? title;
  List<FlashCard>? flashCards;

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) {
    return other is FlashCardCollection && other.id == id;
  }
}
