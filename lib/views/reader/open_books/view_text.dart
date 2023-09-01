import 'package:flashcards_reader/bloc/book_listing_bloc/book_listing_bloc.dart';
import 'package:flashcards_reader/bloc/flashcards_bloc/flashcards_bloc.dart';
import 'package:flashcards_reader/bloc/providers/word_collection_provider.dart';
import 'package:flashcards_reader/bloc/translator_bloc/translator_bloc.dart';
import 'package:flashcards_reader/bloc/providers/book_pagination_provider.dart';
import 'package:flashcards_reader/util/error_handler.dart';
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

class FutureStringProvider {
  static Future<String>? loadingText;
}

// ignore: must_be_immutable
class TextBookProvider extends ParentStatefulWidget {
  TextBookProvider({
    super.key,
  });

  @override
  ParentState<TextBookProvider> createState() => _TextBookProviderState();
}

class _TextBookProviderState extends ParentState<TextBookProvider> {
  @override
  Widget build(BuildContext context) {
    widget.page = BlocProvider(
      create: (_) => BookBloc(),
      child: BlocProvider(
        create: (_) => FlashCardBloc(),
        child: BlocProvider(
          create: (_) => TranslatorBloc(),
          child: const ViewTextBook(),
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
    FutureStringProvider.loadingText = BookPaginationProvider.loadBook();

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
    super.dispose();
    FutureStringProvider.loadingText = null;
    BookPaginationProvider.needToUpdatePagesFromUI = true;
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
                          BookPaginationProvider.book.title.toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(BookPaginationProvider.getAuthor,
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
                  onClickedConfirm: () => setState(() {}),
                ),
                onClosing: () {},
              )
            : showNotes
                ? BottomSheetNotes(
                    book: BookPaginationProvider.book,
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
          note: note, context: context, book: BookPaginationProvider.book);
    });
  }

  Widget _buildTextContent(BuildContext context) {
    return FutureBuilder(
      future: FutureStringProvider.loadingText,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData && snapshot.data.toString().isNotEmpty) {
          /// =====================[SETUP PAGES]
          if (BookPaginationProvider.needToUpdatePagesFromUI) {
            BookPaginationProvider.initPages(
                SizeConfig.size(context, edgeInsets: EdgeInsets.all(10)),
                context);
          }

          BlocProvider.of<BookBloc>(context)
              .add(UpdateBookEvent(bookModel: BookPaginationProvider.book));
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
    BookPaginationProvider.jumpToPage(context: context, pageNumber: page);

    _pageController.jumpToPage(page);
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    print('rebuild paginator');
    _pageController.addListener(() {
      BookPaginationProvider.jumpToPage(
          context: context,
          pageNumber:
              (_pageController.page ?? BookPaginationProvider.currentPage)
                  .toInt());
      debugPrintIt('listen page builder');
      setState(() {});
    });

    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        setState(() {
          changePage(BookPaginationProvider.currentPage.toInt());
        });
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    debugPrintIt('dispose page Controller');
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
              (AppBarProvider.hideBar ? 16 : widget.appBarHeigth * 2.5),
          width: SizeConfig.getMediaWidth(context),
          child: PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            physics: const PageScrollPhysics(),
            itemCount: BookPaginationProvider.upperBoundPage.toInt(),
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  BookPaginationProvider.pages[index].toString(),
                  textAlign: TextAlign.justify,
                  textDirection: TextDirection.ltr,
                  style: BookPaginationProvider.getBookTextStyle,
                ),
              );
            },
          ),
        ),
        if (!AppBarProvider.hideBar)
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(BookPaginationProvider.label,
                  style: FontConfigs.h3TextStyleBlack),
              if (!BookPaginationProvider.isOnePage)
                Slider(
                    value: BookPaginationProvider.currentPage.toDouble(),
                    min: BookPaginationProvider.lowerBoundPage.toDouble(),
                    max: BookPaginationProvider.upperBoundPage.toDouble() - 1,
                    divisions: BookPaginationProvider.upperBoundPage.toInt(),
                    onChanged: (value) {
                      setState(() {
                        changePage(value.round());
                      });
                    }),
            ],
          )
      ],
    );
  }
}
