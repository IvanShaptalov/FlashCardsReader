part of 'flashcards_bloc.dart';

// flashcards event call it on the bloc
abstract class FlashCardsEvent {}

class GetFlashCardsEvent extends FlashCardsEvent {
  final bool isDeleted;

  GetFlashCardsEvent({required this.isDeleted});
}

class DeletePermanentlyEvent extends FlashCardsEvent {
  final FlashCardCollection flashCardCollection;

  DeletePermanentlyEvent({required this.flashCardCollection});
}

class MoveToTrashEvent extends FlashCardsEvent {
  final FlashCardCollection flashCardCollection;

  MoveToTrashEvent({required this.flashCardCollection});
}

class DeleteAllTrashPermanentlyEvent extends FlashCardsEvent {}

class RestoreFromTrashEvent extends FlashCardsEvent {
  final FlashCardCollection flashCardCollection;

  RestoreFromTrashEvent({required this.flashCardCollection});
}



class MergeFlashCardsEvent extends FlashCardsEvent {
  final List<FlashCardCollection> flashCardsToMerge;
  final FlashCardCollection targetFlashCard;

  MergeFlashCardsEvent(
      {required this.flashCardsToMerge, required this.targetFlashCard});
}

class StartMergeEvent extends FlashCardsEvent {
  final FlashCardCollection targetFlashCard;

  StartMergeEvent({required this.targetFlashCard});
}

class StopMergeEvent extends FlashCardsEvent {}

class UpdateFlashCardEvent extends FlashCardsEvent {
  final FlashCardCollection flashCardCollection;

  UpdateFlashCardEvent({required this.flashCardCollection});
}
