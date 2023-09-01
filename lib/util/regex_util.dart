import 'package:flashcards_reader/constants.dart';

/// Input:
/// ```dart
/// >>>
/// """
/// line
/// not broken
/// 
/// then paragraph"""
/// ```
/// Result:
/// ```dart
/// >>>
/// """
/// line not broken
/// 
///     then paragraph"""
/// ```
String regexFixParagraph(String text) {
  String result = text.replaceAll(textBookRegex, ' ');
  result = result.replaceAll('\n\n', '\n\n  ');
  return result;
}
