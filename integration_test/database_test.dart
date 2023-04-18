import 'package:flashcards_reader/database/core/core.dart';
import 'package:flashcards_reader/database/core/table_methods.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/util/enums.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flashcards_reader/main.dart' as app;

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  await app.main();

  group('DATABASE and flashcards', () {
    FlashCardCollection flashFixture() {
      final FlashCard flashCard1 = FlashCard(
        questionLanguage: 'English',
        answerLanguage: 'German',
        questionWords: 'Hello',
        answerWords: 'Hallo',
        lastTested: DateTime.now(),
        correctAnswers: 0,
        wrongAnswers: 0,
        isLearned: false,
      );
      final FlashCard flashCard2 = FlashCard(
        questionLanguage: 'English',
        answerLanguage: 'German',
        questionWords: 'Goodbye',
        answerWords: 'Auf Wiedersehen',
        lastTested: DateTime.now(),
        correctAnswers: 0,
        wrongAnswers: 0,
        isLearned: false,
      );
      final FlashCardCollection testFlashCardCollection = FlashCardCollection(
        uuid.v4().toString(),
        title: 'English-German',
        flashCardSet: {flashCard1, flashCard2},
        createdAt: DateTime.now(),
        isDeleted: false,
        questionLanguage: 'English',
        answerLanguage: 'German',
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
      await FlashcardDatabaseProvider.deleteAllAsync(isTest: true);

      var flashcards = flashFixture();
      await FlashcardDatabaseProvider.deleteAllAsync(isTest: true);
      await FlashcardDatabaseProvider.writeEditAsync(flashcards, isTest: true);
      await FlashcardDatabaseProvider.writeEditAsync(flashcards, isTest: true);
      await FlashcardDatabaseProvider.writeEditAsync(flashcards, isTest: true);

      var flashcardsList = FlashcardDatabaseProvider.getAll(isTest: true);
      expect(flashcardsList.length, 1);
      await FlashcardDatabaseProvider.deleteAllAsync(isTest: true);
    });

    testWidgets('Write , delete , get by id', (tester) async {
      await FlashcardDatabaseProvider.deleteAllAsync(isTest: true);

      var flashcards = flashFixture();

      bool written = await FlashcardDatabaseProvider.writeEditAsync(flashcards,
          isTest: true);
      expect(written, true);
      // get from db
      var collectionFromDb =
          FlashcardDatabaseProvider.getById(flashcards.id, isTest: true);

      expect(collectionFromDb, flashcards);

      await FlashcardDatabaseProvider.deleteAsync(collectionFromDb!.id,
          isTest: true);

      final collectionFromDbDeleted =
          FlashcardDatabaseProvider.getById(collectionFromDb.id, isTest: true);
      expect(collectionFromDbDeleted, null);
      await FlashcardDatabaseProvider.deleteAllAsync(isTest: true);
    });

    testWidgets('Write null', (tester) async {
      await FlashcardDatabaseProvider.deleteAllAsync(isTest: true);

      var emptyFlash = FlashCard(
        questionLanguage: '',
        answerLanguage: '',
        questionWords: '',
        answerWords: '',
        lastTested: DateTime.now(),
        correctAnswers: 0,
        wrongAnswers: 0,
        isLearned: false,
      );

      var emptyFlashCollection = FlashCardCollection(
        uuid.v4().toString(),
        title: '',
        flashCardSet: {emptyFlash},
        createdAt: DateTime.now(),
        isDeleted: false,
        questionLanguage: '',
        answerLanguage: '',
      );

      bool written = await FlashcardDatabaseProvider.writeEditAsync(
          emptyFlashCollection,
          isTest: true);
      // expect than database not write null
      expect(written, false);

      expect((emptyFlash..answerLanguage = '1').isValid, false);
      expect((emptyFlash..answerWords = '1').isValid, false);
      expect((emptyFlash..correctAnswers = 1).isValid, false);
      expect((emptyFlash..questionLanguage = '1').isValid, false);
      expect((emptyFlash..questionWords = '1').isValid, true);

      expect((emptyFlashCollection..title = '1').isValid, false);
      expect((emptyFlashCollection..questionLanguage = '1').isValid, false);
      expect((emptyFlashCollection..answerLanguage = '1').isValid, true);
    });

    testWidgets('test get all flashcards', (widgetTester) async {
      await FlashcardDatabaseProvider.deleteAllAsync(isTest: true);
      var flashcards = flashFixture();
      var flashcards2 = flashFixture();

      expect(flashcards.id != flashcards2.id, true);
      // save to db
      bool written2 = await FlashcardDatabaseProvider.writeEditAsync(
          flashcards2,
          isTest: true);
      expect(written2, true);

      bool written = await FlashcardDatabaseProvider.writeEditAsync(flashcards,
          isTest: true);
      expect(written, true);

      var flashcardsList = FlashcardDatabaseProvider.getAll(isTest: true);

      debugPrint('flashcardsList.length ${flashcardsList.length}');
      expect(flashcardsList.length, 2);
      debugPrint(flashcardsList[0].id);
      debugPrint(flashcardsList[1].id);
      debugPrint(flashcards.id);
      debugPrint(flashcards2.id);
      expect(flashcardsList[0], flashcards2);
      expect(flashcardsList[1], flashcards);
    });

    testWidgets('test to trash, from trash', (widgetTester) async {
      // ==================================================== to trash
      await FlashcardDatabaseProvider.deleteAllAsync(isTest: true);
      var flashcards1 = flashFixture();
      var flashcards2 = flashFixture()..flashCardSet.first.answerWords = 't1';
      var flashcards3 = flashFixture()..flashCardSet.first.answerWords = 't2';
      var flashcards4 = flashFixture()..flashCardSet.first.answerWords = 't3';

      // save to db

      await FlashcardDatabaseProvider.writeEditAsync(flashcards1, isTest: true);
      await FlashcardDatabaseProvider.writeEditAsync(flashcards2, isTest: true);
      await FlashcardDatabaseProvider.writeEditAsync(flashcards3, isTest: true);
      await FlashcardDatabaseProvider.writeEditAsync(flashcards4, isTest: true);
      // check not in trash
      expect(
          FlashcardDatabaseProvider.getAllFromTrash(false, isTest: true).length,
          4);
      // check trash
      expect(
          FlashcardDatabaseProvider.getAllFromTrash(true, isTest: true).length,
          0);
      await FlashcardDatabaseProvider.trashMoveFlashCardsAsync(
          [flashcards1, flashcards2, flashcards3, flashcards4],
          isTest: true, toTrash: true);

      // check not in trash
      expect(
          FlashcardDatabaseProvider.getAllFromTrash(false, isTest: true).length,
          0);
      // check trash
      expect(
          FlashcardDatabaseProvider.getAllFromTrash(true, isTest: true).length,
          4);

      // ===========================================================from trash
      await FlashcardDatabaseProvider.trashMoveFlashCardsAsync(
          [flashcards1, flashcards2, flashcards3, flashcards4],
          isTest: true, toTrash: false);

      expect(
          FlashcardDatabaseProvider.getAllFromTrash(false, isTest: true).length,
          4);
      // check trash
      expect(
          FlashcardDatabaseProvider.getAllFromTrash(true, isTest: true).length,
          0);

      expect(
          await FlashcardDatabaseProvider.deleteAllAsync(isTest: true), true);

      await FlashcardDatabaseProvider.deleteAllAsync(isTest: true);
    });

    testWidgets('test merge flashcard', (widgetTester) async {
      await FlashcardDatabaseProvider.deleteAllAsync(isTest: true);
      var flashcards = flashFixture();
      expect(flashcards.flashCardSet.length, 2);
      var flashcards2 = flashFixture()..flashCardSet.first.answerWords = 't1';
      var flashcards3 = flashFixture()..flashCardSet.first.answerWords = 't2';
      var flashcards4 = flashFixture()..flashCardSet.first.answerWords = 't3';
      var toMerge = [flashcards2, flashcards3, flashcards4];

      expect(flashcards.id != flashcards2.id, true);
      // save to db

      bool written = await FlashcardDatabaseProvider.writeEditAsync(flashcards,
          isTest: true);
      await FlashcardDatabaseProvider.writeEditAsync(flashcards2, isTest: true);
      await FlashcardDatabaseProvider.writeEditAsync(flashcards3, isTest: true);
      await FlashcardDatabaseProvider.writeEditAsync(flashcards4, isTest: true);
      expect(written, true);
      expect(
          FlashcardDatabaseProvider.getAllFromTrash(false, isTest: true).length,
          4);

      bool merged = await FlashcardDatabaseProvider.mergeAsync(
          toMerge, flashcards,
          isTest: true);

      expect(merged, true);

      expect(
          FlashcardDatabaseProvider.getAllFromTrash(false, isTest: true).length,
          1);
      var flashcardsList =
          FlashcardDatabaseProvider.getAllFromTrash(false, isTest: true);
      expect(flashcardsList[0].flashCardSet.length, 5);

      await FlashcardDatabaseProvider.deleteAllAsync(isTest: true);
    });
  });

  group('Database theme', () {
    testWidgets('theme from hive database', (widgetTester) async {
      await ThemeDatabaseProvider.writeEditAsync(Themes.dark, isTest: true);
      var theme = await ThemeDatabaseProvider.getAsync(isTest: true);
      expect(theme, Themes.dark);
    });

    testWidgets('theme from empty hive database', (widgetTester) async {
      await ThemeDatabaseProvider.deleteAsync(isTest: true);
      var theme = await ThemeDatabaseProvider.getAsync(isTest: true);
      expect(theme, Themes.light);
    });
  });
}
