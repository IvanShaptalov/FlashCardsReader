import 'package:flashcards_reader/model/flashcards/flashcards.dart';
import 'package:flashcards_reader/views/view_config.dart';
import 'package:flutter/material.dart';

class FlashCardCollectionWidget extends StatefulWidget {
  const FlashCardCollectionWidget(this.flashCardCollection, {super.key});
  final FlashCardCollection flashCardCollection;
  @override
  State<FlashCardCollectionWidget> createState() =>
      _FlashCardCollectionWidgetState();
}

class _FlashCardCollectionWidgetState extends State<FlashCardCollectionWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
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
                padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.getMediaHeight(context, p: 0.01)),
                child: Text(widget.flashCardCollection.title),
              ),
              Expanded(
                child: widget.flashCardCollection.flashCards.isNotEmpty
                    ? ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: widget.flashCardCollection.flashCards.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(widget.flashCardCollection
                                .flashCards[index].questionWords),
                            subtitle: Text(widget.flashCardCollection
                                .flashCards[index].answerWords),
                          );
                        })
                    : const Text('No flashcards yet'),
              ),
              const Divider(
                // TODO add divider
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

                  IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
                  // const Text('Delete')
                ],
              ),
            ],
          )),
    );
  }
}
