/// SHARING is the process of exporting and importing flashcards
import 'dart:convert';

import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/util/error_handler.dart';

class BaseShare {
  String exportPath = '';
  String exportName = '';
  String exportType = '';
  List<FlashCardCollection> collections = [];
  String export() {
    return '';
  }

  List<FlashCardCollection> import() {
    return [];
  }
}

class JsonShare extends BaseShare {
  String jsonEntity = '';

  @override
  String export() {
    List<String> jsonShare = [];

    for (var collection in collections) {
      jsonShare.add(collection.toJson());
    }

    debugPrintIt(jsonShare.toString());
    String encodedJson = jsonEncode(jsonShare);
    debugPrintIt(encodedJson);
    return encodedJson;
  }

  @override
  List<FlashCardCollection> import() {
    List<FlashCardCollection> collections = [];
    if (jsonEntity == '') {
      throw Exception('Json entity is empty');
    }
    List<dynamic> jsonShare = jsonDecode(jsonEntity) as List<dynamic>;
    for (var json in jsonShare) {
      collections.add(FlashCardCollection.fromJson(json));
    }
    this.collections = collections;
    return collections;
  }
}

class XmlShare extends BaseShare {}

class CsvShare extends BaseShare {}

class SqlShare extends BaseShare {}

class ExcelShare extends BaseShare {}

class TextShare extends BaseShare {}
