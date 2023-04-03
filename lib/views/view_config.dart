import 'package:flutter/widgets.dart';

class SizeConfig {
  static double getMediaHeight(context, {double percent = 1.0}) {
    return MediaQuery.of(context).size.height * percent;
  }

  static double getMediaWidth(context, {double percent = 1.0}) {
    return MediaQuery.of(context).size.width * percent;
  }
}

class ViewConfig {
  static const String timeFormat = 'hh:mm:ss a';
}
