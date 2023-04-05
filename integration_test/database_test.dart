import 'package:flashcards_reader/model/flashcards/flashcards.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flashcards_reader/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  app.main();

  group('DATABASE', () {
    testWidgets('CRUD operation', (tester) async {
      // final FlashCard flashCard1 = FlashCard(
      //   fromLanguage: 'English',
      //   toLanguage: 'German',
      //   questionWords: 'Hello',
      //   answerWords: 'Hallo',
      //   nextTest: DateTime.now().add(const Duration(days: 1)),
      //   lastTested: DateTime.now(),
      //   correctAnswers: 0,
      //   wrongAnswers: 0,
      // );
      // final FlashCard flashCard2 = FlashCard(
      //   fromLanguage: 'English',
      //   toLanguage: 'German',
      //   questionWords: 'Goodbye',
      //   answerWords: 'Auf Wiedersehen',
      //   nextTest: DateTime.now().add(const Duration(days: 1)),
      //   lastTested: DateTime.now(),
      //   correctAnswers: 0,
      //   wrongAnswers: 0,
      // );
      // final FlashCardCollection testFlashCardCollection = FlashCardCollection(
      //   title: 'English-German',
      //   flashCards: [flashCard1, flashCard2],
      // );

      // await isar!.writeTxn(() async {
      //   await isar.flashCardCollections.put(testFlashCardCollection);
      // });

      // final collectionFromDb = await isar.flashCardCollections
      //     .get(testFlashCardCollection.id); // get

      // expect(collectionFromDb, testFlashCardCollection);

      // await isar.writeTxn(() async {
      //   await isar.flashCardCollections.delete(collectionFromDb!.id); // delete
      // });

      // final collectionFromDbDeleted =
      //     await isar.flashCardCollections.get(testFlashCardCollection.id);

      // expect(collectionFromDbDeleted, null);
    });
  });
}
