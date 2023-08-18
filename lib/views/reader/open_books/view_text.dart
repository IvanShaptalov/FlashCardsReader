import 'package:flashcards_reader/bloc/flashcards_bloc/flashcards_bloc.dart';
import 'package:flashcards_reader/bloc/providers/word_collection_provider.dart';
import 'package:flashcards_reader/bloc/translator_bloc/translator_bloc.dart';
import 'package:flashcards_reader/model/entities/reader/book_model.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flashcards_reader/views/menu/adaptive_context_selection_menu.dart';
import 'package:flashcards_reader/views/reader/open_books/bottom_sheet_widget.dart';
import 'package:flashcards_reader/views/reader/tabs/settings_book.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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

class TextBookProvider extends StatefulWidget {
  const TextBookProvider(
      {super.key, required this.book, this.isTutorial = false});
  final BookModel book;
  final bool isTutorial;

  @override
  State<TextBookProvider> createState() => _TextBookProviderState();
}

class _TextBookProviderState extends State<TextBookProvider> {
  Future<String>? textFuture;
  int pages = 0;
  BookSettings bookSettings = BookSettings();
  Future<String>? fString;
  @override
  void initState() {
    textFuture = widget.book.getAllTextAsync();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FlashCardBloc(),
      child: BlocProvider(
        create: (_) => TranslatorBloc(),
        child: ViewTextBook(
          book: widget.book,
          bookText: textFuture,
          isTutorial: widget.isTutorial,
          settingsController: SettingsControllerViewText(SettingsService()),
        ),
      ),
    );
  }
}

class ViewTextBook extends StatefulWidget {
  final Future<String>? bookText;

  final BookModel book;

  final bool isTutorial;
  final SettingsControllerViewText settingsController;

  const ViewTextBook({
    Key? key,
    required this.book,
    required this.bookText,
    required this.isTutorial,
    required this.settingsController,
    /*  required this.settingsController */
  }) : super(key: key);

  @override
  State<ViewTextBook> createState() => _ViewTextBookState();
}

class _ViewTextBookState extends State<ViewTextBook> {
  bool show = false;
  TextStyle font = const TextStyle(
      fontSize: 16, fontWeight: FontWeight.normal, fontFamily: 'Roboto');

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
    return Scaffold(
      appBar: appBar,
      body: _buildContent(context),
      bottomSheet: show == true
          ? BottomSheet(
              enableDrag: false,
              builder: (context) => BottomSheetWidget(
                settingsController: widget.settingsController,
                settings: {
                  'size': font.fontSize,
                  'theme': false,
                  'font_name': font.fontFamily,
                },
                onClickedClose: () => setState(() {
                  show = false;
                }),
                onClickedConfirm: (value) => setState(() {
                  font = value;
                  show = false;
                }),
              ),
              onClosing: () {},
            )
          : null,
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
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
                            selectableRegionState: selectableRegionState,
                            isTutorial: widget.isTutorial),
                    onSelectionChanged: (value) {
                      if (value != null) {
                        WordCreatingUIProvider.tmpFlashCard.question =
                            value.plainText;
                        TextBookViewProvider.selectedText = value.plainText;
                      }
                    },
                    child: Paginator(
                      font: font,
                      appBarHeigth: appBarHeigth,
                      hideBar: TextBookViewProvider.hideBar,
                    ));
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
  final TextStyle font;
  final int pagesCount = 10;
  final int startPage = 0;
  final List<String> content = const [];
  final double appBarHeigth;
  final bool hideBar;

  const Paginator(
      {super.key,
      required this.font,
      required this.appBarHeigth,
      required this.hideBar});

  @override
  State<Paginator> createState() => _PaginatorState();
}

class _PaginatorState extends State<Paginator> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.toInt() ?? 0;
      });
    });
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
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: SizeConfig.getMediaHeight(context) -
              (widget.hideBar ? 0 : widget.appBarHeigth * 3),
          width: SizeConfig.getMediaWidth(context),
          child: PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            physics: const PageScrollPhysics(),
            itemCount: widget.pagesCount,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                color: Palette.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'page: ${index + 1}',
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.justify,
                    style: widget.font,
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
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text('${_currentPage + 1} of ${widget.pagesCount}',
                    style: FontConfigs.h3TextStyle.copyWith(fontSize: 10)),
              ),
              Slider(
                  value: _currentPage.toDouble(),
                  min: 0,
                  max: widget.pagesCount.toDouble() - 1,
                  onChanged: (value) {
                    setState(() {
                      // validate value, -1 because starts from 0
                      value = value < 1
                          ? 0
                          : value > widget.pagesCount
                              ? widget.pagesCount.toDouble()
                              : value;
                      _pageController.jumpToPage(value.round());
                    });
                  })
            ],
          ),
      ],
    );
  }
}
