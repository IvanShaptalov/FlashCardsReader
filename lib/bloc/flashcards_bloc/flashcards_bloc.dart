import 'package:flashcards_reader/bloc/providers/word_collection_provider.dart';
import 'package:flashcards_reader/database/core/table_methods.dart';
import 'package:flashcards_reader/firebase/firebase.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'flashcards_event.dart';

part 'flashcards_state.dart';

class FlashCardBloc extends Bloc<FlashCardsEvent, FlashcardsState> {
  FlashCardBloc() : super(FlashcardsState.initial()) {
    on<GetFlashCardsEvent>((event, emit) => getFlashCards(event, emit));
    on<MoveToTrashEvent>((event, emit) => moveToTrash(event, emit));
    on<DeleteAllTrashPermanentlyEvent>(
        (event, emit) => deleteAllTrash(event, emit));
    on<RestoreFromTrashEvent>((event, emit) => restoreFromTrash(event, emit));

    on<UpdateFlashCardEvent>((event, emit) => addEdit(event, emit));

    on<DeletePermanentlyEvent>((event, emit) => deleteFromTrash(event, emit));
  }

  /// realisation of the event, event trigger emit
  getFlashCards(GetFlashCardsEvent event, Emitter<FlashcardsState> emit) {
    emit(state.copyWith(fromTrash: event.isDeleted));
  }

  deleteAllTrash(DeleteAllTrashPermanentlyEvent event,
      Emitter<FlashcardsState> emit) async {
    emit(await state.deleteFromTrashAllAsync());
  }

  deleteFromTrash(
      DeletePermanentlyEvent event, Emitter<FlashcardsState> emit) async {
    emit(await state.deletePermanently(event.flashCardCollection));
  }

  restoreFromTrash(
      RestoreFromTrashEvent event, Emitter<FlashcardsState> emit) async {
    emit(
        await state.restoreFlashCardCollectionAsync(event.flashCardCollection));
  }

  addEdit(UpdateFlashCardEvent event, Emitter<FlashcardsState> emit) async {
    emit(await state.addFlashCardCollectionAsync(event.flashCardCollection));
  }

  moveToTrash(MoveToTrashEvent event, Emitter<FlashcardsState> emit) async {
    emit(await state.moveToTrashAsync(event.flashCardCollection));
  }

  // deleteToTrash(DeleteToTrashEvent event, Emitter<FlashcardsState> emit) {
  //   emit(state.copyWith(isDeletedP: event.isDeleted));
  // }
}
