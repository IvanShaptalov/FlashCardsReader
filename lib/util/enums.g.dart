// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enums.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookThemesAdapter extends TypeAdapter<BookThemes> {
  @override
  final int typeId = 3;

  @override
  BookThemes read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BookThemes.darkSoft;
      case 1:
        return BookThemes.dark;
      case 2:
        return BookThemes.light;
      case 3:
        return BookThemes.lightSoft;
      case 4:
        return BookThemes.grey;
      case 5:
        return BookThemes.sepia;
      case 6:
        return BookThemes.sepiaSoft;
      default:
        return BookThemes.darkSoft;
    }
  }

  @override
  void write(BinaryWriter writer, BookThemes obj) {
    switch (obj) {
      case BookThemes.darkSoft:
        writer.writeByte(0);
        break;
      case BookThemes.dark:
        writer.writeByte(1);
        break;
      case BookThemes.light:
        writer.writeByte(2);
        break;
      case BookThemes.lightSoft:
        writer.writeByte(3);
        break;
      case BookThemes.grey:
        writer.writeByte(4);
        break;
      case BookThemes.sepia:
        writer.writeByte(5);
        break;
      case BookThemes.sepiaSoft:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookThemesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
