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
    // return multiple bloc providers
    return MultiBlocProvider(
      providers: [
        BlocProvider<FlashTrainingBloc>(
            create: (BuildContext context) => FlashTrainingBloc()),
        BlocProvider<FlashCardBloc>(
            create: (BuildContext context) => FlashCardBloc())
      ],
      child: const QuizView(),
    );
  }
}

class QuizView extends StatefulWidget {
  const QuizView({super.key});

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
  }

  @override
  Widget build(BuildContext specialContext) {
    return BlocBuilder<FlashTrainingBloc, FlashTrainingState>(
        builder: (context, state) {
      // create app bar
      var appBar = getAppBar();
      appBarHeight = appBar.preferredSize.height;

      // load model
      var result =
          BlocProvider.of<FlashTrainingBloc>(context).state.trainingModel;

      debugPrintIt(result);
      debugPrintIt('====================================== updated');
      debugPrintIt('now training flash: ${state.nowTrainingFlash}');
      debugPrintIt('====================================== updated');
      
      return Scaffold(
        appBar: appBar,
        drawer: getDrawer(),
        body: Center(
          child: Column(
            children: [
              IconButton(
                  onPressed: () {
                    BlocProvider.of<FlashTrainingBloc>(context)
                        .add(GetToTrainEvent());
                    // context.read<FlashTrainingBloc>().add(GetToTrainEvent());
                    debugPrintIt(state.nowTrainingFlash);
                    // context
                    //     .read<FlashTrainingBloc>()
                    //     .add(TrainFlashCardEvent(isAnswerCorrect: true));
                    BlocProvider.of<FlashTrainingBloc>(context)
                        .add(TrainFlashCardEvent(isAnswerCorrect: true));
                    setState(() {});
                  },
                  icon: const Icon(Icons.add)),
              BlocBuilder<FlashTrainingBloc, FlashTrainingState>(
                  builder: (context, state) {
                return Text(
                    state.nowTrainingFlash?.questionWords ?? 'no flash');
              }),
              Text(state.nowTrainingFlash?.answerWords ?? 'no flash'),
            ],
          ),
        ),
      );
    });
    // });
  }
}
