import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:intro/intro.dart';

class GuideProvider {
  static int interactiveStepCount = 6;
  static int helpPageStepCount = 4; // five steps from 0
  static IntroController introController =
      IntroController(stepCount: interactiveStepCount);
  static bool isTutorial = false;

  static int initIndex = 0;

  static void pushToLastStep() {
    initIndex = GuideProvider.helpPageStepCount;
  }

  static void init() {
    GuideProvider.isTutorial = true;
    GuideProvider.initIndex = 0;
  }

  static void endTutorial() {
    GuideProvider.isTutorial = false;
    GuideProvider.initIndex = 0;
  }

  static bool step1Rendered = false;
  static bool step2Rendered = false;
  static bool step3Rendered = false;
  static bool step4Rendered = false;
  static bool step5Rendered = false;
  static bool step6Rendered = false;

  static bool stepRendered(int step) {
    switch (step) {
      case 1:
        return step1Rendered;
      case 2:
        return step2Rendered;
      case 3:
        return step3Rendered;
      case 4:
        return step4Rendered;
      case 5:
        return step5Rendered;
      case 6:
        return step6Rendered;
      default:
        throw Exception('only from 1 to 6');
    }
  }

  static bool setStepRendered(int step, bool rendered) {
    switch (step) {
      case 1:
        return step1Rendered = rendered;
      case 2:
        return step2Rendered = rendered;
      case 3:
        return step3Rendered = rendered;
      case 4:
        return step4Rendered = rendered;
      case 5:
        return step5Rendered = rendered;
      case 6:
        return step6Rendered = rendered;
      default:
        throw Exception('only from 1 to 6');
    }
  }

  static Widget wrapInGuideIfNeeded(
      {required Widget child,
      required VoidCallback? onHighlightTap,
      required int step,
      required String guideText,
      bool toWrap = true}) {
    if (isTutorial && toWrap) {
      setStepRendered(step, true);
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

  static void startStep(
      BuildContext context, Function updateCallback, int step) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      debugPrintIt('tutorial starts now...');
      introController.start(context, initStep: step);
      updateCallback();
    });
  }
}
