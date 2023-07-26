import 'package:flashcards_reader/bloc/flashcards_bloc/flashcards_bloc.dart';
import 'package:flashcards_reader/bloc/providers/flashcard_merge_provider.dart';
import 'package:flashcards_reader/bloc/providers/word_collection_provider.dart';
import 'package:flashcards_reader/bloc/translator_bloc/translator_bloc.dart';
import 'package:flashcards_reader/quick_actions.dart';
import 'package:flashcards_reader/constants.dart';
import 'package:flashcards_reader/views/flashcards/flashcards/add_flashcard_widget.dart';
import 'package:flashcards_reader/views/flashcards/flashcards/flashcard_collection_widget.dart';
import 'package:flashcards_reader/views/flashcards/flashcards/view_flashcard_menu.dart';
import 'package:flashcards_reader/views/flashcards/sharing/extension_dialog.dart';
import 'package:flashcards_reader/views/guide_wrapper.dart';
import 'package:flashcards_reader/views/menu/side_menu.dart';
import 'package:flashcards_reader/views/overlay_notification.dart';
import 'package:flashcards_reader/views/parent_screen.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:quick_actions/quick_actions.dart';

class FlashCardScreen extends StatefulWidget {
  const FlashCardScreen({super.key, this.isTutorial = false});
  final bool isTutorial;

  @override
  State<FlashCardScreen> createState() => _FlashCardScreenState();
}

class _FlashCardScreenState extends State<FlashCardScreen> {
  @override
  void initState() {
    const QuickActions quickActions = QuickActions();

    quickActions.initialize((String shortcutType) {
      setState(() {
        ShortcutsProvider.shortcut = shortcutType;
      });
    });

    quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(
        type: addWordAction,
        localizedTitle: addWordAction,
        icon: 'add_circle',
      ),
      const ShortcutItem(
          type: quizAction, localizedTitle: quizAction, icon: 'quiz'),
    ]).then((void _) {
      if (ShortcutsProvider.shortcut == 'no action set') {
        setState(() {
          ShortcutsProvider.shortcut = 'actions ready';
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FlashCardBloc(),
      child: BlocProvider(
        create: (_) => TranslatorBloc(),
        child: FlashCardView(isTutorial: widget.isTutorial),
      ),
    );
  }
}

// ignore: must_be_immutable
class FlashCardView extends ParentStatefulWidget {
  FlashCardView({super.key, this.isTutorial = false});
  final bool isTutorial;
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
      return [];
    }
  }

  AppBar getAppBar(flashCardCollection) {
    if (FlashCardCollectionProvider.isMergeModeStarted) {
      return AppBar(
        title: Text(
          'Merge mode is on',
          style: FontConfigs.pageNameTextStyle,
        ),
      );
    } else {
      return AppBar(
        title: Text(
          'Flashcards: ${flashCardCollection.length}',
          style: FontConfigs.pageNameTextStyle,
        ),
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
      return SideMenu(appBarHeight);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isTutorial) {
      GuideProvider.startStep(context, updateCallback, 4);
    }
  }

  @override
  Widget build(BuildContext upperContext) {
    widget.page = BlocBuilder<FlashCardBloc, FlashcardsState>(
        builder: (builderContext, state) {
      var flashCardCollection = state.copyWith(fromTrash: false).flashCards;
      columnCount = ViewColumnCalculator.calculateColumnCount(builderContext);
      var appBar = getAppBar(flashCardCollection);
      appBarHeight = appBar.preferredSize.height;
      return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: appBar,
          body: AnimationLimiter(
            child: GridView.count(
                mainAxisSpacing:
                    SizeConfig.getMediaHeight(builderContext, p: 0.04),
                crossAxisSpacing:
                    ViewColumnCalculator.calculateCrossSpacing(builderContext),
                crossAxisCount: columnCount,
                childAspectRatio: ViewConfig.getCardForm(builderContext),
                children:
                    List.generate(flashCardCollection.length + 1, (index) {
                  /// ====================================================================[FlashCardCollectionWidget]
                  // add flashcards
                  if (index == 0) {
                    return GuideProvider.wrapInGuideIfNeeded(
                      child: Transform.scale(
                        scale: 0.85,
                        child: AnimationConfiguration.staggeredGrid(
                          position: index,
                          duration: DurationConfig.cardAppearDuration,
                          columnCount: columnCount,
                          child: SlideAnimation(
                            child: FadeInAnimation(
                              child: AddFlashCardWidget(
                                  updateCallbackCrunch: updateCallback),
                            ),
                          ),
                        ),
                      ),
                      guideText: 'Use this card to create new collections',
                      onHighlightTap: () {
                        GuideProvider.introController.next();
                      },
                      step: 4,
                      toWrap: widget.isTutorial,
                    );
                  } else {
                    return GuideProvider.wrapInGuideIfNeeded(
                      guideText: 'tap on FlashCard',
                      onHighlightTap: () {
                        FlashCardProvider.fc = flashCardCollection[index - 1];
                        FlashCardViewBottomSheet(
                                creatingFlashC: flashCardCollection[index - 1])
                            .showFlashCardViewMenu(context,
                                isTutorial: widget.isTutorial);
                      },
                      step: 5,
                      toWrap: widget.isTutorial,
                      child: Transform.scale(
                        scale: 0.85,
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
                  }
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

    return super.build(upperContext);
  }
}
