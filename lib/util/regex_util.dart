import 'package:flashcards_reader/constants.dart';

String regexFixParagraph(String text) {
  String result = text.replaceAll(textBookRegex, ' ');
  result = result.replaceAll('\n\n', '\n\n  ');
  return result;
}
