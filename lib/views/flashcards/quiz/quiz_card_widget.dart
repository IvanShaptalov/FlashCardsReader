import 'dart:ui';

import 'package:flashcards_reader/bloc/quiz_bloc/quiz_bloc.dart';
import 'package:flashcards_reader/views/view_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class QuizFlashCard extends StatefulWidget {
  final BuildContext quizContext;
  bool blurred = true;
  bool empty;
  QuizFlashCard({this.empty = false, required this.quizContext, super.key});

  @override
  State<QuizFlashCard> createState() => _QuizFlashCardState();
}

class _QuizFlashCardState extends State<QuizFlashCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.amber.shade50,
        shape: ShapeBorder.lerp(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            0.5),
        child: SizedBox(
          height: SizeConfig.getMediaHeight(context, p: 0.7),
          width: SizeConfig.getMediaWidth(context, p: 0.8),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: widget.empty
                    ? const SizedBox.shrink()
                    : Text(
                        BlocProvider.of<QuizBloc>(widget.quizContext)
                                .state
                                .quizModel
                                .currentFCard
                                ?.questionWords ??
                            'Swipe right\nif you know',
                        style: FontConfigs.cardQuestionTextStyle,
                        textAlign: TextAlign.center,
                      ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    widget.blurred = !widget.blurred;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ImageFiltered(
                    imageFilter: widget.blurred
                        ? ImageFilter.blur(sigmaX: 5, sigmaY: 5)
                        : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                    child: widget.empty
                        ? const SizedBox.shrink()
                        : Text(
                            BlocProvider.of<QuizBloc>(widget.quizContext)
                                    .state
                                    .quizModel
                                    .currentFCard
                                    ?.answerWords ??
                                'Swipe left\nif you don\'t',
                            style: FontConfigs.cardAnswerTextStyle,
                            textAlign: TextAlign.center,
                          ),
                  ),
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
