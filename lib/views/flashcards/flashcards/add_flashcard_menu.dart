import 'package:flashcards_reader/bloc/flashcards_bloc/flashcards_bloc.dart';
import 'package:flashcards_reader/main.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/views/flashcards/flashcards/add_flashcard_widget.dart';
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

class AddEditFlashCardBottomSheet {
  AddEditFlashCardBottomSheet(
      {FlashCardCollection? creatingFlashC, this.edit = false}) {
    flashCardCollection = creatingFlashC ?? flashFixture();
  }
  bool edit;

  late FlashCardCollection flashCardCollection;

  showAddEditMenu(BuildContext specialContext) async {
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
            widget.specialContext.read<FlashCardBloc>().add(
                AddEditEvent(flashCardCollection: widget.flashCardCollection));
            Navigator.pop(context);
            FlashCardCreatingUIProvider.clear();
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
                    onPressed: () {
                      // TODO implement translation
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
        height: SizeConfig.getMediaHeight(context, p: 0.7),
        child: Column(children: [
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
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: widget
                        .flashCardFormController.questionLanguageController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'From language',
                    ),
                    onChanged: (text) {
                      widget.flashCardCollection.questionLanguage = text;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller:
                        widget.flashCardFormController.answerLanguageController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'To language',
                    ),
                    onChanged: (text) {
                      widget.flashCardCollection.answerLanguage = text;
                    },
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
