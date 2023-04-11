import 'package:flashcards_reader/model/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/view_models/flashcards_provider/flashcard_collection_provider.dart';
import 'package:flashcards_reader/views/flashcards/deleted%20flashcards/deleted_flashcard_collection_widget.dart';
import 'package:flashcards_reader/views/menu/drawer_menu.dart';
import 'package:flashcards_reader/views/view_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class DeletedFlashCardScreen extends StatefulWidget {
  DeletedFlashCardScreen({super.key});
  Duration cardAppearDuration = const Duration(milliseconds: 375);
  List<FlashCardCollection> flashCardCollection =
      FlashCardCollectionProvider.getFlashCards(isDeleted: true);

  @override
  State<DeletedFlashCardScreen> createState() => _DeletedFlashCardScreenState();
}

class _DeletedFlashCardScreenState extends State<DeletedFlashCardScreen> {
  void updateCallback() {
    setState(() {
      widget.flashCardCollection =
          FlashCardCollectionProvider.getFlashCards(isDeleted: true);
    });
  }

  int columnCount = 2;
  double appBarHeight = 0;

  double getCardForm(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.portrait ? 0.65 : 1;

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

  List<Widget> bottomNavigationBarItems() {
    return [
      if (widget.flashCardCollection.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.delete_forever),
          onPressed: () async {
            // delete all from trash
            await FlashCardCollectionProvider.deleteFromTrashAllAsync();
            updateCallback();
          },
        ),
    ];
  }

  AppBar getAppBar() {
    return AppBar(
      title: Text('Deleted flashcards: ${widget.flashCardCollection.length}'),
    );
  }

  Widget? getDrawer() {
    if (FlashCardCollectionProvider.isMergeModeStarted) {
      return null;
    } else {
      return MenuDrawer(appBarHeight);
    }
  }

  @override
  Widget build(BuildContext context) {
    columnCount = calculateColumnCount(context);
    var appBar = getAppBar();
    appBarHeight = appBar.preferredSize.height;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: appBar,
        body: widget.flashCardCollection.isEmpty
            ? const Center(child:  Text('Bin is empty'))
            : AnimationLimiter(
                child: GridView.count(
                    mainAxisSpacing:
                        SizeConfig.getMediaHeight(context, p: 0.04),
                    crossAxisSpacing: calculateCrossSpacing(context),
                    crossAxisCount: columnCount,
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.getMediaWidth(context, p: 0.05)),
                    childAspectRatio: getCardForm(context),
                    children: List.generate(widget.flashCardCollection.length,
                        (index) {
                      /// ====================================================================[FlashCardCollectionWidget]
                      // add flashcards
                      return Transform.scale(
                        scale: columnCount == 1 ? 0.9 : 1,
                        child: AnimationConfiguration.staggeredGrid(
                          position: index,
                          duration: widget.cardAppearDuration,
                          columnCount: columnCount,
                          child: SlideAnimation(
                            child: FadeInAnimation(
                              child: DeletedFlashCardCollectionWidget(
                                  widget.flashCardCollection[index],
                                  updateCallback),
                            ),
                          ),
                        ),
                      );
                    })),
              ),
        drawer: getDrawer(),
        bottomNavigationBar: BottomAppBar(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              /// icon buttons, analog of bottom navigation bar with flashcards, merge if merge mode is on and quiz
              children: bottomNavigationBarItems()),
        ));
  }
}
