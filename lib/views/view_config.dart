import 'package:flashcards_reader/util/error_handler.dart';
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

class ViewColumnCalculator {
  static int calculateColumnCount(BuildContext context) {
    double screenWidth = SizeConfig.getMediaWidth(context);
    if (screenWidth > 1000) {
      return SizeConfig.getMediaWidth(context) ~/ 200;
    } else if (screenWidth > 600) {
      return 3;
    }
    return 2;
  }

  static double calculateCrossSpacing(BuildContext context) {
    double screenWidth = SizeConfig.getMediaWidth(context);
    if (screenWidth > 1000) {
      return SizeConfig.getMediaWidth(context) / 20;
    } else if (screenWidth > 600) {
      return 20;
    } else if (screenWidth >= 380) {
      return 15;
    }
    return 15;
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
  static Color selectedCardColor = Colors.amber.shade100;
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
  static Color mergeTargetColor = Colors.green.shade100;
  static Color mergeObjectColor = Colors.amber.shade200;
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
  static Color addWordMenuColor = Colors.green.shade200;
  static Color buttonIconColor = Colors.grey.shade800;
  static double wordButtonWidthPercent = 0.3;
}

class MyConfigOrientation {
  static bool isPortrait(context) =>
      MediaQuery.of(context).orientation == Orientation.portrait;

  static bool isLandscape(context) => !isPortrait(context);
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
      TextStyle(fontSize: 16, color: Colors.grey.shade900);
}

class ConfigFastAddWordView {
  static Color buttonColor = Colors.amber.shade50;
  static Color selectedCard = Colors.green.shade100;
  static Color menuColor = Colors.green.shade200;
}

class ConfigExtensionDialog {
  static LinearGradient dialogGradient =
      LinearGradient(colors: [Colors.green.shade100, Colors.green.shade200]);
}

enum ScreenDesign { portrait, landscape, portraitSmall, landscapeSmall }

class ScreenIdentifier {
  static ScreenDesign indentify(BuildContext context) {
    if (MyConfigOrientation.isPortrait(context)) {
      if (SizeConfig.getMediaHeight(context) < 600) {
        debugPrintIt('identifed portrait small for element');
        return ScreenDesign.portraitSmall;
      } else {
        debugPrintIt('identifed portrait for element');

        return ScreenDesign.portrait;
      }
    } else {
      if (SizeConfig.getMediaWidth(context) < 600) {
        debugPrintIt('identifed landscape small for element');
        return ScreenDesign.landscapeSmall;
      } else {
        debugPrintIt('identifed landscape for element');
        return ScreenDesign.landscape;
      }
    }
  }

  /// isPortraitRelative is true if the screen is portrait or portraitSmall
  static bool isPortraitRelative(BuildContext context) {
    return isPortraitSmall(context) || isPortrait(context);
  }

  /// isLandscapeRelative is true if the screen is landscape or landscapeSmall
  static bool isLandscapeRelative(BuildContext context) {
    return isLandscapeSmall(context) || isLandscape(context);
  }

  static bool isPortraitSmall(BuildContext context) {
    return indentify(context) == ScreenDesign.portraitSmall;
  }

  static bool isLandscapeSmall(BuildContext context) {
    return indentify(context) == ScreenDesign.landscapeSmall;
  }

  static bool isPortrait(BuildContext context) {
    return indentify(context) == ScreenDesign.portrait;
  }

  static bool isLandscape(BuildContext context) {
    return indentify(context) == ScreenDesign.landscape;
  }

  static Widget returnScreen(
      {required Widget portraitScreen,
      required Widget landscapeScreen,
      required Widget portraitSmallScreen,
      required Widget landscapeSmallScreen,
      required BuildContext context}) {
    switch (indentify(context)) {
      case ScreenDesign.portrait:
        return portraitScreen;
      case ScreenDesign.landscape:
        return landscapeScreen;
      case ScreenDesign.portraitSmall:
        return portraitSmallScreen;
      case ScreenDesign.landscapeSmall:
        return landscapeSmallScreen;
      default:
        return portraitScreen;
    }
  }
}
