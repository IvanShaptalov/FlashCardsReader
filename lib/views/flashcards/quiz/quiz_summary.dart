import 'package:flashcards_reader/bloc/quiz_bloc/quiz_bloc.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
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

List<Widget> loadListItems(BuildContext context) {
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
      padding: EdgeInsets.all(SizeConfig.getMediaHeight(context, p: 0.01)),
      child: Container(
          height: SizeConfig.getMediaHeight(context,
              p: ScreenIdentifier.isLandscapeRelative(context) ? 0.15 : 0.1),
          width: SizeConfig.getMediaWidth(context, p: 0.6),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: flash.isCorrect
                  ? ConfigQuizView.correctAreaColor.withOpacity(0.7)
                  : ConfigQuizView.wrongAreaColor.withOpacity(0.7)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Center(
                  child: Text(
                    flash.question,
                    style: ConfigQuizView.quizWordSummaryTextStyleBlack,
                    maxLines: 1,
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
                    style: ConfigQuizView.quizWordSummaryTextStyle,
                    maxLines: 1,
                  ),
                ),
              ),
            ],
          )),
    ));
  }
  return list;
}

Widget loadEndQuiz(BuildContext context, String fromPage) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Container(
        color: ConfigQuizView.quizResultBackgroundColor,
        height: SizeConfig.getMediaHeight(context,
            p: ScreenIdentifier.isLandscapeRelative(context) ? 0.6 : 0.7),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.getMediaWidth(context, p: 0.02)),
          child: ListView(
            children: loadListItems(context),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
            top: ScreenIdentifier.isLandscapeRelative(context) ? 0 : 16.0,
            bottom: ScreenIdentifier.isLandscapeRelative(context) ? 0 : 16.0),
        child: GestureDetector(
          child: Container(
            width: SizeConfig.getMediaWidth(context,
                p: ScreenIdentifier.isLandscapeRelative(context) ? 0.35 : 0.6),
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
                fromPage: fromPage, context: context);
          },
        ),
      )
    ],
  );
}

void addWordToResult(bool answer, BuildContext context) {
  FlashCard? flash =
      BlocProvider.of<QuizBloc>(context).state.quizModel.currentFCard;
  if (flash != null) {
    FlashCardMock mock = FlashCardMock(
        question: flash.question, answer: flash.answer, isCorrect: answer);
    SummaryFlashCardsProvider.flashSetMock.add(mock);
  }
}
