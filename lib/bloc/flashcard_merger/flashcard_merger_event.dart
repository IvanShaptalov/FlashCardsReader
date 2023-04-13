part of 'flashcard_merger_bloc.dart';

// flashcards event call it on the bloc
abstract class FlashCardMergerEvent {}

class GetFlashCardsEvent extends FlashCardMergerEvent {
  final bool isDeleted;

  GetFlashCardsEvent({required this.isDeleted});
}

class DeletePermanentlyEvent extends FlashCardMergerEvent {
  final FlashCardCollection flashCardCollection;

  DeletePermanentlyEvent({required this.flashCardCollection});
}
