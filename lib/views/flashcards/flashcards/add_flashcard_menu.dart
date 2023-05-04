import 'package:flashcards_reader/bloc/flashcards_bloc/flashcards_bloc.dart';
import 'package:flashcards_reader/main.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/model/entities/translator/api.dart';
import 'package:flashcards_reader/util/constants.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/util/internet_checker.dart';
import 'package:flashcards_reader/views/flashcards/flashcards/add_flashcard_widget.dart';
import 'package:flashcards_reader/views/flashcards/flashcards/select_language_widget.dart';
import 'package:flashcards_reader/views/overlay_notification.dart';
import 'package:flashcards_reader/views/view_config.dart';
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

  void setUp(FlashCard flashCard) {
    // update controller text
    questionController.text = flashCard.questionWords;
    answerController.text = flashCard.answerWords;

    // set cursor to the end of the text

    questionController.selection = TextSelection.fromPosition(
        TextPosition(offset: flashCard.questionWords.length));
    answerController.selection = TextSelection.fromPosition(
        TextPosition(offset: flashCard.answerWords.length));
  }
}

class UpdateFlashCardBottomSheet {
  UpdateFlashCardBottomSheet(
      {FlashCardCollection? creatingFlashC, this.edit = false}) {
    if (creatingFlashC != null) {
      debugPrintIt('create copy of flashcard collection');
      flashCardCollection = creatingFlashC.copy();
    } else {
      debugPrintIt('create flashFixture');
      flashCardCollection = flashExample();
    }
  }
  bool edit;

  late FlashCardCollection flashCardCollection;
// =================================[SHOWMODAL SHEETS]================
  showUpdateFlashCardMenu(BuildContext specialContext) async {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        context: specialContext,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (BuildContext context, setState) {
            return FlashCardCreatingWall(specialContext, flashCardCollection,
                isEdit: edit);
          });
        });
  }
}

// ignore: must_be_immutable
class FlashCardCreatingWall extends StatefulWidget {
  FlashCardCreatingWall(this.specialContext, this.flashCardCollection,
      {super.key, this.isEdit = false});
  bool isEdit;
  BuildContext specialContext;
  FlashCardFormController flashCardFormController = FlashCardFormController();
  WordFormContoller wordFormContoller = WordFormContoller();
  GoogleTranslatorAPIWrapper translator = GoogleTranslatorAPIWrapper();
  FlashCardCollection flashCardCollection;
  @override
  State<FlashCardCreatingWall> createState() => _FlashCardCreatingWallState();
}

class _FlashCardCreatingWallState extends State<FlashCardCreatingWall> {
  bool _isPressed = false;
  bool _oldPress = false;

  void callback() {
    setState(() {});
  }

  Widget loadTranslate() {
    if (_isPressed != _oldPress) {
      _oldPress = _isPressed;
      return TranslateButton(widget: widget, callback: callback);
    }
    return const Icon(Icons.translate);
  }

  void updateCollection() {
    if (WordCreatingUIProvider.tmpFlashCard.isValid) {
      debugPrint('add flashcard');

      WordCreatingUIProvider.setQuestionLanguage(
          widget.flashCardCollection.questionLanguage);
      WordCreatingUIProvider.setAnswerLanguage(
          widget.flashCardCollection.answerLanguage);

      widget.flashCardCollection.flashCardSet
          .add(WordCreatingUIProvider.tmpFlashCard);
      WordCreatingUIProvider.clear();
      OverlayNotificationProvider.showOverlayNotification('word added',
          status: NotificationStatus.success);

      setState(() {});
    } else {
      if (WordCreatingUIProvider.tmpFlashCard.answerWords.isEmpty) {
        OverlayNotificationProvider.showOverlayNotification('add translation',
            status: NotificationStatus.info);
      } else if (WordCreatingUIProvider.tmpFlashCard.questionWords.isEmpty) {
        OverlayNotificationProvider.showOverlayNotification('add word',
            status: NotificationStatus.info);
      }

      debugPrint('not valid');
    }
  }

  Widget addCollectionButton() {
    return Center(
      child: GestureDetector(
        child: Container(
          height: SizeConfig.getMediaHeight(context, p: 0.1),
          width: SizeConfig.getMediaWidth(context, p: 0.8),
          decoration: BoxDecoration(
            color: Colors.green.shade300,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          ),
          child: const Center(
            child: Text(
              'Update collection',
              style: TextStyle(fontSize: 20, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        onTap: () {
          if (widget.flashCardCollection.isValid) {
            debugPrint('=====================add collection');
            widget.specialContext.read<FlashCardBloc>().add(
                UpdateFlashCardEvent(
                    flashCardCollection: widget.flashCardCollection));
            Navigator.pop(context);
            FlashCardCreatingUIProvider.clear();
            widget.isEdit
                ? OverlayNotificationProvider.showOverlayNotification(
                    'Collection edited',
                    status: NotificationStatus.info)
                : OverlayNotificationProvider.showOverlayNotification(
                    'Collection added',
                    status: NotificationStatus.success);
          } else {
            OverlayNotificationProvider.showOverlayNotification(
                'Your collection not valid',
                status: NotificationStatus.warning);

            debugPrint('flash not valid');
          }
        },
      ),
    );
  }

  Widget addWordWidget() {
    return Transform.scale(
      scale: 0.9,
      child: Container(
          height: SizeConfig.getMediaHeight(context, p: 0.17),
          width: SizeConfig.getMediaWidth(context, p: 1),
          decoration: BoxDecoration(
            color: Colors.green.shade200,

            // rounded full border
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () {
                        updateCollection();
                      },
                      icon: const Icon(Icons.add_circle_outlined)),
                  Expanded(
                    child: TextField(
                      controller: widget.wordFormContoller.questionController,
                      decoration: InputDecoration(
                        labelText: 'Add Word',
                        labelStyle: FontConfigs.h3TextStyle,
                      ),
                      onChanged: (text) {
                        WordCreatingUIProvider.setQuestion(text);
                      },
                      onSubmitted: (value) {
                        updateCollection();
                      },
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          WordCreatingUIProvider.clear();
                        });
                      },
                      icon: const Icon(Icons.delete_sweep_outlined))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () {
                        _isPressed = !_isPressed;

                        setState(() {
                          debugPrintIt('pressed');
                        });
                      },
                      icon: loadTranslate()),
                  Expanded(
                    child: TextField(
                      controller: widget.wordFormContoller.answerController,
                      decoration: InputDecoration(
                        labelText: 'Add Translation',
                        labelStyle: FontConfigs.h3TextStyle,
                      ),
                      onChanged: (text) {
                        WordCreatingUIProvider.setAnswer(text);
                      },
                      onSubmitted: (value) {
                        updateCollection();
                      },
                    ),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.record_voice_over_outlined))
                ],
              )
            ],
          )),
    );
  }

