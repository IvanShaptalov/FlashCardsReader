part of 'book_listing_bloc.dart';

// flashcards event call it on the bloc
abstract class BookEvent {}

class GetBooksEvent extends BookEvent {
  bool reading = false;
  bool read = false;
  bool wantToRead = false;
  bool favourite = false;
  GetBooksEvent(
      {reading = false, read = false, wantToRead = false, favoutire = false});
}

class UpdateBookEvent extends BookEvent {
  final BookModel bookModel;

  UpdateBookEvent({required this.bookModel});
}
