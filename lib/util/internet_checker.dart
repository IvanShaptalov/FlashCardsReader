import 'dart:io';

import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/views/overlay_notification.dart';

class InternetConnectionChecker {
  static Future<bool> connected() async {
    try {
      final response = await InternetAddress.lookup('www.kindacode.com');
      if (response.isNotEmpty) {
        return true;
      }
    } on SocketException catch (e) {
      debugPrintIt(e.toString());
      return false;
    }
    return false;
  }

  static startChecking() async {
    debugPrintIt('start checking internet connection');
    bool connectionIsLost = false;
    while (true) {
      debugPrintIt('check');
      await Future.delayed(const Duration(seconds: 3));
      // send once notification about internet connection back
      if (await InternetConnectionChecker.connected() && connectionIsLost) {
        debugPrintIt('internet connection is back');
        OverlayNotificationProvider.backOnline();

        connectionIsLost = false;
      }
      // send once notification about internet connection lost
      else if (await InternetConnectionChecker.connected() == false &&
          connectionIsLost == false) {
        debugPrintIt('no internet connection');
        OverlayNotificationProvider.showInternetError();
        connectionIsLost = true;
      }
    }
  }
}
