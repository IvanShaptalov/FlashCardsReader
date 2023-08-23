import 'package:flashcards_reader/util/enums.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flutter/material.dart';
import 'package:intro/intro.dart';

class GuideProvider {
  static int interactiveStepCount = 7;
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

  static Widget wrapInGuideIfNeeded(
      {required Widget child,
      required VoidCallback? onHighlightTap,
      required int step,
      required String guideText,
      bool toWrap = true}) {
    if (isTutorial && toWrap) {
      return IntroStepTarget(
        key: Key(uuid.v4()),
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

  static Widget wrapInIntroIfNeeded(
      {required Widget child,
      required int step,
      required String guideText,
      bool toWrap = true}) {
    if (isTutorial && toWrap) {
      return IntroStepTarget(
        key: Key(uuid.v4()),
        cardDecoration: IntroCardDecoration(
            closeButtonStyle: ButtonStyle(
                iconColor: MaterialStatePropertyAll(Palette.green300Primary),
                backgroundColor:
                    MaterialStatePropertyAll(Palette.green300Primary)),
            closeButtonLabel: 'ok',
            showCloseButton: true,
            showNextButton: false,
            showPreviousButton: false,
            padding: const EdgeInsets.all(8)),
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

  static void startStep(BuildContext context, int step) {
    debugPrintIt('tutorial starts now...');
    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      introController.start(context, initStep: step);
    });
  }
}
