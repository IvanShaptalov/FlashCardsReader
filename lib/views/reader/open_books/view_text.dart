import 'package:flashcards_reader/bloc/book_listing_bloc/book_listing_bloc.dart';
import 'package:flashcards_reader/bloc/flashcards_bloc/flashcards_bloc.dart';
import 'package:flashcards_reader/bloc/providers/word_collection_provider.dart';
import 'package:flashcards_reader/bloc/translator_bloc/translator_bloc.dart';
import 'package:flashcards_reader/model/entities/reader/book_model.dart';
import 'package:flashcards_reader/model/entities/reader/page_paginator.dart';
import 'package:flashcards_reader/util/router.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flashcards_reader/views/flashcards/flashcards/flashcards_screen.dart';
import 'package:flashcards_reader/views/guide_wrapper.dart';
import 'package:flashcards_reader/views/menu/adaptive_context_selection_menu.dart';
import 'package:flashcards_reader/views/overlay_notification.dart';
import 'package:flashcards_reader/views/parent_screen.dart';
import 'package:flashcards_reader/views/reader/open_books/bottom_sheet_notes.dart';
import 'package:flashcards_reader/views/reader/open_books/bottom_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FontProvider {}

// ignore: must_be_immutable
class TextBookProvider extends ParentStatefulWidget {
  TextBookProvider({
    super.key,
    required this.book,
  });
  final BookModel book;

  @override
  ParentState<TextBookProvider> createState() => _TextBookProviderState();
}

class _TextBookProviderState extends ParentState<TextBookProvider> {
  @override
  void initState() {
    PagePaginatorProvider.book = widget.book;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.page = BlocProvider(
      create: (_) => BookBloc(),
      child: BlocProvider(
        create: (_) => FlashCardBloc(),
        child: BlocProvider(
          create: (_) => TranslatorBloc(),
          child: ViewTextBook(
            book: widget.book,
          ),
        ),
      ),
    );
    return super.build(context);
  }
}

class ViewTextBook extends StatefulWidget {
  final BookModel book;

  const ViewTextBook({
    Key? key,
    required this.book,
  }) : super(key: key);

  @override
  State<ViewTextBook> createState() => _ViewTextBookState();
}

