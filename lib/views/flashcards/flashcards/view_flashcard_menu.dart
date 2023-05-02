import 'package:flashcards_reader/main.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/model/entities/translator/api.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/util/router.dart';
import 'package:flashcards_reader/views/flashcards/flashcards/add_flashcard_widget.dart';
import 'package:flashcards_reader/views/flashcards/quiz/quiz_menu.dart';
import 'package:flashcards_reader/views/flashcards/quiz/quiz_process.dart';
import 'package:flashcards_reader/views/overlay_notification.dart';
import 'package:flashcards_reader/views/view_config.dart';
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
    return SizedBox(
        height: SizeConfig.getMediaHeight(context, p: 0.8),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: SizeConfig.getMediaHeight(context, p: 0.03)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.arrow_drop_down),
                Text(
                  'Drag to hide menu',
                  style: TextStyle(fontSize: 20),
                ),
                Icon(Icons.arrow_drop_down),
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
                        width: SizeConfig.getMediaWidth(context, p: 0.8),
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
                                          children: const [
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Icon(Icons.verified),
                                            ),
                                            Text(
                                              'Flashcard Title : ',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(fontSize: 18),
                                              maxLines: 1,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: SizeConfig.getMediaWidth(
                                              context,
                                              p: 0.3),
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                widget
                                                    .flashCardCollection.title,
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(
                                                    fontSize: 18),
                                                maxLines: 1,
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
                                          children: const [
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Icon(Icons.language),
                                            ),
                                            Text(
                                              'Question Language : ',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(fontSize: 16),
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
                                            style:
                                                const TextStyle(fontSize: 16),
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
                                          children: const [
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Icon(Icons.translate),
                                            ),
                                            Text(
                                              'Answer Language : ',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(fontSize: 16),
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
                                            style:
                                                const TextStyle(fontSize: 16),
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
                                          children: const [
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Icon(Icons
                                                  .calendar_month_outlined),
                                            ),
                                            Text(
                                              'Created : ',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(fontSize: 16),
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
                                            style:
                                                const TextStyle(fontSize: 16),
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
                                          children: const [
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Icon(
                                                  Icons.web_stories_outlined),
                                            ),
                                            Text(
                                              'Flashcards : ',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(fontSize: 16),
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
                                            style:
                                                const TextStyle(fontSize: 16),
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
                                            p: 0.4),
                                        decoration: BoxDecoration(
                                            color: Colors.blueGrey.shade100,
                                            border: Border.all(
                                                color: Colors.grey.shade600,
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(Icons.quiz_outlined),
                                            Text(
                                              'Start Quiz',
                                              style: TextStyle(fontSize: 16),
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
                      vertical: 8.0,
                      horizontal: SizeConfig.getMediaWidth(context, p: 0.05)),
                  child: Column(
                    children: [
                      for (var flashCard
                          in widget.flashCardCollection.flashCardSet.toList())
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            height: SizeConfig.getMediaHeight(context, p: 0.1),
                            width: SizeConfig.getMediaWidth(context, p: 0.7),
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey.shade400, width: 1),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: SizeConfig.getMediaWidth(context,
                                          p: 0.2),
                                      child: Align(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Text(
                                                  flashCard.answerWords,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                  ),
                                                  maxLines: 1,
                                                )),
                                            SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Text(
                                                  flashCard.questionWords,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                  ),
                                                  maxLines: 1,
                                                ))
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            const Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text('Status',
                                                    style: TextStyle())),
                                            RichText(
                                              textAlign: TextAlign.left,
                                              overflow: TextOverflow.fade,
                                              text: TextSpan(
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white),
                                                children: [
                                                  WidgetSpan(
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 2.0),
                                                      child: Icon(
                                                          flashCard.isLearned
                                                              ? Icons
                                                                  .check_circle_sharp
                                                              : Icons.cancel,
                                                          size: 16,
                                                          color: flashCard
                                                                  .isLearned
                                                              ? Colors.green
                                                              : Colors
                                                                  .deepPurple),
                                                    ),
                                                  ),
                                                  TextSpan(
                                                      text: flashCard.isLearned
                                                          ? 'Learned'
                                                          : 'Unlearned',
                                                      style: const TextStyle(
                                                          color: Colors.black)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Align(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          const Text('Answers',
                                              style: TextStyle(
                                                  color: Colors.black)),
                                          RichText(
                                            overflow: TextOverflow.ellipsis,
                                            text: TextSpan(
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black),
                                              children: [
                                                const WidgetSpan(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 2.0),
                                                    child: Icon(
                                                        Icons.check_circle,
                                                        size: 16,
                                                        color: Colors.green),
                                                  ),
                                                ),
                                                TextSpan(
                                                    text:
                                                        'Correct: ${flashCard.correctAnswers}',
                                                    style: const TextStyle(
                                                        color: Colors.black)),
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
                                                const WidgetSpan(
                                                  alignment:
                                                      PlaceholderAlignment
                                                          .middle,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 2.0),
                                                    child: Icon(Icons.cancel,
                                                        size: 16,
                                                        color:
                                                            Colors.deepPurple),
                                                  ),
                                                ),
                                                WidgetSpan(
                                                  alignment:
                                                      PlaceholderAlignment
                                                          .middle,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 2.0),
                                                    child: Text(
                                                        'Wrong: ${flashCard.wrongAnswers}',
                                                        style: const TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.black)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
