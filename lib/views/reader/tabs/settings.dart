class EntitySettings {
  double letterSpacing = 0.2;
  String fontFamily = 'Roboto';
  String backgroundColor = '#ffffff';
}

class BookSettings extends EntitySettings {
  int fontSize = 16;
  String fontColor = '#000000';
  double lineHeight = 1.0;
  double wordSpacing = 1.0;
}

class PDFSettings extends EntitySettings {
  int scaling = 1;
}
