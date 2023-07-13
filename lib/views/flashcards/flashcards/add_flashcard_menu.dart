import 'package:flashcards_reader/bloc/flashcards_bloc/flashcards_bloc.dart';
import 'package:flashcards_reader/bloc/translator_bloc/translator_bloc.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/views/flashcards/flashcards/select_language_widget.dart';
import 'package:flashcards_reader/views/flashcards/new_word/base_new_word_widget.dart';
import 'package:flashcards_reader/views/flashcards/tts_widget.dart';
import 'package:flashcards_reader/bloc/providers/word_collection_provider.dart';
import 'package:flashcards_reader/views/overlay_notification.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlashCardFormController {
  TextEditingController titleController = TextEditingController();
  TextEditingController questionLanguageController = TextEditingController();
  TextEditingController answerLanguageController = TextEditingController();

  void setUp(FlashCardCollection flashCardCollection) {
    // update controller text
    titleController.text = flashCardCollection.title;
    questionLanguageController.text = flashCardCollection.questionLanguage;
    answerLanguageController.text = flashCardCollection.answerLanguage;

    // set cursor to the end of the text

    titleController.selection = TextSelection.fromPosition(
        TextPosition(offset: flashCardCollection.title.length));
    questionLanguageController.selection = TextSelection.fromPosition(
        TextPosition(offset: flashCardCollection.questionLanguage.length));
    answerLanguageController.selection = TextSelection.fromPosition(
        TextPosition(offset: flashCardCollection.answerLanguage.length));
  }
}

class WordFormContoller {
  TextEditingController questionController = TextEditingController();
  TextEditingController answerController = TextEditingController();

  /// add setup method in widget build method
  /// [example:
  /// wordFormContoller.setUp(WordCreatingUIProvider.tmpFlashCard);
  /// from:
  /// import 'package:flashcards_reader/bloc/providers/word_collection_provider.dart';
  void setUp(FlashCard flashCard) {
    // update controller text
    questionController.text = flashCard.question;
    answerController.text = flashCard.answer;

    // set cursor to the end of the text
    
    questionController.selection = TextSelection.fromPosition(
        TextPosition(offset: flashCard.question.length));
    answerController.selection = TextSelection.fromPosition(
        TextPosition(offset: flashCard.answer.length));
  }
}

class UpdateFlashCardBottomSheet {
  UpdateFlashCardBottomSheet({this.edit = false});
  bool edit;

// =================================[SHOWMODAL SHEETS]================
  showUpdateFlashCardMenu(
      BuildContext context, Function updateCallbackCrunch) async {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (BuildContext context, setState) {
            return FlashCardCreatingWall(
                isEdit: edit, updateCallbackCrunch: updateCallbackCrunch);
          });
        });
  }
}

// ignore: must_be_immutable
class FlashCardCreatingWall extends StatefulWidget {
  FlashCardCreatingWall(
      {super.key, this.isEdit = false, required this.updateCallbackCrunch});
  bool isEdit = false;
  final Function updateCallbackCrunch;

  @override
  State<FlashCardCreatingWall> createState() => _FlashCardCreatingWallState();
}

class _FlashCardCreatingWallState extends State<FlashCardCreatingWall> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => FlashCardBloc(),
        child: BlocProvider(
            create: (_) => TranslatorBloc(),
            child: FlashCardCreatingWallView(
                isEdit: widget.isEdit,
                updateCallbackCrunch: widget.updateCallbackCrunch)));
  }
}

// ignore: must_be_immutable
class FlashCardCreatingWallView extends StatefulWidget {
  FlashCardCreatingWallView(
      {super.key, this.isEdit = false, required this.updateCallbackCrunch});
  final Function updateCallbackCrunch;
  bool isEdit;
  FlashCardFormController flashCardFormController = FlashCardFormController();
  @override
  State<FlashCardCreatingWallView> createState() =>
      _FlashCardCreatingWallViewState();
}

class _FlashCardCreatingWallViewState extends State<FlashCardCreatingWallView> {
  String oldWord = '';

