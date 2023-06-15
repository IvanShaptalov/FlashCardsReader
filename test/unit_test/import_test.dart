import 'package:flashcards_reader/model/entities/translator/api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Import', () {
    test('', () async {});

    test('test lan not supported translate', () async {
      GoogleTranslatorApiWrapper api = GoogleTranslatorApiWrapper();
      String text = 'Hello';
      TranslateResponse result =
          await api.translate(text, to: 'oao', from: 'en');

      expect(result.toString(), '');
    });
  });
}
