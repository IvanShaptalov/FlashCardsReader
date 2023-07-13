import 'package:flashcards_reader/bloc/quiz_bloc/quiz_bloc.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/views/flashcards/quiz/horizontal_quiz_card_widget.dart';
import 'package:flashcards_reader/views/flashcards/quiz/quiz_summary.dart';
import 'package:flashcards_reader/views/flashcards/quiz/util_provider.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class HorizontalQuiz extends StatefulWidget {
  HorizontalQuiz({required this.fromPage, super.key});
  String fromPage;
  @override
  State<HorizontalQuiz> createState() => _HorizontalQuizState();
}

class _HorizontalQuizState extends State<HorizontalQuiz> {
  @override
  Widget build(BuildContext context) {
    var dragCard = HorizontalQuizFlashCard(
      quizContext: context,
    );
    return Container(
      color: Palette.grey300,
      child: Card(
        child: Center(
          child: BlocProvider.of<QuizBloc>(context).state.quizModel.isQuizFinished
              ? loadEndQuiz(context, widget.fromPage)
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CorrectAnswerArea(),
                    Draggable<bool>(
                        // Data is the value this Draggable stores.
                        axis: Axis.vertical,
                        data: true,
                        feedback: dragCard,
                        childWhenDragging: HorizontalQuizFlashCard(
                          quizContext: context,
                          empty: true,
                        ),
                        onDragStarted: () {
                          debugPrintIt('started');
                        },
                        affinity: Axis.vertical,
                        onDragUpdate: (details) {
                          debugPrintIt('update');
                        },
                        onDraggableCanceled: (velocity, offset) {
                          debugPrintIt(offset.dx);
                          debugPrintIt(BlocProvider.of<QuizBloc>(context)
                              .state
                              .quizModel
                              .isQuizFinished);
      
                          if (offset.dy <
                              SizeConfig.getMediaHeight(context,
                                  p: -0.1) /* 25 percent of screen to left*/) {
                            BlocProvider.of<QuizBloc>(context)
                                .add(AnswerFlashEvent(isAnswerCorrect: false));
                            BlurProvider.blurred = true;
                            addWordToResult(false, context);
                          } else if (offset.dy >
                              SizeConfig.getMediaHeight(context, p: 0.1) +
                                  35 /* 25 percent of screen to right*/) {
                            BlocProvider.of<QuizBloc>(context)
                                .add(AnswerFlashEvent(isAnswerCorrect: true));
                            BlurProvider.blurred = true;
                            addWordToResult(true, context);
                          }
                        },
                        child: dragCard),
                    const WrongAnswerArea(),
                  ],
                ),
        ),
      ),
    );
  }
}

class CorrectAnswerArea extends StatelessWidget {
  const CorrectAnswerArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.getMediaWidth(context, p: 0.6),
      height: SizeConfig.getMediaHeight(context, p: 0.03),
      decoration: BoxDecoration(
          color: Palette.green300Primary,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          )),
    );
  }
}

class WrongAnswerArea extends StatelessWidget {
  const WrongAnswerArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.getMediaWidth(context, p: 0.6),
      height: SizeConfig.getMediaHeight(context, p: 0.03),
      decoration: BoxDecoration(
          color: Palette.red300,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          )),
    );
  }
}
