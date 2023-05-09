import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/model/entities/tts/core.dart';
import 'package:flashcards_reader/quick_actions.dart';
import 'package:flashcards_reader/util/constants.dart';
import 'package:flashcards_reader/util/enums.dart';
import 'package:flashcards_reader/views/menu/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:quick_actions/quick_actions.dart';

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
      title: 'Example',
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
  void initState() {
    QuickActions quickActions = const QuickActions();

    quickActions.initialize((String shortcutType) {
      setState(() {
        ShortcutsProvider.shortcut = shortcutType;
      });
    });

    quickActions.setShortcutItems(<ShortcutItem>[
      // NOTE: This first action icon will only work on iOS.
      // In a real world project keep the same file name for both platforms.
      const ShortcutItem(
        type: addWordAction,
        localizedTitle: addWordAction,
        icon: 'add_circle',
      ),
      // NOTE: This second action icon will only work on Android.
      // In a real world project keep the same file name for both platforms.
      const ShortcutItem(
          type: quizAction, localizedTitle: quizAction, icon: 'quiz'),
    ]).then((void _) {
      if (ShortcutsProvider.shortcut == 'no action set') {
        setState(() {
          ShortcutsProvider.shortcut = 'actions ready';
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      title: Text(widget.title),
    );
    appBarHeight = appBar.preferredSize.height;
    return ShortcutsProvider.wrapper(
        child: Scaffold(
      appBar: appBar,
      body: Center(
          child: Column(
        children: const [Text('hello world')],
      )),
      drawer: MenuDrawer(appBarHeight),
    ));
  }
}