// =====================================[WALL]==[BUILD]=====================================
  @override
  Widget build(BuildContext context) {
    widget.flashCardFormController.setUp(widget.flashCardCollection);
    widget.wordFormContoller.setUp(WordCreatingUIProvider.tmpFlashCard);
    return Container(
        decoration: BoxDecoration(
          color: CardViewConfig.defaultCardColor,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        ),
        height: SizeConfig.getMediaHeight(context,
            p: widget.flashCardCollection.isEmpty ? 0.55 : 0.85),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: SizeConfig.getMediaHeight(context, p: 0.01)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.arrow_drop_down),
                Text(
                  widget.isEdit
                      ? 'Drag to cancel editing'
                      : 'Drag to cancel adding',
                  style: FontConfigs.h2TextStyle,
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
          addWordWidget(),
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
                      widget.flashCardCollection.title = text;
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
                          Text(
                            'question language',
                            style: FontConfigs.h3TextStyle,
                          ),
                          SelectLanguageDropdown(
                            flashCardCollection: widget.flashCardCollection,
                            langDestination: 'from',
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            'answer language',
                            style: FontConfigs.h3TextStyle,
                          ),
                          SelectLanguageDropdown(
                            flashCardCollection: widget.flashCardCollection,
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
                        in widget.flashCardCollection.flashCardSet.toList())
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            height: SizeConfig.getMediaHeight(context, p: 0.3),
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
                                              style:
                                                  FontConfigs.h2TextStyleBlack,
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
                                                height:
                                                    SizeConfig.getMediaHeight(
                                                        context,
                                                        p: 0.05),
                                                width: SizeConfig.getMediaWidth(
                                                    context,
                                                    p: ConfigViewUpdateMenu
                                                        .wordButtonWidthPercent),
                                                decoration: BoxDecoration(
                                                    color: ConfigViewUpdateMenu
                                                        .buttonColor,
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
                                                  widget.flashCardCollection
                                                      .flashCardSet
                                                      .remove(flashCard);
                                                });
                                              },
                                            ),
                                            GestureDetector(
                                              child: Container(
                                                height:
                                                    SizeConfig.getMediaHeight(
                                                        context,
                                                        p: 0.05),
                                                width: SizeConfig.getMediaWidth(
                                                    context,
                                                    p: ConfigViewUpdateMenu
                                                        .wordButtonWidthPercent),
                                                decoration: BoxDecoration(
                                                    color: ConfigViewUpdateMenu
                                                        .buttonColor,
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
}

// ignore: must_be_immutable
class TranslateButton extends StatelessWidget {
  dynamic widget;
  Function callback;

  Future<bool>? translate() async {
    if (await InternetChecker.hasConnection()) {
      String questionWords = WordCreatingUIProvider.tmpFlashCard.questionWords;
      if (questionWords.isNotEmpty) {
        TranslateResponse answerWords = await widget.translator.translate(
            questionWords,
            from: getCode(widget.flashCardCollection.questionLanguage),
            to: getCode(widget.flashCardCollection.answerLanguage));
        WordCreatingUIProvider.setAnswer(answerWords.toString());
      } else {
        await Future.delayed(const Duration(milliseconds: 250));

        OverlayNotificationProvider.showOverlayNotification(
            'No word to translate',
            status: NotificationStatus.warning);
      }
    } else {
      await Future.delayed(const Duration(milliseconds: 250));
      OverlayNotificationProvider.showOverlayNotification(
          'No internet connection',
          status: NotificationStatus.warning);
    }
    callback();
    return true;
  }

  TranslateButton({required this.callback, required this.widget, super.key});
  @override
  Widget build(BuildContext context) {
    var translateIcon = const Icon(
      Icons.translate,
    );
    Future<bool>? result = translate();
    return FutureBuilder<bool>(
        future: result, // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          Widget childIcon;
          if (snapshot.hasData) {
            childIcon = snapshot.data == true ? translateIcon : translateIcon;
          } else {
            childIcon = Transform.scale(
              scale: 0.6,
              child: const CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.black,
              ),
            );
          }

          return childIcon;
        });
  }
}
