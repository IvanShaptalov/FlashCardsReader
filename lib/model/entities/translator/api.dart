import 'package:flashcards_reader/util/constants.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:translator/translator.dart';

class TranslateResponse {
  final String fromLanguage;
  final String toLanguage;
  final String from;
  final String to;

  TranslateResponse(
      {required this.fromLanguage,
      required this.toLanguage,
      required this.from,
      required this.to});

  static TranslateResponse fromTranslate(Translation tr) {
    return TranslateResponse(
        fromLanguage: tr.sourceLanguage.toString(),
        toLanguage: tr.targetLanguage.toString(),
        from: tr.source,
        to: tr.text);
  }

  static TranslateResponse trException(
      {required String sourceLanguage,
      required String targetLanguage,
      required String text,
      required String source,
      required String exception}) {
    return TranslateResponse(
        fromLanguage: sourceLanguage,
        toLanguage: targetLanguage,
        from: source,
        to: text);
  }

  @override
  String toString() => to;
}

class GoogleTranslatorAPIWrapper {
  final GoogleTranslator _translator = GoogleTranslator();

  

  Future<TranslateResponse> translate(String text,
      {String from = "auto", String to = "uk"}) async {
    // validate languages
    if (!isLanguageSupported(from)) {
      return TranslateResponse.trException(
          sourceLanguage: from,
          targetLanguage: to,
          text: langUnsupported + from,
          source: text,
          exception: langUnsupported + from);
    }
    if (!isLanguageSupported(to)) {
      return TranslateResponse.trException(
          sourceLanguage: from,
          targetLanguage: to,
          text: langUnsupported + to,
          source: text,
          exception: langUnsupported + to);
    }

    // translate
    try {
      var result = await _translator.translate(text, from: from, to: to);
      return TranslateResponse.fromTranslate(result);
    } catch (e) {
      debugPrintIt(e.toString());
      return TranslateResponse.trException(
          sourceLanguage: from,
          targetLanguage: to,
          text: checkInternetConnection,
          source: text,
          exception: checkInternetConnection);
    }
  }

  bool isLanguageSupported(String language) {
    // if lan null, then try auto detect
    return supportedLangs.containsKey(language);
  }
}
