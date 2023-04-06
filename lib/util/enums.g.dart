// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enums.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ThemesAdapter extends TypeAdapter<Themes> {
  @override
  final int typeId = 3;

  @override
  Themes read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Themes.darkSoft;
      case 1:
        return Themes.dark;
      case 2:
        return Themes.light;
      case 3:
        return Themes.lightSoft;
      case 4:
        return Themes.grey;
      case 5:
        return Themes.sepia;
      case 6:
        return Themes.sepiaSoft;
      default:
        return Themes.darkSoft;
    }
  }

  @override
  void write(BinaryWriter writer, Themes obj) {
    switch (obj) {
      case Themes.darkSoft:
        writer.writeByte(0);
        break;
      case Themes.dark:
        writer.writeByte(1);
        break;
      case Themes.light:
        writer.writeByte(2);
        break;
      case Themes.lightSoft:
        writer.writeByte(3);
        break;
      case Themes.grey:
        writer.writeByte(4);
        break;
      case Themes.sepia:
        writer.writeByte(5);
        break;
      case Themes.sepiaSoft:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
