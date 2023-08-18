// ignore_for_file: lines_longer_than_80_chars

import 'package:flashcards_reader/model/entities/reader/book_scanner.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/util/router.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flashcards_reader/views/flashcards/flashcards/flashcards_screen.dart';
import 'package:flashcards_reader/views/guide_wrapper.dart';
import 'package:flashcards_reader/views/menu/side_menu.dart';
import 'package:flashcards_reader/views/overlay_notification.dart';
import 'package:flashcards_reader/views/parent_screen.dart';
import 'package:flashcards_reader/views/reader/screens/reading_homepage.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';

// ignore: must_be_immutable
class HelpPage extends ParentStatefulWidget {
  HelpPage({super.key});

  @override
  ParentState<HelpPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ParentState<HelpPage> {
  double appBarHeight = 0;

  @override
  Widget build(BuildContext context, {Widget? page}) {
    /// ===============================================[Create page]======
    var appBar = AppBar(
      title: const Text('Settings and help'),
    );
    appBarHeight = appBar.preferredSize.height;
    bindPage(Scaffold(
      backgroundColor: Palette.lightGreen,
      appBar: appBar,
      body: Center(
          child: SizedBox(
        height: SizeConfig.getMediaHeight(context),
        child: const AppIntroduceStepper(),
      )),
      drawer: SideMenu(appBarHeight),
    ));

    /// =======================================[Select design via context]==

    return super.build(context);
  }
}

// ignore: must_be_immutable
class AppIntroduceStepper extends StatefulWidget {
  const AppIntroduceStepper({
    super.key,
  });

  @override
  State<AppIntroduceStepper> createState() => _AppIntroduceStepperState();
}

class _AppIntroduceStepperState extends State<AppIntroduceStepper> {
  final int _stepCount = GuideProvider.helpPageStepCount;

