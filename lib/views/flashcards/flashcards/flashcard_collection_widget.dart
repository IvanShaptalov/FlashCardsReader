import 'package:flashcards_reader/bloc/flashcards_bloc/flashcards_bloc.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/bloc/merge_provider/flashcard_merge_provider.dart';
import 'package:flashcards_reader/views/flashcards/flashcards/add_flashcard_menu.dart';
import 'package:flashcards_reader/views/flashcards/flashcards/add_flashcard_widget.dart';
import 'package:flashcards_reader/views/overlay_notification.dart';
import 'package:flashcards_reader/views/view_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    if (FlashCardCollectionProvider.isMergeModeStarted) {
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

  /// if icon is target, cancel merge mode, otherwise cancel selection
  IconButton currentCardDeactivateIcon(bool isTarget, bool isSelected) {
    if (isTarget) {
      // cancel merge mode
      return IconButton(
          onPressed: () {
            debugPrint('merge mode deactivated');
            FlashCardCollectionProvider.deactivateMergeMode();
            widget.updateCallback();
          },
          icon: const Icon(Icons.cancel));
    } else {
      // cancel selection
      return IconButton(
          onPressed: () {
            debugPrint('card unselected');
            selectCard();
            widget.updateCallback();
          },
          icon: isSelected
              ? const Icon(Icons.check_circle_outlined)
              : const Icon(Icons.circle_outlined));
    }
  }

  List<Widget> getCardActions(bool isTarget, bool isSelected) {
    if (FlashCardCollectionProvider.isMergeModeStarted) {
      return [currentCardDeactivateIcon(isTarget, isSelected)];
    } else {
      return [
        IconButton(
            onPressed: () {
              // if merge mode is not activated
              if (!FlashCardCollectionProvider.isMergeModeStarted) {
                AddEditFlashCardBottomSheet(
                        creatingFlashC: widget.flashCardCollection, edit: true)
                    .showAddEditMenu(context);
              } else {
                OverlayNotificationProvider.showOverlayNotification('merge mode is activated, cannot edit', status: NotificationStatus.warning);
                debugPrint('merge mode is activated, cannot edit');
              }
            },
            icon: const Icon(Icons.edit)),
        // if merge mode is not activated
        IconButton(
            // activate merge mode
            onPressed: () {
              debugPrint('merge mode activated');

              FlashCardCollectionProvider.activateMergeMode(
                  widget.flashCardCollection);
               OverlayNotificationProvider.showOverlayNotification(
              'merge mode activated',
              status: NotificationStatus.info);

              widget.updateCallback();
            },
            // cancel merge mode
            icon: const Icon(Icons.merge_sharp)),

        IconButton(
            onPressed: () async {
              // if merge mode is not activated
              if (!FlashCardCollectionProvider.isMergeModeStarted) {
                context.read<FlashCardBloc>().add(MoveToTrashEvent(
                    flashCardCollection: widget.flashCardCollection));
              } else {
                debugPrint('merge mode is activated, cannot delete');
              }
            },
            icon: const Icon(Icons.delete)),
      ];
    }
  }

  void selectCard() {
    debugPrint('tap ${widget.flashCardCollection.title}');
    // if merge mode is on and the item is not the target item
    if (FlashCardCollectionProvider.isMergeModeStarted &&
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
          selectCard();
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: getCardActions(isTarget, isSelected)),
            ],
          ),
        ),
      ),
    );
  }
}
