import 'package:flashcards_reader/main.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/util/router.dart';
import 'package:flashcards_reader/views/flashcards/quiz/quiz_menu.dart';
import 'package:flashcards_reader/views/flashcards/quiz/quiz_process.dart';
import 'package:flashcards_reader/views/overlay_notification.dart';
import 'package:flashcards_reader/views/view_config.dart';
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

  showFlashCardViewMenu(BuildContext specialContext) async {
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
    super.key,
  });
  BuildContext specialContext;

  FlashCardCollection flashCardCollection;
  @override
  State<FlashCardViewWall> createState() => _FlashCardViewWallState();
}

class _FlashCardViewWallState extends State<FlashCardViewWall> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: CardViewConfig.defaultCardColor,
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
                  color: ConfigFlashcardView.descriptionIconColor,
                ),
                Text(
                  'drag to hide menu',
                  style: FontConfigs.h2TextStyle,
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: ConfigFlashcardView.descriptionIconColor,
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.grey,
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
                                    color: Colors.grey.shade400, width: 1),
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
                                              padding: EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.verified_outlined,
                                                color: ConfigFlashcardView
                                                    .descriptionIconColor,
                                              ),
                                            ),
                                            Text(
                                              'Flashcard Title : ',
                                              textAlign: TextAlign.start,
                                              style: FontConfigs.h1TextStyle,
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
                                  const Divider(
                                    color: Colors.grey,
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
                                              padding: EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.language,
                                                color: ConfigFlashcardView
                                                    .descriptionIconColor,
                                              ),
                                            ),
                                            Text(
                                              'Question Language : ',
                                              textAlign: TextAlign.start,
                                              style: FontConfigs.h1TextStyle,
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
                                              padding: EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.translate,
                                                color: ConfigFlashcardView
                                                    .descriptionIconColor,
                                              ),
                                            ),
                                            Text(
                                              'Answer Language : ',
                                              textAlign: TextAlign.start,
                                              style: FontConfigs.h1TextStyle,
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
                                  const Divider(
                                    color: Colors.grey,
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
                                              padding: EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.calendar_month_outlined,
                                                color: ConfigFlashcardView
                                                    .descriptionIconColor,
                                              ),
                                            ),
                                            Text(
                                              'Created : ',
                                              textAlign: TextAlign.start,
                                              style: FontConfigs.h1TextStyle,
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
                                  const Divider(
                                    color: Colors.grey,
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
                                              padding: EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.web_stories_outlined,
                                                color: ConfigFlashcardView
                                                    .descriptionIconColor,
                                              ),
                                            ),
                                            Text(
                                              'Flashcards : ',
                                              textAlign: TextAlign.start,
                                              style: FontConfigs.h1TextStyle,
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
                                  const Divider(
                                    color: Colors.grey,
                                    thickness: 1,
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: GestureDetector(
                                      onTap: () {
                                        if (widget
                                            .flashCardCollection.isLearned) {
                                          OverlayNotificationProvider
                                              .showOverlayNotification(
                                                  'This collection is already learned',
                                                  status:
                                                      NotificationStatus.info);
                                        } else if (widget
                                            .flashCardCollection.isEmpty) {
                                          OverlayNotificationProvider
                                              .showOverlayNotification(
                                                  'This collection is empty',
                                                  status:
                                                      NotificationStatus.info);
                                        } else {
                                          MyRouter.pushPage(
                                            context,
                                            QuizTrainer(
                                              numberOfFlashCards: widget
                                                  .flashCardCollection
                                                  .flashCardSet
                                                  .length,
                                              mode: QuizModeProvider.mode,
                                              fCollection:
                                                  widget.flashCardCollection,
                                              fromPage: 'collection',
                                            ),
                                          );
                                        }
                                      },
                                      child: Container(
                                        height: SizeConfig.getMediaHeight(
                                            context,
                                            p: 0.06),
                                        width: SizeConfig.getMediaWidth(context,
                                            p: 0.6),
                                        decoration: BoxDecoration(
                                            color: Colors.green.shade200,
                                            border: Border.all(
                                                color: Colors.grey, width: 1),
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.quiz_outlined,
                                              color: ConfigFlashcardView
                                                  .quizIconColor,
                                            ),
                                            const Text(
                                              'Start Quiz',
                                              style:
                                                  FontConfigs.h2TextStyleBlack,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
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
                      for (var flashCard
                          in widget.flashCardCollection.flashCardSet.toList())
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              height:
                                  SizeConfig.getMediaHeight(context, p: 0.2),
                              width: SizeConfig.getMediaWidth(context, p: 0.89),
                              child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade400,
                                          width: 1),
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
                                              child: Text(
                                                flashCard.questionWords,
                                                style: FontConfigs
                                                    .h2TextStyleBlack
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w500),
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
                                              child: Text(
                                                flashCard.answerWords,
                                                style: FontConfigs
                                                    .h2TextStyleBlack,
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
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black),
                                                  children: [
                                                    const WidgetSpan(
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    2.0),
                                                        child: Icon(
                                                            Icons.check_circle,
                                                            size: 16,
                                                            color:
                                                                Colors.green),
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
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey),
                                                  children: [
                                                    WidgetSpan(
                                                      alignment:
                                                          PlaceholderAlignment
                                                              .middle,
                                                      child: Padding(
                                                          padding: EdgeInsets
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
                                                                  color: Colors
                                                                      .green)
                                                              : Icon(
                                                                  Icons
                                                                      .cancel_outlined,
                                                                  size: 16,
                                                                  color: Colors
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
                                                                ? Colors.green
                                                                : Colors
                                                                    .deepPurple),
                                                      ),
                                                    ),
                                                    TextSpan(
                                                        text:
                                                            flashCard.isLearned
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
                                      )
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
}
