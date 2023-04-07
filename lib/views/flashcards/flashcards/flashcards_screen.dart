import 'package:flashcards_reader/model/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/view_models/flashcards_provider/flashcard_collection_provider.dart';
import 'package:flashcards_reader/views/flashcards/flashcards/add_flashcard.dart';
import 'package:flashcards_reader/views/flashcards/flashcards/flashcard_collection_widget.dart';
import 'package:flashcards_reader/views/menu/drawer_menu.dart';
import 'package:flashcards_reader/views/view_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class FlashCardScreen extends StatefulWidget {
  FlashCardScreen({super.key});
  Duration cardAppearDuration = const Duration(milliseconds: 375);
  List<FlashCardCollection> flashCardCollection =
      FlashCardCollectionProvider.getFlashCards();
  List<FlashCardCollection> cardsToMerge = [];

  @override
  State<FlashCardScreen> createState() => _FlashCardScreenState();
}

class _FlashCardScreenState extends State<FlashCardScreen> {
  void updateCallback() {
    setState(() {
      widget.flashCardCollection = FlashCardCollectionProvider.getFlashCards();
    });
  }

  int columnCount = 2;
  double appBarHeight = 0;

  int calculateColumnCount(BuildContext context) {
    double screenWidth = SizeConfig.getMediaWidth(context);
    if (screenWidth > 1000) {
      return SizeConfig.getMediaWidth(context) ~/ 200;
    } else if (screenWidth > 600) {
      return 3;
    } else if (screenWidth >= 380) {
      return 2;
    }
    return 1;
  }

  double calculateCrossSpacing(BuildContext context) {
    double screenWidth = SizeConfig.getMediaWidth(context);
    if (screenWidth > 1000) {
      return SizeConfig.getMediaWidth(context) / 20;
    } else if (screenWidth > 600) {
      return 40;
    } else if (screenWidth >= 380) {
      return 25;
    }
    return 15;
  }

  @override
  Widget build(BuildContext context) {
    columnCount = calculateColumnCount(context);
    var appBar = AppBar(
      title: Text('Flashcards: ${widget.flashCardCollection.length}'),
    );
    appBarHeight = appBar.preferredSize.height;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: appBar,
        body: AnimationLimiter(
          child: GridView.count(
              mainAxisSpacing: SizeConfig.getMediaHeight(context, p: 0.04),
              crossAxisSpacing: calculateCrossSpacing(context),
              crossAxisCount: columnCount,
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.getMediaWidth(context, p: 0.05)),
              childAspectRatio: 0.65,
              children:
                  List.generate(widget.flashCardCollection.length + 1, (index) {
                /// ====================================================================[FlashCardCollectionWidget]
                // add flashcards
                if (index == 0) {
                  return AnimationConfiguration.staggeredGrid(
                    position: index,
                    duration: widget.cardAppearDuration,
                    columnCount: columnCount,
                    child: SlideAnimation(
                      child: FadeInAnimation(
                        child: AddFlashCardWidget(updateCallback),
                      ),
                    ),
                  );
                } else {
                  return AnimationConfiguration.staggeredGrid(
                    position: index,
                    duration: widget.cardAppearDuration,
                    columnCount: columnCount,
                    child: SlideAnimation(
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
