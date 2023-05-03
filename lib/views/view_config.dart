import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
}

class ConfigFlashcardView {
  static Color descriptionIconColor = Colors.blueGrey.shade700;
  static Color quizIconColor = Colors.grey.shade800;
}

class ConfigFCWordsInfo {
  static Color questionLanguageIconColor = Colors.blueAccent;
  static Color answerLanguageIconColor = Colors.green.shade600;
}

class ConfigViewUpdateMenu{
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