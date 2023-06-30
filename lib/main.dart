import 'package:flashcards_reader/model/IO/local_manager.dart';
import 'package:flashcards_reader/model/entities/reader/book_scanner.dart';
import 'package:flashcards_reader/model/entities/tts/core.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/util/internet_checker.dart';
import 'package:flashcards_reader/views/menu/side_menu.dart';
import 'package:flashcards_reader/views/parent_screen.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

import 'database/core/core.dart';

Future<bool> initAsync() async {
  bool ioInit = await LocalManager.initAsync();
  bool dbInit = await DataBase.initAsync();
  debugPrint('db inited: $dbInit');

  TextToSpeechService.initTtsEngineAsync()
      .then((value) => debugPrint('tts engine inited: $value'));

  // start checking internet connection
  debugPrintIt('start checking internet connection');
  InternetConnectionChecker.startChecking();
  return dbInit && ioInit;
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
  Widget build(BuildContext context, {Widget? page}) {
    /// ===============================================[Create page]===============================
    var appBar = AppBar(
      title: Text(widget.title),
    );
    appBarHeight = appBar.preferredSize.height;

    bindPage(Scaffold(
      appBar: appBar,
      body: Center(
          child: Column(
        children: [
          Text('hello world'),
          IconButton(
              onPressed: () {
                BookScanner.scan();
              },
              icon: Icon(Icons.add))
        ],
      )),
      drawer: SideMenu(appBarHeight),
    ));

    /// ===============================================[Select design via context]===============================

    return super.build(context);
  }
}
