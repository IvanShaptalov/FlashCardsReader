import 'package:flashcards_reader/bloc/quiz_bloc/quiz_bloc.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/util/enums.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/views/menu/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuizTrainer extends StatefulWidget {
  const QuizTrainer(
      {required this.numberOfFlashCards,
      required this.mode,
      required this.fCollection,
      super.key});
  final FlashCardCollection fCollection;
  final QuizMode mode;
  final int numberOfFlashCards;

  @override
  State<QuizTrainer> createState() => _QuizTrainerState();
}

class _QuizTrainerState extends State<QuizTrainer> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QuizBloc(),
      child: QuizTrainerView(
          numberOfFlashCards: widget.numberOfFlashCards,
          mode: widget.mode,
          fCollection: widget.fCollection),
    );
  }
}

class QuizTrainerView extends StatefulWidget {
  const QuizTrainerView(
      {required this.numberOfFlashCards,
      required this.mode,
      required this.fCollection,
      super.key});
  final FlashCardCollection fCollection;
  final QuizMode mode;
  final int numberOfFlashCards;

  final Duration cardAppearDuration = const Duration(milliseconds: 375);

  @override
  State<QuizTrainerView> createState() => _QuizTrainerViewState();
}

class _QuizTrainerViewState extends State<QuizTrainerView> {
  int columnCount = 2;
  double appBarHeight = 0;

  double getQuizForm(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.portrait ? 0.65 : 1;

  AppBar getAppBar() {
    return AppBar(
      title: const Text('Quiz Menu'),
    );
  }

  Widget getDrawer() {
    return MenuDrawer(appBarHeight);
  }

  @override
  void initState() {
    context.read<QuizBloc>().add(StartQuizEvent(
        flashCardsCollection: widget.fCollection,
        mode: widget.mode,
        numberOfQuestions: widget.numberOfFlashCards));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // creating bloc builder for flashcards
    return BlocBuilder<QuizBloc, QuizState>(
      builder: (context, state) {
        debugPrintIt(
            '===================================UPDATE UI===================================');
        debugPrintIt(context.read<QuizBloc>().state.currentCard?.questionWords);
        debugPrintIt(context.read<QuizBloc>().state.flashCardsCollection.title);
        debugPrintIt(
            context.read<QuizBloc>().state.currentCard?.correctAnswers);
        debugPrintIt(context.read<QuizBloc>().state.currentCard?.wrongAnswers);
        var appBar = getAppBar();
        appBarHeight = appBar.preferredSize.height;
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: appBar,
          body: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(context
                  .read<QuizBloc>()
                  .state
                  .quizModel
                  .flashCardsCollection
                  .title),
              Text(context.read<QuizBloc>().state.mode.name),
              const Text('Quiz Menu'),
              IconButton(
                  onPressed: () {
                    context.read<QuizBloc>().add(NextFlashEvent());
                  },
                  icon: const Icon(Icons.get_app)),
              Text(context.read<QuizBloc>().state.currentCard?.questionWords ??
                  'No question'),
              Text(context.read<QuizBloc>().state.currentCard?.answerWords ??
                  'No answer'),
              IconButton(
                  onPressed: () {
                    context
                        .read<QuizBloc>()
                        .add(AnswerFlashEvent(isAnswerCorrect: true));
                  },
                  icon: const Icon(Icons.question_answer)),
            ],
          )),
        );
      },
    );
  }
}
