import 'package:flashcards_reader/model/entities/reader/book_model.dart';
import 'package:flashcards_reader/model/entities/reader/book_parser/txt.dart';

import 'package:flashcards_reader/main.dart' as app;
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  await app.main();
  group('scanners', () {
    testWidgets('txt format', (tester) async {
      var model = await BinderTxt.bind(
          await BookModel.asset().getFileFromAssets('assets/book/quotes.txt'));
      debugPrintIt(model);
      expect(model.title, 'quotes.txt');
      expect(model.coverPath, 'assets/images/empty.png');
      expect(model.author, '');
      expect(model.path, '/data/user/0/com.example.flashcards_reader/cache/assets/book/quotes.txt');
      expect(model.file.ext, '.txt');

    });
  });
}
