import 'package:flashcards_reader/util/router.dart';
import 'package:flashcards_reader/views/flashcards/deleted%20flashcards/deleted_flashcards_screen.dart';
import 'package:flashcards_reader/views/flashcards/flashcards/flashcards_screen.dart';
import 'package:flashcards_reader/views/flashcards/quiz/flash_quiz.dart';
import 'package:flutter/material.dart';

class MenuDrawer extends StatelessWidget {
  final double appBarHeight;

  const MenuDrawer(this.appBarHeight, {super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[300],
      child: ListView(
        semanticChildCount: 14,
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
            leading: const Icon(Icons.recycling),
            title: const Text('Recycle Bin'),
            onTap: () {},
          ),
          Divider(
            color: Colors.grey[700],
          ),
          ListTile(
            leading: const Icon(Icons.flash_on),
            title: const Text('Flashcards'),
            onTap: () {
              MyRouter.pushPageReplacement(context, const FlashCardScreen());
            },
          ),
          ListTile(
            leading: const Icon(Icons.quiz),
            title: const Text('Take a Quiz'),
            onTap: () {
              MyRouter.pushPageReplacement(context, const QuizMenu());
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Add new words'),
            onTap: () {
              // MyRouter.pushPageReplacement(context, );
            },
          ),
          ListTile(
            leading: const Icon(Icons.import_export),
            title: const Text('Import from file'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Deleted flashcards'),
            onTap: () {
              MyRouter.pushPageReplacement(
                  context, const DeletedFlashCardScreen());
            },
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
    );
  }
}
