import 'package:flashcards_reader/bloc/flashcards_bloc/flashcards_bloc.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/bloc/providers/flashcard_merge_provider.dart';
import 'package:flashcards_reader/quick_actions.dart';
import 'package:flashcards_reader/constants.dart';
import 'package:flashcards_reader/views/flashcards/deleted%20flashcards/deleted_flashcard_collection_widget.dart';
import 'package:flashcards_reader/views/menu/side_menu.dart';
import 'package:flashcards_reader/views/parent_screen.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:quick_actions/quick_actions.dart';

class DeletedFlashCardScreen extends StatefulWidget {
  const DeletedFlashCardScreen({super.key});

  @override
  State<DeletedFlashCardScreen> createState() => _DeletedFlashCardScreenState();
}

class _DeletedFlashCardScreenState extends State<DeletedFlashCardScreen> {
  @override
  void initState() {
    const QuickActions quickActions = QuickActions();

    quickActions.initialize((String shortcutType) {
      setState(() {
        ShortcutsProvider.shortcut = shortcutType;
      });
    });

    quickActions.setShortcutItems(<ShortcutItem>[
      // NOTE: This first action icon will only work on iOS.
      // In a real world project keep the same file name for both platforms.
      const ShortcutItem(
        type: addWordAction,
        localizedTitle: addWordAction,
        icon: 'add_circle',
      ),
      // NOTE: This second action icon will only work on Android.
      // In a real world project keep the same file name for both platforms.
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
      child: ShortcutsProvider.wrapper(child: DeletedFlashCardView()),
    );
  }
}

// ignore: must_be_immutable
class DeletedFlashCardView extends ParentStatefulWidget {
  DeletedFlashCardView({super.key});
  Duration cardAppearDuration = const Duration(milliseconds: 375);

  @override
  ParentState<DeletedFlashCardView> createState() =>
      _DeletedFlashCardViewState();
}

class _DeletedFlashCardViewState extends ParentState<DeletedFlashCardView> {
  int columnCount = 2;
  double appBarHeight = 0;

  List<Widget> bottomNavigationBarItems(
      List<FlashCardCollection> flashCardCollection) {
    return [
      if (flashCardCollection.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.delete_forever),
          onPressed: () {
            // delete all from trash
            context.read<FlashCardBloc>().add(DeleteAllTrashPermanentlyEvent());
            context
                .read<FlashCardBloc>()
                .add(GetFlashCardsEvent(isDeleted: true));
          },
        ),
    ];
  }

  AppBar getAppBar(List<FlashCardCollection> flashCardCollection) {
    return AppBar(
      title: Text(
        'Deleted flashcards: ${flashCardCollection.length}',
        style: FontConfigs.pageNameTextStyle,
      ),
    );
  }

  Widget? getDrawer() {
    if (FlashCardCollectionProvider.isMergeModeStarted) {
      return null;
    } else {
      return SideMenu(appBarHeight);
    }
  }

  @override
  Widget build(BuildContext context) {
    // creating bloc builder for flashcards
    bindPage(BlocBuilder<FlashCardBloc, FlashcardsState>(
      builder: (context, state) {
        var flashCardCollection = state.copyWith(fromTrash: true).flashCards;
        columnCount = ViewColumnCalculator.calculateColumnCount(context);
        var appBar = getAppBar(flashCardCollection);
        appBarHeight = appBar.preferredSize.height;
        var screenNow = Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: appBar,
            body: flashCardCollection.isEmpty
                ? Center(
                    child: Image.asset(
                    'assets/images/empty.png',
                    fit: BoxFit.fitHeight,
                    height: SizeConfig.getMediaHeight(context, p: 1),
                    width: SizeConfig.getMediaWidth(context, p: 0.6),
                  ))
                : AnimationLimiter(
                    child: GridView.count(
                        mainAxisSpacing:
                            SizeConfig.getMediaHeight(context, p: 0.04),
                        crossAxisSpacing:
                            ViewColumnCalculator.calculateCrossSpacing(context),
                        crossAxisCount: columnCount,
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                SizeConfig.getMediaWidth(context, p: 0.05)),
                        childAspectRatio: ViewConfig.getCardForm(context),
                        children:
                            List.generate(flashCardCollection.length, (index) {
                          /// ====================================================================[FlashCardCollectionWidget]
                          // add flashcards
                          return Transform.scale(
                            scale: 0.9,
                            child: AnimationConfiguration.staggeredGrid(
                              position: index,
                              duration: widget.cardAppearDuration,
                              columnCount: columnCount,
                              child: SlideAnimation(
                                child: FadeInAnimation(
                                    child: DeletedFlashCardCollectionWidget(
                                        flashCardCollection[index])),
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
                  children: bottomNavigationBarItems(flashCardCollection)),
            ));

        return ScreenIdentifier.returnScreen(
          context: context,
          portraitScreen: screenNow,
          landscapeScreen: screenNow,
          portraitSmallScreen: screenNow,
          landscapeSmallScreen: screenNow,
        );
      },
    ));

    /// ===============================================[Select design via context]===============================

    return super.build(context);
  }
}
