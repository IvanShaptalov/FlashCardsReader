part of 'view_config.dart';

class SizeConfig {
  /// height of the screen p - percentage of the screen height
  static double getMediaHeight(context, {double p = 1.0}) {
    return MediaQuery.of(context).size.height * p;
  }

  /// width of the screen p - percentage of the screen width
  static double getMediaWidth(context, {double p = 1.0}) {
    return MediaQuery.of(context).size.width * p;
  }

  static Size size(BuildContext context,
      {EdgeInsetsGeometry? edgeInsets}) {
    var size = MediaQuery.sizeOf(context);
    if (edgeInsets == null) {
      return size;
    }
    return Size(
        size.height - edgeInsets.vertical, size.width - edgeInsets.horizontal);
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

class MyConfigOrientation {
  static bool isPortrait(context) =>
      MediaQuery.of(context).orientation == Orientation.portrait;

  static bool isLandscape(context) => !isPortrait(context);
}
