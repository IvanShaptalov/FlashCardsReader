import 'package:flashcards_reader/database/core/table_methods.dart';
import 'package:flashcards_reader/model/entities/reader/book_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'book_listing_event.dart';

part 'book_listing_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  BookBloc() : super(BookState.initial()) {
    on<GetBooksEvent>((event, emit) => getBooks(event, emit));
    // on<DeletePermanentlyEvent>((event, emit) => incrementCounter(event, emit));

    on<UpdateBookEvent>((event, emit) => addEdit(event, emit));
  }

  /// realisation of the event, event trigger emit
  getBooks(GetBooksEvent event, Emitter<BookState> emit) {
    emit(state);
  }

  addEdit(UpdateBookEvent event, Emitter<BookState> emit) async {
    emit(await state.updateBookAsync(event.bookModel));
  }
}
