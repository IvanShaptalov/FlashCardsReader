import 'package:flashcards_reader/model/entities/reader/book_scanner.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/views/overlay_notification.dart';

class Checker {
  /// =======================[Extensions]======================
  static String getExtension(String path) {
    return p.extension(path);
  }

  static String getName(String path) {
    return p.basename(path);
  }

  /// =========================[Internet]========================
  static ValueNotifier<bool> isConnected = ValueNotifier(true);

  static Future<bool> connected() async {
    try {
      final response = await InternetAddress.lookup('www.kindacode.com');
      if (response.isNotEmpty) {
        isConnected.value = true;
        return true;
      }
    } on Exception catch (e) {
      debugPrintIt(e.toString());
      isConnected.value = false;
      return false;
    }
    isConnected.value = false;
    return false;
  }

  static startChecking() async {
    debugPrintIt('start checking internet connection');
    bool connectionIsLost = false;
    while (true) {
      BookScanner.getStatus();
      debugPrintIt('check connection and permission');
      await Future.delayed(const Duration(seconds: 3));
      // send once notification about internet connection back
      if (await Checker.connected() && connectionIsLost) {
        debugPrintIt('internet connection is back');
        OverlayNotificationProvider.backOnline();
        isConnected.value = true;
        connectionIsLost = false;
      }
      // send once notification about internet connection lost
      else if (await Checker.connected() == false &&
          connectionIsLost == false) {
        debugPrintIt('no internet connection');
        OverlayNotificationProvider.showInternetError();
        isConnected.value = false;
        connectionIsLost = true;
      }
    }
  }

  ///=========================[ANDROIDVERSION]=================
  static int androidVersion() {
    return 0;
  }
}
