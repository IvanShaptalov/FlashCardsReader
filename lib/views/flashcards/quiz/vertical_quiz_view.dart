import 'package:flashcards_reader/bloc/quiz_bloc/quiz_bloc.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/views/flashcards/quiz/quiz_card_widget.dart';
import 'package:flashcards_reader/views/flashcards/quiz/quiz_menu.dart';
import 'package:flashcards_reader/views/flashcards/quiz/quiz_summary.dart';
import 'package:flashcards_reader/views/flashcards/quiz/util_provider.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class VerticalQuiz extends StatefulWidget {
  bool isTutorial;

  VerticalQuiz({required this.fromPage, super.key, required this.isTutorial});
  String fromPage;

  @override
  State<VerticalQuiz> createState() => _VerticalQuizState();
}

class _VerticalQuizState extends State<VerticalQuiz> {
  @override
  Widget build(BuildContext context) {
    var dragCard = QuizFlashCard(
      quizContext: context,
    );
    return Container(
      color: Palette.grey300,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (!BlocProvider.of<QuizBloc>(context)
              .state
              .quizModel
              .isQuizFinished)
            Transform.scale(
              scale: 1.2,
              child: SelectQuizMode(
                mode: BlocProvider.of<QuizBloc>(context).state.quizModel.mode,
                explisit: true,
              ),
            ),
          BlocProvider.of<QuizBloc>(context).state.quizModel.isQuizFinished
              ? loadEndQuiz(context, widget.fromPage, widget.isTutorial)
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const WrongAnswerArea(),
                    Draggable<bool>(
                        // Data is the value this Draggable stores.
                        axis: Axis.horizontal,
                        data: true,
                        feedback: dragCard,
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
                            addWordToResult(false, context);
                          } else if (offset.dx >
                              SizeConfig.getMediaWidth(context, p: 0.1) +
                                  35 /* 25 percent of screen to right*/) {
                            BlocProvider.of<QuizBloc>(context)
                                .add(AnswerFlashEvent(isAnswerCorrect: true));
                            BlurProvider.blurred = true;
                            addWordToResult(true, context);
                          } else {}
                        },
                        child: dragCard),
                    const CorrectAnswerArea(),
                  ],
                ),
          SizedBox(
            height: SizeConfig.getMediaHeight(context, p: 0.01),
          ),
        ],
      )),
    );
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
          color: Palette.green300Primary,
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
          color: Palette.red300,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10),
          )),
    );
  }
}
