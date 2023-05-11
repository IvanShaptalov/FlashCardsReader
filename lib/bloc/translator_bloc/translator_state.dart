part of 'translator_bloc.dart';

class TranslatorInitial {
  String result;
  GoogleTranslatorApiWrapper _translator = GoogleTranslatorApiWrapper();
  String actionId = uuid.v4();

  TranslatorInitial(
      {required this.result, GoogleTranslatorApiWrapper? translator}) {
    if (translator != null) {
      _translator = translator;
    }
  }

  TranslatorInitial copyWith({
    String? result,
  }) {
    return TranslatorInitial(
      result: result ?? this.result,
      translator: _translator,
    );
  }

  Future<TranslatorInitial> translate(
      String text, String fromLan, String toLan) async {
    result = await _translate(text, fromLan, toLan);
    debugPrintIt(result);
    return copyWith(result: result);
  }

  Future<String> _translate(
      String text, String questionLang, String answerLang) async {
    TranslateResponse response = await _translator.translate(text,
        from: getLangCode(questionLang), to: getLangCode(answerLang));
    return response.to;
  }

  TranslatorInitial clear() {
    return copyWith(result: '');
  }
}
