// ignore_for_file: lines_longer_than_80_chars

import 'dart:io';

import 'package:flashcards_reader/bloc/book_listing_bloc/book_listing_bloc.dart';
import 'package:flashcards_reader/bloc/flashcards_bloc/flashcards_bloc.dart';
import 'package:flashcards_reader/bloc/providers/book_pagination_provider.dart';
import 'package:flashcards_reader/bloc/providers/word_collection_provider.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/model/entities/reader/book_model.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/util/router.dart';
import 'package:flashcards_reader/views/guide_wrapper.dart';
import 'package:flashcards_reader/views/overlay_notification.dart';
import 'package:flashcards_reader/views/parent_screen.dart';
import 'package:flashcards_reader/views/reader/open_books/view_epub.dart';
import 'package:flashcards_reader/views/reader/open_books/view_pdf.dart';
import 'package:flashcards_reader/views/reader/open_books/view_text.dart';
import 'package:flashcards_reader/views/flashcards/new_word/add_word_collection_widget.dart';
import 'package:flashcards_reader/views/flashcards/new_word/screens/base_new_word_screen.dart';
import 'package:flutter/material.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';

// ignore: must_be_immutable
class OpenBook extends ParentStatefulWidget {
  final BookModel book;
  final BuildContext upperContext;

  OpenBook({
    required this.book,
    super.key,
    required this.upperContext,
  });

  @override
  OpenBookState createState() => OpenBookState();
}

class OpenBookState extends ParentState<OpenBook> {
  List<FlashCardCollection>? collection;
  void callback() {
    setState(() {});
  }

  @override
  void initState() {
    // get collection
    collection = BlocProvider.of<FlashCardBloc>(widget.upperContext)
        .state
        .copyWith(fromTrash: false)
        .flashCards;

    /// get selected flashcard
    FlashCardCollection? selected = FlashCardProvider.fc;
    if (collection != null &&
        collection!.isNotEmpty &&
        selected.compareWithoutId(flashExample())) {
      selected = collection!.first;
      FlashCardProvider.fc = selected;
    }

    super.initState();

    if (GuideProvider.isTutorial) {
      GuideProvider.startStep(context, 2);
      GuideProvider.isTutorial = true;
    }
  }

  void updateCallback() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // reorder cards
    if (!FastCardListProvider.putSelectedCardToFirstPositionBookMenu(
        collection ?? [], widget.book)) {
      debugPrintIt('book doesn`t have flashcard id yet, select and save first');
      var selectedFlash =
          FastCardListProvider.putSelectedCardToFirstPosition(collection ?? []);
      // save flashcard
      widget.upperContext.read<BookBloc>().add(UpdateBookEvent(
          bookModel: widget.book..flashCardId = selectedFlash.id));
    }

