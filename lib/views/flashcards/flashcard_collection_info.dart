import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/views/view_config.dart';
import 'package:flutter/material.dart';

class FlashCardCollectionInfo extends StatelessWidget {
  final FlashCardCollection flashCardCollection;
  const FlashCardCollectionInfo(this.flashCardCollection, {Key? key})
      : super(key: key);
  final double iconScale = 0.7;
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          Text(
            "Flashcards: ${flashCardCollection.flashCardSet.length}",
            style: const TextStyle(fontSize: 14),
            textAlign: TextAlign.start,
          ),
          const Divider(),
          Row(
            children: [
              Transform.scale(
                  scale: iconScale, child: const Icon(Icons.language)),
              Text(
                "-> ${flashCardCollection.questionLanguage}\n<- ${flashCardCollection.answerLanguage}",
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.start,
              ),
            ],
          ),
          Row(
            children: [
              Transform.scale(
                  scale: iconScale, child: const Icon(Icons.date_range)),
              Text(
                ViewConfig.formatDate(flashCardCollection.createdAt),
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
