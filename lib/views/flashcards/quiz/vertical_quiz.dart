import 'package:flashcards_reader/bloc/quiz_bloc/quiz_bloc.dart';
import 'package:flashcards_reader/views/flashcards/quiz/quiz_flash_card.dart';
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [QuizFlashCard()],
        )
      ],
    ));
  }
}
