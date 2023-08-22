import 'package:flashcards_reader/bloc/book_listing_bloc/book_listing_bloc.dart';
import 'package:flashcards_reader/bloc/flashcards_bloc/flashcards_bloc.dart';
import 'package:flashcards_reader/bloc/providers/word_collection_provider.dart';
import 'package:flashcards_reader/bloc/translator_bloc/translator_bloc.dart';
import 'package:flashcards_reader/model/entities/reader/book_model.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flashcards_reader/views/guide_wrapper.dart';
import 'package:flashcards_reader/views/menu/adaptive_context_selection_menu.dart';
import 'package:flashcards_reader/views/parent_screen.dart';
import 'package:flashcards_reader/views/reader/open_books/bottom_sheet_widget.dart';
import 'package:flashcards_reader/views/reader/tabs/settings_book.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FontProvider {
  static TextStyle font = const TextStyle();
}

class TextBookViewProvider {
  static bool _hideBar = false;
  static get hideBar => _hideBar;
  static String selectedText = '';
  static void switchBar() {
    _hideBar = !_hideBar;
    if (_hideBar) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: SystemUiOverlay.values);
    }
  }

  static void dispose() {
    _hideBar = false;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }
}

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
  Future<String>? textFuture;
  Future<String>? fString;
  @override
  void initState() {
    textFuture = widget.book.getAllTextAsync();

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
            bookText: textFuture,
            settingsController: SettingsControllerViewText(SettingsService()),
          ),
        ),
      ),
    );
    return super.build(context);
  }
}

class ViewTextBook extends StatefulWidget {
  final Future<String>? bookText;

  final BookModel book;

  final SettingsControllerViewText settingsController;

  const ViewTextBook({
    Key? key,
    required this.book,
    required this.bookText,
    required this.settingsController,
    /*  required this.settingsController */
  }) : super(key: key);

  @override
  State<ViewTextBook> createState() => _ViewTextBookState();
}

class _ViewTextBookState extends State<ViewTextBook> {
  bool show = false;

  @override
  void dispose() {
    TextBookViewProvider.dispose();
    super.dispose();
  }

  double appBarHeigth = 0;

  @override
  Widget build(BuildContext context) {
    var appBar = !TextBookViewProvider.hideBar
        ? AppBar(
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      show == true ? show = false : show = true;
                    });
                  },
                  icon: const Icon(Icons.more_vert)),
              const SizedBox(
                width: 12,
              ),
            ],
            elevation: 0,
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.book.title.toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(widget.book.author.toString(),
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Roboto')),
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
        bottomSheet: show == true
            ? BottomSheet(
                enableDrag: false,
                builder: (context) => BottomSheetWidget(
                  settingsController: widget.settingsController,
                  book: widget.book,
                  onClickedClose: () => setState(() {
                    show = false;
                  }),
                  onClickedConfirm: (value) => setState(() {
                    FontProvider.font = value;
                    show = false;
                  }),
                ),
                onClosing: () {},
              )
            : null,
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onDoubleTap: () {
            setState(() {
              TextBookViewProvider.switchBar();
            });
          },
          child: FutureBuilder(
            future: widget.bookText,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                return SelectionArea(
                    contextMenuBuilder: (
                      BuildContext context,
                      SelectableRegionState selectableRegionState,
                    ) =>
                        FlashReaderAdaptiveContextSelectionMenu(
                            selectableRegionState: selectableRegionState),
                    onSelectionChanged: (value) {
                      if (value != null) {
                        WordCreatingUIProvider.tmpFlashCard.question =
                            value.plainText;
                        TextBookViewProvider.selectedText = value.plainText;
                      }
                    },
                    child: Paginator(
                        appBarHeigth: appBarHeigth,
                        hideBar: TextBookViewProvider.hideBar,
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
  double _currentPage = 0;

  void changePage(int page) {
    _pageController.jumpToPage(page);
  }

  @override
  void initState() {
    FontProvider.font = TextStyle(
        fontFamily: widget.book.settings.fontFamily,
        fontSize: widget.book.settings.fontSize.toDouble());
    _currentPage = widget.book.settings.currentPage.toDouble();
    _pageController.addListener(() {
      _currentPage = _pageController.page ?? _currentPage;

      setState(() {});
    });
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        setState(() {
          changePage(_currentPage.round());
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
    int pagesCount = widget.book.settings.pagesCount;
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
                    'page: ${index + 1}',
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.justify,
                    style: FontProvider.font,
                  ),
                ),
              );
            },
          ),
        ),
        if (!TextBookViewProvider.hideBar)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Slider(
                  value: _currentPage.toDouble(),
                  min: 0,
                  max: pagesCount - 1 > 1 ? pagesCount - 1 : 1,
                  divisions: pagesCount - 1 > 1 ? pagesCount - 1 : 1,
                  label: '${(_currentPage + 1).toInt()} of $pagesCount',
                  onChanged: (value) {
                    setState(() {
                      _currentPage = value;
                      // validate value, -1 because starts from 0

                      changePage(value.round());

                      if (widget.book.settings.currentPage != value.round()) {
                        debugPrintIt(
                            'save current page $_currentPage to book : ${widget.book.title}');

                        BlocProvider.of<BookBloc>(context).add(UpdateBookEvent(
                            bookModel: widget.book
                              ..settings.currentPage = _currentPage.round()
                              // TODO detete it after calculate pages fr
                              ..settings.pagesCount = 10));
                      }
                    });
                  })
            ],
          ),
      ],
    );
  }
}
