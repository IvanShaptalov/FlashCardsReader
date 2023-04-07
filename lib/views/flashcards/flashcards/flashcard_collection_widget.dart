import 'package:flashcards_reader/model/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/view_models/flashcards_provider/flashcard_collection_provider.dart';
import 'package:flashcards_reader/views/view_config.dart';
import 'package:flutter/material.dart';

class FlashCardCollectionWidget extends StatefulWidget {
  const FlashCardCollectionWidget(this.flashCardCollection, this.updateCallback,
      {super.key});
  final Function updateCallback;

  final FlashCardCollection flashCardCollection;
  @override
  State<FlashCardCollectionWidget> createState() =>
      _FlashCardCollectionWidgetState();
}

class _FlashCardCollectionWidgetState extends State<FlashCardCollectionWidget> {
  Color setCardColor() {
    if (FlashCardCollectionProvider.isMergeMode) {
      if (FlashCardCollectionProvider.flashcardsToMerge
          .contains(widget.flashCardCollection)) {
        return Colors.greenAccent[100] ?? Colors.greenAccent;
      }
      if (FlashCardCollectionProvider.targetFlashCard ==
          widget.flashCardCollection) {
        return Colors.indigoAccent[100] ?? Colors.indigoAccent;
      }
    }
    return Colors.grey[200] ?? Colors.grey;
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
      child: GestureDetector(
        onTap: () {
          debugPrint('tap ${widget.flashCardCollection.title}');
          // if merge mode is on and the item is not the target item
          if (FlashCardCollectionProvider.isMergeMode &&
              FlashCardCollectionProvider.targetFlashCard !=
                  widget.flashCardCollection) {
            setState(() {
              if (FlashCardCollectionProvider.flashcardsToMerge
                  .contains(widget.flashCardCollection)) {
                debugPrint('unselected ${widget.flashCardCollection.title}');
                FlashCardCollectionProvider.flashcardsToMerge
                    .remove(widget.flashCardCollection);
              } else {
                debugPrint('selected ${widget.flashCardCollection.title}');
                FlashCardCollectionProvider.flashcardsToMerge
                    .add(widget.flashCardCollection);
              }
              widget.updateCallback();
            });
          }
        },
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
                        itemCount:
                            widget.flashCardCollection.flashCardSet.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(widget.flashCardCollection.flashCardSet
                                .toList()[index]
                                .questionWords),
                            subtitle: Text(widget
                                .flashCardCollection.flashCardSet
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        // if merge mode is not activated
                        if (!FlashCardCollectionProvider.isMergeMode) {
                        } else {
                          debugPrint('merge mode is activated, cannot edit');
                        }
                      },
                      icon: const Icon(Icons.edit)),
                  // if merge mode is not activated
                  !FlashCardCollectionProvider.isMergeMode
                      ? IconButton(
                          // activate merge mode
                          onPressed: () {
                            debugPrint('merge mode activated');

                            FlashCardCollectionProvider.activateMergeMode(
                                widget.flashCardCollection);

                            widget.updateCallback();
                          },
                          // cancel merge mode
                          icon: const Icon(Icons.merge_sharp))
                      : IconButton(
                          onPressed: () {
                            debugPrint('merge mode deactivated');
                            FlashCardCollectionProvider.deactivateMergeMode();
                            widget.updateCallback();
                          },
                          icon: const Icon(Icons.arrow_back)),

                  IconButton(
                      onPressed: () async {
                        // if merge mode is not activated
                        if (!FlashCardCollectionProvider.isMergeMode) {
                          await FlashCardCollectionProvider
                              .deleteFlashCardCollectionAsync(
                                  widget.flashCardCollection);
                          setState(() {
                            widget.updateCallback();
                          });
                        } else {
                          debugPrint('merge mode is activated, cannot delete');
                        }
                      },
                      icon: const Icon(Icons.delete)),
                  // const Text('Delete')
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
