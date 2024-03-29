import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
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
      child: Column(
        children: [
          Row(
            children: [
              Transform.scale(
                scale: iconScale,
                child: Icon(Icons.language, color: Palette.blueAccent),
              ),
              Text(
                flashCardCollection.questionLanguage,
                style: FontConfigs.h3TextStyle,
                textAlign: TextAlign.start,
              ),
            ],
          ),
          Row(
            children: [
              Transform.scale(
                scale: iconScale,
                child: Icon(Icons.language, color: Palette.green600),
              ),
              Text(
                flashCardCollection.answerLanguage,
                style: FontConfigs.h3TextStyle,
                textAlign: TextAlign.start,
              ),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(Icons.web_stories_outlined,
                      size: 14, color: Palette.green300Primary),
                  Text(
                    flashCardCollection.flashCardSet.length.toString(),
                    style: FontConfigs.h3TextStyle
                        .copyWith(color: Palette.green300Primary, fontSize: 14),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Row(
                children: [
                  Icon(Icons.school_outlined,
                      size: 16, color: Palette.blueAccent),
                  Text(
                    flashCardCollection.learnedCount().toString(),
                    style: FontConfigs.h3TextStyle
                        .copyWith(color: Palette.blueAccent, fontSize: 14),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ],
          ),
          if (![
            ScreenDesign.portraitSmall,
            ScreenDesign.landscapeSmall,
            ScreenDesign.landscape
          ].contains(ScreenIdentifier.indentify(context)))
            const Divider(),
          if (![
            ScreenDesign.portraitSmall,
            ScreenDesign.landscapeSmall,
            ScreenDesign.landscape
          ].contains(ScreenIdentifier.indentify(context)))
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bar_chart_rounded,
                    size: 16, color: Palette.blueAccent),
                Text(
                  '${flashCardCollection.learnedPercent()} %',
                  style: FontConfigs.h3TextStyle.copyWith(fontSize: 14),
                ),
              ],
            ),
        ],
      ),
    ));
  }
}
