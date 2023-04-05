import 'package:flashcards_reader/database/core/core.dart';
import 'package:flashcards_reader/model/flashcards/flashcards.dart';
import 'package:flashcards_reader/util/enums.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flashcards_reader/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  app.main();

  group('DATABASE', () {
    testWidgets('CRUD operation', (tester) async {
      bool registered = await DataBase.registerAdapters();
      expect(registered, true);
      await Hive.openBox<FlashCardCollection>('testFlashCardCollection');
      var testBox = Hive.box<FlashCardCollection>('testFlashCardCollection');

      final FlashCard flashCard1 = FlashCard(
        fromLanguage: 'English',
        toLanguage: 'German',
        questionWords: 'Hello',
        answerWords: 'Hallo',
        nextTest: DateTime.now().add(const Duration(days: 1)),
        lastTested: DateTime.now(),
        correctAnswers: 0,
        wrongAnswers: 0,
      );
      final FlashCard flashCard2 = FlashCard(
        fromLanguage: 'English',
        toLanguage: 'German',
        questionWords: 'Goodbye',
        answerWords: 'Auf Wiedersehen',
        nextTest: DateTime.now().add(const Duration(days: 1)),
        lastTested: DateTime.now(),
        correctAnswers: 0,
        wrongAnswers: 0,
      );
      final FlashCardCollection testFlashCardCollection = FlashCardCollection(
        uuid.v4().toString(),
        title: 'English-German',
        flashCards: [flashCard1, flashCard2],
      );

      await testBox.put(testFlashCardCollection.id, testFlashCardCollection);

      var collectionFromDb = testBox.get(testFlashCardCollection.id);

      expect(collectionFromDb, testFlashCardCollection);

      await testBox.delete(collectionFromDb!.id);

      final collectionFromDbDeleted = testBox.get(collectionFromDb.id);

      expect(collectionFromDbDeleted, null);
    });
  });
}
