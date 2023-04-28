import 'package:flashcards_reader/bloc/quiz_bloc/quiz_bloc.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/util/router.dart';
import 'package:flashcards_reader/views/flashcards/quiz/quiz_card_widget.dart';
import 'package:flashcards_reader/views/flashcards/quiz/quiz_menu.dart';
import 'package:flashcards_reader/views/view_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class VerticalQuiz extends StatefulWidget {
  VerticalQuiz({super.key});
  bool blurred = true;
  @override
  State<VerticalQuiz> createState() => _VerticalQuizState();
}

class _VerticalQuizState extends State<VerticalQuiz> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BlocProvider.of<QuizBloc>(context).state.quizModel.isQuizFinished
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Quiz Finished',
                      style: TextStyle(fontSize: 24),
                    ),
                    IconButton(
                        onPressed: () {
                          MyRouter.pushPageReplacement(
                              context, const QuizMenu());
                        },
                        icon: const Icon(Icons.arrow_downward)),
                  ],
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const WrongAnswerArea(),
                  Draggable<bool>(
                    // Data is the value this Draggable stores.
                    axis: Axis.horizontal, data: true,
                    feedback: QuizFlashCard(
                      quizContext: context,
                      blurred: widget.blurred,
                    ),
                    child: QuizFlashCard(
                      quizContext: context,
                      blurred: widget.blurred,
                    ),
                    onDragStarted: () {
                      debugPrintIt('started');
                    },
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
                              p: -0.25) /* 25 percent of screen to left*/) {
                        BlocProvider.of<QuizBloc>(context)
                            .add(AnswerFlashEvent(isAnswerCorrect: false));
                      } else if (offset.dx >
                          SizeConfig.getMediaWidth(context, p: 0.25) +
                              35 /* 25 percent of screen to right*/) {
                        BlocProvider.of<QuizBloc>(context)
                            .add(AnswerFlashEvent(isAnswerCorrect: true));
                      } else {
                        setState(() {
                          widget.blurred = false;
                        });
                      }
                    },
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
      decoration: const BoxDecoration(
          color: Colors.greenAccent,
          borderRadius: BorderRadius.only(
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
      decoration: const BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10),
          )),
    );
  }
}