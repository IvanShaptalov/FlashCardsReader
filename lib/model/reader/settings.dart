class EntitySettings {
  int lineSpacing = 1;
  String fontFamily = 'Roboto';
  String backgroundColor = '#ffffff';
}

class BookSettings extends EntitySettings {
  int fontSize = 16;
  String fontColor = '#000000';
}

class PDFSettings extends EntitySettings {
  int scaling = 1;
}
