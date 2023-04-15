// import 'package:flashcards_reader/bloc/flashcards_bloc/flashcards_bloc.dart';
import 'package:flashcards_reader/bloc/flashcards_bloc/flashcards_bloc.dart';
import 'package:flashcards_reader/main.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/views/flashcards/flashcards/add_flashcard_menu.dart';
import 'package:flashcards_reader/views/view_config.dart';
import 'package:flutter/material.dart';

class FlashCardCreatingUIProvider {
  static FlashCardCollection creatingFlashCardCollection = flashFixture();

  static clear() {
    creatingFlashCardCollection = flashFixture();
    WordCreatingUIProvider.clear();
  }
}

class WordCreatingUIProvider {
  static FlashCard _tmpFlashCard = FlashCard.fixture();
  static clear() {
    _tmpFlashCard = FlashCard.fixture();
  }

  static FlashCard get tmpFlashCard => _tmpFlashCard;

  static void setQuestionLanguage(String language) {
    _tmpFlashCard.questionLanguage = language;
  }

  static void setAnswerLanguage(String language) {
    _tmpFlashCard.answerLanguage = language;
  }

  static void setQuestion(String question) {
    _tmpFlashCard.questionWords = question;
  }

  static void setAnswer(String answer) {
    _tmpFlashCard.answerWords = answer;
  }
}

class AddFlashCardWidget extends StatefulWidget {
  const AddFlashCardWidget({super.key});

  @override
  State<AddFlashCardWidget> createState() => AddFlashCardWidgetState();
}

class AddFlashCardWidgetState extends State<AddFlashCardWidget> {
  Duration deleteDuration = const Duration(milliseconds: 170);
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: /* widget.toDelete ? 0 : */ 1,
      duration: deleteDuration,
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.getMediaHeight(context, p: 0.01),
            horizontal: SizeConfig.getMediaWidth(context, p: 0.01)),
        child: Card(
          shape: ShapeBorder.lerp(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              0.5),
          color: Colors.grey[200],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: SizeConfig.getMediaHeight(context, p: 0.03),
                    bottom: SizeConfig.getMediaHeight(context, p: 0.02)),
                child: const Text(
                  'Add flashcard',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return const ListTile(
                          title: Text('Add Word'),
                          subtitle: Text('Add Flashcard'),
                        );
                      })),
              const Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// ============================[ADD FLASHCARD MENU OPEN]============================
                  //? in plans add languages
                  IconButton(
                      onPressed: () async {
                        FlashCardCreatingUIProvider
                                .creatingFlashCardCollection =
                            await AddEditFlashCardBottomSheet(
                                    creatingFlashC: FlashCardCreatingUIProvider
                                        .creatingFlashCardCollection)
                                .showAddEditMenu(context);
                        // TODO delete this
                        //  context.read<FlashCardBloc>().add(
                        //     AddEditEvent(flashCardCollection: FlashCardCreatingUIProvider.creatingFlashCardCollection));
                        //     FlashCardCreatingUIProvider.clear();
                      },
                      icon: const Icon(Icons.add)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
