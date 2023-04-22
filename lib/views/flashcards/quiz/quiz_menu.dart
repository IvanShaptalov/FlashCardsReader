import 'package:flashcards_reader/bloc/flashcards_bloc/flashcards_bloc.dart';
import 'package:flashcards_reader/bloc/quiz_bloc/quiz_bloc.dart';
import 'package:flashcards_reader/main.dart';
import 'package:flashcards_reader/util/enums.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/views/flashcards/quiz/quiz_flash_collection.dart';
import 'package:flashcards_reader/views/menu/drawer_menu.dart';
import 'package:flashcards_reader/views/view_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class QuizMenu extends StatefulWidget {
  const QuizMenu({super.key});

  @override
  State<QuizMenu> createState() => _QuizMenuState();
}

class _QuizMenuState extends State<QuizMenu> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => QuizBloc(),
        child: BlocProvider(
          create: (_) => FlashCardBloc(),
          child: QuizMenuView(),
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
          icon: const Icon(Icons.quiz),
          onPressed: () {},
        ),
      ];
    }
  }

  @override
  void initState() {
    context.read<QuizBloc>().add(InitQuizEvent(
        flashCardsCollection:
            context.read<FlashCardBloc>().state.flashCards.first ??
                flashFixture()));
    super.initState();
  }

  double getCardForm(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.portrait ? 0.65 : 1;

  @override
  Widget build(BuildContext context) {
    // creating bloc builder for flashcards
    return BlocBuilder<QuizBloc, QuizState>(
      builder: (context, state) {
        var flashCollectionList = context
            .read<FlashCardBloc>()
            .state
            .copyWith(fromTrash: false)
            .flashCards;

        debugPrintIt(
            '===================================UPDATE MENU UI===================================');
        debugPrintIt(context
            .read<QuizBloc>()
            .state
            .quizModel
            .currentFCard
            ?.questionWords);
        debugPrintIt(context
            .read<QuizBloc>()
            .state
            .quizModel
            .currentFCard
            ?.correctAnswers);
        debugPrintIt(context
            .read<QuizBloc>()
            .state
            .quizModel
            .currentFCard
            ?.wrongAnswers);
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
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      labelText: 'Find quiz',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                const Center(child: Text('Select quiz mode')),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SelectQuizMode(
                            mode: QuizMode.all,
                          ),
                          SelectQuizMode(mode: QuizMode.simple),
                          SelectQuizMode(mode: QuizMode.hard),
                          SelectQuizMode(mode: QuizMode.newest),
                          SelectQuizMode(mode: QuizMode.oldest),
                          SelectQuizMode(mode: QuizMode.random),
                        ],
                      )),
                ),
                Container(
                  height: SizeConfig.getMediaHeight(context, p: 0.6),
                  color: Colors.blueGrey,
                  child: flashCollectionList.isEmpty
                      ? const Center(child: Text('Bin is empty'))
                      : AnimationLimiter(
                          child: GridView.count(
                              mainAxisSpacing:
                                  SizeConfig.getMediaHeight(context, p: 0.04),
                              crossAxisSpacing: calculateCrossSpacing(context),
                              crossAxisCount: columnCount,
                              padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.getMediaWidth(context,
                                      p: 0.05)),
                              childAspectRatio: getCardForm(context),
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
                )
              ],
            ));
      },
    );
  }
}

class SelectQuizMode extends StatelessWidget {
  const SelectQuizMode({required this.mode, super.key});
  final QuizMode mode;

  @override
  Widget build(BuildContext context) {
    bool isSelected = context.watch<QuizBloc>().state.quizModel.mode == mode;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: isSelected ? Colors.teal : Colors.blueGrey,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
        ),
        onPressed: () {
          QuizModeProvider.mode = mode;
          context.read<QuizBloc>().add(ChangeQuizModeEvent(mode: mode));
        },
        child: Text(mode.name),
      ),
    );
  }
}

class QuizModeProvider {
  static QuizMode mode = QuizMode.all;
}
