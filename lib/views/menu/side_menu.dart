import 'package:flashcards_reader/model/entities/reader/reading.dart';
import 'package:flashcards_reader/util/router.dart';
import 'package:flashcards_reader/views/flashcards/deleted%20flashcards/deleted_flashcards_screen.dart';
import 'package:flashcards_reader/views/flashcards/new_word/new_word_screen.dart';
import 'package:flashcards_reader/views/flashcards/sharing/import_page.dart';
import 'package:flashcards_reader/views/menu/bottom_nav_bar.dart';
import 'package:flashcards_reader/views/reader/screens/splash.dart';
import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  final double appBarHeight;

  const SideMenu(this.appBarHeight, {super.key});

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
            leading: Reading.icon,
            title: const Text(Reading.title),
            onTap: () {
              MyRouter.pushPageReplacement(context, const ReadingMainScreen());
            },
          ),
          ListTile(
            leading: const Icon(Icons.web_stories_outlined),
            title: const Text('Flashcards'),
            onTap: () {
              BottomNavBar.setPageIndex(BottomNavPages.flashcards);
              MyRouter.pushPageReplacement(context, const BottomNavBar());
            },
          ),
          ListTile(
            leading: const Icon(Icons.quiz),
            title: const Text('Take a Quiz'),
            onTap: () {
              BottomNavBar.setPageIndex(BottomNavPages.quiz);
              MyRouter.pushPageReplacement(context, const BottomNavBar());
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Add new word'),
            onTap: () {
              MyRouter.pushPageReplacement(context, AddWordFastScreen());
            },
          ),
          ListTile(
            leading: const Icon(Icons.import_export),
            title: const Text('Import flashcards'),
            onTap: () {
              MyRouter.pushPageReplacement(context, const SharingPage());
            },
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