  @override
  Widget build(BuildContext context) {
    double lineHeight = SizeConfig.getMediaHeight(context, p: 0.1);
    return Stepper(
      elevation: 0,
      controlsBuilder: (context, details) {
        return Row(
          children: <Widget>[
            if (details.stepIndex != _stepCount)
              TextButton(
                onPressed: details.onStepContinue,
                child: Icon(
                  Icons.arrow_downward_rounded,
                  color: Palette.white,
                ),
              )
            else
              TextButton(
                onPressed: () {
                  MyRouter.pushPage(context, const FlashCardScreen());
                },
                child: Icon(Icons.web_stories_outlined, color: Palette.white),
              ),
            if (details.stepIndex == 3)
              TextButton(
                  onPressed: () {
                    MyRouter.pushPageReplacement(
                        context,
                        const ReadingHomePage(
                          isTutorial: true,
                        ));
                  },
                  child: Icon(Icons.play_arrow_rounded, color: Palette.white)),
            if (details.stepIndex > 0)
              TextButton(
                onPressed: details.onStepCancel,
                child: Icon(Icons.arrow_upward_rounded, color: Palette.white),
              ),
          ],
        );
      },
      currentStep: GuideProvider.initIndex,
      onStepCancel: () {
        if (GuideProvider.initIndex > 0) {
          setState(() {
            GuideProvider.initIndex -= 1;
          });
          // widget.updateBackground(GuideProvider.initIndex);
        }
      },
      onStepContinue: () {
        if (GuideProvider.initIndex < _stepCount) {
          setState(() {
            GuideProvider.initIndex += 1;
          });
          // widget.updateBackground(GuideProvider.initIndex);
        }
      },
      onStepTapped: (int index) {
        setState(() {
          GuideProvider.initIndex = index;
        });
        // widget.updateBackground(GuideProvider.initIndex);
      },
      steps: <Step>[
        Step(
          title: Text('Use it',
              style: FontConfigs.h2TextStyle.copyWith(color: Palette.white)),
          content: SizedBox(
            height: SizeConfig.getMediaHeight(context, p: 0.4),
            width: double.infinity,
            child: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/guide/1.png'),
                      fit: BoxFit.contain)),
            ),
          ),
        ),
        Step(
          title: Text('Abilities',
              style: FontConfigs.h2TextStyle.copyWith(color: Palette.white)),
          content: SizedBox(
            height: SizeConfig.getMediaHeight(context, p: 0.4),
            width: double.infinity,
            child: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/guide/2.png'),
                      fit: BoxFit.contain)),
            ),
          ),
        ),

        /// =======================================[STEP 3 - scanning]
        Step(
          title: Text('Scanning',
              style: FontConfigs.h2TextStyle.copyWith(color: Palette.white)),
          content: Container(
            alignment: Alignment.centerLeft,
            child: Column(
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: ValueListenableBuilder(
                        valueListenable:
                            BookScanner.manageStorage,
                        builder: (BuildContext context, bool isGranted,
                            Widget? child) {
                          return GestureDetector(
                            onTap: isGranted
                                ? () {
                                    OverlayNotificationProvider
                                        .showOverlayNotification(
                                            'permission already granted');
                                  }
                                : () async {
                                    await BookScanner.getFilePermission();
                                    setState(() {});
                                  },
                            child: SizedBox(
                              height: lineHeight,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '''${!isGranted ? "tap to grant \n'Read Storage' " : "granted: 'Read Storage'"} ''',
                                    style: FontConfigs.h2TextStyle
                                        .copyWith(color: Palette.white),
                                  ),
                                  isGranted
                                      ? Icon(Icons.check, color: Palette.white)
                                      : Icon(Icons.ads_click,
                                          color: Palette.white)
                                ],
                              ),
                            ),
                          );
                        })),
                const Divider(),
                ValueListenableBuilder(
                    valueListenable:
                        BookScanner.manageStorage,
                    builder:
                        (BuildContext context, bool isGranted, Widget? child) {
                      return SizedBox(
                        height: lineHeight,
                        child: GestureDetector(
                          onTap: isGranted
                              ? () {
                                  BookScanner.scan();
                                }
                              : () {
                                  OverlayNotificationProvider
                                      .showOverlayNotification(
                                          'grant permission to scan');
                                },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    isGranted
                                        ? 'tap to find books'
                                        : 'grant permission',
                                    style: FontConfigs.h2TextStyle
                                        .copyWith(color: Palette.white)),
                              ),
                              isGranted
                                  ? Icon(
                                      Icons.find_replace_outlined,
                                      color: Palette.white,
                                    )
                                  : Icon(
                                      Icons.warning,
                                      color: Palette.white,
                                    ),
                            ],
                          ),
                        ),
                      );
                    }),
                SizedBox(
                  height: ScreenIdentifier.isPortrait(context)
                      ? lineHeight / 2
                      : lineHeight,
                  child: ValueListenableBuilder(
                      valueListenable:
                          BookScanner.manageStorage,
                      builder: (BuildContext context, bool isGranted,
                          Widget? child) {
                        return ValueListenableBuilder(
                            valueListenable: BookScanner.scanPercent,
                            builder: (BuildContext context, double percent,
                                Widget? child) {
                              if (percent == 1 || percent == 0) {
                                debugPrintIt('update book count');
                              }
                              return LiquidLinearProgressIndicator(
                                value: percent, // Defaults to 0.5.
                                valueColor: AlwaysStoppedAnimation(isGranted
                                    ? Palette.blueAccent
                                    : Palette
                                        .blueGrey), // Defaults to the current Theme's accentColor.
                                backgroundColor: Colors
                                    .white, // Defaults to the current Theme's backgroundColor.
                                borderRadius: 6.0,
                                direction: Axis
                                    .horizontal, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
                                center: Text(
                                  isGranted && percent > 0 ? "Scanning" : "",
                                  style: FontConfigs.h3TextStyle
                                      .copyWith(color: Palette.white),
                                ),
                              );
                            });
                      }),
                ),
                const Divider(),
              ],
            ),
          ),
        ),
        Step(
          title: Text('How to use',
              style: FontConfigs.h2TextStyle.copyWith(color: Palette.white)),
          content: Text('Instruction how to use app,\nTap to play',
              style: FontConfigs.h2TextStyle.copyWith(color: Palette.white)),
        ),

        Step(
          title: Text('Quick actions',
              style: FontConfigs.h2TextStyle.copyWith(color: Palette.white)),
          content: SizedBox(
            height: SizeConfig.getMediaHeight(context, p: 0.4),
            width: double.infinity,
            child: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/guide/3.png'),
                      fit: BoxFit.contain)),
            ),
          ),
        ),
      ],
    );
  }
}
