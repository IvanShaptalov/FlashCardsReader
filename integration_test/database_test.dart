import 'package:flashcards_reader/database/core/core.dart';
import 'package:flashcards_reader/database/core/table_methods.dart';
import 'package:flashcards_reader/model/flashcards/flashcards.dart';
import 'package:flashcards_reader/util/enums.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flashcards_reader/main.dart' as app;

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  await app.main();

  group('DATABASE', () {
    FlashCardCollection flashFixture() {
      final FlashCard flashCard1 = FlashCard(
        fromLanguage: 'English',
        toLanguage: 'German',
        questionWords: 'Hello',
        answerWords: 'Hallo',
        nextTest: DateTime.now().add(const Duration(days: 1)),
        lastTested: DateTime.now(),
        correctAnswers: 0,
        wrongAnswers: 0,
        isDeleted: false,
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
        isDeleted: false,
      );
      final FlashCardCollection testFlashCardCollection = FlashCardCollection(
        uuid.v4().toString(),
        title: 'English-German',
        flashCards: [flashCard1, flashCard2],
        createdAt: DateTime.now(),

      );
      return testFlashCardCollection;
    }

    testWidgets('Initialization', (tester) async {
      expect(DataBase.dbInitialized, true);
    });

    testWidgets('Test session', (widgetTester) async {
      expect(DataBase.flashcardsSession, isNotNull);
      expect(DataBase.themeSession, isNotNull);
      expect(DataBase.settingsSession, isNotNull);
      expect(DataBase.flashcardsTestSession, isNotNull);
      expect(DataBase.settingsTestSession, isNotNull);
      expect(DataBase.themeTestSession, isNotNull);
    });

    testWidgets('test adapters', (widgetTester) async {
      expect(DataBase.adaptersRegistered, true);
    });

    testWidgets('test write collision via FlashCardDBProvider, delete all',
        (widgetTester) async {
      await FlashcardProvider.deleteAllAsync(isTest: true);

      var flashcards = flashFixture();
      await FlashcardProvider.deleteAllAsync(isTest: true);
      await FlashcardProvider.writeEditAsync(flashcards, isTest: true);
      await FlashcardProvider.writeEditAsync(flashcards, isTest: true);
      await FlashcardProvider.writeEditAsync(flashcards, isTest: true);

      var flashcardsList = FlashcardProvider.getAll(isTest: true);
      expect(flashcardsList.length, 1);
      await FlashcardProvider.deleteAllAsync(isTest: true);
    });

    testWidgets('Write , delete , get by id', (tester) async {
      await FlashcardProvider.deleteAllAsync(isTest: true);

      var flashcards = flashFixture();

      bool writed =
          await FlashcardProvider.writeEditAsync(flashcards, isTest: true);
      expect(writed, true);
      // get from db
      var collectionFromDb =
          FlashcardProvider.getById(flashcards.id, isTest: true);

      expect(collectionFromDb, flashcards);

      await FlashcardProvider.deleteAsync(collectionFromDb!.id, isTest: true);

      final collectionFromDbDeleted =
          FlashcardProvider.getById(collectionFromDb.id, isTest: true);
      expect(collectionFromDbDeleted, null);
      await FlashcardProvider.deleteAllAsync(isTest: true);
    });

    testWidgets('test get all flashcards', (widgetTester) async {
      await FlashcardProvider.deleteAllAsync(isTest: true);
      var flashcards = flashFixture();
      var flashcards2 = flashFixture();

      expect(flashcards.id != flashcards2.id, true);
      // save to db
      bool writed2 =
          await FlashcardProvider.writeEditAsync(flashcards2, isTest: true);
      expect(writed2, true);

      bool writed =
          await FlashcardProvider.writeEditAsync(flashcards, isTest: true);
      expect(writed, true);

      var flashcardsList = 
          FlashcardProvider.getAll(isTest: true);

      debugPrint('flashcardsList.length ${flashcardsList.length}');
      expect(flashcardsList.length, 2);
      debugPrint(flashcardsList[0].id);
      debugPrint(flashcardsList[1].id);
      debugPrint(flashcards.id);
      debugPrint(flashcards2.id);
      expect(flashcardsList[0], flashcards2);
      expect(flashcardsList[1], flashcards);
    });
  });
}
