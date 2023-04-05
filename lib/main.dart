import 'package:flashcards_reader/model/flashcards/flashcards.dart';
import 'package:flashcards_reader/views/menu/drawer_menu.dart';
import 'package:flutter/material.dart';

import 'database/core/core.dart';

Future<bool> initAsync() async {
  bool dbInit = await DataBase.initAsync();

  return dbInit;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool inited = await initAsync();

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
