part of 'book_listing_bloc.dart';

// flashcards event call it on the bloc
abstract class BookEvent {}

class GetBooksEvent extends BookEvent {
  GetBooksEvent();
}

class UpdateBookEvent extends BookEvent {
  final BookModel bookModel;

  UpdateBookEvent({required this.bookModel});
}
