import 'package:flashcards_reader/model/flashcards/flashcards.dart';
import 'package:flashcards_reader/view_models/flashcards_provider/flashcard_collection_provider.dart';
import 'package:flashcards_reader/views/flashcards/flashcards/flashcard_screen_controller.dart';
import 'package:flashcards_reader/views/view_config.dart';
import 'package:flutter/material.dart';

class FlashCardCollectionWidget extends StatefulWidget {
  bool toDelete = false;

  FlashCardCollectionWidget(this.flashCardCollection, this.updateCallback,
      {super.key});
  final Function updateCallback;

  final FlashCardCollection flashCardCollection;
  @override
  State<FlashCardCollectionWidget> createState() =>
      _FlashCardCollectionWidgetState();
}

class _FlashCardCollectionWidgetState extends State<FlashCardCollectionWidget> {
  Duration deleteDuration = const Duration(milliseconds: 300);
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.toDelete ? 0 : 1,
      duration: deleteDuration,
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.getMediaHeight(context, p: 0.01),
            horizontal: SizeConfig.getMediaWidth(context, p: 0.01)),
        child: GestureDetector(
          onTap: () {
            debugPrint('tap');
            debugPrint(widget.flashCardCollection.title);
            if (FlashCardsScreenController.isMergeMode) {

            } else {}
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
            color: Colors.grey[200],
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
                              title: Text(widget.flashCardCollection
                                  .flashCardSet.toList()[index].questionWords),
                              subtitle: Text(widget.flashCardCollection
                                  .flashCardSet.toList()[index].answerWords),
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
                    // TODO add languages
                    IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
                    // const Text('Edit')

                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.merge_sharp)),
                    // const Text('Merge')

                    IconButton(
                        onPressed: () async {
                          // Start delete animation
                          setState(() {
                            widget.toDelete = true;
                          });

                          await Future.delayed(deleteDuration)
                              .whenComplete(() async {
                            // Delete after animation
                            await FlashCardCollectionProvider
                                .deleteFlashCardCollectionAsync(
                                    widget.flashCardCollection);
                            setState(() {
                              widget.updateCallback();
                            });
                          });
                        },
                        icon: const Icon(Icons.delete)),
                    // const Text('Delete')
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
