// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flashcards.dart';

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
      fromLanguage: fields[0] as String?,
      toLanguage: fields[1] as String?,
      questionWords: fields[2] as String?,
      answerWords: fields[3] as String?,
      lastTested: fields[4] as DateTime?,
      nextTest: fields[5] as DateTime?,
      correctAnswers: fields[6] as int?,
      wrongAnswers: fields[7] as int?,
      isDeleted: fields[8] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, FlashCard obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.fromLanguage)
      ..writeByte(1)
      ..write(obj.toLanguage)
      ..writeByte(2)
      ..write(obj.questionWords)
      ..writeByte(3)
      ..write(obj.answerWords)
      ..writeByte(4)
      ..write(obj.lastTested)
      ..writeByte(5)
      ..write(obj.nextTest)
      ..writeByte(6)
      ..write(obj.correctAnswers)
      ..writeByte(7)
      ..write(obj.wrongAnswers)
      ..writeByte(8)
      ..write(obj.isDeleted);
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
      title: fields[1] as String?,
      flashCards: (fields[2] as List?)?.cast<FlashCard>(),
      createdAt: fields[3] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, FlashCardCollection obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.flashCards)
      ..writeByte(3)
      ..write(obj.createdAt);
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
