// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookStatusAdapter extends TypeAdapter<BookStatus> {
  @override
  final int typeId = 4;

  @override
  BookStatus read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookStatus()
      ..reading = fields[0] as bool
      ..read = fields[1] as bool
      ..wantToRead = fields[2] as bool
      ..favourite = fields[3] as bool
      ..onPage = fields[4] as int;
  }

  @override
  void write(BinaryWriter writer, BookStatus obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.reading)
      ..writeByte(1)
      ..write(obj.read)
      ..writeByte(2)
      ..write(obj.wantToRead)
      ..writeByte(3)
      ..write(obj.favourite)
      ..writeByte(4)
      ..write(obj.onPage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BookSettingsAdapter extends TypeAdapter<BookSettings> {
  @override
  final int typeId = 5;

  @override
  BookSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookSettings()..theme = fields[0] as BookThemes;
  }

  @override
  void write(BinaryWriter writer, BookSettings obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.theme);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BookModelAdapter extends TypeAdapter<BookModel> {
  @override
  final int typeId = 6;

  @override
  BookModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookModel(
      title: fields[0] as String?,
      author: fields[1] as String?,
      description: fields[2] as String?,
      cover: fields[3] as String?,
      language: fields[4] as String?,
      pageCount: fields[5] as int?,
      textSnippet: fields[6] as String?,
      path: fields[7] as String?,
      isBinded: fields[8] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, BookModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.author)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.cover)
      ..writeByte(4)
      ..write(obj.language)
      ..writeByte(5)
      ..write(obj.pageCount)
      ..writeByte(6)
      ..write(obj.textSnippet)
      ..writeByte(7)
      ..write(obj.path)
      ..writeByte(8)
      ..write(obj.isBinded);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