class _ViewTextBookState extends State<ViewTextBook> {
  bool showSettings = false;
  bool showNotes = false;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (GuideProvider.isTutorial) {
        OverlayNotificationProvider.showOverlayNotification(
            'select text and tap translate',
            duration: null);
      }
    });
  }

  @override
  void dispose() {
    PagePaginatorProvider.dispose();
    super.dispose();
  }

  double appBarHeigth = 0;

  @override
  Widget build(BuildContext context) {
    var appBar = !PagePaginatorProvider.hideBar
        ? AppBar(
            elevation: 0,
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: SizeConfig.getMediaWidth(context, p: 0.3),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.book.title.toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                            widget.book.author.isNotEmpty
                                ? widget.book.author
                                : 'no author',
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Roboto')),
                      ],
                    ),
                  ),
                ),
                if (!GuideProvider.isTutorial)
                  IconButton(
                    onPressed: () {
                      MyRouter.pushPage(context, const FlashCardScreen());
                    },
                    icon: const Icon(Icons.web_stories_outlined),
                    color: Palette.grey800,
                  ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      showNotes == true ? showNotes = false : showNotes = true;

                      showSettings = false;
                    });
                  },
                  icon: const Icon(Icons.notes),
                  color: Palette.grey800,
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      showSettings == true
                          ? showSettings = false
                          : showSettings = true;

                      showNotes = false;
                    });
                  },
                  icon: const Icon(Icons.settings),
                  color: Palette.grey800,
                ),
              ],
            ),
          )
        : null;
    if (appBar != null) {
      appBarHeigth = appBar.preferredSize.height;
    }

    return WillPopScope(
      onWillPop: () {
        return Future.value(!GuideProvider.isTutorial);
      },
      child: Scaffold(
        appBar: appBar,
        body: _buildContent(context),
        resizeToAvoidBottomInset: true,
        bottomSheet: showSettings
            ? BottomSheet(
                enableDrag: false,
                builder: (context) => BottomSheetWidget(
                  onClickedClose: () => setState(() {
                    setState(() {
                      showSettings = false;
                    });
                  }),
                  onClickedConfirm: (value) => setState(() {
                    PagePaginatorProvider.font = value;

                    showSettings = false;
                  }),
                ),
                onClosing: () {},
              )
            : showNotes
                ? BottomSheetNotes(
                    book: widget.book,
                    onClickedClose: () {
                      setState(() {
                        showNotes = false;
                      });
                    })
                : null,
      ),
    );
  }

  static String note = '';

  void addNoteCallback() {
    setState(() {
      widget.book.bookNotes.notes.addAll({note: 'add your comment'});
      BlocProvider.of<BookBloc>(context)
          .add(UpdateBookEvent(bookModel: widget.book));
    });
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onDoubleTap: () {
            setState(() {
              PagePaginatorProvider.switchBar();
            });
          },
          child: FutureBuilder(
            future: PagePaginatorProvider.loadBook(context),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                /// =====================[SETUP PAGES]

                widget.book.settings.pagesCount =
                    PagePaginatorProvider.setupPages(context, appBarHeigth);
                BlocProvider.of<BookBloc>(context)
                    .add(UpdateBookEvent(bookModel: widget.book));
                return SelectionArea(
                    contextMenuBuilder: (
                      BuildContext context,
                      SelectableRegionState selectableRegionState,
                    ) =>
                        FlashReaderAdaptiveContextSelectionMenu(
                            selectableRegionState: selectableRegionState,
                            addNoteCallback: addNoteCallback),
                    onSelectionChanged: (value) {
                      if (value != null) {
                        WordCreatingUIProvider.tmpFlashCard.question =
                            value.plainText;
                        PagePaginatorProvider.selectedText = value.plainText;
                        note = value.plainText;
                      }
                    },
                    child: Paginator(
                        appBarHeigth: appBarHeigth,
                        hideBar: PagePaginatorProvider.hideBar,
                        book: widget.book));
              } else {
                return SpinKitWave(
                  color: Palette.green300Primary,
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

class Paginator extends StatefulWidget {
  final List<String> content = const [];
  final double appBarHeigth;
  final bool hideBar;
  final BookModel book;

  const Paginator(
      {super.key,
      required this.appBarHeigth,
      required this.hideBar,
      required this.book});

  @override
  State<Paginator> createState() => _PaginatorState();
}

class _PaginatorState extends State<Paginator> {
  final PageController _pageController = PageController();

  void changePage(int page) {
    _pageController.jumpToPage(page);
  }

  @override
  void initState() {
    PagePaginatorProvider.font = TextStyle(
        fontFamily: widget.book.settings.fontFamily,
        fontSize: widget.book.settings.fontSize.toDouble());
    PagePaginatorProvider.currentPage = widget.book.settings.currentPage;
    _pageController.addListener(() {
      PagePaginatorProvider.updateBookPage(
          (_pageController.page ?? PagePaginatorProvider.currentPage).toInt(),
          context);

      setState(() {});
    });

    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        setState(() {
          changePage(PagePaginatorProvider.currentPage);
        });
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: SizeConfig.getMediaHeight(context) -
              (widget.hideBar ? 0 : widget.appBarHeigth * 2.5),
          width: SizeConfig.getMediaWidth(context),
          child: PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            physics: const PageScrollPhysics(),
            itemCount: widget.book.settings.pagesCount,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                color: Palette.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    PagePaginatorProvider.pages[index].toString(),
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.justify,
                    style: PagePaginatorProvider.font,
                  ),
                ),
              );
            },
          ),
        ),
        if (!PagePaginatorProvider.hideBar)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (PagePaginatorProvider.maxPage > 0)
                Slider(
                    value: PagePaginatorProvider.currentPage.toDouble(),
                    min: PagePaginatorProvider.minPage.toDouble(),
                    max: PagePaginatorProvider.maxPage.toDouble(),
                    divisions: PagePaginatorProvider.maxPage,
                    label:
                        '''${(PagePaginatorProvider.currentPage + 1).toInt()} of ${PagePaginatorProvider.maxPage + 1}''',
                    onChanged: (value) {
                      setState(() {
                        changePage(value.round());
                      });
                    })
            ],
          ),
      ],
    );
  }
}
