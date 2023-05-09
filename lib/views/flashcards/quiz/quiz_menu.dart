import 'package:flashcards_reader/bloc/flashcards_bloc/flashcards_bloc.dart';
import 'package:flashcards_reader/bloc/quiz_bloc/quiz_bloc.dart';
import 'package:flashcards_reader/main.dart';
import 'package:flashcards_reader/quick_actions.dart';
import 'package:flashcards_reader/util/constants.dart';
import 'package:flashcards_reader/util/enums.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/util/router.dart';
import 'package:flashcards_reader/views/flashcards/flashcards/flashcards_screen.dart';
import 'package:flashcards_reader/views/flashcards/quiz/quiz_fc_collection_widget.dart';
import 'package:flashcards_reader/views/menu/drawer_menu.dart';
import 'package:flashcards_reader/views/view_config.dart';
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
class QuizMenuView extends StatefulWidget {
  QuizMenuView({super.key});
  Duration cardAppearDuration = const Duration(milliseconds: 375);

  @override
  State<QuizMenuView> createState() => _QuizMenuViewState();
}

class _QuizMenuViewState extends State<QuizMenuView> {
  int columnCount = 2;
  double appBarHeight = 0;

  double getQuizForm(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.portrait ? 0.65 : 1;

  AppBar getAppBar() {
    return AppBar(
      title: const Text('Take a quiz'),
    );
  }

  Widget getDrawer() {
    return MenuDrawer(appBarHeight);
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
    {
      // dont show merge button or deactivate merge mode
      return [
        IconButton(
          icon: const Icon(Icons.book),
          onPressed: () {},
        ),

        /// show merge button if merge mode is available
        IconButton(
          icon: const Icon(Icons.web_stories_outlined),
          onPressed: () {
            MyRouter.pushPageReplacement(context, const FlashCardScreen());
          },
        ),
      ];
    }
  }

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

  @override
  Widget build(BuildContext context) {
    // creating bloc builder for flashcards
    return BlocBuilder<QuizBloc, QuizState>(
      builder: (context, state) {
        columnCount = calculateColumnCount(context);

        var flashCollectionList = context
            .read<FlashCardBloc>()
            .state
            .copyWith(fromTrash: false)
            .flashCards;

        var appBar = getAppBar();
        appBarHeight = appBar.preferredSize.height;
        return Scaffold(
            bottomNavigationBar: BottomAppBar(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                  /// icon buttons, analog of bottom navigation bar with flashcards, merge if merge mode is on and quiz
                  children: bottomNavigationBarItems()),
            ),
            resizeToAvoidBottomInset: false,
            appBar: appBar,
            drawer: getDrawer(),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Center(
                        child: Padding(
                      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
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
                                children: const [
                                  SelectQuizMode(
                                    mode: QuizMode.all,
                                  ),
                                  SelectQuizMode(mode: QuizMode.learned),
                                  SelectQuizMode(mode: QuizMode.simple),
                                  SelectQuizMode(mode: QuizMode.hard),
                                  SelectQuizMode(mode: QuizMode.newest),
                                  SelectQuizMode(mode: QuizMode.oldest),
                                  SelectQuizMode(mode: QuizMode.random),
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
                        ? const Center(child: Text('Bin is empty'))
                        : AnimationLimiter(
                            child: GridView.count(
                                mainAxisSpacing:
                                    SizeConfig.getMediaHeight(context, p: 0.04),
                                crossAxisSpacing:
                                    calculateCrossSpacing(context),
                                crossAxisCount: columnCount,
                                padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.getMediaWidth(
                                        context,
                                        p: 0.05)),
                                childAspectRatio:
                                    ViewConfig.getCardForm(context),
                                children: List.generate(
                                    flashCollectionList.length, (index) {
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
    );
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
