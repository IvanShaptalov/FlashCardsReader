import 'package:flashcards_reader/firebase/firebase.dart';
import 'package:flashcards_reader/util/enums.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intro/intro.dart';

class GuideProvider {
  static int interactiveStepCount = 7;
  static int helpPageStepCount = 4; // five steps from 0
  static IntroController introController = IntroController(
    stepCount: interactiveStepCount,
    onWillClose: (currentStep) {
      if ([1, 2, 5, 6].contains(currentStep)) {
        FireBaseService.logGuide(GuideStatus.ended, currentStep);
        debugPrintIt('guide is ended');
        GuideProvider.isTutorial = false;
        return true;
      }
      return true;
    },
  );
  static bool _isTutorial = false;

  static bool get isTutorial => _isTutorial;

  static set isTutorial(bool isTutorial) {
    _isTutorial = isTutorial;
    if (_isTutorial) {
      debugPrintIt('enable portrait in tutorial');
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    } else {
      debugPrintIt('disable portrait in tutorial');
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight
      ]);
    }
  }

  static int initIndex = 0;

  static void pushToLastStep() {
    initIndex = GuideProvider.helpPageStepCount;
  }

  static void init() {
    GuideProvider._isTutorial = true;
    GuideProvider.initIndex = 0;
    FireBaseService.logGuide(GuideStatus.started, 0);
  }

  static void endTutorial() {
    FireBaseService.logGuide(GuideStatus.ended, -1);

    GuideProvider._isTutorial = false;
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
    if (_isTutorial && toWrap) {
      FireBaseService.logGuide(GuideStatus.continued, step);

      return IntroStepTarget(
        key: Key(uuid.v4()),
        cardDecoration: IntroCardDecoration(
            closeButtonStyle: ButtonStyle(
                iconColor: MaterialStatePropertyAll(Palette.grey),
                backgroundColor: MaterialStatePropertyAll(Palette.grey)),
            showCloseButton: true,
            closeButtonLabel: 'skip tutorial',
            showNextButton: false,
            showPreviousButton: false,
            padding: const EdgeInsets.all(8)),
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
    if (_isTutorial && toWrap) {
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
