import 'package:flashcards_reader/model/entities/translator/api.dart';
import 'package:flashcards_reader/util/constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

void main() {
  group('Translator api', () {
    test('Initialized', () async {
      try {
        GoogleTranslatorAPIWrapper api = GoogleTranslatorAPIWrapper();
        expect(api, isNotNull);
      } catch (e) {
        /// If this fails, it means that the api key is not set.
        expect(false, true);
      }
    });

    test('test lan not supported translate', () async {
      GoogleTranslatorAPIWrapper api = GoogleTranslatorAPIWrapper();
      String text = 'Hello';
      TranslateResponse result =
          await api.translate(text, to: 'oao', from: 'en');

      expect(result.toString(), '${langUnsupported}oao');
    });

    test('test lan supported translate', () async {
      GoogleTranslatorAPIWrapper api = GoogleTranslatorAPIWrapper();
      String text = 'Hello';

      TranslateResponse result =
          await api.translate(text, to: 'uk', from: 'en');

      bool internet = await InternetConnectionChecker().hasConnection;
      if (internet) {
        expect(result.toString(), 'Привіт');
      } else {
        expect(result.toString(), checkInternetConnection);
      }
    });

    test('test autodetect language', () async {
      GoogleTranslatorAPIWrapper api = GoogleTranslatorAPIWrapper();

      String text = 'День';
      TranslateResponse result = await api.translate(text, to: 'en');

      bool internet = await InternetConnectionChecker().hasConnection;
      if (internet) {
        expect(result.toString(), 'Day');
      } else {
        expect(result.toString(), checkInternetConnection);
      }
    });
  });
}
