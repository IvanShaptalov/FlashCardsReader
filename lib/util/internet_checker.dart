import 'dart:io';

import 'package:flashcards_reader/util/error_handler.dart';

class InternetChecker {
  static Future<bool> hasConnection() async {
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
}
