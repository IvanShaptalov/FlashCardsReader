import 'package:flashcards_reader/bloc/flashcards_bloc/flashcards_bloc.dart';
import 'package:flashcards_reader/bloc/providers/word_collection_provider.dart';
import 'package:flashcards_reader/bloc/quiz_bloc/quiz_bloc.dart';
import 'package:flashcards_reader/quick_actions.dart';
import 'package:flashcards_reader/constants.dart';
import 'package:flashcards_reader/util/enums.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/views/flashcards/new_word/new_word_screen.dart';
import 'package:flashcards_reader/views/flashcards/quiz/flashcard_widget.dart';
import 'package:flashcards_reader/views/menu/side_menu.dart';
import 'package:flashcards_reader/views/parent_screen.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:quick_actions/quick_actions.dart';

class QuizMenu extends StatefulWidget {
  const QuizMenu({super.key});

  @override
  State<QuizMenu> createState() => _QuizMenuState();
}

class _QuizMenuState extends State<QuizMenu> {
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
        create: (_) => QuizBloc(),
        child: BlocProvider(
          create: (_) => FlashCardBloc(),
          child: ShortcutsProvider.wrapper(child: QuizMenuView()),
        ));
  }
}

// ignore: must_be_immutable
class QuizMenuView extends ParentStatefulWidget {
  QuizMenuView({super.key});
  Duration cardAppearDuration = const Duration(milliseconds: 375);

  @override
  ParentState<QuizMenuView> createState() => _QuizMenuViewState();
}

class _QuizMenuViewState extends ParentState<QuizMenuView> {
  int columnCount = 2;
  double appBarHeight = 0;

  double getQuizForm(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.portrait ? 0.65 : 1;

  AppBar getAppBar() {
    return AppBar(
      title: const Text(
        'Take a quiz',
        style: FontConfigs.pageNameTextStyle,
      ),
    );
  }

  Widget getDrawer() {
    return SideMenu(appBarHeight);
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

  // shortcut actions region ==================================================

  Widget loadMenu({required Widget child}) {
    if (widget.shortcut == addWordAction) {
      return AddWordFastScreen();
    } else if (widget.shortcut == quizAction) {
      return const QuizMenu();
    } else {
      return child;
    }
  }
  // end shortcut actions region ==============================================

  @override
  void initState() {
    var flashCardCollection =
        context.read<FlashCardBloc>().state.flashCards.isNotEmpty
            ? context.read<FlashCardBloc>().state.flashCards.first
            : flashExample();

    context
        .read<QuizBloc>()
        .add(InitQuizEvent(flashCardsCollection: flashCardCollection));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // creating bloc builder for flashcards
    widget.page = loadMenu(
      child: BlocBuilder<QuizBloc, QuizState>(
        builder: (context, state) {
          columnCount = ViewColumnCalculator.calculateColumnCount(context);

          var flashCollectionList = context
              .read<FlashCardBloc>()
              .state
              .copyWith(fromTrash: false)
              .flashCards;

          var appBar = getAppBar();
          appBarHeight = appBar.preferredSize.height;
          return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: appBar,
              drawer: getDrawer(),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (MyConfigOrientation.isPortrait(context))
                        const Center(
                            child: Padding(
                          padding:
                              EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0),
                          child: Text('Select quiz mode',
                              style: FontConfigs.h1TextStyle),
                        )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            scrollDirection: Axis.horizontal,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (MyConfigOrientation.isLandscape(
                                        context))
                                      const Text('Select quiz mode',
                                          style: FontConfigs.h1TextStyle),
                                    const SelectQuizMode(
                                      mode: QuizMode.all,
                                    ),
                                    const SelectQuizMode(
                                        mode: QuizMode.learned),
                                    const SelectQuizMode(mode: QuizMode.simple),
                                    const SelectQuizMode(mode: QuizMode.hard),
                                    const SelectQuizMode(mode: QuizMode.newest),
                                    const SelectQuizMode(mode: QuizMode.oldest),
                                    const SelectQuizMode(mode: QuizMode.random),
                                  ],
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.grey.shade300,
                      child: flashCollectionList.isEmpty
                          ? Center(
                              child: Center(
                                  child: Image.asset(
                              'assets/images/empty.png',
                              fit: BoxFit.fitHeight,
                              height:
                                  SizeConfig.getMediaHeight(context, p: 0.6),
                              width: SizeConfig.getMediaWidth(context, p: 0.6),
                            )))
                          : AnimationLimiter(
                              child: GridView.count(
                                  mainAxisSpacing: SizeConfig.getMediaHeight(
                                      context,
                                      p: 0.04),
                                  crossAxisSpacing:
                                      calculateCrossSpacing(context),
                                  crossAxisCount: columnCount,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: SizeConfig.getMediaWidth(
                                          context,
                                          p: 0.02)),
                                  childAspectRatio:
                                      ViewConfig.getCardForm(context),
                                  children: List.generate(
                                      flashCollectionList.length, (index) {
                                    /// ====================================================================[FlashCardCollectionWidget]
                                    // add flashcards
                                    return Transform.scale(
                                      scale: 0.95,
                                      child:
                                          AnimationConfiguration.staggeredGrid(
                                        position: index,
                                        duration: widget.cardAppearDuration,
                                        columnCount: columnCount,
                                        child: SlideAnimation(
                                          child: FadeInAnimation(
                                              child: QuizFlashCollectionWidget(
                                                  flashCollectionList[index])),
                                        ),
                                      ),
                                    );
                                  })),
                            ),
                    ),
                  )
                ],
              ));
        },
      ),
    );
    return super.build(context);
  }
}

class SelectQuizMode extends StatelessWidget {
  const SelectQuizMode({this.explisit = false, required this.mode, super.key});
  final QuizMode mode;
  final bool explisit;

  @override
  Widget build(BuildContext context) {
    // wtf, i dont know why it update only when i use this variable
    bool isSelected = context.watch<QuizBloc>().state.quizModel.mode == mode;
    isSelected = QuizModeProvider.mode == mode;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: ConfigQuizView.foregroundModeColor,
          backgroundColor: isSelected || explisit
              ? ConfigQuizView.selectedModeColor
              : ConfigQuizView.unselectedModeColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
        ),
        onPressed: () {
          QuizModeProvider.mode = mode;
          debugPrintIt(
              'mode changed to ${mode.name}=========================================');
          context.read<QuizBloc>().add(ChangeQuizModeEvent(mode: mode));
        },
        child: explisit
            ? Text('Selected mode: ${mode.name} cards')
            : Text(mode.name),
      ),
    );
  }
}

class QuizModeProvider {
  static QuizMode mode = QuizMode.all;
}
