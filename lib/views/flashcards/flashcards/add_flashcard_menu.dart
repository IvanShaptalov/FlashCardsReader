import 'package:flashcards_reader/bloc/flashcards_bloc/flashcards_bloc.dart';
import 'package:flashcards_reader/main.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/views/flashcards/flashcards/add_flashcard_widget.dart';
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

class AddEditFlashCardBottomSheet {
  AddEditFlashCardBottomSheet({FlashCardCollection? creatingFlashC}) {
    flashCardCollection = creatingFlashC ?? flashFixture();
  }
  late FlashCardCollection flashCardCollection;

  Future<FlashCardCollection> showAddEditMenu(
      BuildContext specialContext) async {
    return showModalBottomSheet(
        // isDismissible: true,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        context: specialContext,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (BuildContext context, setState) {
            return FlashCardCreatingWall(specialContext, flashCardCollection);
          });
        }).then((value) => flashCardCollection);
  }
}

// ignore: must_be_immutable
class FlashCardCreatingWall extends StatefulWidget {
  FlashCardCreatingWall(this.specialContext, this.flashCardCollection,
      {super.key});
  BuildContext specialContext;
  FlashCardFormController flashCardFormController = FlashCardFormController();
  FlashCardCollection flashCardCollection;

  @override
  State<FlashCardCreatingWall> createState() => _FlashCardCreatingWallState();
}

class _FlashCardCreatingWallState extends State<FlashCardCreatingWall> {
  Widget addCollectionButton() {
    return IconButton(
        onPressed: () {
          widget.specialContext.read<FlashCardBloc>().add(
              AddEditEvent(flashCardCollection: widget.flashCardCollection));
          Navigator.pop(context);
          FlashCardCreatingUIProvider.clear();
        },
        icon: const Icon(Icons.library_add));
  }

  ListTile addWordTile() {
    return ListTile(
      leading: IconButton(
          onPressed: () {
            debugPrint('add flashcard');
            WordCreatingUIProvider.setQuestionLanguage(
                widget.flashCardCollection.questionLanguage);
            WordCreatingUIProvider.setAnswerLanguage(
                widget.flashCardCollection.answerLanguage);

            widget.flashCardCollection.flashCardSet
                .add(WordCreatingUIProvider.tmpFlashCard);
            WordCreatingUIProvider.clear();
            setState(() {});
          },
          icon: const Icon(Icons.add)),
      title: TextField(
        decoration: const InputDecoration(
          labelText: 'Add Word',
        ),
        onChanged: (text) {
          WordCreatingUIProvider.setQuestion(text);
        },
      ),
      subtitle: TextField(
        decoration: const InputDecoration(
          labelText: 'Add Translation',
        ),
        onChanged: (text) {
          WordCreatingUIProvider.setAnswer(text);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    widget.flashCardFormController.setUp(widget.flashCardCollection);
    return SizedBox(
        height: SizeConfig.getMediaHeight(context, p: 0.8),
        child: Column(children: [
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: SizeConfig.getMediaHeight(context, p: 0.03)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Add Flashcard Collection',
                  style: TextStyle(fontSize: 20),
                ),
                addCollectionButton(),
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
                  child: Container(
                      // color: Colors.grey[200],
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey)),
                      child: Column(
                        children: [
                          addWordTile(),
                          for (var flashCard in widget
                              .flashCardCollection.flashCardSet
                              .toList())
                            ListTile(
                              leading: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      widget.flashCardCollection.flashCardSet
                                          .remove(flashCard);
                                    });
                                  },
                                  icon: const Icon(Icons.delete_forever)),
                              title: Text(flashCard.answerWords),
                              subtitle: Text(flashCard.questionWords),
                            ),
                          if (widget.flashCardCollection.flashCardSet.length >
                              2)
                            addWordTile(),
                        ],
                      )),
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
