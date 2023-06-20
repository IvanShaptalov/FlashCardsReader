import 'package:flashcards_reader/bloc/flashcards_bloc/flashcards_bloc.dart';
import 'package:flashcards_reader/bloc/providers/flashcard_merge_provider.dart';
import 'package:flashcards_reader/bloc/translator_bloc/translator_bloc.dart';
import 'package:flashcards_reader/util/router.dart';
import 'package:flashcards_reader/views/flashcards/flashcards/add_flashcard_widget.dart';
import 'package:flashcards_reader/views/flashcards/flashcards/flashcard_collection_widget.dart';
import 'package:flashcards_reader/views/flashcards/quiz/quiz_menu.dart';
import 'package:flashcards_reader/views/flashcards/sharing/extension_dialog.dart';
import 'package:flashcards_reader/views/menu/drawer_menu.dart';
import 'package:flashcards_reader/views/overlay_notification.dart';
import 'package:flashcards_reader/views/parent_screen.dart';
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
      child: BlocProvider(
        create: (_) => TranslatorBloc(),
        child: FlashCardView(),
      ),
    );
  }
}

// ignore: must_be_immutable
class FlashCardView extends ParentStatefulWidget {
  FlashCardView({super.key});
  Duration cardAppearDuration = const Duration(milliseconds: 375);

  @override
  ParentState<FlashCardView> createState() => _FlashCardViewState();
}

class _FlashCardViewState extends ParentState<FlashCardView> {
  void updateCallback() {
    setState(() {});
  }

  int columnCount = 2;
  double appBarHeight = 0;

  List<Widget> bottomNavigationBarItems() {
    // deactivate merge mode
    if (FlashCardCollectionProvider.isMergeModeStarted &&
        !FlashCardCollectionProvider.readyToMerge()) {
      return [deactivateMergeIcon()];
    }
    // deactivate merge mode or merge if possible
    if (FlashCardCollectionProvider.readyToMerge()) {
      return [
        deactivateMergeIcon(),
        IconButton(
          icon: const Icon(Icons.merge_sharp),
          onPressed: () async {
            await FlashCardCollectionProvider.mergeFlashCardsCollectionAsync(
                FlashCardCollectionProvider.flashcardsToMerge,
                FlashCardCollectionProvider.targetFlashCard!);
            FlashCardCollectionProvider.deactivateMergeMode();
            OverlayNotificationProvider.showOverlayNotification(
                'merge succesfully',
                status: NotificationStatus.success);
            updateCallback();
          },
        ),
        IconButton(
          icon: const Icon(Icons.import_export),
          onPressed: () {
            ExtensionDialog.showBulkExportDialog(context, updateCallback);
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
          onPressed: () {
            MyRouter.pushPageReplacement(context, const QuizMenu());
          },
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
          OverlayNotificationProvider.showOverlayNotification('deactivated',
              status: NotificationStatus.info);

          debugPrint('deactivated');
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
    widget.page =
        BlocBuilder<FlashCardBloc, FlashcardsState>(builder: (context, state) {
      var flashCardCollection = state.copyWith(fromTrash: false).flashCards;
      columnCount = ViewColumnCalculator.calculateColumnCount(context);
      var appBar = getAppBar(flashCardCollection);
      appBarHeight = appBar.preferredSize.height;
      return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: appBar,
          body: AnimationLimiter(
            child: GridView.count(
                mainAxisSpacing: SizeConfig.getMediaHeight(context, p: 0.04),
                crossAxisSpacing:
                    ViewColumnCalculator.calculateCrossSpacing(context),
                crossAxisCount: columnCount,
                childAspectRatio: ViewConfig.getCardForm(context),
                children:
                    List.generate(flashCardCollection.length + 1, (index) {
                  /// ====================================================================[FlashCardCollectionWidget]
                  // add flashcards
                  return Transform.scale(
                    scale: 1,
                    child: index == 0
                        ? Transform.scale(
                            scale: ScreenDesign.landscapeSmall ==
                                    ScreenIdentifier.indentify(context)
                                ? 0.85
                                : 1,
                            child: AnimationConfiguration.staggeredGrid(
                              position: index,
                              duration: widget.cardAppearDuration,
                              columnCount: columnCount,
                              child: const SlideAnimation(
                                child: FadeInAnimation(
                                  child: AddFlashCardWidget(),
                                ),
                              ),
                            ),
                          )
                        : Transform.scale(
                            scale: ScreenDesign.landscapeSmall ==
                                    ScreenIdentifier.indentify(context)
                                ? 0.85
                                : 1,
                            child: AnimationConfiguration.staggeredGrid(
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

    return super.build(context);
  }
}
