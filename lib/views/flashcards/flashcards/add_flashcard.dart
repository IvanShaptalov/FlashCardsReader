import 'package:flashcards_reader/bloc/flashcards_bloc/flashcards_bloc.dart';
import 'package:flashcards_reader/main.dart';
import 'package:flashcards_reader/bloc/flashcards_provider/flashcard_collection_provider.dart';
import 'package:flashcards_reader/views/view_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddFlashCardWidget extends StatefulWidget {
  const AddFlashCardWidget(this.updateCallback, {super.key});
  final Function updateCallback;

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
                  //? in plans add languages
                  IconButton(
                      onPressed: () {
                        context.read<FlashCardBloc>().add(
                            AddEditEvent(flashCardCollection: flashFixture()));
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
