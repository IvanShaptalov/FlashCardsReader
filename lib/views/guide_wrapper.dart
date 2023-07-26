import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:intro/intro.dart';

class GuideProvider {
  static Widget wrapInGuideIfNeeded(
      {required Widget child,
      required VoidCallback? onHighlightTap,
      required int step,
      required bool toWrap,
      required String guideText,
      required BuildContext context}) {
    if (toWrap) {
      return IntroStepTarget(
        cardDecoration: const IntroCardDecoration(
            showCloseButton: false,
            showNextButton: false,
            showPreviousButton: false,
            padding: EdgeInsets.all(8)),
        onHighlightTap: onHighlightTap,
        step: step,
        controller: Intro.of(context).controller,
        cardContents: TextSpan(
          text: guideText,
        ),
        child: child,
      );
    }
    return child;
  }

  static void startStep(
      BuildContext context, Function updateCallback, int step) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      debugPrintIt('tutorial starts now...');
      Intro.of(context).controller.start(context, initStep: step);
      updateCallback();
    });
  }
}
