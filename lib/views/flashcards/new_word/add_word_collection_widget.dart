import 'package:flashcards_reader/bloc/providers/word_collection_provider.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/views/flashcards/flashcard_collection_info.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flashcards_reader/views/overlay_notification.dart';
import 'package:flutter/material.dart';

class FastAddWordFCcWidget extends StatefulWidget {
  const FastAddWordFCcWidget(this.flashCardCollection, this.updateCallback,
      {required this.backElementToStart, required this.design, super.key});
  final Function updateCallback;
  final Function backElementToStart;
  final ScreenDesign design;

  final FlashCardCollection flashCardCollection;
  @override
  State<FastAddWordFCcWidget> createState() => _FastAddWordFCcWidgetState();
}

class _FastAddWordFCcWidgetState extends State<FastAddWordFCcWidget> {
  Color setCardColor() {
    if (widget.flashCardCollection == FlashCardProvider.fc) {
      return ConfigFastAddWordView.selectedCard;
    }
    return CardViewConfig.defaultCardColor;
  }

  /// if icon is target, cancel merge mode, otherwise cancel selection

  @override
  Widget build(BuildContext context) {
    // set the target item for merge

    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: SizeConfig.getMediaHeight(context, p: 0.01),
          horizontal: SizeConfig.getMediaWidth(context, p: 0.01)),
      // select items for merge
      child: GestureDetector(
        onTap: () {
          if (FlashCardProvider.fc != widget.flashCardCollection) {
            FlashCardProvider.fc = widget.flashCardCollection;
          }

          widget.updateCallback();
          widget.backElementToStart();
          OverlayNotificationProvider.showOverlayNotification('target collection is ${widget.flashCardCollection.title}', status: NotificationStatus.success);
        },
        child: SizedBox(
          height: SizeConfig.getMediaHeight(context, p: 0.5),
          width: SizeConfig.getMediaWidth(context, p: 0.4),
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
                  padding: EdgeInsets.all(
                      SizeConfig.getMediaHeight(context, p: 0.02)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.getMediaWidth(context, p: 0.02)),
                    child: Center(
                      child: Text(
                        widget.flashCardCollection.title,
                        style: FontConfigs.cardTitleTextStyle,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                FlashCardCollectionInfo(
                  widget.flashCardCollection,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
