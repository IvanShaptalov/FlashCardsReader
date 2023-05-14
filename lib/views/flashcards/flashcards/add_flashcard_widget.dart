// import 'package:flashcards_reader/bloc/flashcards_bloc/flashcards_bloc.dart';
import 'package:flashcards_reader/bloc/translator_bloc/translator_bloc.dart';
import 'package:flashcards_reader/main.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/views/flashcards/flashcards/add_flashcard_menu.dart';
import 'package:flashcards_reader/bloc/providers/word_collection_provider.dart';
import 'package:flashcards_reader/views/view_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlashCardCreatingUIProvider {
  static FlashCardCollection fc = flashExample();

  static clear() {
    fc = flashExample();
    WordCreatingUIProvider.clear();
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
    debugPrintIt(
        'bloc provider exists in add flash widget ${BlocProvider.of<TranslatorBloc>(context).state.result}');
    return AnimatedOpacity(
      opacity: /* widget.toDelete ? 0 : */ 1,
      duration: deleteDuration,
      child: GestureDetector(
        onTap: () {
          FlashCardCreatingUIProvider.clear();
          UpdateFlashCardBottomSheet().showUpdateFlashCardMenu(context);
        },
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
            color: CardViewConfig.defaultCardColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: SizeConfig.getMediaHeight(context, p: 0.03),
                      bottom: SizeConfig.getMediaHeight(context, p: 0.02)),
                  child: const Text(
                    'Add flashcard',
                    style: FontConfigs.cardTitleTextStyle,
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                Expanded(
                    child: Column(children: const [
                  ListTile(
                    title: Text('Add Word'),
                    subtitle: Text(
                      'Add Flashcard',
                    ),
                  )
                ])),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    /// ============================[ADD FLASHCARD MENU OPEN]============================
                    //? in plans add languages
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.add_circle_outline),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
