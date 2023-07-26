import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:intro/intro.dart';

class GuideProvider {
  static IntroController introController = IntroController(stepCount: 5);

  static Widget wrapInGuideIfNeeded(
      {required Widget child,
      required VoidCallback? onHighlightTap,
      required int step,
      required bool toWrap,
      required String guideText}) {
    if (toWrap) {
      return IntroStepTarget(
        cardDecoration: const IntroCardDecoration(
            showCloseButton: false,
            showNextButton: false,
            showPreviousButton: false,
            padding: EdgeInsets.all(8)),
        onHighlightTap: onHighlightTap,
        step: step,
        controller: introController,
        cardContents: TextSpan(
          text: guideText,
        ),
        child: child,
      );
    }
    return child;
  }

  static Widget wrapInGuideNote(
      {required Widget child,
      required bool toWrap,
      required int step,
      required String guideText}) {
    if (toWrap) {
      return IntroStepTarget(
        cardDecoration: const IntroCardDecoration(
            showCloseButton: true, padding: EdgeInsets.all(8)),
        step: step,
        controller: introController,
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
      introController.start(context, initStep: step);
      updateCallback();
    });
  }
}
