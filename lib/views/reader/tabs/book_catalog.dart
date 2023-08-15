import 'dart:io';

import 'package:flashcards_reader/bloc/book_listing_bloc/book_listing_bloc.dart';
import 'package:flashcards_reader/model/entities/reader/book_model.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/util/router.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flashcards_reader/model/entities/reader/open_book.dart';
import 'package:flashcards_reader/views/guide_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

enum DotsMenu { share, trash, edit }

enum BookStatus { favourites, haveRead, reading, toRead, allBooks, inTrash }

class BookCatalog extends StatefulWidget {
  const BookCatalog(
      {required this.bookStatus,
      super.key,
      required this.upperContext,
      this.isTutorial = false});
  final BuildContext upperContext;
  final BookStatus bookStatus;
  static const icon = Icon(Icons.book_sharp);
  static const String booksTitle = 'Books';
  static const String tabTitle = 'Reading';
  final bool isTutorial;

  @override
  BookCatalogState createState() => BookCatalogState();
}

class BookCatalogState extends State<BookCatalog> {
  List<BookModel>? data;

  DotsMenu selectedMenu = DotsMenu.share;
  void fetchData() {
    switch (widget.bookStatus) {
      case BookStatus.favourites:
        data = BlocProvider.of<BookBloc>(context)
            .state
            .books
            .where((element) =>
                element.status.favourite && !element.status.inTrash)
            .toList();
        break;
      case BookStatus.haveRead:
        data = BlocProvider.of<BookBloc>(context)
            .state
            .books
            .where(
                (element) => element.status.haveRead && !element.status.inTrash)
            .toList();
        break;
      case BookStatus.toRead:
        data = BlocProvider.of<BookBloc>(context)
            .state
            .books
            .where(
                (element) => element.status.toRead && !element.status.inTrash)
            .toList();
        break;

      case BookStatus.reading:
        data = BlocProvider.of<BookBloc>(context)
            .state
            .books
            .where(
                (element) => element.status.reading && !element.status.inTrash)
            .toList();
        break;
      case BookStatus.inTrash:
        data = BlocProvider.of<BookBloc>(context)
            .state
            .books
            .where((element) => element.status.inTrash)
            .toList();
        break;
      default:
        data = BlocProvider.of<BookBloc>(context)
            .state
            .books
            .where((element) => !element.status.inTrash)
            .toList();

        if (widget.isTutorial && data is List<BookModel>) {
          debugPrintIt('is tutorial, added book');
          data!.remove(BookModel.asset());
          data!.insert(0, BookModel.asset());
        }
    }
  }

