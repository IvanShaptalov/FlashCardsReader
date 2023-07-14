import 'package:flashcards_reader/bloc/flashcards_bloc/flashcards_bloc.dart';
import 'package:flashcards_reader/bloc/providers/word_collection_provider.dart';
import 'package:flashcards_reader/bloc/translator_bloc/translator_bloc.dart';
import 'package:flashcards_reader/model/entities/reader/book_model.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flashcards_reader/views/menu/adaptive_context_selection_menu.dart';
import 'package:flashcards_reader/views/parent_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TextBookProvider extends StatefulWidget {
  const TextBookProvider({super.key, required this.book});
  final BookModel book;

  @override
  State<TextBookProvider> createState() => _TextBookProviderState();
}

class _TextBookProviderState extends State<TextBookProvider> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FlashCardBloc(),
      child: BlocProvider(
        create: (_) => TranslatorBloc(),
        child: ViewTextBook(book: widget.book),
      ),
    );
  }
}

// ignore: must_be_immutable
class ViewTextBook extends ParentStatefulWidget {
  ViewTextBook({super.key, required this.book});
  final BookModel book;
  static bool showBar = false;

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
    bindPage(Scaffold(
        appBar: ViewTextBook.showBar
            ? AppBar(
                title: Text(
                  widget.book.title,
                  style: FontConfigs.pageNameTextStyle,
                ),
                actions: const [Offstage()],
                backgroundColor: Palette.green300Primary,
                elevation: 0,
                iconTheme: IconThemeData(color: Palette.blueGrey),
              )
            : null,
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
                  ),
                  onSelectionChanged: (value) {
                    if (value != null) {
                      WordCreatingUIProvider.tmpFlashCard.question =
                          value.plainText;
                    }
                  },
                  child: Text(widget.book.getAllText()),
                ),
              )),
        ])));
    return super.build(context);
  }
}
