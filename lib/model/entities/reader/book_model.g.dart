// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookSettingsAdapter extends TypeAdapter<BookSettings> {
  @override
  final int typeId = 4;

  @override
  BookSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookSettings(
      fontSize: fields[0] as double,
      foreground: fields[1] as String,
      fontFamily: fields[2] as String,
      backgroundColor: fields[3] as String,
      currentPage: fields[4] as int,
      epubCFI: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BookSettings obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.fontSize)
      ..writeByte(1)
      ..write(obj.foreground)
      ..writeByte(2)
      ..write(obj.fontFamily)
      ..writeByte(3)
      ..write(obj.backgroundColor)
      ..writeByte(4)
      ..write(obj.currentPage)
      ..writeByte(5)
      ..write(obj.epubCFI);
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

class PDFSettingsAdapter extends TypeAdapter<PDFSettings> {
  @override
  final int typeId = 5;

  @override
  PDFSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PDFSettings(
      scaling: fields[0] as int,
      currentPage: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PDFSettings obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.scaling)
      ..writeByte(1)
      ..write(obj.currentPage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PDFSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BookNotesAdapter extends TypeAdapter<BookNotes> {
  @override
  final int typeId = 6;

  @override
  BookNotes read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookNotes(
      notes: (fields[0] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, BookNotes obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookNotesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BookStatusAdapter extends TypeAdapter<BookStatus> {
  @override
  final int typeId = 7;

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

class BookFileMetaAdapter extends TypeAdapter<BookFileMeta> {
  @override
  final int typeId = 8;

  @override
  BookFileMeta read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookFileMeta(
      path: fields[0] as String,
      ext: fields[1] as String,
      size: fields[2] as int,
      lastModified: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, BookFileMeta obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.path)
      ..writeByte(1)
      ..write(obj.ext)
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
  final int typeId = 9;

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
      flashCardId: fields[10] as String?,
      status: fields[7] as BookStatus,
      fileMeta: fields[8] as BookFileMeta,
      lastAccess: fields[9] as DateTime,
      settings: fields[11] as BookSettings,
      pdfSettings: fields[12] as PDFSettings,
      bookNotes: fields[13] as BookNotes,
    );
  }

  @override
  void write(BinaryWriter writer, BookModel obj) {
    writer
      ..writeByte(12)
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
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.fileMeta)
      ..writeByte(9)
      ..write(obj.lastAccess)
      ..writeByte(10)
      ..write(obj.flashCardId)
      ..writeByte(11)
      ..write(obj.settings)
      ..writeByte(12)
      ..write(obj.pdfSettings)
      ..writeByte(13)
      ..write(obj.bookNotes);
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
