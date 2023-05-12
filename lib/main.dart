import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/model/entities/tts/core.dart';
import 'package:flashcards_reader/util/enums.dart';
import 'package:flashcards_reader/views/menu/drawer_menu.dart';
import 'package:flashcards_reader/views/parent_screen.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

import 'database/core/core.dart';

Future<bool> initAsync() async {
  bool dbInit = await DataBase.initAsync();
  debugPrint('db inited: $dbInit');

  
  TextToSpeechService.initTtsEngineAsync()
      .then((value) => debugPrint('tts engine inited: $value'));

  return dbInit /* && quickInit */;
}

FlashCardCollection flashExample() {
  final FlashCardCollection testFlashCardCollection = FlashCardCollection(
      uuid.v4().toString(),
      title: 'FlashCard Collection',
      flashCardSet: {},
      createdAt: DateTime.now(),
      isDeleted: false,
      questionLanguage: 'English',
      answerLanguage: 'Ukrainian');
  return testFlashCardCollection;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool inited = await initAsync();
  debugPrint('inited: $inited');
  assert(inited, true);

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
          primarySwatch: Colors.green,
          // ignore: deprecated_member_use
          androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
          iconTheme: IconThemeData(color: Colors.grey.shade700),
          scaffoldBackgroundColor: Colors.grey.shade200,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

// ignore: must_be_immutable
class MyHomePage extends ParentStatefulWidget {
  MyHomePage({super.key, required this.title});
  final String title;

  @override
  ParentState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ParentState<MyHomePage> {
  double appBarHeight = 0;

  @override
  Widget build(BuildContext context) {
    /// ===============================================[Create page]===============================
    var appBar = AppBar(
      title: Text(widget.title),
    );
    appBarHeight = appBar.preferredSize.height;
    widget.portraitPage = Scaffold(
      appBar: appBar,
      body: Center(
          child: Column(
        children: const [Text('hello world')],
      )),
      drawer: MenuDrawer(appBarHeight),
    );

    // for now, when 4 desings not implemented, we use only one design
    bindAllPages(widget.portraitPage);

    /// ===============================================[Select design via context]===============================

    return super.build(context);
  }
}
