import 'package:flashcards_reader/bloc/flashcards_bloc/flashcards_bloc.dart';
import 'package:flashcards_reader/bloc/translator_bloc/translator_bloc.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/util/enums.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/views/flashcards/flashcards/add_flashcard_widget.dart';
import 'package:flashcards_reader/views/flashcards/flashcards/select_language_widget.dart';
import 'package:flashcards_reader/views/flashcards/tts_widget.dart';
import 'package:flashcards_reader/views/flashcards/new_word/add_word_collection_provider.dart';
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
  showUpdateFlashCardMenu(BuildContext context) async {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (BuildContext context, setState) {
            return FlashCardCreatingWall(isEdit: edit);
          });
        });
  }
}

// ignore: must_be_immutable
class FlashCardCreatingWall extends StatefulWidget {
  FlashCardCreatingWall({super.key, this.isEdit = false});
  bool isEdit = false;

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
            child: FlashCardCreatingWallView(isEdit: widget.isEdit)));
  }
}

// ignore: must_be_immutable
class FlashCardCreatingWallView extends StatefulWidget {
  FlashCardCreatingWallView({super.key, this.isEdit = false});
  bool isEdit;
  FlashCardFormController flashCardFormController = FlashCardFormController();
  WordFormContoller wordFormContoller = WordFormContoller();
  @override
  State<FlashCardCreatingWallView> createState() =>
      _FlashCardCreatingWallViewState();
}

class _FlashCardCreatingWallViewState extends State<FlashCardCreatingWallView> {
  bool _isPressed = false;

  String oldWord = '';

