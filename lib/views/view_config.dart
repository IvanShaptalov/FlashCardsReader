import 'package:flashcards_reader/util/router.dart';
import 'package:flashcards_reader/views/flashcards/flashcards/flashcards_screen.dart';
import 'package:flashcards_reader/views/flashcards/quiz/quiz_menu.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SizeConfig {
  /// height of the screen p - percentage of the screen height
  static double getMediaHeight(context, {double p = 1.0}) {
    return MediaQuery.of(context).size.height * p;
  }

  /// width of the screen p - percentage of the screen width
  static double getMediaWidth(context, {double p = 1.0}) {
    return MediaQuery.of(context).size.width * p;
  }
}

class ViewConfig {
  static const String creatingFormat = 'MMM d, yyyy';

  static String formatDate(DateTime date,
      {String creatingFormat = creatingFormat}) {
    return DateFormat(creatingFormat).format(date);
  }

  static double getCardForm(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.portrait ? 0.6 : 1;

  static void pushFromQuizProcess(
      {required context, required String fromPage}) {
    MyRouter.pushPageReplacement(context,
        fromPage == 'collection' ? const FlashCardScreen() : const QuizMenu());
  }
}

class CardViewConfig {
  static Color defaultCardColor = Colors.amber.shade50;
}

class FontConfigs {
  static const TextStyle h1TextStyle =
      TextStyle(fontSize: 20, color: Colors.black);

  static TextStyle h2TextStyle =
      TextStyle(fontSize: 18, color: Colors.grey.shade800);

  static const TextStyle h2TextStyleBlack =
      TextStyle(fontSize: 18, color: Colors.black);

  static TextStyle h3TextStyle =
      TextStyle(fontSize: 16, color: Colors.grey.shade800);

  static const TextStyle h3TextStyleBlack =
      TextStyle(fontSize: 16, color: Colors.black);

  static const TextStyle cardTitleTextStyle =
      TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

  static const TextStyle cardAnswerTextStyle =
      TextStyle(fontSize: 22, color: Colors.black);
  static const TextStyle cardQuestionTextStyle =
      TextStyle(fontSize: 22, color: Colors.black);
}

class ConfigFlashcardView {
  static Color descriptionIconColor = Colors.blueGrey.shade700;
  static Color quizIconColor = Colors.grey.shade800;
}

class ConfigFCWordsInfo {
  static Color questionLanguageIconColor = Colors.blueAccent;
  static Color answerLanguageIconColor = Colors.green.shade600;
}

class ConfigViewUpdateMenu {
  static Color iconColor = Colors.blueGrey.shade700;
  static Color backgroundColor = Colors.white;
  static Color textColor = Colors.black;
  static Color dividerColor = Colors.grey.shade300;
  static Color dropDownColor = Colors.amber.shade50;
  static Color dropDownColorUndlerline = Colors.green.shade300;
  static Color buttonColor = Colors.green.shade300;
  static Color buttonIconColor = Colors.grey.shade800;
  static double wordButtonWidthPercent = 0.3;
}

class MyConfigOrientation {
  static bool isPortrait(context) =>
      MediaQuery.of(context).orientation == Orientation.portrait;

  static bool isLandscape(context) => !isPortrait(context);
}

class ListOrColumn extends StatelessWidget {
  final List<Widget> children;
  const ListOrColumn({required this.children, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MyConfigOrientation.isPortrait(context)
        ? Column(
            children: children,
          )
        : ListView(
            children: children,
          );
  }
}

class ConfigQuizView {
  static Color backFromQuizButtonBackgroundColor = Colors.green.shade500;
  static Color backFromQuizIconColor = Colors.white;
  static Color wrongAreaColor = Colors.red.shade300;
  static TextStyle backFromQuizTextStyle = const TextStyle(
      fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white);
  static Color correctAreaColor = Colors.green.shade300;
  static Color selectedModeColor = Colors.teal;
  static Color unselectedModeColor = Colors.blueGrey;
  static Color foregroundModeColor = Colors.white;
  static Color cardQuizColor = Colors.amber.shade50;
  static Color quizResultBackgroundColor = Colors.grey.shade300;

  static TextStyle quizSummaryTextStyle = TextStyle(
      fontSize: 18, fontWeight: FontWeight.w700, color: Colors.grey.shade800);

  static TextStyle quizWordSummaryTextStyleBlack =
      const TextStyle(fontSize: 18, color: Colors.black);
  static TextStyle quizWordSummaryTextStyle =
      TextStyle(fontSize: 16,  color: Colors.grey.shade900);
}
