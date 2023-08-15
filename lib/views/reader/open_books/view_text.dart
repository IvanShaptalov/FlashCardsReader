import 'package:flashcards_reader/bloc/flashcards_bloc/flashcards_bloc.dart';
import 'package:flashcards_reader/bloc/providers/word_collection_provider.dart';
import 'package:flashcards_reader/bloc/translator_bloc/translator_bloc.dart';
import 'package:flashcards_reader/model/entities/reader/book_model.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/util/router.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flashcards_reader/views/menu/adaptive_context_selection_menu.dart';
import 'package:flashcards_reader/views/parent_screen.dart';
import 'package:flashcards_reader/views/reader/open_books/page_counter.dart';
import 'package:flashcards_reader/views/reader/screens/reading_homepage.dart';
import 'package:flashcards_reader/views/reader/tabs/settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
  // TODO merge book settings (2 classes exists now)
  BookSettings bookSettings = BookSettings();

  @override
  void initState() {
    textFuture = widget.book.getAllTextAsync().then((value) {
      pages = PageCounter.calculatePages(value, bookSettings);
      return value;
    });
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
          textFuture: textFuture,
          isTutorial: widget.isTutorial,
          bookSettings: bookSettings,
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ViewTextBook extends ParentStatefulWidget {
  final BookSettings bookSettings;
  Future<String>? textFuture;
  final BookModel book;
  static bool showBar = false;
  final bool isTutorial;
  static bool textLoaded = false;

  ViewTextBook(
      {super.key,
      required this.book,
      required this.isTutorial,
      required this.textFuture,
      required this.bookSettings});

  @override
  ViewTextState createState() => ViewTextState();
}

class ViewTextState extends ParentState<ViewTextBook> {
  @override
  void initState() {
    ViewTextBook.showBar = true;

    super.initState();
    if (kIsWeb) {
      BrowserContextMenu.disableContextMenu();
    }
  }

  @override
  void dispose() {
    if (kIsWeb) {
      BrowserContextMenu.enableContextMenu();
    }
    super.dispose();
  }

  void callback() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    debugPrintIt(
        'title of selected flashcard : ======================${FlashCardProvider.fc.title}');
    var appBar = ViewTextBook.showBar
        ? AppBar(
            title: Text(
              widget.book.title,
              style: FontConfigs.pageNameTextStyle,
            ),
            actions: const [
              Offstage(),
            ],
            leading: BackButton(
              onPressed: () => MyRouter.pushPageReplacement(
                  context, ReadingHomePage(isTutorial: widget.isTutorial)),
            ),
            backgroundColor: Palette.green300Primary,
            elevation: 0,
            iconTheme: IconThemeData(color: Palette.blueGrey),
          )
        : null;

    double appBarHeight = appBar != null ? appBar.preferredSize.height : 0;
    bindPage(Scaffold(
        appBar: appBar,
        body: Stack(children: [
          GestureDetector(
              // behavior: HitTestBehavior.,
              onDoubleTap: () {
                ViewTextBook.showBar = !ViewTextBook.showBar;
                debugPrintIt('on tap');
                setState(() {});
              },
              child: Container(
                padding: EdgeInsets.only(
                    top: SizeConfig.getMediaHeight(context,
                        p: !ViewTextBook.showBar ? 0.05 : 0),
                    left: 8,
                    right: 8,
                    bottom: 8),
                color: Palette.amber50,
                height: SizeConfig.getMediaHeight(context),
                width: SizeConfig.getMediaWidth(context),
                child: SelectionArea(
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
                    }
                  },
                  child: FutureBuilder(
                    builder: (context, snapshot) {
                      TextStyle style = widget.bookSettings.calculateStyle();

                      var maxLines = PageCounter.maxLines(context, appBarHeight,
                          widget.bookSettings.fontSize.round(),
                          lineHeight: widget.bookSettings.lineHeight);
                      if (snapshot.hasData && snapshot.data != null) {
                        // start from 4 step
                        ViewTextBook.textLoaded = true;
                        return widget.isTutorial
                            ? Text(
                                """SELECT TEXT\nTAP TRANSLATE BUTTON\nTHEN SAVE WORD\n\n${snapshot.data!}""",
                                style: style,
                                maxLines: maxLines,
                              )
                            : Text(
                                snapshot.data!,
                                style: style,
                                maxLines: maxLines,
                              );
                      } else {
                        return Center(
                          child: SpinKitWave(
                            color: Palette.green600,
                          ),
                        );
                      }
                    },
                    future: widget.textFuture,
                  ),
                ),
              )),
        ])));

    return super.build(context);
  }
}
