import 'package:flashcards_reader/model/entities/reader/book_model.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flashcards_reader/views/menu/adaptive_context_selection_menu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ViewText extends StatefulWidget {
  const ViewText({Key? key, required this.book}) : super(key: key);
  final BookModel book;
  static bool showBar = false;

  @override
  ViewTextState createState() => ViewTextState();
}

class ViewTextState extends State<ViewText> {
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

  void _showDialog(BuildContext context) {
    Navigator.of(context).push(
      DialogRoute<void>(
        context: context,
        builder: (BuildContext context) =>
            const AlertDialog(title: Text('You clicked print!')),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ViewText.showBar
            ? AppBar(
                title: Text(
                  widget.book.title,
                  style: FontConfigs.pageNameTextStyle,
                ),
                actions: const [Offstage()],
                backgroundColor: Palette.menuColor,
                elevation: 0,
                iconTheme: const IconThemeData(color: Palette.darkblue),
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
                color: Palette.cardButtonColor,
                height: SizeConfig.getMediaHeight(context),
                width: SizeConfig.getMediaWidth(context),
                child: SelectionArea(
                  contextMenuBuilder: (
                    BuildContext context,
                    SelectableRegionState selectableRegionState,
                  ) =>
                      FlashReaderAdaptiveContextSelectionMenu(
                          selectableRegionState: selectableRegionState),
                  child: Text(widget.book.getAllText()),
                ),
              )),
        ]));
  }
}
