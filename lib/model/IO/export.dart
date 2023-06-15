import 'dart:convert';

import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';

class BaseExport {
  String exportPath = '';
  String exportName = '';
  String exportType = '';
  List<FlashCardCollection> collections = [];
  String export() {
    return '';
  }
}

class JsonExport extends BaseExport {

  // String toJson(FlashCardCollection collection) {
    
  //   return '';
  // }
  // @override
  // String export() {
    
  // }
}

class XmlExport extends BaseExport {}

class CsvExport extends BaseExport {}

class SqlExport extends BaseExport {}

class ExcelExport extends BaseExport {}

class TextExport extends BaseExport {}
