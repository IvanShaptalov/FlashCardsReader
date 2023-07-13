import 'package:flashcards_reader/bloc/providers/word_collection_provider.dart';
import 'package:flashcards_reader/model/entities/reader/book_model.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flashcards_reader/views/menu/adaptive_context_selection_menu.dart';
import 'package:flashcards_reader/views/parent_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class ViewText extends ParentStatefulWidget {
  ViewText({super.key, required this.book, required this.upperContext});
  final BookModel book;
  final BuildContext upperContext;
  static bool showBar = false;

  @override
  ViewTextState createState() => ViewTextState();
}

class ViewTextState extends ParentState<ViewText> {
  @override
  void initState() {
    ViewText.showBar = true;
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
        appBar: ViewText.showBar
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
                ViewText.showBar = !ViewText.showBar;
                debugPrintIt('on tap');
                setState(() {});
              },
              child: Container(
                padding: EdgeInsets.only(
                    top: SizeConfig.getMediaHeight(context,
                        p: !ViewText.showBar ? 0.05 : 0),
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
                    callback: callback,
                    widget: widget,
                  ),
                  child: Text(widget.book.getAllText()),
                ),
              )),
        ])));
    return super.build(context);
  }
}
