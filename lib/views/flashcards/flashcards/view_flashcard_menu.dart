import 'package:flashcards_reader/bloc/providers/word_collection_provider.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/util/enums.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/util/router.dart';
import 'package:flashcards_reader/views/flashcards/sharing/extension_dialog.dart';
import 'package:flashcards_reader/views/flashcards/tts_widget.dart';
import 'package:flashcards_reader/views/flashcards/quiz/quiz_process.dart';
import 'package:flashcards_reader/views/guide_wrapper.dart';
import 'package:flashcards_reader/views/overlay_notification.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class FlashCardViewBottomSheet {
  FlashCardViewBottomSheet({FlashCardCollection? creatingFlashC}) {
    if (creatingFlashC != null) {
      debugPrintIt('create copy of flashcard collection');
      flashCardCollection = creatingFlashC.copy();
    } else {
      debugPrintIt('create flashFixture');
      flashCardCollection = flashExample();
    }
  }

  late FlashCardCollection flashCardCollection;

  showFlashCardViewMenu(BuildContext specialContext,
      {bool isTutorial = false}) async {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        context: specialContext,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (BuildContext context, setState) {
            return FlashCardViewWall(
              specialContext,
              flashCardCollection,
              isTutorial: isTutorial,
            );
          });
        });
  }
}

// ignore: must_be_immutable
class FlashCardViewWall extends StatefulWidget {
  FlashCardViewWall(
    this.specialContext,
    this.flashCardCollection, {
    this.isTutorial = false,
    super.key,
  });
  final bool isTutorial;
  BuildContext specialContext;

  FlashCardCollection flashCardCollection;
  @override
  State<FlashCardViewWall> createState() => _FlashCardViewWallState();
}

