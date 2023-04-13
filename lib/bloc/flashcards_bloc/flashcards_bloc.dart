import 'package:flashcards_reader/database/core/table_methods.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'flashcards_event.dart';

part 'flashcards_state.dart';

class FlashCardBloc extends Bloc<FlashCardsEvent, FlashcardsState> {
  FlashCardBloc() : super(FlashcardsState.initial()) {
    on<GetFlashCardsEvent>((event, emit) => getFlashCards(event, emit));
    // on<DeletePermanentlyEvent>((event, emit) => incrementCounter(event, emit));
    on<MoveToTrashEvent>((event, emit) => throw UnimplementedError());
    on<DeleteAllTrashEvent>((event, emit) => deleteAllTrash(event, emit));
    on<RestoreFromTrashEvent>((event, emit) => restoreFromTrash(event, emit));
    // on<MergeFlashCardsEvent>((event, emit) => incrementCounter(event, emit));
    // on<StartMergeEvent>((event, emit) => incrementCounter(event, emit));
    // on<StopMergeEvent>((event, emit) => incrementCounter(event, emit));
    on<AddEditEvent>((event, emit) => addEdit(event, emit));
  }

  /// realisation of the event, event trigger emit
  getFlashCards(GetFlashCardsEvent event, Emitter<FlashcardsState> emit) {
    emit(state.copyWith(fromTrash: event.isDeleted));
  }

  deleteAllTrash(
      DeleteAllTrashEvent event, Emitter<FlashcardsState> emit) async {
    emit(await state.deleteFromTrashAllAsync());
  }

  restoreFromTrash(
      RestoreFromTrashEvent event, Emitter<FlashcardsState> emit) async {
    emit(
        await state.restoreFlashCardCollectionAsync(event.flashCardCollection));
  }

  addEdit(AddEditEvent event, Emitter<FlashcardsState> emit) async {
    emit(await state.addFlashCardCollectionAsync(event.flashCardCollection));
  }

  // deleteToTrash(DeleteToTrashEvent event, Emitter<FlashcardsState> emit) {
  //   emit(state.copyWith(isDeletedP: event.isDeleted));
  // }
}
