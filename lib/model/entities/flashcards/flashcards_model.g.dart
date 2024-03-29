// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flashcards_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FlashCardAdapter extends TypeAdapter<FlashCard> {
  @override
  final int typeId = 1;

  @override
  FlashCard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FlashCard(
      questionLanguage: fields[0] as String,
      answerLanguage: fields[1] as String,
      question: fields[2] as String,
      answer: fields[3] as String,
      lastTested: fields[4] as DateTime,
      correctAnswers: fields[5] as int,
      wrongAnswers: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, FlashCard obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.questionLanguage)
      ..writeByte(1)
      ..write(obj.answerLanguage)
      ..writeByte(2)
      ..write(obj.question)
      ..writeByte(3)
      ..write(obj.answer)
      ..writeByte(4)
      ..write(obj.lastTested)
      ..writeByte(5)
      ..write(obj.correctAnswers)
      ..writeByte(6)
      ..write(obj.wrongAnswers);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlashCardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FlashCardCollectionAdapter extends TypeAdapter<FlashCardCollection> {
  @override
  final int typeId = 2;

  @override
  FlashCardCollection read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FlashCardCollection(
      fields[0] as String,
      title: fields[1] as String,
      flashCardSet: (fields[2] as List).toSet().cast<FlashCard>(),
      createdAt: fields[3] as DateTime,
      isDeleted: fields[4] as bool,
      questionLanguage: fields[5] as String,
      answerLanguage: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FlashCardCollection obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.flashCardSet.toList())
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.isDeleted)
      ..writeByte(5)
      ..write(obj.questionLanguage)
      ..writeByte(6)
      ..write(obj.answerLanguage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlashCardCollectionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