  // =====================================[WALL]==[BUILD]=====================================
  @override
  Widget build(BuildContext context) {
    widget.flashCardFormController.setUp(FlashCardCreatingUIProvider.fc);
    widget.wordFormContoller.setUp(WordCreatingUIProvider.tmpFlashCard);
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
                      FlashCardCreatingUIProvider.fc.title = text;
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
                    for (var flashCard in FlashCardCreatingUIProvider
                        .fc.flashCardSet
                        .toList()
                        .reversed)
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
                                                                flashCard
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
                                                                flashCard
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
                                                  FlashCardCreatingUIProvider
                                                      .fc.flashCardSet
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

  void callback() {
    setState(() {});
  }

  void saveCollectionFromWord({required bool onSubmitted}) {
    updateWord(onSubmitted: onSubmitted);
    if (FlashCardCreatingUIProvider.fc.isValid) {
      context.read<FlashCardBloc>().add(UpdateFlashCardEvent(
          flashCardCollection: FlashCardCreatingUIProvider.fc..id = uuid.v4()));
    } else {
      showValidatorMessage();
    }
  }

  void showValidatorMessage() {
    if (FlashCardCreatingUIProvider.fc.title.isEmpty) {
      OverlayNotificationProvider.showOverlayNotification(
          'Add collection title',
          status: NotificationStatus.info);

      debugPrint('title');
    } else if (FlashCardCreatingUIProvider.fc.isEmpty) {
      OverlayNotificationProvider.showOverlayNotification(
          'Add at least one flashcard',
          status: NotificationStatus.info);

      debugPrint('Add at least one flashcard');
    } else if (FlashCardCreatingUIProvider.fc.answerLanguage.isEmpty) {
      OverlayNotificationProvider.showOverlayNotification(
          'Add question language',
          status: NotificationStatus.info);

      debugPrint('Add question language');
    } else if (FlashCardCreatingUIProvider.fc.answerLanguage.isEmpty) {
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

  Widget loadTranslate() {
    return const Icon(Icons.translate);
  }

  void updateWord({bool onSubmitted = false}) {
    var flash = WordCreatingUIProvider.tmpFlashCard;
    if (onSubmitted && flash.answer.isEmpty && flash.question.isEmpty) {
      debugPrintIt('on submitted and word empty, do nothing');
    } else if (WordCreatingUIProvider.tmpFlashCard.isValid) {
      debugPrint('add flashcard');

      WordCreatingUIProvider.setQuestionLanguage(
          FlashCardCreatingUIProvider.fc.questionLanguage);
      WordCreatingUIProvider.setAnswerLanguage(
          FlashCardCreatingUIProvider.fc.answerLanguage);

      FlashCardCreatingUIProvider.fc.flashCardSet
          .add(WordCreatingUIProvider.tmpFlashCard);
      WordCreatingUIProvider.clear();
      OverlayNotificationProvider.showOverlayNotification('word added',
          status: NotificationStatus.success);

      setState(() {});
    } else {
      if (WordCreatingUIProvider.tmpFlashCard.question.isEmpty) {
        OverlayNotificationProvider.showOverlayNotification('add word',
            status: NotificationStatus.info);
      } else if (WordCreatingUIProvider.tmpFlashCard.answer.isEmpty) {
        OverlayNotificationProvider.showOverlayNotification(
            'tap translate button',
            status: NotificationStatus.info);
      } else {
        // ====================[save whole collection]
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
            color: ConfigFashAddWordView.menuColor,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          ),
          child: const Center(
            child: Text(
              'Save collection',
              style: TextStyle(fontSize: 20, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        onTap: () {
          if (FlashCardCreatingUIProvider.fc.isValid) {
            debugPrint('=====================add collection');
            context.read<FlashCardBloc>().add(UpdateFlashCardEvent(
                flashCardCollection: FlashCardCreatingUIProvider.fc));
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
            showValidatorMessage();
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
                        saveCollectionFromWord(onSubmitted: false);
                      },
                      icon: const Icon(Icons.add_circle_outlined)),
                  Expanded(
                    child: BlocProvider(
                      create: (context) => TranslatorBloc(),
                      child: TextField(
                        controller: widget.wordFormContoller.questionController,
                        decoration: InputDecoration(
                          labelText: 'Add Word',
                          labelStyle: FontConfigs.h3TextStyle,
                        ),
                        onChanged: (text) {
                          WordCreatingUIProvider.setQuestion(text);
                          debugPrintIt('text: $text');
                          // set the word
                          oldWord = text;
                          debugPrintIt('wait for 5 seconds');
                          Future.delayed(const Duration(milliseconds: 100))
                              .then((value) {
                            if (oldWord == text) {
                              debugPrintIt('user stopped typing');
                              debugPrintIt(
                                  'translate: $oldWord to ${FlashCardCreatingUIProvider.fc.answerLanguage}');
                              BlocProvider.of<TranslatorBloc>(context).add(
                                  TranslateEvent(
                                      text: text,
                                      fromLan: FlashCardCreatingUIProvider
                                          .fc.questionLanguage,
                                      toLan: FlashCardCreatingUIProvider
                                          .fc.answerLanguage));
                            } else if (oldWord.isEmpty || text.isEmpty) {
                              debugPrintIt('user cleared the text');
                              BlocProvider.of<TranslatorBloc>(context)
                                  .add(ClearTranslateEvent());
                            } else if (oldWord != text) {
                              debugPrintIt('user is still typing');
                            }
                          });
                        },
                        onSubmitted: (value) {
                          saveCollectionFromWord(onSubmitted: true);
                          context
                              .read<TranslatorBloc>()
                              .add(ClearTranslateEvent());
                        },
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          WordCreatingUIProvider.clear();
                        });
                      },
                      icon: const Icon(Icons.delete_sweep_outlined)),
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
                        context
                            .read<TranslatorBloc>()
                            .add(ClearTranslateEvent());
                      },
                      icon: loadTranslate()),
                  Expanded(
                    child: BlocListener<TranslatorBloc, TranslatorInitial>(
                      listener: (context, state) {
                        widget.wordFormContoller.answerController.text =
                            state.result;
                        WordCreatingUIProvider.setAnswer(state.result);
                        debugPrintIt(
                            'answer changed to ${state.result} from translate');

                        if (WordCreatingUIProvider
                            .tmpFlashCard.answer.isEmpty) {
                          widget.wordFormContoller.answerController.text =
                              state.result;
                          WordCreatingUIProvider.setAnswer(state.result);
                          debugPrintIt(
                              'answer changed to ${state.result} from translate');
                        }
                      },
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
                          saveCollectionFromWord(onSubmitted: true);
                        },
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          WordCreatingUIProvider.clear();
                        });
                      },
                      icon: const Icon(Icons.delete_sweep_outlined)),
                ],
              )
            ],
          )),
    );
  }
}
