part of 'book_listing_bloc.dart';

// initialization of data

class BookState {
  List<BookModel> books = <BookModel>[];

  BookState({this.books = const []});

  // default state
  factory BookState.initial() =>
      BookState(books: [] //TODO add all books from database
          );

  /// ===============================================================[PROVIDER METHODS]===============================================================
  BookState copyWith({List<BookModel>? books}) {
    return BookState(
        books: /* FlashcardDatabaseProvider.getAllFromTrash(fromTrash) */ []);
  }

  Future<BookState> deletePermanently(List<BookModel> books) async {
    // await FlashcardDatabaseProvider.deleteFlashCardsAsync(
    //     [flashCardCollection]);
    return BookState.initial().copyWith();
  }

  Future<BookState> updateBookAsync(BookModel model) async {
    // await FlashcardDatabaseProvider.writeEditAsync(flashCardCollection);
    return BookState.initial().copyWith(books: [] /* books here */);
  }
}
