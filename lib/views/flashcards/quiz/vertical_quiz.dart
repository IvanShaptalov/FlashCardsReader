import 'package:flashcards_reader/bloc/quiz_bloc/quiz_bloc.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/views/flashcards/quiz/quiz_flash_card.dart';
import 'package:flashcards_reader/views/view_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerticalQuiz extends StatefulWidget {
  const VerticalQuiz({super.key});

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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DragTarget<bool>(onAccept: (data) {
              debugPrintIt('answer is wrong');
              BlocProvider.of<QuizBloc>(context)
                  .add(AnswerFlashEvent(isAnswerCorrect: false));
            },builder: (
              BuildContext context,
              List<dynamic> accepted,
              List<dynamic> rejected,
            ) {
              return const WrongAnswerArea();
            }),
            Draggable<bool>(
              // Data is the value this Draggable stores.
              data: true,
              feedback: QuizFlashCard(
                quizContext: context,
              ),
              child: QuizFlashCard(
                quizContext: context,
              ),
            ),
            DragTarget<bool>(
              onAccept: (data) {
              debugPrintIt('answer is correct');
              BlocProvider.of<QuizBloc>(context)
                  .add(AnswerFlashEvent(isAnswerCorrect: true));
            }, builder: (
              BuildContext context,
              List<dynamic> accepted,
              List<dynamic> rejected,
            ) {
              return const CorrectAnswerArea();
            })
          ],
        )
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
