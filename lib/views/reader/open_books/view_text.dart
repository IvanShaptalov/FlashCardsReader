import 'package:flashcards_reader/bloc/book_listing_bloc/book_listing_bloc.dart';
import 'package:flashcards_reader/bloc/flashcards_bloc/flashcards_bloc.dart';
import 'package:flashcards_reader/bloc/providers/word_collection_provider.dart';
import 'package:flashcards_reader/bloc/translator_bloc/translator_bloc.dart';
import 'package:flashcards_reader/model/entities/reader/book_model.dart';
import 'package:flashcards_reader/bloc/providers/book_interaction_provider.dart';
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
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
    BookInteractivityProvider.setUpTextBook(widget.book);

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
          child: ViewTextBook(),
        ),
      ),
    );
    return super.build(context);
  }
}

class ViewTextBook extends StatefulWidget {
  const ViewTextBook({
    Key? key,
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
    BookInteractivityProvider.needToUpdatePagesFromUI = true;

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      BookInteractivityProvider.setupPages(SizeConfig.size(context), context);

      if (GuideProvider.isTutorial) {
        OverlayNotificationProvider.showOverlayNotification(
            'select text and tap translate',
            duration: null);
      }
    });
  }

  @override
  void dispose() {
    AppBarProvider.dispose();
    super.dispose();
  }

  double appBarHeigth = 0;

  @override
  Widget build(BuildContext context) {
    var appBar = !AppBarProvider.hideBar
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
                          BookInteractivityProvider.getBook.title.toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(BookInteractivityProvider.getAuthor,
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
        body: /* _buildTextContent(context) */ GestureDetector(
            onDoubleTap: () {
              setState(() {
                AppBarProvider.switchBar();
              });
            },
            child: _buildTextContent(context)),
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
                    BookInteractivityProvider.textStyle = value;
                  }),
                ),
                onClosing: () {},
              )
            : showNotes
                ? BottomSheetNotes(
                    book: BookInteractivityProvider.getBook,
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
      BookNotesProvider.updateNotes(
          note: note,
          context: context,
          book: BookInteractivityProvider.getBook);
    });
  }

  Widget _buildTextContent(BuildContext context) {
    return FutureBuilder(
      future: BookInteractivityProvider.loadBook(context),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          /// =====================[SETUP PAGES]
          if (BookInteractivityProvider.needToUpdatePagesFromUI) {
            BookInteractivityProvider.setupPages(
                SizeConfig.size(context), context);
            setState(() {});
          }

          BlocProvider.of<BookBloc>(context).add(
              UpdateBookEvent(bookModel: BookInteractivityProvider.getBook));
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
                  TextSelectorProvider.selectedText = value.plainText;
                  note = value.plainText;
                }
              },
              child: Paginator(appBarHeigth: appBarHeigth));
        } else {
          return SpinKitWave(
            color: Palette.green300Primary,
          );
        }
      },
    );
  }
}

class Paginator extends StatefulWidget {
  final double appBarHeigth;

  const Paginator({
    super.key,
    required this.appBarHeigth,
  });

  @override
  State<Paginator> createState() => _PaginatorState();
}

class _PaginatorState extends State<Paginator> {
  final PageController _pageController = PageController();

  void changePage(int page) {
    BookInteractivityProvider.changeCurrentPage(page);

    _pageController.jumpToPage(page);
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    _pageController.addListener(() {
      double fontSize = (_pageController.page ??
          BookInteractivityProvider.currentPage.toDouble());

      BookInteractivityProvider.updateBookPage(
          fontSize: fontSize, oldFontSize: fontSize, context: context);

      setState(() {});
    });

    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        setState(() {
          changePage(BookInteractivityProvider.currentPage.toInt());
        });
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: SizeConfig.getMediaHeight(context) -
              (AppBarProvider.hideBar ? 0 : widget.appBarHeigth * 2),
          width: SizeConfig.getMediaWidth(context),
          child: PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            physics: const PageScrollPhysics(),
            itemCount: BookInteractivityProvider.upperBoundPage.toInt(),
            itemBuilder: (BuildContext context, int index) {
              return Text(
                BookInteractivityProvider.pages[index].toString(),
                textDirection: TextDirection.ltr,
                style: BookInteractivityProvider.getBookTextStyle,
              );
            },
          ),
        ),
        if (!AppBarProvider.hideBar)
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (BookInteractivityProvider.upperBoundPage > 0)
                Slider(
                    value: BookInteractivityProvider.currentPage.toDouble(),
                    min: BookInteractivityProvider.lowerBoundPage.toDouble(),
                    max: BookInteractivityProvider.upperBoundPage.toDouble(),
                    divisions: BookInteractivityProvider.upperBoundPage.toInt(),
                    label: BookInteractivityProvider.label,
                    onChanged: (value) {
                      setState(() {
                        changePage(value.round());
                      });
                    })
              else
                Text(BookInteractivityProvider.label,
                    style: FontConfigs.h2TextStyleBlack),
            ],
          )
      ],
    );
  }
}
