part of 'translator_bloc.dart';

class TranslatorInitial {
  String result;
  String source;
  GoogleTranslatorApiWrapper _translator = GoogleTranslatorApiWrapper();
  String actionId = uuid.v4();

  TranslatorInitial(
      {required this.result,
      required this.source,
      GoogleTranslatorApiWrapper? translator}) {
    if (translator != null) {
      _translator = translator;
    }
  }

  TranslatorInitial copyWith({
    String? result,
    String? source,
  }) {
    return TranslatorInitial(
      result: result ?? this.result,
      source: source ?? this.source,
      translator: _translator,
    );
  }

  Future<TranslatorInitial> translate(
      String text, String fromLan, String toLan) async {
    await _translate(text, fromLan, toLan);
    return copyWith(result: result, source: source);
  }

  Future<String> _translate(
      String text, String questionLang, String answerLang) async {
    TranslateResponse response = await _translator.translate(text,
        from: getLangCode(questionLang), to: getLangCode(answerLang));
    result = response.to;
    source = text;
    debugPrintIt('$source -> $result');

    return response.to;
  }

  TranslatorInitial clear() {
    return copyWith(result: '');
  }
}