  void updateCallback() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    // start tutorial if it is
    if (widget.isTutorial) {
      GuideProvider.startStep(context, updateCallback, 1);
    }
  }

  void openBook(BookModel book, {bool isTutorial = false}) {
    MyRouter.pushPage(
        context,
        OpenBook(
          book: book,
          upperContext: widget.upperContext,
          isTutorial: isTutorial,
        ));
  }

  /// Wraps widget in guide

  @override
  Widget build(BuildContext context) {
    fetchData();
    return Container(
      child: data != null
          ? ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: data?.length,
              itemBuilder: (BuildContext context, int index) {
                final book = data![index];
                return GuideProvider.wrapInGuideIfNeeded(
                  onHighlightTap: () async {
                    openBook(book, isTutorial: true);
                    await Future.delayed(const Duration(milliseconds: 400))
                        .then(
                            (value) => GuideProvider.introController.jumpTo(2));
                  },
                  guideText: 'Click on book',
                  step: 1,
                  // if element is first - wrap
                  toWrap: index == 0 && widget.isTutorial,
                  child: Container(
                      height: ScreenIdentifier.isNormal(context)
                          ? SizeConfig.getMediaHeight(context, p: 0.21)
                          : 160,
                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Palette.white),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              openBook(book);
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width * 0.25,
                              margin:
                                  const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              decoration: BoxDecoration(
                                  image: book.coverPath.isNotEmpty &&
                                          File(book.coverPath).existsSync()
                                      ? DecorationImage(
                                          image:
                                              FileImage(File(book.coverPath)),
                                          fit: BoxFit.fill,
                                        )
                                      : DecorationImage(
                                          image: AssetImage(book ==
                                                  BookModel.asset()
                                              ? 'assets/book/quotes_skin.png'
                                              : 'assets/images/empty.png'),
                                          fit: BoxFit.fill),
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              openBook(book);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  color: Palette.white,
                                  width:
                                      MediaQuery.of(context).size.width * 0.65,
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 10, 10, 5),
                                  child: Text(
                                    book.title,
                                    style: const TextStyle(
                                      fontSize: 15.5,
                                    ),
                                    maxLines: 2,
                                  ),
                                ),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.06,
                                  width:
                                      MediaQuery.of(context).size.width * 0.67,
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  child: Text(
                                    book.author,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                                SizedBox(
                                  width: SizeConfig.getMediaWidth(context,
                                      p: 0.67),
                                  child: !book.status.inTrash
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            GestureDetector(
                                              child: Icon(
                                                Icons.star_outline,
                                                color: book.status.favourite
                                                    ? Palette.green
                                                    : null,
                                              ),
                                              onTap: () {
                                                BlocProvider.of<BookBloc>(
                                                        context)
                                                    .add(UpdateBookEvent(
                                                        bookModel: book
                                                          ..status.favourite =
                                                              !book.status
                                                                  .favourite));
                                              },
                                            ),
                                            GestureDetector(
                                              child: Icon(
                                                Icons.history,
                                                color: book.status.toRead
                                                    ? Palette.green
                                                    : null,
                                              ),
                                              onTap: () {
                                                BlocProvider.of<BookBloc>(
                                                        context)
                                                    .add(UpdateBookEvent(
                                                        bookModel: book
                                                          ..status.toRead =
                                                              !book.status
                                                                  .toRead));
                                              },
                                            ),
                                            GestureDetector(
                                              child: Icon(
                                                Icons
                                                    .library_add_check_outlined,
                                                color: book.status.haveRead
                                                    ? Palette.green
                                                    : null,
                                              ),
                                              onTap: () {
                                                context.read<BookBloc>().add(
                                                    UpdateBookEvent(
                                                        bookModel: book
                                                          ..status.haveRead =
                                                              !book.status
                                                                  .haveRead));
                                              },
                                            ),
                                            PopupMenuButton<DotsMenu>(
                                              initialValue: selectedMenu,
                                              // Callback that sets the selected popup menu item.
                                              onSelected: (DotsMenu item) {
                                                debugPrintIt(item.toString());
                                                switch (item) {
                                                  case DotsMenu.trash:
                                                    BlocProvider.of<BookBloc>(
                                                            context)
                                                        .add(UpdateBookEvent(
                                                            bookModel: book
                                                              ..status.inTrash =
                                                                  true));
                                                    break;
                                                  default:
                                                }
                                              },
                                              itemBuilder: (BuildContext
                                                      context) =>
                                                  <PopupMenuEntry<DotsMenu>>[
                                                const PopupMenuItem<DotsMenu>(
                                                  value: DotsMenu.share,
                                                  child: Text('Share file'),
                                                ),
                                                const PopupMenuItem<DotsMenu>(
                                                  value: DotsMenu.trash,
                                                  child: Text('Move to trash'),
                                                ),
                                                const PopupMenuItem<DotsMenu>(
                                                  value: DotsMenu.edit,
                                                  child: Text('Edit'),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            const SizedBox.shrink(),
                                            const SizedBox.shrink(),
                                            GestureDetector(
                                              child: const Icon(
                                                Icons.restore_from_trash,
                                              ),
                                              onTap: () {
                                                BlocProvider.of<BookBloc>(
                                                        context)
                                                    .add(UpdateBookEvent(
                                                        bookModel: book
                                                          ..status.inTrash =
                                                              false));
                                              },
                                            ),
                                          ],
                                        ),
                                )
                              ],
                            ),
                          )
                        ],
                      )),
                );
              },
            )
          : Center(
              child: SpinKitWave(
                color: Palette.green600,
              ),
            ),
    );
  }
}
