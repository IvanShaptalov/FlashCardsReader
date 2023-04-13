import 'package:flashcards_reader/bloc/flashcards_bloc/flashcards_bloc.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/bloc/flashcards_provider/flashcard_collection_provider.dart';
import 'package:flashcards_reader/views/view_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeletedFlashCardCollectionWidget extends StatefulWidget {
  const DeletedFlashCardCollectionWidget(this.flashCardCollection, {super.key});

  final FlashCardCollection flashCardCollection;
  @override
  State<DeletedFlashCardCollectionWidget> createState() =>
      _DeletedFlashCardCollectionWidgetState();
}

class _DeletedFlashCardCollectionWidgetState
    extends State<DeletedFlashCardCollectionWidget> {
  Color setCardColor() {
    return Colors.grey[200] ?? Colors.grey;
  }

  List<Widget> getCardActions(
      bool isTarget, bool isSelected, BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            // if merge mode is not activated
            context.read<FlashCardBloc>().add(RestoreFromTrashEvent(
                flashCardCollection: widget.flashCardCollection));

            context
                .read<FlashCardBloc>()
                .add(GetFlashCardsEvent(isDeleted: true));
          },
          icon: const Icon(Icons.restore_from_trash))
    ];
  }

  @override
  Widget build(BuildContext context) {
    // set the target item for merge
    bool isTarget = FlashCardCollectionProvider.targetFlashCard ==
        widget.flashCardCollection;

    // check if the item is selected for merge
    bool isSelected = FlashCardCollectionProvider.flashcardsToMerge
            .contains(widget.flashCardCollection) &&
        !isTarget;
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: SizeConfig.getMediaHeight(context, p: 0.01),
          horizontal: SizeConfig.getMediaWidth(context, p: 0.01)),
      // select items for merge

      child: Card(
        shape: ShapeBorder.lerp(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            0.5),
        color: setCardColor(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: SizeConfig.getMediaHeight(context, p: 0.03),
                  bottom: SizeConfig.getMediaHeight(context, p: 0.02)),
              child: Text(
                widget.flashCardCollection.title,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            Expanded(
              child: widget.flashCardCollection.flashCardSet.isNotEmpty
                  ? ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: widget.flashCardCollection.flashCardSet.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(widget.flashCardCollection.flashCardSet
                              .toList()[index]
                              .questionWords),
                          subtitle: Text(widget.flashCardCollection.flashCardSet
                              .toList()[index]
                              .answerWords),
                        );
                      })
                  : const Text('No flashcards yet'),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: getCardActions(isTarget, isSelected, context)),
          ],
        ),
      ),
    );
  }
}
