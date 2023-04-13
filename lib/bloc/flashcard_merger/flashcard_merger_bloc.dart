import 'package:flashcards_reader/database/core/table_methods.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'flashcard_merger_event.dart';

part 'flashcard_merger_state.dart';

class FlashCardBloc extends Bloc<FlashCardMergerEvent, FlashcardMergerState> {
  FlashCardBloc() : super(FlashcardMergerState.initial()) {
    on<GetFlashCardsEvent>((event, emit) => getFlashCards(event, emit));
    // on<DeletePermanentlyEvent>((event, emit) => incrementCounter(event, emit));
  }

  /// realisation of the event, event trigger emit
  getFlashCards(GetFlashCardsEvent event, Emitter<FlashcardMergerState> emit) {
    emit(state.copyWith(fromTrash: event.isDeleted));
  }
}
