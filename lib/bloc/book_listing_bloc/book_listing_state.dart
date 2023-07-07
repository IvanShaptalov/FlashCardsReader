part of 'book_listing_bloc.dart';

// initialization of data

class BookState {
  List<BookModel> books = <BookModel>[];

  BookState({this.books = const []});

  // default state
  factory BookState.initial() =>
      BookState(books: BookDatabaseProvider.getAll());

  /// ===============================================================[PROVIDER METHODS]===============================================================
  BookState copyWith({List<BookModel>? books}) {
    return BookState(books: BookDatabaseProvider.getAll());
  }

  Future<BookState> getBooksFiltered(
      {reading = false,
      read = false,
      wantToRead = false,
      favourite = false}) async {
    return BookState.initial().copyWith(
        books: BookDatabaseProvider.getFiltered(
            reading: reading,
            read: read,
            wantToRead: wantToRead,
            favourite: favourite));
  }

  Future<BookState> updateBookAsync(BookModel model) async {
    await BookDatabaseProvider.writeEditAsync(model);
    return BookState.initial().copyWith(books: BookDatabaseProvider.getAll());
  }
}
