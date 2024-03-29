import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/util/router.dart';
import 'package:flashcards_reader/views/flashcards/flashcards/flashcards_screen.dart';
import 'package:flashcards_reader/views/flashcards/quiz/quiz_menu.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

part 'view_config_flashcards.dart';
part 'view_config_reader.dart';

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
    var page =
        fromPage == 'collection' ? const FlashCardScreen() : const QuizMenu();

    MyRouter.pushPageReplacement(context, page);
  }
}

class FontConfigs {
  static TextStyle pageNameTextStyle = TextStyle(
      color: Palette.white,
      fontSize: 24,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.6);
  static TextStyle h1TextStyle = TextStyle(fontSize: 20, color: Palette.black);

  static TextStyle h2TextStyle =
      TextStyle(fontSize: 18, color: Palette.grey800);

  static TextStyle h2TextStyleBlack =
      TextStyle(fontSize: 18, color: Palette.black);

  static TextStyle h3TextStyle =
      TextStyle(fontSize: 16, color: Palette.grey800);

  static TextStyle h3TextStyleBlack =
      TextStyle(fontSize: 16, color: Palette.black);

  static const TextStyle cardTitleTextStyle =
      TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

  static TextStyle cardAnswerTextStyle =
      TextStyle(fontSize: 22, color: Palette.black);
  static TextStyle cardQuestionTextStyle =
      TextStyle(fontSize: 22, color: Palette.black);
  static TextStyle backFromQuizTextStyle = TextStyle(
      fontSize: 16, fontWeight: FontWeight.bold, color: Palette.white);

  static TextStyle quizSummaryTextStyle = TextStyle(
      fontSize: 18, fontWeight: FontWeight.w700, color: Palette.grey800);

  static TextStyle quizWordSummaryTextStyleBlack =
      TextStyle(fontSize: 18, color: Palette.black);
  static TextStyle quizWordSummaryTextStyle =
      TextStyle(fontSize: 16, color: Palette.grey900);
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

  static bool isSmall(BuildContext context) {
    return !isNormal(context);
  }

  static bool isNormal(BuildContext context) {
    return isLandscape(context) || isPortrait(context);
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

class ConfigMenu {
  static double iconSize = 28;
}

class DurationConfig {
  static Duration cardAppearDuration = const Duration(milliseconds: 375);
}
