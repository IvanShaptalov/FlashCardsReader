import 'package:flashcards_reader/database/core/table_methods.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/util/enums.dart';
import 'package:flashcards_reader/views/menu/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

import 'database/core/core.dart';

Future<bool> initAsync() async {
  bool dbInit = await DataBase.initAsync();

  return dbInit;
}

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
      answerLanguage: 'German');
  return testFlashCardCollection;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool inited = await initAsync();
  debugPrint('inited: $inited');
  assert(inited, true);

  await FlashcardDatabaseProvider.deleteAllAsync();
  for (var i = 0; i < 8; i++) {
    await FlashcardDatabaseProvider.writeEditAsync(
      flashFixture()..title = 'English-German $i',
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            // ignore: deprecated_member_use
            androidOverscrollIndicator: AndroidOverscrollIndicator.stretch),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double appBarHeight = 0;

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      title: Text(widget.title),
    );
    appBarHeight = appBar.preferredSize.height;
    return Scaffold(
      appBar: appBar,
      body: Center(
        child: Column(children: const [Text('Hello World!')]),
      ),
      drawer: MenuDrawer(appBarHeight),
    );
  }
}
