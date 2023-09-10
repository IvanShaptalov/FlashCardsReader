import 'package:flashcards_reader/constants.dart';
import 'package:flashcards_reader/views/feedback.dart';
import 'package:flashcards_reader/views/help_page/help_page.dart';
import 'package:flashcards_reader/views/reader/tabs/book_catalog.dart';
import 'package:flashcards_reader/util/router.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flashcards_reader/views/flashcards/deleted%20flashcards/deleted_flashcards_screen.dart';
import 'package:flashcards_reader/views/flashcards/flashcards/flashcards_screen.dart';
import 'package:flashcards_reader/views/flashcards/new_word/new_word_screen.dart';
import 'package:flashcards_reader/views/flashcards/quiz/quiz_menu.dart';
import 'package:flashcards_reader/views/flashcards/sharing/import_page.dart';
import 'package:flashcards_reader/views/reader/screens/reading_homepage.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SideMenu extends StatelessWidget {
  final double appBarHeight;

  const SideMenu(this.appBarHeight, {super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Palette.grey300,
      child: ListView(
        semanticChildCount: 14,
        children: [
          SizedBox(
            height: appBarHeight - 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    launchUrl(Uri.parse(devLink));
                  },
                  child: CircleAvatar(
                    backgroundColor: Palette.amber200,
                    foregroundColor: Palette.amber200,
                    // Display the Flutter Logo image asset.
                    foregroundImage: AssetImage('assets/appIcon.png'),
                  ),
                ),
                // IconButton(onPressed: () {}, icon: const Icon(Icons.sunny))
              ],
            ),
          ),
          Divider(
            color: Palette.grey800,
          ),
          ListTile(
            leading: Icon(Icons.book_sharp, size: ConfigMenu.iconSize),
            title: const Text(BookCatalog.booksTitle),
            onTap: () {
              MyRouter.pushPageReplacement(context, const ReadingHomePage());
            },
          ),
          ListTile(
            leading:
                Icon(Icons.web_stories_outlined, size: ConfigMenu.iconSize),
            title: const Text('Flashcards'),
            onTap: () {
              MyRouter.pushPageReplacement(context, const FlashCardScreen());
            },
          ),
          ListTile(
            leading: Icon(Icons.quiz, size: ConfigMenu.iconSize),
            title: const Text('Take a Quiz'),
            onTap: () {
              MyRouter.pushPageReplacement(context, const QuizMenu());
            },
          ),
          ListTile(
            leading: Icon(Icons.add_circle_outline, size: ConfigMenu.iconSize),
            title: const Text('Add new word'),
            onTap: () {
              MyRouter.pushPageReplacement(context, AddWordFastScreen());
            },
          ),
          ListTile(
            leading: Icon(Icons.import_export, size: ConfigMenu.iconSize),
            title: const Text('Import flashcards'),
            onTap: () {
              MyRouter.pushPageReplacement(context, const SharingPage());
            },
          ),
          ListTile(
            leading: Icon(Icons.delete, size: ConfigMenu.iconSize),
            title: const Text('Deleted flashcards'),
            onTap: () {
              MyRouter.pushPageReplacement(
                  context, const DeletedFlashCardScreen());
            },
          ),
          Divider(
            color: Palette.grey700,
          ),
          ListTile(
            leading: Icon(Icons.settings, size: ConfigMenu.iconSize),
            title: const Text('Settings and Help'),
            onTap: () {
              MyRouter.pushPageReplacement(context, HelpPage());
            },
          ),
          ListTile(
            leading: Icon(Icons.feedback, size: ConfigMenu.iconSize),
            title: const Text('Feedback & Support'),
            onTap: () {
              MyRouter.pushPageReplacement(context, FeedBackPage());
            },
          ),
        ],
      ),
    );
  }
}
