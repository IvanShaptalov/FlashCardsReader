import 'package:flashcards_reader/bloc/quiz_bloc/quiz_bloc.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/util/enums.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/util/router.dart';
import 'package:flashcards_reader/views/flashcards/quiz/horizontal_quiz_view.dart';
import 'package:flashcards_reader/views/flashcards/quiz/vertical_quiz_view.dart';
import 'package:flashcards_reader/views/guide_wrapper.dart';
import 'package:flashcards_reader/views/help_page/help_page.dart';
import 'package:flashcards_reader/views/menu/side_menu.dart';
import 'package:flashcards_reader/views/parent_screen.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class QuizTrainer extends ParentStatefulWidget {
  bool isTutorial;
  final FlashCardCollection fCollection;
  final QuizMode mode;
  final int numberOfFlashCards;
  final String fromPage;

  QuizTrainer(
      {required this.numberOfFlashCards,
      required this.mode,
      required this.fCollection,
      required this.fromPage,
      super.key,
      this.isTutorial = false});

  @override
  ParentState<QuizTrainer> createState() => _QuizTrainerState();
}

class _QuizTrainerState extends ParentState<QuizTrainer> {
  @override
  Widget build(BuildContext context) {
    bindPage(BlocProvider(
      create: (_) => QuizBloc(),
      child: QuizTrainerView(
          numberOfFlashCards: widget.numberOfFlashCards,
          mode: widget.mode,
          fCollection: widget.fCollection,
          fromPage: widget.fromPage,
          isTutorial: widget.isTutorial),
    ));

    return super.build(context);
  }
}

class QuizTrainerView extends StatefulWidget {
  final bool isTutorial;
  final FlashCardCollection fCollection;
  final QuizMode mode;
  final int numberOfFlashCards;
  final String fromPage;

  const QuizTrainerView(
      {required this.numberOfFlashCards,
      required this.mode,
      required this.fCollection,
      required this.fromPage,
      super.key,
      required this.isTutorial});

  @override
  State<QuizTrainerView> createState() => _QuizTrainerViewState();
}

class _QuizTrainerViewState extends State<QuizTrainerView> {
  int columnCount = 2;
  double appBarHeight = 0;

  double getQuizForm(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.portrait ? 0.65 : 1;

  Widget getDrawer() {
    return SideMenu(appBarHeight);
  }

  @override
  void initState() {
    debugPrintIt('init mode : ${widget.mode}');
    context.read<QuizBloc>().add(StartQuizEvent(
        flashCardCollection: widget.fCollection,
        mode: widget.mode,
        numberOfQuestions: widget.numberOfFlashCards));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // creating bloc builder for flashcards
    return BlocBuilder<QuizBloc, QuizState>(
      builder: (context, state) {
        return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    if (widget.isTutorial) {
                      GuideProvider.pushToLastStep();
                      MyRouter.pushPage(context, HelpPage());
                      return;
                    }
                    ViewConfig.pushFromQuizProcess(
                        fromPage: widget.fromPage, context: context);
                  },
                  icon: const Icon(Icons.arrow_back)),
              title: Text(
                context
                    .read<QuizBloc>()
                    .state
                    .quizModel
                    .flashCardsCollection
                    .title,
                style: FontConfigs.pageNameTextStyle,
              ),
            ),
            body: ScreenIdentifier.isPortraitRelative(context)
                ? VerticalQuiz(
                    fromPage: widget.fromPage, isTutorial: widget.isTutorial)
                : HorizontalQuiz(
                    fromPage: widget.fromPage, isTutorial: widget.isTutorial));
      },
    );
  }
}
