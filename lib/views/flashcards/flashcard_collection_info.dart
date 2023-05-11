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
      child: ListOrColumn(
        children: [
          Row(
            children: [
              Transform.scale(
                scale: iconScale,
                child: Icon(Icons.language,
                    color: ConfigFCWordsInfo.questionLanguageIconColor),
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
                child: Icon(Icons.language,
                    color: ConfigFCWordsInfo.answerLanguageIconColor),
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
                      size: 14, color: Colors.green.shade300),
                  Text(
                    flashCardCollection.flashCardSet.length.toString(),
                    style: FontConfigs.h3TextStyle
                        .copyWith(color: Colors.green.shade300, fontSize: 14),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Row(
                children: [
                  const Icon(Icons.school_outlined,
                      size: 16, color: Colors.blueAccent),
                  Text(
                    flashCardCollection.learnedCount().toString(),
                    style: FontConfigs.h3TextStyle
                        .copyWith(color: Colors.blueAccent, fontSize: 14),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ],
          ),
          if (![ScreenDesign.portraitSmall, ScreenDesign.landscapeSmall]
              .contains(DesignIdentifier.identifyScreenDesign(context)))
            const Divider(),
          if (![ScreenDesign.portraitSmall, ScreenDesign.landscapeSmall]
              .contains(DesignIdentifier.identifyScreenDesign(context)))
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.bar_chart_rounded,
                    size: 16, color: Colors.blueAccent),
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
