import 'package:flashcards_reader/bloc/flashcards_bloc/flashcards_bloc.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/bloc/flashcards_provider/flashcard_collection_provider.dart';
import 'package:flashcards_reader/views/flashcards/flashcards/add_flashcard.dart';
import 'package:flashcards_reader/views/flashcards/flashcards/flashcard_collection_widget.dart';
import 'package:flashcards_reader/views/menu/drawer_menu.dart';
import 'package:flashcards_reader/views/view_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class FlashCardScreen extends StatefulWidget {
  const FlashCardScreen({super.key});

  @override
  State<FlashCardScreen> createState() => _FlashCardScreenState();
}

class _FlashCardScreenState extends State<FlashCardScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FlashCardBloc(),
      child: FlashCardView(),
    );
  }
}

// ignore: must_be_immutable
class FlashCardView extends StatefulWidget {
  FlashCardView({super.key});
  Duration cardAppearDuration = const Duration(milliseconds: 375);

  @override
  State<FlashCardView> createState() => _FlashCardViewState();
}

class _FlashCardViewState extends State<FlashCardView> {
  void updateCallback() {
    setState(() {});
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
    // deactivate merge mode
    if (FlashCardCollectionProvider.isMergeModeStarted &&
        !FlashCardCollectionProvider.mergeModeCondition()) {
      return [deactivateMergeIcon()];
    }
    // deactivate merge mode or merge if possible
    if (FlashCardCollectionProvider.mergeModeCondition()) {
      return [
        deactivateMergeIcon(),
        IconButton(
          icon: const Icon(Icons.merge_type),
          onPressed: () async {
            await FlashCardCollectionProvider.mergeFlashCardsCollectionAsync(
                FlashCardCollectionProvider.flashcardsToMerge,
                FlashCardCollectionProvider.targetFlashCard!);
            FlashCardCollectionProvider.deactivateMergeMode();
            updateCallback();
          },
        ),
      ];
    } else {
      // dont show merge button or deactivate merge mode
      return [
        IconButton(
          icon: const Icon(Icons.book),
          onPressed: () {},
        ),

        /// show merge button if merge mode is available
        IconButton(
          icon: const Icon(Icons.quiz),
          onPressed: () {},
        ),
      ];
    }
  }

  AppBar getAppBar(flashCardCollection) {
    if (FlashCardCollectionProvider.isMergeModeStarted) {
      return AppBar(
        title: const Text('Merge mode is on'),
      );
    } else {
      return AppBar(
        title: Text('Flashcards: ${flashCardCollection.length}'),
      );
    }
  }

  IconButton deactivateMergeIcon() {
    return IconButton(
        onPressed: () {
          debugPrint('merge mode deactivated');
          FlashCardCollectionProvider.deactivateMergeMode();
          updateCallback();
        },
        icon: const Icon(Icons.cancel));
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
    return BlocBuilder<FlashCardBloc, FlashcardsState>(
        builder: (context, state) {
      var flashCardCollection = state.copyWith(fromTrash: false).flashCards;
      columnCount = calculateColumnCount(context);
      var appBar = getAppBar(flashCardCollection);
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
                childAspectRatio: getCardForm(context),
                children:
                    List.generate(flashCardCollection.length + 1, (index) {
                  /// ====================================================================[FlashCardCollectionWidget]
                  // add flashcards
                  return Transform.scale(
                    scale: columnCount == 1 ? 0.9 : 1,
                    child: index == 0
                        ? AnimationConfiguration.staggeredGrid(
                            position: index,
                            duration: widget.cardAppearDuration,
                            columnCount: columnCount,
                            child: const SlideAnimation(
                              child: FadeInAnimation(
                                child: AddFlashCardWidget(),
                              ),
                            ),
                          )
                        : AnimationConfiguration.staggeredGrid(
                            position: index,
                            duration: widget.cardAppearDuration,
                            columnCount: columnCount,
                            child: SlideAnimation(
                              child: FadeInAnimation(
                                child: FlashCardCollectionWidget(
                                    flashCardCollection[index - 1],
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
    });
  }
}
