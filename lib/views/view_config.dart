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

class ConfigFlashCardView {
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

  static Color descriptionIconColor = Colors.blueGrey.shade700;
  static Color quizIconColor = Colors.grey.shade800;

  static const TextStyle cardTitleTextStyle =
      TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
}

class ConfigFCWordsInfo {
  static Color questionLanguageIconColor = Colors.blueAccent;
  static Color answerLanguageIconColor = Colors.green.shade600;
}
