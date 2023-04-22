import 'package:flashcards_reader/bloc/quiz_bloc/quiz_bloc.dart';
import 'package:flashcards_reader/views/view_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuizFlashCard extends StatefulWidget {
  const QuizFlashCard({super.key});

  @override
  State<QuizFlashCard> createState() => _QuizFlashCardState();
}

class _QuizFlashCardState extends State<QuizFlashCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueGrey,
      shape: ShapeBorder.lerp(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          0.5),
      child: SizedBox(
        height: SizeConfig.getMediaHeight(context, p: 0.8),
        width: SizeConfig.getMediaWidth(context, p: 0.8),
        child: Center(
                child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(context
                    .read<QuizBloc>()
                    .state
                    .quizModel
                    .currentFCard
                    ?.questionWords ??
                'Swipe to left if you don\'t know the answer'),
            Text(context
                    .read<QuizBloc>()
                    .state
                    .quizModel
                    .currentFCard
                    ?.answerWords ??
                'Swipe to right if you know the answer'),
          ],
        )),
      ),
    );
  }
}