class _FlashCardViewWallState extends State<FlashCardViewWall> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      GuideProvider.introController.next();

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Palette.amber50,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        ),
        height: SizeConfig.getMediaHeight(context, p: 0.85),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: SizeConfig.getMediaHeight(context, p: 0.03)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_drop_down,
                  color: Palette.descriptionIconColor,
                ),
                Text(
                  'drag to hide menu',
                  style: FontConfigs.h2TextStyle,
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Palette.descriptionIconColor,
                ),
              ],
            ),
          ),
          Divider(
            color: Palette.grey,
            thickness: 1,
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.getMediaWidth(context, p: 0.05)),
                  child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                        width: SizeConfig.getMediaWidth(context, p: 0.99),
                        child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Palette.grey400, width: 1),
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.verified_outlined,
                                                color: Palette
                                                    .descriptionIconColor,
                                              ),
                                            ),
                                            Text(
                                              'Flashcard Title : ',
                                              textAlign: TextAlign.start,
                                              style: [
                                                ScreenDesign.landscapeSmall,
                                                ScreenDesign.portraitSmall
                                              ].contains(ScreenIdentifier
                                                      .indentify(context))
                                                  ? FontConfigs.h2TextStyleBlack
                                                  : FontConfigs.h1TextStyle,
                                              maxLines: 1,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: SizeConfig.getMediaWidth(
                                              context,
                                              p: 0.3),
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              dragStartBehavior:
                                                  DragStartBehavior.down,
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                  widget.flashCardCollection
                                                      .title,
                                                  textAlign: TextAlign.start,
                                                  style:
                                                      FontConfigs.h2TextStyle,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    color: Palette.grey,
                                    thickness: 1,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.language,
                                                color: Palette
                                                    .descriptionIconColor,
                                              ),
                                            ),
                                            Text(
                                              'Source : ',
                                              textAlign: TextAlign.start,
                                              style: [
                                                ScreenDesign.landscapeSmall,
                                                ScreenDesign.portraitSmall
                                              ].contains(ScreenIdentifier
                                                      .indentify(context))
                                                  ? FontConfigs.h2TextStyleBlack
                                                  : FontConfigs.h1TextStyle,
                                              maxLines: 1,
                                            ),
                                          ],
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            widget.flashCardCollection
                                                .questionLanguage,
                                            textAlign: TextAlign.start,
                                            style: FontConfigs.h2TextStyle,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.translate,
                                                color: Palette
                                                    .descriptionIconColor,
                                              ),
                                            ),
                                            Text(
                                              'Translation : ',
                                              textAlign: TextAlign.start,
                                              style: [
                                                ScreenDesign.landscapeSmall,
                                                ScreenDesign.portraitSmall
                                              ].contains(ScreenIdentifier
                                                      .indentify(context))
                                                  ? FontConfigs.h2TextStyleBlack
                                                  : FontConfigs.h1TextStyle,
                                              maxLines: 1,
                                            ),
                                          ],
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            widget.flashCardCollection
                                                .answerLanguage,
                                            textAlign: TextAlign.start,
                                            style: FontConfigs.h2TextStyle,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    color: Palette.grey,
                                    thickness: 1,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.calendar_month_outlined,
                                                color: Palette
                                                    .descriptionIconColor,
                                              ),
                                            ),
                                            Text(
                                              'Created : ',
                                              textAlign: TextAlign.start,
                                              style: [
                                                ScreenDesign.landscapeSmall,
                                                ScreenDesign.portraitSmall
                                              ].contains(ScreenIdentifier
                                                      .indentify(context))
                                                  ? FontConfigs.h2TextStyleBlack
                                                  : FontConfigs.h1TextStyle,
                                              maxLines: 1,
                                            ),
                                          ],
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            ViewConfig.formatDate(widget
                                                .flashCardCollection.createdAt),
                                            textAlign: TextAlign.start,
                                            style: FontConfigs.h2TextStyle,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    color: Palette.grey,
                                    thickness: 1,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.web_stories_outlined,
                                                color: Palette
                                                    .descriptionIconColor,
                                              ),
                                            ),
                                            Text(
                                              'Flashcards : ',
                                              textAlign: TextAlign.start,
                                              style: [
                                                ScreenDesign.landscapeSmall,
                                                ScreenDesign.portraitSmall
                                              ].contains(ScreenIdentifier
                                                      .indentify(context))
                                                  ? FontConfigs.h2TextStyleBlack
                                                  : FontConfigs.h1TextStyle,
                                              maxLines: 1,
                                            ),
                                          ],
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            widget.flashCardCollection
                                                .flashCardSet.length
                                                .toString(),
                                            textAlign: TextAlign.start,
                                            style: FontConfigs.h2TextStyle,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    color: Palette.grey,
                                    thickness: 1,
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: GestureDetector(
                                      onTap: () {
                                        /// ===================================[Export]===========
                                        ExtensionDialog.showExportDialog(
                                            context);
                                      },
                                      child: Container(
                                        height: SizeConfig.getMediaHeight(
                                            context,
                                            p: [
                                              ScreenDesign.landscape,
                                              ScreenDesign.landscapeSmall
                                            ].contains(
                                                    ScreenIdentifier.indentify(
                                                        context))
                                                ? 0.15
                                                : 0.06),
                                        width: SizeConfig.getMediaWidth(context,
                                            p: 0.6),
                                        decoration: BoxDecoration(
                                            color: Palette.green200,
                                            border: Border.all(
                                                color: Palette.grey, width: 1),
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.import_export,
                                              color: Palette.grey800,
                                            ),
                                            Text(
                                              'Export FlashCards',
                                              style:
                                                  FontConfigs.h2TextStyleBlack,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    color: Palette.grey,
                                    thickness: 1,
                                  ),
                                  GuideProvider.wrapInGuideIfNeeded(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: GestureDetector(
                                        onTap: openQuiz,
                                        child: Container(
                                          height: SizeConfig.getMediaHeight(
                                              context,
                                              p: [
                                                ScreenDesign.landscape,
                                                ScreenDesign.landscapeSmall
                                              ].contains(ScreenIdentifier
                                                      .indentify(context))
                                                  ? 0.15
                                                  : 0.06),
                                          width: SizeConfig.getMediaWidth(
                                              context,
                                              p: 0.6),
                                          decoration: BoxDecoration(
                                              color: Palette.green200,
                                              border: Border.all(
                                                  color: Palette.grey,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(25)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.quiz_outlined,
                                                color: Palette.grey800,
                                              ),
                                              Text(
                                                'Start Quiz',
                                                style: FontConfigs
                                                    .h2TextStyleBlack,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    guideText: 'tap to start quiz',
                                    onHighlightTap: () {
                                      GuideProvider.introController
                                          .close()
                                          .then((value) => openQuiz(
                                              isTutorial: widget.isTutorial));
                                    },
                                    step: 6,
                                    toWrap: widget.isTutorial,
                                  ),
                                ],
                              ),
                            ))),
                  ),
                ),

                /// =================== [Flashcard List] ===================

                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 32.0,
                      horizontal: SizeConfig.getMediaWidth(context, p: 0.05)),
                  child: Column(
                    children: [
                      for (var flashCard in widget
                          .flashCardCollection.flashCardSet
                          .toList()
                          .reversed)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: SizeConfig.getMediaWidth(context, p: 0.89),
                              height: ScreenIdentifier.isLandscapeRelative(
                                      context)
                                  // rules for landscape
                                  ? SizeConfig.getMediaHeight(context, p: 0.5)
                                  // rules for portrait
                                  : SizeConfig.getMediaHeight(context,
                                      p: ScreenIdentifier.isPortraitSmall(
                                              context)
                                          ? 0.3
                                          : 0.25),
                              child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Palette.grey400, width: 1),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Align(
                                              alignment: Alignment.center,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    SizedBox(
                                                      width: SizeConfig
                                                          .getMediaWidth(
                                                              context,
                                                              p: 0.6),
                                                      child:
                                                          SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: Text(
                                                          flashCard.question,
                                                          style: FontConfigs
                                                              .h2TextStyleBlack
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                        ),
                                                      ),
                                                    ),
                                                    IconButton(
                                                        onPressed: () {
                                                          TextToSpeechWrapper
                                                              .onPressed(
                                                                  flashCard
                                                                      .question,
                                                                  FlashCardProvider
                                                                      .fc
                                                                      .questionLanguage);
                                                        },
                                                        icon: const Icon(Icons
                                                            .volume_up_outlined)),
                                                  ],
                                                ),
                                              )),
                                        ],
                                      ),
                                      const Divider(
                                        thickness: 1,
                                        height: 1,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Align(
                                              alignment: Alignment.center,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    SizedBox(
                                                      width: SizeConfig
                                                          .getMediaWidth(
                                                              context,
                                                              p: 0.6),
                                                      child:
                                                          SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: Text(
                                                          flashCard.answer,
                                                          style: FontConfigs
                                                              .h2TextStyleBlack,
                                                        ),
                                                      ),
                                                    ),
                                                    IconButton(
                                                        onPressed: () {
                                                          TextToSpeechWrapper
                                                              .onPressed(
                                                                  flashCard
                                                                      .answer,
                                                                  FlashCardProvider
                                                                      .fc
                                                                      .answerLanguage);
                                                        },
                                                        icon: const Icon(Icons
                                                            .volume_up_outlined)),
                                                  ],
                                                ),
                                              )),
                                        ],
                                      ),
                                      const Divider(
                                        thickness: 1,
                                        height: 1,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              RichText(
                                                overflow: TextOverflow.ellipsis,
                                                text: TextSpan(
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Palette.black),
                                                  children: [
                                                    WidgetSpan(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    2.0),
                                                        child: Icon(
                                                            Icons.check_circle,
                                                            size: 16,
                                                            color:
                                                                Palette.green),
                                                      ),
                                                    ),
                                                    TextSpan(
                                                        text:
                                                            'Correct: ${flashCard.correctAnswers}',
                                                        style: FontConfigs
                                                            .h2TextStyle),
                                                  ],
                                                ),
                                              ),
                                              RichText(
                                                textAlign: TextAlign.left,
                                                overflow: TextOverflow.ellipsis,
                                                text: TextSpan(
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Palette.grey),
                                                  children: [
                                                    WidgetSpan(
                                                      alignment:
                                                          PlaceholderAlignment
                                                              .middle,
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      2.0),
                                                          child: flashCard.wrongAnswers ==
                                                                      0 &&
                                                                  flashCard
                                                                      .isLearned
                                                              ? Icon(
                                                                  Icons
                                                                      .check_circle,
                                                                  size: 16,
                                                                  color: Palette
                                                                      .green)
                                                              : Icon(
                                                                  Icons
                                                                      .cancel_outlined,
                                                                  size: 16,
                                                                  color: Palette
                                                                      .deepPurple)),
                                                    ),
                                                    WidgetSpan(
                                                      alignment:
                                                          PlaceholderAlignment
                                                              .middle,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    2.0),
                                                        child: Text(
                                                            'Wrong: ${flashCard.wrongAnswers}',
                                                            style: FontConfigs
                                                                .h2TextStyle),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              if (ScreenIdentifier.indentify(
                                                      context) !=
                                                  ScreenDesign.portraitSmall)
                                                RichText(
                                                  textAlign: TextAlign.left,
                                                  overflow: TextOverflow.fade,
                                                  text: TextSpan(
                                                    style:
                                                        FontConfigs.h2TextStyle,
                                                    children: [
                                                      WidgetSpan(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      2.0),
                                                          child: Icon(
                                                              flashCard.isLearned
                                                                  ? Icons
                                                                      .check_circle
                                                                  : Icons
                                                                      .cancel_outlined,
                                                              size: 16,
                                                              color: flashCard
                                                                      .isLearned
                                                                  ? Palette
                                                                      .green
                                                                  : Palette
                                                                      .deepPurple),
                                                        ),
                                                      ),
                                                      TextSpan(
                                                          text: flashCard
                                                                  .isLearned
                                                              ? 'Learned'
                                                              : 'Unlearned',
                                                          style: FontConfigs
                                                              .h2TextStyle),
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ]));
  }

  void openQuiz({bool isTutorial = false}) {
    if (widget.flashCardCollection.isLearned) {
      MyRouter.pushPage(
        context,
        QuizTrainer(
          numberOfFlashCards: widget.flashCardCollection.flashCardSet.length,
          mode: QuizMode.learned,
          fCollection: widget.flashCardCollection,
          fromPage: 'collection',
          isTutorial: isTutorial
        ),
      );
    } else if (widget.flashCardCollection.isEmpty) {
      OverlayNotificationProvider.showOverlayNotification(
          'This collection is empty',
          status: NotificationStatus.info);
    } else {
      MyRouter.pushPage(
        context,
        QuizTrainer(
          numberOfFlashCards: widget.flashCardCollection.flashCardSet.length,
          mode: QuizMode.all,
          fCollection: widget.flashCardCollection,
          fromPage: 'collection',
          isTutorial: isTutorial

        ),
      );
    }
  }
}
