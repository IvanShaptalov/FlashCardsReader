import 'package:flashcards_reader/main.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/views/view_config.dart';
import 'package:flutter/material.dart';

class FlashCardFormController {
  TextEditingController titleController = TextEditingController();
  TextEditingController fromLanguageController = TextEditingController();
  TextEditingController toLanguageController = TextEditingController();

  void setUp(FlashCardCollection flashCardCollection) {
    titleController.text = flashCardCollection.title;
    fromLanguageController.text = 'en';
    toLanguageController.text = 'ua';
  }
}

class AddEditFlashCardBottomSheet {
  FlashCardFormController flashCardFormController = FlashCardFormController();
  AddEditFlashCardBottomSheet({FlashCardCollection? creatingFlashC}) {
    flashCardCollection = creatingFlashC ?? flashFixture();
  }
  late FlashCardCollection flashCardCollection;

  Future<FlashCardCollection> showAddEditMenu(context) async {
    flashCardFormController.setUp(flashCardCollection);

    return showModalBottomSheet(
        // isDismissible: true,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (BuildContext context, setState) {
            return _flashCardCreatingWall(context);
          });
        }).then((value) => flashCardCollection);
  }

  Widget _flashCardCreatingWall(context) {
    return SizedBox(
        height: SizeConfig.getMediaHeight(context, p: 0.8),
        child: Column(children: [
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: SizeConfig.getMediaHeight(context, p: 0.03)),
            child: const Text(
              'Add Flashcard Collection',
              style: TextStyle(fontSize: 20),
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
                    controller: flashCardFormController.titleController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Flashcard Collection Name',
                    ),
                    onChanged: (text) {
                      flashCardCollection.title = text;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: flashCardFormController.fromLanguageController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'From language',
                    ),
                    onChanged: (text) {
                      flashCardCollection.title = text;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: flashCardFormController.toLanguageController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'To language',
                    ),
                    onChanged: (text) {
                      flashCardCollection.title = text;
                    },
                  ),
                ),
                ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return const ListTile(
                        title: Text('Add Word'),
                        subtitle: Text('Add Flashcard'),
                      );
                    }),
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
