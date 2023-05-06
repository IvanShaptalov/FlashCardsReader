import 'package:flashcards_reader/bloc/quiz_bloc/quiz_bloc.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/views/flashcards/quiz/quiz_card_widget.dart';
import 'package:flashcards_reader/views/flashcards/quiz/quiz_menu.dart';
import 'package:flashcards_reader/views/flashcards/quiz/util_provider.dart';
import 'package:flashcards_reader/views/view_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SummaryFlashCardsProvider {
  static Set<FlashCardMock> flashSetMock = {};

  static void clear() {
    flashSetMock.clear();
  }

  static int correctPercentage() {
    if (flashSetMock.isEmpty) return 0;
    return (flashSetMock.where((element) => element.isCorrect).length /
            flashSetMock.length *
            100)
        .round();
  }

  static int correctAnswers() {
    return flashSetMock.where((element) => element.isCorrect).length;
  }

  static int wrongAnswers() {
    return flashSetMock.where((element) => !element.isCorrect).length;
  }

  static int totalAnswers() {
    return flashSetMock.length;
  }
}

class FlashCardMock {
  String question;
  String answer;
  bool isCorrect;
  FlashCardMock(
      {required this.question, required this.answer, required this.isCorrect});

  @override
  String toString() {
    return 'FlashCardMock{question: $question, answer: $answer, isCorrect: $isCorrect}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlashCardMock &&
          runtimeType == other.runtimeType &&
          question == other.question &&
          answer == other.answer &&
          isCorrect == other.isCorrect;

  @override
  int get hashCode => question.hashCode ^ answer.hashCode ^ isCorrect.hashCode;
}

// ignore: must_be_immutable
class VerticalQuiz extends StatefulWidget {
  VerticalQuiz({required this.fromPage, super.key});
  String fromPage;
  @override
  State<VerticalQuiz> createState() => _VerticalQuizState();
}

class _VerticalQuizState extends State<VerticalQuiz> {
  List<Widget> loadListItems() {
    List<Widget> list = [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Total: ${SummaryFlashCardsProvider.totalAnswers()}',
          style: ConfigQuizView.quizSummaryTextStyle,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Correct: ${SummaryFlashCardsProvider.correctAnswers()}',
          style: ConfigQuizView.quizSummaryTextStyle,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Wrong: ${SummaryFlashCardsProvider.wrongAnswers()}',
          style: ConfigQuizView.quizSummaryTextStyle,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Percentage: ${SummaryFlashCardsProvider.correctPercentage()}%',
          style: ConfigQuizView.quizSummaryTextStyle,
        ),
      ),
      const Divider(
        color: Colors.black,
      ),
    ];

    for (var flash in SummaryFlashCardsProvider.flashSetMock.toList()) {
      list.add(Padding(
        padding: EdgeInsets.all(SizeConfig.getMediaHeight(context, p: 0.02)),
        child: Container(
            height: SizeConfig.getMediaHeight(context, p: 0.1),
            width: SizeConfig.getMediaWidth(context, p: 0.7),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: flash.isCorrect
                    ? ConfigQuizView.correctAreaColor
                    : ConfigQuizView.wrongAreaColor),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Center(
                    child: Text(
                      flash.question,
                      style: ConfigQuizView.quizWordSummaryTextStyleBlack,
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.getMediaHeight(context, p: 0.01),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Center(
                    child: Text(
                      flash.answer,
                      style: ConfigQuizView.quizWordSummaryTextStyleBlack,
                    ),
                  ),
                ),
              ],
            )),
      ));
    }
    return list;
  }

  Widget loadEndQuiz() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            color: ConfigQuizView.quizResultBackgroundColor,
            height: SizeConfig.getMediaHeight(context, p: 0.7),
            child: ListView(
              children: loadListItems(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
            child: GestureDetector(
              child: Container(
                width: SizeConfig.getMediaWidth(context, p: 0.5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: ConfigQuizView.backFromQuizButtonBackgroundColor),
                child: Transform.scale(
                  scale: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(Icons.arrow_downward_rounded,
                            color: ConfigQuizView.backFromQuizIconColor),
                        Text(
                          'Quiz Finished',
                          style: ConfigQuizView.backFromQuizTextStyle,
                        ),
                        Icon(Icons.arrow_downward_rounded,
                            color: ConfigQuizView.backFromQuizIconColor)
                      ],
                    ),
                  ),
                ),
              ),
              onTap: () {
                ViewConfig.pushFromQuizProcess(
                    fromPage: widget.fromPage, context: context);
              },
            ),
          )
        ],
      ),
    );
  }

  void addWordToResult(bool answer) {
    FlashCard? flash =
        BlocProvider.of<QuizBloc>(context).state.quizModel.currentFCard;
    if (flash != null) {
      FlashCardMock mock = FlashCardMock(
          question: flash.question, answer: flash.answer, isCorrect: answer);
      SummaryFlashCardsProvider.flashSetMock.add(mock);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Transform.scale(
          scale: 1.2,
          child: SelectQuizMode(
            mode: BlocProvider.of<QuizBloc>(context).state.quizModel.mode,
            explisit: true,
          ),
        ),
        BlocProvider.of<QuizBloc>(context).state.quizModel.isQuizFinished
            ? loadEndQuiz()
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const WrongAnswerArea(),
                  Draggable<bool>(
                    // Data is the value this Draggable stores.
                    axis: Axis.horizontal, data: true,
                    feedback: QuizFlashCard(
                      quizContext: context,
                    ),
                    childWhenDragging: QuizFlashCard(
                      quizContext: context,
                      empty: true,
                    ),
                    onDragStarted: () {
                      debugPrintIt('started');
                    },
                    affinity: Axis.horizontal,
                    onDragUpdate: (details) {
                      debugPrintIt('update');
                    },

                    onDraggableCanceled: (velocity, offset) {
                      debugPrintIt(offset.dx);
                      debugPrintIt(BlocProvider.of<QuizBloc>(context)
                          .state
                          .quizModel
                          .isQuizFinished);

                      if (offset.dx <
                          SizeConfig.getMediaWidth(context,
                              p: -0.1) /* 25 percent of screen to left*/) {
                        BlocProvider.of<QuizBloc>(context)
                            .add(AnswerFlashEvent(isAnswerCorrect: false));
                        BlurProvider.blurred = true;
                        addWordToResult(false);
                      } else if (offset.dx >
                          SizeConfig.getMediaWidth(context, p: 0.1) +
                              35 /* 25 percent of screen to right*/) {
                        BlocProvider.of<QuizBloc>(context)
                            .add(AnswerFlashEvent(isAnswerCorrect: true));
                        BlurProvider.blurred = true;
                        addWordToResult(true);
                      } else {}
                    },
                    child: QuizFlashCard(
                      quizContext: context,
                    ),
                  ),
                  const CorrectAnswerArea(),
                ],
              ),
      ],
    ));
  }
}

class CorrectAnswerArea extends StatelessWidget {
  const CorrectAnswerArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.getMediaWidth(context, p: 0.05),
      height: SizeConfig.getMediaHeight(context, p: 0.6),
      decoration: BoxDecoration(
          color: ConfigQuizView.correctAreaColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          )),
    );
  }
}

class WrongAnswerArea extends StatelessWidget {
  const WrongAnswerArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.getMediaWidth(context, p: 0.05),
      height: SizeConfig.getMediaHeight(context, p: 0.6),
      decoration: BoxDecoration(
          color: ConfigQuizView.wrongAreaColor,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10),
          )),
    );
  }
}
