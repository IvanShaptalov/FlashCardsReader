part of 'translator_bloc.dart';

class TranslatorInitial {
  String result;
  GoogleTranslatorApiWrapper _translator = GoogleTranslatorApiWrapper();

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
    return copyWith(result: result);
  }

  Future<String> _translate(String text, String fromLan, String toLan) async {
    TranslateResponse response =
        await _translator.translate(text, from: fromLan, to: toLan);
    return response.to;
  }
}
