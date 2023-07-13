import 'package:flashcards_reader/bloc/book_listing_bloc/book_listing_bloc.dart';
import 'package:flashcards_reader/bloc/providers/word_collection_provider.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/model/entities/reader/book_model.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/views/flashcards/flashcard_collection_info.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flashcards_reader/views/flashcards/new_word/screens/base_new_word_screen.dart';
import 'package:flashcards_reader/views/overlay_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FastAddWordFCcWidget extends StatefulWidget {
  /// if called from open book menu, when select - save flashcard to book
  const FastAddWordFCcWidget(this.flashCardCollection, this.updateCallback,
      {required this.design, super.key, this.book, this.bookContext});
  final Function updateCallback;
  final ScreenDesign design;
  final BookModel? book;
  final BuildContext? bookContext;

  final FlashCardCollection flashCardCollection;
  @override
  State<FastAddWordFCcWidget> createState() => _FastAddWordFCcWidgetState();
}

class _FastAddWordFCcWidgetState extends State<FastAddWordFCcWidget> {
  Color setCardColor() {
    if (widget.flashCardCollection == FlashCardProvider.fc) {
      return Palette.green100;
    }
    return Palette.amber50;
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

          if (widget.book is BookModel && widget.bookContext is BuildContext) {
            // send save book event to book bloc to
            debugPrintIt('called from book menu');
            widget.bookContext!.read<BookBloc>().state.updateBookAsync(
                widget.book!..flashCardId = widget.flashCardCollection.id);
          } else if (widget.book is BookModel ||
              widget.bookContext is BuildContext) {
            throw Exception(
                'for book menu must provided book, bookContext to work with bloc');
          }
          widget.updateCallback();
          FastCardListProvider.backElementToStart();

          OverlayNotificationProvider.showOverlayNotification(
              'target collection is ${widget.flashCardCollection.title}',
              status: NotificationStatus.success);
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
