import 'package:flashcards_reader/model/flashcards/flashcards.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

void main() {
  group('Database test', () {
    test('crud test', () async {
      final isar = await Isar.open([FlashCardCollectionSchema]);
      final FlashCard flashCard1 = FlashCard(
        fromLanguage: 'English',
        toLanguage: 'German',
        questionWords: 'Hello',
        answerWords: 'Hallo',
      );
      final FlashCard flashCard2 = FlashCard(
        fromLanguage: 'English',
        toLanguage: 'German',
        questionWords: 'Goodbye',
        answerWords: 'Auf Wiedersehen',
      );
      final FlashCardCollection testFlashCardCollection = FlashCardCollection(
        title: 'English-German',
        flashCards: [flashCard1, flashCard2],
      );

      await isar.writeTxn(() async {
        await isar.flashCardCollections.put(testFlashCardCollection);
      });

      final collectionFromDb = await isar.flashCardCollections
          .get(testFlashCardCollection.id); // get

      expect(collectionFromDb, testFlashCardCollection);

      await isar.writeTxn(() async {
        await isar.flashCardCollections.delete(collectionFromDb!.id); // delete
      });
    });
  });
}
