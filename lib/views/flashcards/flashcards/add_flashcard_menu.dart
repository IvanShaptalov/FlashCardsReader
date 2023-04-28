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
      flashCardCollection = flashFixture();
    }
  }
  bool edit;

  late FlashCardCollection flashCardCollection;

  showUpdateFlashCardMenu(BuildContext specialContext) async {
    showModalBottomSheet(
        // isDismissible: true,
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
  final int wordsBeforeRelocateEditor = 4;
  @override
  State<FlashCardCreatingWall> createState() => _FlashCardCreatingWallState();
}

class _FlashCardCreatingWallState extends State<FlashCardCreatingWall> {
  Widget addCollectionButton() {
    return IconButton(
        onPressed: () {
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
        icon: Icon(widget.isEdit ? Icons.edit_square : Icons.library_add));
  }

  Widget addWordWidget() {
    return Container(
        height: SizeConfig.getMediaHeight(context, p: 0.2),
        width: SizeConfig.getMediaWidth(context, p: 0.9),
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blueGrey[200],

          // rounded full border
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: const Border(
              top: BorderSide(color: Colors.grey, width: 1),
              left: BorderSide(color: Colors.grey, width: 1),
              right: BorderSide(color: Colors.grey, width: 1),
              bottom: BorderSide(color: Colors.grey, width: 1)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      if (WordCreatingUIProvider.tmpFlashCard.isValid) {
                        debugPrint('add flashcard');

                        WordCreatingUIProvider.setQuestionLanguage(
                            widget.flashCardCollection.questionLanguage);
                        WordCreatingUIProvider.setAnswerLanguage(
                            widget.flashCardCollection.answerLanguage);

                        widget.flashCardCollection.flashCardSet
                            .add(WordCreatingUIProvider.tmpFlashCard);
                        WordCreatingUIProvider.clear();
                        OverlayNotificationProvider.showOverlayNotification(
                            'word added',
                            status: NotificationStatus.success);

                        setState(() {});
                      } else {
                        OverlayNotificationProvider.showOverlayNotification(
                            'word is not valid',
                            status: NotificationStatus.warning);

                        debugPrint('not valid');
                      }
                    },
                    icon: const Icon(Icons.add)),
                Expanded(
                  child: TextField(
                    controller: widget.wordFormContoller.questionController,
                    decoration: const InputDecoration(
                      labelText: 'Add Word',
                    ),
                    onChanged: (text) {
                      WordCreatingUIProvider.setQuestion(text);
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () async {
                      if (await InternetChecker.hasInternet()) {
                        String questionWords =
                            WordCreatingUIProvider.tmpFlashCard.questionWords;
                        if (questionWords.isNotEmpty) {
                          TranslateResponse answerWords =
                              await widget.translator.translate(questionWords,
                                  from: getCode(widget
                                      .flashCardCollection.questionLanguage),
                                  to: getCode(widget
                                      .flashCardCollection.answerLanguage));
                          WordCreatingUIProvider.setAnswer(
                              answerWords.toString());
                        } else {
                          OverlayNotificationProvider.showOverlayNotification(
                              'No word to translate',
                              status: NotificationStatus.warning);
                        }
                      } else {
                        OverlayNotificationProvider.showOverlayNotification(
                            'No internet connection',
                            status: NotificationStatus.warning);
                      }
                      setState(() {});
                    },
                    icon: const Icon(Icons.translate)),
                Expanded(
                  child: TextField(
                    controller: widget.wordFormContoller.answerController,
                    decoration: const InputDecoration(
                      labelText: 'Add Translation',
                    ),
                    onChanged: (text) {
                      WordCreatingUIProvider.setAnswer(text);
                    },
                  ),
                ),
              ],
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    widget.flashCardFormController.setUp(widget.flashCardCollection);
    widget.wordFormContoller.setUp(WordCreatingUIProvider.tmpFlashCard);
    return SizedBox(
        height: SizeConfig.getMediaHeight(context, p: 0.85),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: SizeConfig.getMediaHeight(context, p: 0.03)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.isEdit
                      ? 'Edit Flashcard Collection'
                      : 'Add Flashcard Collection',
                  style: const TextStyle(fontSize: 20),
                ),
                addCollectionButton(),
              ],
            ),
          ),
          if (widget.flashCardCollection.flashCardSet.length >=
              widget.wordsBeforeRelocateEditor)
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
                      left: SizeConfig.getMediaWidth(context, p: 0.05)),
                  child: TextField(
                    controller: widget.flashCardFormController.titleController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Flashcard Collection Name',
                    ),
                    onChanged: (text) {
                      widget.flashCardCollection.title = text;
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: SizeConfig.getMediaWidth(context, p: 0.085),
                        top: 10),
                    child: Text(
                      'question language',
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: SizeConfig.getMediaWidth(context, p: 0.06)),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SelectLanguageDropdown(
                      flashCardCollection: widget.flashCardCollection,
                      langDestination: 'from',
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: SizeConfig.getMediaWidth(context, p: 0.085)),
                    child: Text(
                      'answer language',
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: SizeConfig.getMediaWidth(context, p: 0.06)),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SelectLanguageDropdown(
                      flashCardCollection: widget.flashCardCollection,
                      langDestination: 'to',
                    ),
                  ),
                ),

                /// =================== [Flashcard List] ===================

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      if (widget.flashCardCollection.flashCardSet.length <
                          widget.wordsBeforeRelocateEditor)
                        addWordWidget(),
                      for (var flashCard
                          in widget.flashCardCollection.flashCardSet.toList())
                        ListTile(
                          leading: IconButton(
                              onPressed: () {
                                setState(() {
                                  widget.flashCardCollection.flashCardSet
                                      .remove(flashCard);
                                });
                              },
                              icon: const Icon(Icons.delete_forever)),
                          title: Text(flashCard.questionWords),
                          subtitle: Text(flashCard.answerWords),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          )),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),
        ]));
  }
}
