import 'package:flashcards_reader/model/flashcards/flashcards.dart';
import 'package:flashcards_reader/view_models/flashcards_provider/flashcard_collection_provider.dart';
import 'package:flashcards_reader/views/flashcards/flashcard_collection_widget.dart';
import 'package:flashcards_reader/views/menu/drawer_menu.dart';
import 'package:flashcards_reader/views/view_config.dart';
import 'package:flutter/material.dart';

class FlashCardScreen extends StatefulWidget {
  FlashCardScreen({super.key});
  final List<FlashCardCollection> flashCardCollection =
      FlashCardCollectionProvider.getFlashCards();

  @override
  State<FlashCardScreen> createState() => _FlashCardScreenState();
}

class _FlashCardScreenState extends State<FlashCardScreen> {
  double appBarHeight = 0;
  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      title: const Text('Flashcards'),
    );
    appBarHeight = appBar.preferredSize.height;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: appBar,
        body: Padding(
          padding: EdgeInsets.symmetric(
              vertical: SizeConfig.getMediaHeight(context, p: 0.05),
              horizontal: SizeConfig.getMediaWidth(context, p: 0.05)),
          child: widget.flashCardCollection.isNotEmpty
              ? GridView.count(
                  crossAxisCount: 2,
                  children:
                      List.generate(widget.flashCardCollection.length, (index) {
                    /// ====================================================================[FlashCardCollectionWidget]
                    return FlashCardCollectionWidget(
                        widget.flashCardCollection[index]);
                  }))
              : const Text('No flashcards yet'),
        ),
        drawer: MenuDrawer(appBarHeight),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'reading',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.quiz),
              label: 'take a quiz',
            ),
          ],
        ));
  }
}
