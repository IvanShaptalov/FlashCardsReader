import 'dart:ui';

import 'package:flashcards_reader/bloc/quiz_bloc/quiz_bloc.dart';
import 'package:flashcards_reader/views/flashcards/tts_widget.dart';
import 'package:flashcards_reader/views/flashcards/quiz/util_provider.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class QuizFlashCard extends StatefulWidget {
  final BuildContext quizContext;
  bool empty;
  QuizFlashCard({this.empty = false, required this.quizContext, super.key});
  String swipeRight = 'Swipe right\nif you know';
  String swipeLeft = 'Swipe left\nif you don\'t';
  @override
  State<QuizFlashCard> createState() => _QuizFlashCardState();
}

class _QuizFlashCardState extends State<QuizFlashCard> {
  @override
  Widget build(BuildContext context) {
    // if landscape mode

    var currentFcard = BlocProvider.of<QuizBloc>(widget.quizContext)
        .state
        .quizModel
        .currentFCard;
    var firstText = SwapWordsProvider.swap
        ? currentFcard?.answer ?? widget.swipeRight
        : currentFcard?.question ?? widget.swipeLeft;
    var firstLanguage = SwapWordsProvider.swap
        ? currentFcard?.answerLanguage ?? 'en'
        : currentFcard?.questionLanguage ?? 'en';
    var first = Container(
      height: SizeConfig.getMediaHeight(context, p: 0.3),
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: widget.empty
            ? const SizedBox.shrink()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      firstText,
                      style: FontConfigs.cardQuestionTextStyle,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: SizeConfig.getMediaHeight(context, p: 0.05),
                    ),
                    Transform.scale(
                      scale: 1.2,
                      child: IconButton(
                          onPressed: () {
                            TextToSpeechWrapper.onPressed(
                                firstText, firstLanguage);
                          },
                          icon: const Icon(Icons.volume_up_outlined)),
                    ),
                  ],
                ),
              ),
      ),
    );
    var secondText = SwapWordsProvider.swap
        ? currentFcard?.question ?? widget.swipeLeft
        : currentFcard?.answer ?? widget.swipeRight;

    var secondLanguage = SwapWordsProvider.swap
        ? currentFcard?.questionLanguage ?? 'en'
        : currentFcard?.answerLanguage ?? 'en';

    var second = GestureDetector(
      onTap: () {
        setState(() {
          BlurProvider.blurred = !BlurProvider.blurred;
        });
      },
      child: Container(
        color: Colors.transparent,
        height: SizeConfig.getMediaHeight(context, p: 0.3),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.empty
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Transform.scale(
                          scale: 1.2,
                          child: IconButton(
                              onPressed: () {
                                TextToSpeechWrapper.onPressed(
                                    secondText, secondLanguage);
                              },
                              icon: const Icon(Icons.volume_up_outlined)),
                        ),
                        SizedBox(
                          height: SizeConfig.getMediaHeight(context, p: 0.05),
                        ),
                        ImageFiltered(
                          imageFilter: BlurProvider.blurred
                              ? ImageFilter.blur(
                                  sigmaX: 5,
                                  sigmaY: 5,
                                  tileMode: TileMode.decal)
                              : ImageFilter.blur(
                                  sigmaX: 0,
                                  sigmaY: 0,
                                  tileMode: TileMode.decal),
                          child: Text(
                            secondText,
                            style: FontConfigs.cardQuestionTextStyle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: ConfigQuizView.cardQuizColor,
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
              first,
              Transform.scale(
                scale: 1,
                child: IconButton(
                    onPressed: () {
                      SwapWordsProvider.swapIt();
                      setState(() {});
                    },
                    icon: Icon(
                      Icons.swap_vert_rounded,
                      color: ConfigFlashcardView.quizIconColor,
                    )),
              ),
              second
            ],
          )),
        ),
      ),
    );
  }
}
