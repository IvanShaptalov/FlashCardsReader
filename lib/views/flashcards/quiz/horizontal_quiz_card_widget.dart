import 'dart:ui';

import 'package:flashcards_reader/bloc/quiz_bloc/quiz_bloc.dart';
import 'package:flashcards_reader/views/flashcards/quiz/util_provider.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class HorizontalQuizFlashCard extends StatefulWidget {
  final BuildContext quizContext;
  bool empty;
  HorizontalQuizFlashCard(
      {this.empty = false, required this.quizContext, super.key});
  String swipeRight = 'Swipe righn if you know';
  String swipeLeft = 'Swipe left if you don\'t';
  @override
  State<HorizontalQuizFlashCard> createState() =>
      _HorizontalQuizFlashCardState();
}

class _HorizontalQuizFlashCardState extends State<HorizontalQuizFlashCard> {
  @override
  Widget build(BuildContext context) {
    // if landscape mode
    if (ScreenIdentifier.isLandscapeRelative(context)) {
      widget.swipeRight = 'Swipe up if you know';
      widget.swipeLeft = 'Swipe down if you don\'t';
    }

    var currentFcard = BlocProvider.of<QuizBloc>(widget.quizContext)
        .state
        .quizModel
        .currentFCard;
    var firstText = SwapWordsProvider.swap
        ? currentFcard?.answer ?? widget.swipeRight
        : currentFcard?.question ?? widget.swipeLeft;

    var first = Container(
      height: SizeConfig.getMediaHeight(context, p: 0.2),
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
                  ],
                ),
              ),
      ),
    );
    var secondText = SwapWordsProvider.swap
        ? currentFcard?.question ?? widget.swipeLeft
        : currentFcard?.answer ?? widget.swipeRight;

    var second = GestureDetector(
      onTap: () {
        setState(() {
          BlurProvider.blurred = !BlurProvider.blurred;
        });
      },
      child: Container(
        color: Colors.transparent,
        height: SizeConfig.getMediaHeight(context, p: 0.2),
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
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Card(
          shadowColor: Colors.black.withOpacity(0.2),
          child: SizedBox(
            height: SizeConfig.getMediaHeight(context, p: 0.55),
            width: SizeConfig.getMediaWidth(context, p: 0.8),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                first,
                IconButton(
                    onPressed: () {
                      SwapWordsProvider.swapIt();
                      setState(() {});
                    },
                    icon: Icon(
                      Icons.swap_vert_rounded,
                      color: Palette.grey800,
                    )),
                second
              ],
            )),
          ),
        ),
      ),
    );
  }
}
