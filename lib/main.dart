import 'package:flashcards_reader/views/view_config.dart';
import 'package:flutter/material.dart';

void main() {
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
      drawer: Drawer(
        backgroundColor: Colors.grey[300],
        child: ListView(
          children: [
            SizedBox(
              height: appBarHeight - 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FloatingActionButton(
                    onPressed: () {},
                    child: const CircleAvatar(
                      // Display the Flutter Logo image asset.
                      foregroundImage:
                          AssetImage('assets/images/flutter_logo.png'),
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.sunny))
                ],
              ),
            ),
            Divider(
              color: Colors.grey[700],
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Reading'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Favorites'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('To Read'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.library_books_rounded),
              title: const Text('All Books'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Authors'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.collections_bookmark),
              title: const Text('Collections'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.recycling),
              title: const Text('Recycle Bin'),
              onTap: () {},
            ),
            Divider(
              color: Colors.grey[700],
            ),
            ListTile(
              leading: const Icon(Icons.layers_rounded),
              title: const Text('Flashcards'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.quiz),
              title: const Text('Take a Quiz'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.add_circle_outline),
              title: const Text('Add new words'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.import_export),
              title: const Text('Import from file'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.add_circle_outline),
              title: const Text('Add new words'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Deleted flashcards'),
              onTap: () {},
            ),
            Divider(
              color: Colors.grey[700],
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings and Help'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text('Feedback and Support'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
