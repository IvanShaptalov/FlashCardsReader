import 'package:flashcards_reader/model/flashcards/flashcards.dart';
import 'package:flashcards_reader/view_models/flashcards_provider/flashcard_collection_provider.dart';
import 'package:flashcards_reader/views/flashcards/flashcards/add_flashcard.dart';
import 'package:flashcards_reader/views/flashcards/flashcards/flashcard_collection_widget.dart';
import 'package:flashcards_reader/views/menu/drawer_menu.dart';
import 'package:flashcards_reader/views/view_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class FlashCardScreen extends StatefulWidget {
  FlashCardScreen({super.key});
  final columnCount = 2;
  Duration cardAppearDuration = const Duration(milliseconds: 300);
  List<FlashCardCollection> flashCardCollection =
      FlashCardCollectionProvider.getFlashCards();

  @override
  State<FlashCardScreen> createState() => _FlashCardScreenState();
}

class _FlashCardScreenState extends State<FlashCardScreen> {
  void updateCallback() {
    setState(() {
      widget.flashCardCollection = FlashCardCollectionProvider.getFlashCards();
    });
  }

  double appBarHeight = 0;
  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      title: Text('Flashcards: ${widget.flashCardCollection.length}'),
    );
    appBarHeight = appBar.preferredSize.height;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: appBar,
        body: Padding(
          padding: EdgeInsets.symmetric(
            vertical: SizeConfig.getMediaHeight(context, p: 0.05),
          ),
          child: AnimationLimiter(
            child: GridView.count(
                crossAxisCount: widget.columnCount,
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.getMediaWidth(context, p: 0.02)),
                childAspectRatio: 0.65,
                children: List.generate(widget.flashCardCollection.length + 1,
                    (index) {
                  /// ====================================================================[FlashCardCollectionWidget]
                  // add flashcards
                  if (index == 0) {
                    return AnimationConfiguration.staggeredGrid(
                      position: index,
                      duration: widget.cardAppearDuration,
                      columnCount: widget.columnCount,
                      child: ScaleAnimation(
                        child: FadeInAnimation(
                          child: AddFlashCardWidget(updateCallback),
                        ),
                      ),
                    );
                  } else {
                    return AnimationConfiguration.staggeredGrid(
                      position: index,
                      duration: widget.cardAppearDuration,
                      columnCount: widget.columnCount,
                      child: ScaleAnimation(
                        child: FadeInAnimation(
                          child: FlashCardCollectionWidget(
                              widget.flashCardCollection[index - 1],
                              updateCallback),
                        ),
                      ),
                    );
                  }
                })),
          ),
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
