import 'package:flashcards_reader/bloc/flash_training_bloc/flash_training_bloc.dart';
import 'package:flashcards_reader/bloc/flashcards_bloc/flashcards_bloc.dart';
import 'package:flashcards_reader/model/entities/flashcards/training_model.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/views/menu/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuizMenu extends StatefulWidget {
  const QuizMenu({super.key});

  @override
  State<QuizMenu> createState() => _QuizMenuState();
}

class _QuizMenuState extends State<QuizMenu> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<FlashTrainingBloc>(
          create: (BuildContext context) => FlashTrainingBloc()),
      BlocProvider<FlashCardBloc>(
          create: (BuildContext context) => FlashCardBloc())
    ], child: QuizView());
  }
}

// ignore: must_be_immutable
class QuizView extends StatefulWidget {
  QuizView({super.key});
  Duration cardAppearDuration = const Duration(milliseconds: 375);

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  double appBarHeight = 0;

  AppBar getAppBar() {
    return AppBar(
      title: const Text('Quiz'),
    );
  }

  Widget? getDrawer() {
    return MenuDrawer(appBarHeight);
  }

  @override
  void initState() {
    super.initState();
    var flashCardCollection =
        context.read<FlashCardBloc>().state.flashCards.first;
    debugPrintIt(flashCardCollection);

    context.read<FlashTrainingBloc>().add(InitTrainingModelEvent(
        trainingModel: TrainingModel(
            flashCardsCollection: flashCardCollection,
            numberOfFlashCards: flashCardCollection.flashCardSet.length)));

    context.read<FlashTrainingBloc>().add(GetToTrainEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlashCardBloc, FlashcardsState>(
        builder: (context, state) {
      var appBar = getAppBar();
      appBarHeight = appBar.preferredSize.height;
      return Scaffold(
        appBar: appBar,
        drawer: getDrawer(),
        body: Center(
          child: Column(
            children: [
              IconButton(
                  onPressed: () {
                    context.read<FlashTrainingBloc>().add(GetToTrainEvent());
                    debugPrintIt(context
                        .read<FlashTrainingBloc>()
                        .state
                        .nowTrainingFlash);
                    context
                        .read<FlashTrainingBloc>()
                        .add(TrainFlashCardEvent(isAnswerCorrect: true));
                    context.read<FlashCardBloc>().add(UpdateFlashCardEvent(
                        flashCardCollection: context
                            .read<FlashTrainingBloc>()
                            .state
                            .trainingModel!
                            .flashCardsCollection));
                  },
                  icon: const Icon(Icons.add)),
              BlocBuilder<FlashTrainingBloc, FlashTrainingState>(
                  builder: (context, state) {
                return Text(
                    state.nowTrainingFlash?.questionWords ?? 'no flash');
              }),
              BlocBuilder<FlashTrainingBloc, FlashTrainingState>(
                  builder: (context, state) {
                return Text(state.nowTrainingFlash?.answerWords ?? 'no flash');
              }),
            ],
          ),
        ),
      );
    });
  }
}
