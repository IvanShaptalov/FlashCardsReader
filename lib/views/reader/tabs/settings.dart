import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flutter/src/painting/text_style.dart';

class EntitySettings {
  double letterSpacing = 0.3;
  String fontFamily = 'Roboto';
  String backgroundColor = '#ffffff';
}

class BookSettings extends EntitySettings {
  int fontSize = 16;
  String fontColor = '#000000';
  double lineHeight = 1.0;

  TextStyle calculateStyle() {
    return FontConfigs.h2TextStyleBlack.copyWith(
        letterSpacing: letterSpacing.toDouble(),
        fontSize: fontSize.toDouble(),
        fontFamily: fontFamily,
        height: lineHeight);
  }
}

class PDFSettings extends EntitySettings {
  int scaling = 1;
}
