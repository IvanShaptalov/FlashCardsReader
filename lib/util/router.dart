import 'package:flashcards_reader/firebase/firebase.dart';
import 'package:flutter/material.dart';

class MyRouter {
  static Future pushPageDialog(BuildContext context, Widget page) {
    FireBaseService.logRoute(page.toString());

    var val = Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return page;
        },
        fullscreenDialog: true,
      ),
    );

    return val;
  }

  static pushPage(BuildContext context, Widget page) {
    FireBaseService.logRoute(page.toString());
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return page;
        },
      ),
    );
  }

  static pushPageReplacement(BuildContext context, Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return page;
        },
      ),
    );
  }
}
