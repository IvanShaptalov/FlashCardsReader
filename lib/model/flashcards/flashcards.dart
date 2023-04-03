import 'package:isar/isar.dart';

@embedded
class FlashCard {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  String? fromLanguage;

  @Index(type: IndexType.value)
  String? toLanguage;

  @Index(type: IndexType.value)
  String? questionWords;

  @Index(type: IndexType.value)
  String? answerWords;

  @override
  String toString() {
    return 'FlashCard{fromLanguage: $fromLanguage, toLanguage: $toLanguage, questionWords: $questionWords, answerWords: $answerWords}';
  }

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) {
    return other is FlashCard && other.id == id;
  }
}

@collection
class FlashCardCollection {
  Id id = Isar.autoIncrement;

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
