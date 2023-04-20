import 'package:flashcards_reader/bloc/flashcards_bloc/flashcards_bloc.dart';
import 'package:flashcards_reader/bloc/quiz_bloc/quiz_bloc.dart';
import 'package:flashcards_reader/bloc/merge_provider/flashcard_merge_provider.dart';
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
    return BlocProvider(
        create: (_) => QuizBloc(),
        child: BlocProvider(
          create: (_) => FlashCardBloc(),
          child: QuizView(),
        ));
  }
}

// ignore: must_be_immutable
class QuizView extends StatefulWidget {
  QuizView({super.key});
  Duration cardAppearDuration = const Duration(milliseconds: 375);
  // List<FlashCardCollection> flashCardCollection =
  //     FlashCardCollectionProvider.getFlashCards(isDeleted: true);

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  int columnCount = 2;
  double appBarHeight = 0;

  double getQuizForm(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.portrait ? 0.65 : 1;

  // List<Widget> bottomNavigationBarItems(
  //     List<FlashCardCollection> flashCardCollection) {
  //   return [
  //     if (flashCardCollection.isNotEmpty)
  //       IconButton(
  //         icon: const Icon(Icons.delete_forever),
  //         onPressed: () {
  //           // delete all from trash
  //           context.read<FlashCardBloc>().add(DeleteAllTrashPermanentlyEvent());
  //           context
  //               .read<FlashCardBloc>()
  //               .add(GetFlashCardsEvent(isDeleted: true));
  //         },
  //       ),
  //   ];
  // }

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
    context.read<QuizBloc>().add(InitQuizEvent(
        flashCardsCollection: context
            .read<FlashCardBloc>()
            .state
            .copyWith(fromTrash: false)
            .flashCards
            .first));
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
        debugPrintIt(context.read<QuizBloc>().state.currentCard?.correctAnswers);
        debugPrintIt(context.read<QuizBloc>().state.currentCard?.wrongAnswers);
        var appBar = getAppBar();
        appBarHeight = appBar.preferredSize.height;
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: appBar,
          drawer: getDrawer(),
          body: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
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
