/// SHARING is the process of exporting and importing flashcards
import 'dart:convert';

import 'package:flashcards_reader/bloc/quiz_bloc/quiz_bloc.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/util/enums.dart';
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

class TextShare extends BaseShare {
  String textEntity = "";
  String separator = "\n";
  String titleSeparator = ";";
  String wordSeparator = "-";

  List<String> errors = [];

  /// ===========================[export]===========================
  @override
  String export() {
    String textShare = "";

    for (var collection in collections) {
      textShare += "${exportFlashCardCollection(collection)}$separator";
    }

    debugPrintIt(textShare.toString());
    String encodedText = jsonEncode(textShare);
    debugPrintIt(encodedText);
    return encodedText;
  }

  String exportFlashCardCollection(FlashCardCollection fCC) {
    /// title;questionLanguage:answerLanguage
    /// question-answer
    /// question-answer
    /// question-answer
    ///
    /// title;questionLanguage:answerLanguage
    /// and so on
    print('\n wtff \n');
    print('$separator wtf $separator');
    StringBuffer sb = StringBuffer();

    sb.write(fCC.title);

    sb.write(titleSeparator);

    sb.write(fCC.questionLanguage);

    sb.write(titleSeparator);

    sb.write(fCC.answerLanguage);

    sb.write(separator);

    String result = sb.toString();

    for (var flashCard in fCC.flashCardSet) {
      result += exportFlashCard(flashCard) + separator;
    }
    return result;
  }

  /// Export a single flashcard
  String exportFlashCard(FlashCard flashCard) {
    return "${flashCard.question}$wordSeparator${flashCard.answer}";
  }

  /// ===========================[import]===========================
  FlashCard? importFlashCard(
    String flashCard,
    String questionLanguage,
    String answerLanguage,
  ) {
    List<String> flashCardList = flashCard.split(wordSeparator);
    if (flashCardList.length != 2) {
      return null;
    }
    return FlashCard(
        answer: flashCardList[1],
        question: flashCardList[0],
        questionLanguage: questionLanguage,
        answerLanguage: answerLanguage,
        lastTested: DateTime.now(),
        correctAnswers: 0,
        wrongAnswers: 0);
  }

  FlashCardCollection? importFlashCardCollection(String stringFCC) {
    List<String> lines =
        const LineSplitter().convert(stringFCC.replaceAll('\\n', '\n').replaceAll('"', ''));
    if (lines.isEmpty) {
      errors.add('No lines found');
      return null;
    }
    List<String> titleList = lines[0].split(titleSeparator);
    if (titleList.length != 3) {
      errors.add('Add title, question language and answer language9');
      return null;
    }
    String title = titleList[0];
    String questionLanguage = titleList[1];
    String answerLanguage = titleList[2];
    FlashCardCollection collection = FlashCardCollection(uuid.v4(),
        title: title,
        questionLanguage: questionLanguage,
        answerLanguage: answerLanguage,
        createdAt: DateTime.now(),
        flashCardSet: {});
    for (var flashCard in lines.sublist(1)) {
      FlashCard? card =
          importFlashCard(flashCard, questionLanguage, answerLanguage);
      if (card != null) {
        collection.flashCardSet.add(card);
      }
    }

    return collection;
  }

  @override
  List<FlashCardCollection> import() {
    List<FlashCardCollection> collections = [];
    if (textEntity == '') {
      throw Exception('Text entity is empty');
    }
    //
    List<String> textShare = textEntity.split('$separator$separator');
    for (var stringCollection in textShare) {
      FlashCardCollection? col = importFlashCardCollection(stringCollection);
      if (col is FlashCardCollection) {
        collections.add(col);
      }
    }
    this.collections = collections;
    return collections;
  }
}

class XmlShare extends BaseShare {}

class CsvShare extends BaseShare {}

class SqlShare extends BaseShare {}

class ExcelShare extends BaseShare {}