    bindPage(WillPopScope(
      onWillPop: () {
        return Future.value(!GuideProvider.isTutorial);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.book.title,
            style: FontConfigs.pageNameTextStyle,
          ),
          actions: const [Offstage()],
          backgroundColor: Palette.green300Primary,
          elevation: 0,
          iconTheme: IconThemeData(color: Palette.blueGrey),
        ),
        body: Stack(children: [
          Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  image: File(widget.book.coverPath).existsSync()
                      ? DecorationImage(
                          image: FileImage(File(widget.book.coverPath)),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              Palette.darkBlue.withOpacity(0.9),
                              BlendMode.multiply))
                      : DecorationImage(
                          image: AssetImage(widget.book == BookModel.asset()
                              ? 'assets/book/quotes_skin.png'
                              : 'assets/images/empty.png'),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              Palette.darkBlue.withOpacity(0.9),
                              BlendMode.multiply)))),
          Center(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 45, 0, 0),
                  height: 340,
                  width: 250,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(widget.book == BookModel.asset()
                              ? 'assets/book/quotes_skin.png'
                              : 'assets/images/empty.png'),
                          fit: BoxFit.fill)),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    widget.book.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Palette.white),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: Text(
                    'book',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Palette.white,
                      fontStyle: FontStyle.italic,
                      fontSize: 15,
                    ),
                  ),
                )
              ],
            ),
          ),
          SlidingUpPanel(
            color: Palette.green300Primary,
            maxHeight: SizeConfig.getMediaHeight(context, p: 0.7),
            defaultPanelState: PanelState.OPEN,
            backdropEnabled: true,
            panel: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(
                    'Collection to save words',
                    style: FontConfigs.h1TextStyle.copyWith(
                        fontWeight: FontWeight.bold, color: Palette.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  color: Palette.grey300,
                  child: AnimationLimiter(
                    child: SizedBox(
                      height: SizeConfig.getMediaHeight(context, p: 0.3),
                      width: SizeConfig.getMediaWidth(context, p: 1),
                      child: ListView.builder(
                          controller: FastCardListProvider.scrollController,
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              collection!.isEmpty ? 1 : collection!.length,
                          itemBuilder: (context, index) {
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 400),
                              child: Transform.scale(
                                scale: 0.9,
                                child: GuideProvider.wrapInGuideIfNeeded(
                                  step: 2,
                                  // only first card
                                  toWrap:
                                      index == 0 && GuideProvider.isTutorial,
                                  guideText:
                                      'Select flashCard to save words from book',
                                  onHighlightTap: () {
                                    GuideProvider.introController.next();
                                  },
                                  child: FastAddWordFCcWidget(
                                    collection!.isEmpty
                                        ? FlashCardProvider.fc
                                        : collection![index],
                                    callback,
                                    design: ScreenIdentifier.indentify(context),
                                    book: widget.book,
                                    bookContext: widget.upperContext,
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                ),
                GuideProvider.wrapInIntroIfNeeded(
                  step: 3,
                  guideText: 'Open book',
                  child: ElevatedButton(
                    style: ButtonStyle(
                        padding:
                            MaterialStateProperty.all(const EdgeInsets.all(25)),
                        backgroundColor:
                            MaterialStateProperty.all(Palette.amber50),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)))),
                    onPressed: () {
                      widget.book.status.setReading = true;

                      BlocProvider.of<BookBloc>(widget.upperContext).add(
                          UpdateBookEvent(
                              bookModel: widget.book
                                ..lastAccess = DateTime.now()));
                      debugPrintIt(' it not work in tutorial');
                      // check that flashcard selected
                      if (collection != null &&
                          widget.book.flashCardId != null &&
                          collection!
                              .map((e) => e.id)
                              .contains(widget.book.flashCardId)) {
                        widget.book.flashCardId = FlashCardProvider.fc.id;
                      }
                      if (widget.book.isBinded) {
                        switch (widget.book.fileMeta.ext) {
                          case '.txt':
                            debugPrintIt('txt');
                            // check that collection has selected flashCard
                            BookPaginationProvider.setUpBook(widget.book);

                            MyRouter.pushPageReplacement(
                                context, TextBookProvider());

                            break;
                          case '.pdf':
                            debugPrintIt('pdf');

                            BookPaginationProvider.setUpBook(widget.book);

                            MyRouter.pushPage(
                                context,
                                ViewPDF(
                                  widget.book.title,
                                  widget.book.fileMeta.path,
                                  saveBook: (page) {
                                    widget.book.settings.currentPage = page;
                                    BlocProvider.of<BookBloc>(
                                            widget.upperContext)
                                        .add(UpdateBookEvent(
                                            bookModel: widget.book));
                                  },
                                  page: widget.book.settings.currentPage,
                                ));

                            break;
                          case '.epub':
                            debugPrintIt('epub');

                            MyRouter.pushPageReplacement(
                                context,
                                EpubTextView(
                                  file: File(widget.book.fileMeta.path),
                                  epubCFI: widget.book.settings.epubCFI,
                                  pageIndex: widget.book.settings.currentPage,
                                  saveBook: (pageIndex, epubCfi) {
                                    debugPrintIt('new epubCFI: $pageIndex');
                                    if (pageIndex != null) {
                                      widget.book.settings.currentPage =
                                          pageIndex;
                                    }
                                    if (epubCfi != null) {
                                      widget.book.settings.epubCFI = epubCfi;
                                    }

                                    BlocProvider.of<BookBloc>(
                                            widget.upperContext)
                                        .add(UpdateBookEvent(
                                            bookModel: widget.book));
                                  },
                                ));
                            break;
                          case '.fb2':
                            debugPrintIt('fb2');

                            break;
                          default:
                        }
                      } else {
                        OverlayNotificationProvider.showOverlayNotification(
                            'Book not found');
                      }
                    },
                    child: Text("Read Book", style: FontConfigs.h1TextStyle),
                  ),
                )
              ],
            ),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          const Offstage()
        ]),
      ),
    ));
    return super.build(context);
  }
}
