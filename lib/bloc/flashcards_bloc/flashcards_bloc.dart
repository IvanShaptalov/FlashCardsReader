import 'package:flashcards_reader/database/core/table_methods.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'flashcards_event.dart';

part 'flashcards_state.dart';

class FlashcardsBloc extends Bloc<FlashCardsEvent, FlashCardsState> {
  FlashcardsBloc() : super(FlashCardsState.initial()) {
    on<GetFlashCardsEvent>((event, emit) => getFlashCards(event, emit));
    // on<DeletePermanentlyEvent>((event, emit) => incrementCounter(event, emit));
    // on<DeleteFromTrashEvent>((event, emit) => incrementCounter(event, emit));
    // on<RestoreFromTrashEvent>((event, emit) => incrementCounter(event, emit));
    // on<MergeFlashCardsEvent>((event, emit) => incrementCounter(event, emit));
    // on<StartMergeEvent>((event, emit) => incrementCounter(event, emit));
    // on<StopMergeEvent>((event, emit) => incrementCounter(event, emit));
    // on<AddEditEvent>((event, emit) => incrementCounter(event, emit));
  }

  /// realisation of the event, event trigger emit
  getFlashCards(GetFlashCardsEvent event, Emitter<FlashCardsState> emit) {
    emit(state.copyWith(isDeletedP: event.isDeleted));
  }

 
}
