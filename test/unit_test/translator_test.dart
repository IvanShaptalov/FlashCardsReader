import 'package:flashcards_reader/model/entities/translator/api.dart';
import 'package:flashcards_reader/constants.dart';
import 'package:flashcards_reader/util/checker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Translator api', () {
    test('Initialized', () async {
      try {
        GoogleTranslatorApiWrapper api = GoogleTranslatorApiWrapper();
        expect(api, isNotNull);
      } catch (e) {
        /// If this fails, it means that the api key is not set.
        expect(false, true);
      }
    });

    test('test lan not supported translate', () async {
      GoogleTranslatorApiWrapper api = GoogleTranslatorApiWrapper();
      String text = 'Hello';
      TranslateResponse result =
          await api.translate(text, to: 'oao', from: 'en');

      expect(result.toString(), '');
    });

    test('test lan supported translate', () async {
      GoogleTranslatorApiWrapper api = GoogleTranslatorApiWrapper();
      String text = 'Hello';

      TranslateResponse result =
          await api.translate(text, to: 'uk', from: 'en');

      bool internet = await Checker.connected();
      if (internet) {
        expect(result.toString(), 'Привіт');
      } else {
        expect(result.toString(), checkInternetConnection);
      }
    });

    test('test autodetect language', () async {
      GoogleTranslatorApiWrapper api = GoogleTranslatorApiWrapper();

      String text = 'День';
      TranslateResponse result = await api.translate(text, to: 'en');

      bool internet = await Checker.connected();
      if (internet) {
        expect(result.toString(), 'Day');
      } else {
        expect(result.toString(), checkInternetConnection);
      }
    });
  });
}
