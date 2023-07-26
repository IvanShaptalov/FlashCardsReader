import 'package:flashcards_reader/bloc/book_listing_bloc/book_listing_bloc.dart';
import 'package:flashcards_reader/model/entities/reader/book_scanner.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/util/router.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flashcards_reader/views/menu/side_menu.dart';
import 'package:flashcards_reader/views/overlay_notification.dart';
import 'package:flashcards_reader/views/parent_screen.dart';
import 'package:flashcards_reader/views/reader/screens/reading_homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';

// ignore: must_be_immutable
class HelpPage extends ParentStatefulWidget {
  HelpPage({super.key});

  @override
  ParentState<HelpPage> createState() => _FeedbackSupportPageState();
}

class _FeedbackSupportPageState extends ParentState<HelpPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => BookBloc(), child: HelpPageView());
  }
}

// ignore: must_be_immutable
class HelpPageView extends ParentStatefulWidget {
  HelpPageView({super.key});

  @override
  ParentState<HelpPageView> createState() => _MyHomePageState();
}

class _MyHomePageState extends ParentState<HelpPageView> {
  double appBarHeight = 0;

  @override
  void initState() {
    // BookScanner.manageExternalStoragePermission.addListener()
    super.initState();
  }

  @override
  Widget build(BuildContext context, {Widget? page}) {
    /// ===============================================[Create page]===============================
    var appBar = AppBar(
      title: const Text('Settings and help'),
    );
    appBarHeight = appBar.preferredSize.height;
    bindPage(Scaffold(
      appBar: appBar,
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: SizeConfig.getMediaHeight(context),
          child: SingleChildScrollView(
              child: Column(
            children: [
              AppIntroduceStepper(),
            ],
          )),
        ),
      )),
      drawer: SideMenu(appBarHeight),
    ));

    /// ===============================================[Select design via context]===============================

    return super.build(context);
  }
}

// ignore: must_be_immutable
class AppIntroduceStepper extends ParentStatefulWidget {
  AppIntroduceStepper({super.key});

  @override
  ParentState<AppIntroduceStepper> createState() => _AppIntroduceStepperState();
}

class _AppIntroduceStepperState extends ParentState<AppIntroduceStepper> {
  int _index = 0;
  final int _stepCount = 3;
  static ValueNotifier<int> oldBooksCount = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    double lineHeight = SizeConfig.getMediaHeight(context, p: 0.1);
    return Stepper(
      controlsBuilder: (context, details) {
        return Row(
          children: <Widget>[
            details.stepIndex != _stepCount
                ? TextButton(
                    onPressed: details.onStepContinue,
                    child: const Text('NEXT'),
                  )
                : TextButton(
                    onPressed: () {
                      MyRouter.pushPageReplacement(
                          context,
                          const ReadingHomePage(
                            isTutorial: true,
                          ));
                    },
                    child: const Text('To Books'),
                  ),
            if (details.stepIndex != 0)
              TextButton(
                onPressed: details.onStepCancel,
                child: const Text('BACK'),
              ),
          ],
        );
      },
      currentStep: _index,
      onStepCancel: () {
        if (_index > 0) {
          setState(() {
            _index -= 1;
          });
        }
      },
      onStepContinue: () {
        if (_index < _stepCount) {
          setState(() {
            _index += 1;
          });
        }
      },
      onStepTapped: (int index) {
        setState(() {
          _index = index;
        });
      },
      steps: <Step>[
        const Step(
          title: Text('Step 2 image'),
          content: Text('Content for Step 2'),
        ),
        const Step(
          title: Text('Step scanning'),
          content: Text('Content for Step 2'),
        ),

        /// =========================================================[STEP 3 - scanning]
        Step(
          title: const Text('Scanning'),
          content: Container(
            alignment: Alignment.centerLeft,
            child: Column(
              children: [
                const Divider(),
                SizedBox(
                  height: lineHeight,
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: ValueListenableBuilder(
                          valueListenable:
                              BookScanner.manageExternalStoragePermission,
                          builder: (BuildContext context, bool isGranted,
                              Widget? child) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${!isGranted ? "Tap to grant \n'Read Storage' " : "'Read Storage' granted"} ',
                                  style: FontConfigs.h2TextStyleBlack,
                                ),
                                isGranted
                                    ? IconButton(
                                        icon: Icon(Icons.check,
                                            color: Palette.green300Primary),
                                        onPressed: () {
                                          OverlayNotificationProvider
                                              .showOverlayNotification(
                                                  'permission already granted');
                                        })
                                    : IconButton(
                                        icon: Icon(Icons.ads_click,
                                            color: Palette.deepPurple),
                                        onPressed: () async {
                                          await BookScanner.getFilePermission();
                                          setState(() {});
                                        },
                                      )
                              ],
                            );
                          })),
                ),
                const Divider(),
                SizedBox(
                  height: lineHeight,
                  child: ValueListenableBuilder(
                      valueListenable:
                          BookScanner.manageExternalStoragePermission,
                      builder: (BuildContext context, bool isGranted,
                          Widget? child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                isGranted
                                    ? 'scan now to find books'
                                    : 'grant permission to scan',
                                style: FontConfigs.h1TextStyle,
                              ),
                            ),
                            isGranted
                                ? IconButton(
                                    onPressed: () {
                                      BookScanner.scan();
                                    },
                                    icon: const Icon(
                                      Icons.find_replace_outlined,
                                    ))
                                : IconButton(
                                    onPressed: () {
                                      OverlayNotificationProvider
                                          .showOverlayNotification(
                                              'grant permission to scan');
                                    },
                                    icon: Icon(
                                      Icons.warning,
                                      color: Palette.teal,
                                    )),
                          ],
                        );
                      }),
                ),
                SizedBox(
                  height: ScreenIdentifier.isPortrait(context)
                      ? lineHeight / 2
                      : lineHeight,
                  child: ValueListenableBuilder(
                      valueListenable:
                          BookScanner.manageExternalStoragePermission,
                      builder: (BuildContext context, bool isGranted,
                          Widget? child) {
                        return ValueListenableBuilder(
                            valueListenable: BookScanner.scanPercent,
                            builder: (BuildContext context, double percent,
                                Widget? child) {
                              if (percent == 1 || percent == 0) {
                                debugPrintIt('update book count');
                                oldBooksCount.value =
                                    BlocProvider.of<BookBloc>(context)
                                        .state
                                        .books
                                        .length;
                              }
                              return LiquidLinearProgressIndicator(
                                value: percent, // Defaults to 0.5.
                                valueColor: AlwaysStoppedAnimation(isGranted
                                    ? Palette.blueAccent
                                    : Palette
                                        .blueGrey), // Defaults to the current Theme's accentColor.
                                backgroundColor: Colors
                                    .white, // Defaults to the current Theme's backgroundColor.
                                borderColor: Palette.green200,
                                borderWidth: 5.0,
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
              ],
            ),
          ),
        ),
        const Step(
          title: Text('Step 2 image'),
          content: Text('Content for Step 2'),
        ),
      ],
    );
  }
}
