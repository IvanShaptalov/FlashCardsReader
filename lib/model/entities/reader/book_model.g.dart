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
    return BookStatus(
      readPrivate: fields[1] as bool,
      readingPrivate: fields[0] as bool,
      toRead: fields[2] as bool,
      favourite: fields[3] as bool,
      onPage: fields[5] as int,
      inTrash: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, BookStatus obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.readingPrivate)
      ..writeByte(1)
      ..write(obj.readPrivate)
      ..writeByte(2)
      ..write(obj.toRead)
      ..writeByte(3)
      ..write(obj.favourite)
      ..writeByte(4)
      ..write(obj.inTrash)
      ..writeByte(5)
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
    return BookSettings(
      theme: fields[0] as BookThemes,
    );
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

class BookFileMetaAdapter extends TypeAdapter<BookFileMeta> {
  @override
  final int typeId = 6;

  @override
  BookFileMeta read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookFileMeta(
      name: fields[0] as String,
      extension: fields[1] as String,
      size: fields[2] as int,
      lastModified: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BookFileMeta obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.extension)
      ..writeByte(2)
      ..write(obj.size)
      ..writeByte(3)
      ..write(obj.lastModified);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookFileMetaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BookModelAdapter extends TypeAdapter<BookModel> {
  @override
  final int typeId = 7;

  @override
  BookModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookModel(
      title: fields[0] as String,
      author: fields[1] as String,
      description: fields[2] as String,
      coverPath: fields[3] as String,
      language: fields[4] as String,
      pageCount: fields[5] as int,
      textSnippet: fields[6] as String,
      path: fields[7] as String,
      isBinded: fields[8] as bool,
      flashCardId: fields[13] as String?,
      status: fields[9] as BookStatus,
      settings: fields[10] as BookSettings,
      file: fields[11] as BookFileMeta,
      lastAccess: fields[12] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, BookModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.author)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.coverPath)
      ..writeByte(4)
      ..write(obj.language)
      ..writeByte(5)
      ..write(obj.pageCount)
      ..writeByte(6)
      ..write(obj.textSnippet)
      ..writeByte(7)
      ..write(obj.path)
      ..writeByte(8)
      ..write(obj.isBinded)
      ..writeByte(9)
      ..write(obj.status)
      ..writeByte(10)
      ..write(obj.settings)
      ..writeByte(11)
      ..write(obj.file)
      ..writeByte(12)
      ..write(obj.lastAccess)
      ..writeByte(13)
      ..write(obj.flashCardId);
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
