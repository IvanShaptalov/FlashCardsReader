import 'package:flashcards_reader/bloc/flashcards_bloc/flashcards_bloc.dart';
import 'package:flashcards_reader/bloc/quiz_bloc/quiz_bloc.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/bloc/merge_provider/flashcard_merge_provider.dart';
import 'package:flashcards_reader/util/router.dart';
import 'package:flashcards_reader/views/flashcards/flashcard_collection_info.dart';
import 'package:flashcards_reader/views/flashcards/quiz/quiz_process.dart';
import 'package:flashcards_reader/views/flashcards/quiz/quiz_menu.dart';
import 'package:flashcards_reader/views/overlay_notification.dart';
import 'package:flashcards_reader/views/view_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuizFlashCollectionWidget extends StatefulWidget {
  const QuizFlashCollectionWidget(this.flashCardCollection, {super.key});

  final FlashCardCollection flashCardCollection;

  @override
  State<QuizFlashCollectionWidget> createState() =>
      _QuizFlashCollectionWidgetState();
}

class _QuizFlashCollectionWidgetState extends State<QuizFlashCollectionWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => QuizBloc(),
        child: BlocProvider(
          create: (_) => FlashCardBloc(),
          child: QuizCollectionView(widget.flashCardCollection),
        ));
  }
}

class QuizCollectionView extends StatefulWidget {
  const QuizCollectionView(this.flashCardCollection, {super.key});

  final FlashCardCollection flashCardCollection;
  @override
  State<QuizCollectionView> createState() => _QuizCollectionViewState();
}

class _QuizCollectionViewState extends State<QuizCollectionView> {
  Color setCardColor() {
    return CardViewConfig.defaultCardColor;
  }

  List<Widget> getCardActions(
      bool isTarget, bool isSelected, BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            // start quiz with the selected flashcard collection if possible
            if (widget.flashCardCollection.isLearned) {
              OverlayNotificationProvider.showOverlayNotification(
                  'This collection is already learned',
                  status: NotificationStatus.info);
            } else if (widget.flashCardCollection.isEmpty) {
              OverlayNotificationProvider.showOverlayNotification(
                  'This collection is empty',
                  status: NotificationStatus.info);
            } else {
              MyRouter.pushPage(
                  context,
                  QuizTrainer(
                    numberOfFlashCards:
                        widget.flashCardCollection.flashCardSet.length,
                    mode: QuizModeProvider.mode,
                    fCollection: widget.flashCardCollection,
                    fromPage: 'quiz',
                  ));
            }
          },
          icon: const Icon(Icons.quiz))
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuizBloc, QuizState>(builder: (context, state) {
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

        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black12,
            ),
            color: CardViewConfig.defaultCardColor,
            borderRadius: BorderRadius.circular(10),
          ),
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
                      top: SizeConfig.getMediaHeight(context, p: 0.02),
                      bottom: SizeConfig.getMediaHeight(context, p: 0.02)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.getMediaWidth(context, p: 0.02)),
                    child: Center(
                      child: Text(
                        widget.flashCardCollection.title,
                        style: ConfigFlashCardView.cardTitleTextStyle,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                FlashCardCollectionInfo(widget.flashCardCollection),
               
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: getCardActions(isTarget, isSelected, context)),
              ],
            ),
          ),
        ),
      );
    });
  }
}
