import 'package:flashcards_reader/model/flashcards/flashcards.dart';
import 'package:flashcards_reader/views/menu/drawer_menu.dart';
import 'package:flutter/material.dart';

void main() async {
  // final FlashCard flashCard1 = FlashCard(
  //     fromLanguage: 'English',
  //     toLanguage: 'German',
  //     questionWords: 'Hello',
  //     answerWords: 'Hallo',
  //     lastTested: DateTime.now(),
  //     nextTest: DateTime.now().add(const Duration(days: 1)),
  //     correctAnswers: 0,
  //     wrongAnswers: 0,
  //     isDeleted: false);
  // final FlashCard flashCard2 = FlashCard(
  //     fromLanguage: 'English',
  //     toLanguage: 'German',
  //     questionWords: 'Goodbye',
  //     answerWords: 'Auf Wiedersehen',
  //     lastTested: DateTime.now(),
  //     nextTest: DateTime.now().add(const Duration(days: 1)),
  //     correctAnswers: 0,
  //     wrongAnswers: 0,
  //     isDeleted: false);

  // final FlashCardCollection testFlashCardCollection = FlashCardCollection(
  //   title: 'English-German',
  //   flashCards: [flashCard1, flashCard2],
  // );

 

  // await isar.writeTxn(() async {
  //   await isar.flashCardCollections.put(testFlashCardCollection);
  // });

  // final collectionFromDb =
  //     await isar.flashCardCollections.get(testFlashCardCollection.id);

  // final collectionFromDb1 =
  //     await isar.flashCardCollections.filter().

  // print(collectionFromDb);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