  /// =====================================[WALL]==[BUILD]=====================================
  @override
  Widget build(BuildContext context) {
    widget.flashCardFormController.setUp(FlashCardProvider.fc);
    BaseNewWordWidgetService.wordFormContoller
        .setUp(WordCreatingUIProvider.tmpFlashCard);
    return Container(
        decoration: BoxDecoration(
          color: CardViewConfig.defaultCardColor,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        ),

        /// [portrait mode]
        height: ScreenIdentifier.isPortraitRelative(context)
            ? SizeConfig.getMediaHeight(context,
                p: ScreenIdentifier.isPortrait(context) ? 0.85 : 0.95)

            /// [landscape mode]
            : SizeConfig.getMediaHeight(context, p: 0.8),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          if (ScreenIdentifier.isPortraitRelative(context))
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.getMediaHeight(context, p: 0.01)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.arrow_drop_down),
                  Text(
                    'Drag to cancel action',
                    style: FontConfigs.h2TextStyle,
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ScreenIdentifier.isPortraitRelative(context)
              ? Container(
                  /// [portrait mode]
                  height: SizeConfig.getMediaHeight(context,
                      p: ScreenIdentifier.isPortrait(context) ? 0.3 : 0.4),

                  width: SizeConfig.getMediaWidth(context, p: 1),

                  color: ConfigViewUpdateMenu.addWordMenuColor,
                  child: BaseNewWordWidgetService.addWordMenu(
                      context: context, callback: callback, oldWord: oldWord),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.rotate_right),
                      SizedBox(
                          width: SizeConfig.getMediaWidth(context, p: 0.02)),
                      Text(
                        'rotate screen to add words',
                        style: FontConfigs.h2TextStyle,
                      ),
                    ],
                  ),
                ),
          if (ScreenIdentifier.isPortraitRelative(context))
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
                  padding: EdgeInsets.only(
                      top: SizeConfig.getMediaHeight(context, p: 0.03),
                      left: SizeConfig.getMediaWidth(context, p: 0.03),
                      right: SizeConfig.getMediaWidth(context, p: 0.03)),
                  child: TextField(
                    controller: widget.flashCardFormController.titleController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Flashcard Collection Name',
                      labelStyle: FontConfigs.h3TextStyle,
                    ),
                    onChanged: (text) {
                      FlashCardProvider.fc.title = text;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          if (ScreenIdentifier.isPortraitRelative(context))
                            Text(
                              'source',
                              style: FontConfigs.h3TextStyle,
                            ),
                          SelectLanguageDropdown(
                            langDestination: 'from',
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                FlashCardProvider.fc.switchLanguages();
                              });
                              BlocProvider.of<TranslatorBloc>(context).add(
                                  TranslateEvent(
                                      text: WordCreatingUIProvider
                                          .tmpFlashCard.question,
                                      fromLan:
                                          FlashCardProvider.fc.questionLanguage,
                                      toLan:
                                          FlashCardProvider.fc.answerLanguage));
                            },
                            icon: const Icon(Icons.swap_horiz_rounded)),
                      ),
                      Column(
                        children: [
                          if (ScreenIdentifier.isPortraitRelative(context))
                            Text(
                              'translation',
                              style: FontConfigs.h3TextStyle,
                            ),
                          SelectLanguageDropdown(
                            langDestination: 'to',
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),

                /// =================== [Flashcard List] ===================

                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 32.0,
                      horizontal: SizeConfig.getMediaWidth(context, p: 0.05)),
                  child: Column(children: [
                    for (var flashCard
                        in FlashCardProvider.fc.flashCardSet.toList().reversed)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            height:

                                /// [portrait mode]
                                ScreenIdentifier.isPortraitRelative(context)
                                    ? SizeConfig.getMediaHeight(context,
                                        p: ScreenIdentifier.isPortrait(context)
                                            ? 0.3
                                            : 0.4)
                                    :

                                    /// [landscape mode]
                                    SizeConfig.getMediaHeight(context, p: 0.7),
                            width: SizeConfig.getMediaWidth(context, p: 0.89),
                            child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400, width: 1),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox.shrink(),
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
                                                        .getMediaWidth(context,
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
                                                        .getMediaWidth(context,
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
                                              if (!ScreenIdentifier
                                                  .isPortraitSmall(context))
                                                RichText(
                                                  textAlign: TextAlign.left,
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        2.0),
                                                            child: flashCard.wrongAnswers ==
                                                                        0 &&
                                                                    flashCard
                                                                        .isLearned
                                                                ? const Icon(
                                                                    Icons
                                                                        .check_circle,
                                                                    size: 16,
                                                                    color: Colors
                                                                        .green)
                                                                : const Icon(
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
                                        ]),
                                    const Divider(
                                      thickness: 1,
                                      height: 1,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            GestureDetector(
                                              child: Container(
                                                height: SizeConfig.getMediaHeight(
                                                    context,

                                                    /// [landscape mode]
                                                    p: ScreenIdentifier
                                                            .isPortraitRelative(
                                                                context)
                                                        ? 0.05

                                                        /// [portrait mode]
                                                        : 0.14),
                                                width: SizeConfig.getMediaWidth(
                                                    context,
                                                    p: ConfigViewUpdateMenu
                                                        .wordButtonWidthPercent),
                                                decoration: BoxDecoration(
                                                    color: ConfigViewUpdateMenu
                                                        .addWordMenuColor,
                                                    border: Border.all(
                                                        color: Colors
                                                            .grey.shade400,
                                                        width: 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                child: Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 4.0),
                                                        child: Icon(
                                                          Icons.delete_forever,
                                                          color: ConfigViewUpdateMenu
                                                              .buttonIconColor,
                                                        ),
                                                      ),
                                                      const Text('delete',
                                                          style: FontConfigs
                                                              .h3TextStyleBlack),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  FlashCardProvider
                                                      .fc.flashCardSet
                                                      .remove(flashCard);
                                                });
                                              },
                                            ),
                                            GestureDetector(
                                              child: Container(
                                                height: SizeConfig.getMediaHeight(
                                                    context,

                                                    /// [landscape mode]
                                                    p: ScreenIdentifier
                                                            .isPortraitRelative(
                                                                context)
                                                        ? 0.05

                                                        /// [portrait mode]
                                                        : 0.14),
                                                width: SizeConfig.getMediaWidth(
                                                    context,
                                                    p: ConfigViewUpdateMenu
                                                        .wordButtonWidthPercent),
                                                decoration: BoxDecoration(
                                                    color: ConfigViewUpdateMenu
                                                        .addWordMenuColor,
                                                    border: Border.all(
                                                        color: Colors
                                                            .grey.shade400,
                                                        width: 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                child: Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 4.0),
                                                        child: Icon(
                                                          Icons.school_outlined,
                                                          color: ConfigViewUpdateMenu
                                                              .buttonIconColor,
                                                        ),
                                                      ),
                                                      Text(
                                                          flashCard.isLearned
                                                              ? 'unlearned'
                                                              : 'learned',
                                                          style: FontConfigs
                                                              .h3TextStyleBlack),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  flashCard.isLearned
                                                      ? flashCard.reset()
                                                      : flashCard
                                                          .markAsLearned();
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox.shrink()
                                  ],
                                )),
                          ),
                        ),
                      ),
                  ]),
                ),
              ]))),
          if (ScreenIdentifier.isPortraitRelative(context))
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                color: Colors.transparent,
                height: SizeConfig.getMediaHeight(context, p: 0.08),
                width: SizeConfig.getMediaWidth(context, p: 1),
                child: Center(
                  child: addCollectionButton(),
                ),
              ),
            ),
        ]));
  }

  void callback() {
    setState(() {});
  }

  void showValidatorMessage() {
    if (FlashCardProvider.fc.title.isEmpty) {
      OverlayNotificationProvider.showOverlayNotification(
          'Add collection title',
          status: NotificationStatus.info);

      debugPrint('title');
    } else if (FlashCardProvider.fc.isEmpty) {
      OverlayNotificationProvider.showOverlayNotification(
          'Add at least one flashcard',
          status: NotificationStatus.info);

      debugPrint('Add at least one flashcard');
    } else if (FlashCardProvider.fc.answerLanguage.isEmpty) {
      OverlayNotificationProvider.showOverlayNotification('source language',
          status: NotificationStatus.info);

      debugPrint('Add question language');
    } else if (FlashCardProvider.fc.answerLanguage.isEmpty) {
      OverlayNotificationProvider.showOverlayNotification('Add answerlanguage',
          status: NotificationStatus.info);

      debugPrint('Add answerlanguage');
    } else {
      OverlayNotificationProvider.showOverlayNotification(
          'Your collection not valid',
          status: NotificationStatus.info);

      debugPrint('flash not valid');
    }
  }

  Widget addCollectionButton() {
    return Center(
      child: GestureDetector(
        child: Container(
          height: SizeConfig.getMediaHeight(context, p: 0.1),
          width: SizeConfig.getMediaWidth(context, p: 0.8),
          decoration: BoxDecoration(
            color: ConfigViewUpdateMenu.addWordMenuColor,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          ),
          child: const Center(
            child: Text(
              'Save collection',
              style: FontConfigs.h2TextStyleBlack,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        onTap: () {
          if (FlashCardProvider.fc.isValid) {
            debugPrint('=====================add collection');
            context.read<FlashCardBloc>().add(UpdateFlashCardEvent(
                flashCardCollection: FlashCardProvider.fc));
            Navigator.pop(context);
            FlashCardProvider.clear();
            widget.isEdit
                ? OverlayNotificationProvider.showOverlayNotification(
                    'Collection edited',
                    status: NotificationStatus.info)
                : OverlayNotificationProvider.showOverlayNotification(
                    'Collection added',
                    status: NotificationStatus.success);
          } else {
            showValidatorMessage();
          }
          widget.updateCallbackCrunch();
        },
      ),
    );
  }
}
