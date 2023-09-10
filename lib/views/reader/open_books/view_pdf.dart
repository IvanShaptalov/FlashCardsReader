import 'dart:io';
import 'package:flashcards_reader/bloc/providers/book_pagination_provider.dart';
import 'package:flashcards_reader/bloc/providers/word_collection_provider.dart';
import 'package:flashcards_reader/constants.dart';
import 'package:flashcards_reader/firebase/firebase.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/util/router.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flashcards_reader/views/flashcards/new_word/base_new_word_widget.dart';
import 'package:flashcards_reader/views/menu/adaptive_context_selection_menu.dart';
import 'package:flashcards_reader/views/reader/screens/reading_homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ViewPDF extends StatefulWidget {
  final String name;
  final String path;
  final int page;
  final Function(int page) saveBook;
  const ViewPDF(this.name, this.path,
      {super.key, required this.saveBook, required this.page});

  @override
  ViewPDFState createState() => ViewPDFState();
}

class ViewPDFState extends State<ViewPDF> {
  PdfViewerController? _pdfViewerController;

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _pdfViewerController?.jumpToPage(widget.page);
    });
    super.initState();
  }

  @override
  void dispose() {
    if (_pdfViewerController != null) {
      widget.saveBook(_pdfViewerController!.pageNumber);
    }
    super.dispose();
  }

  OverlayEntry? _overlayEntry;

  void _showContextMenu(
      BuildContext context, PdfTextSelectionChangedDetails details) {
    final OverlayState overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: details.globalSelectedRegion!.center.dy - 55,
        left: details.globalSelectedRegion!.bottomLeft.dx,
        child: Card(
          child: Container(
            decoration: BoxDecoration(
                color: Palette.white, border: Border.all(width: 1)),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Clipboard.setData(
                          ClipboardData(text: details.selectedText!));
                      debugPrintIt(
                          'Text copied to clipboard: ${details.selectedText}');
                      _pdfViewerController?.clearSelection();
                    },
                    icon: const Icon(Icons.copy)),
                IconButton(
                    onPressed: () {
                      _pdfViewerController?.clearSelection();

                      BaseNewWordWidgetService.wordFormController
                          .setUp(WordCreatingUIProvider.tmpFlashCard);

                      FlashReaderAdaptiveContextSelectionMenu
                          .showUpdateFlashCardMenu(context);
                    },
                    icon: const Icon(Icons.translate)),
                IconButton(
                    onPressed: () {
                      _pdfViewerController?.clearSelection();
                      FireBaseAnalyticsService.sharedTranslation();

                      Share.share('''${TextSelectorProvider.selectedText}
                                Read, translate and learn with flashReader! $googlePlayLink''');
                    },
                    icon: const Icon(Icons.share)),
              ],
            ),
          ),
        ),
      ),
    );
    overlayState.insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(widget.name),
          leading: IconButton(
              onPressed: () {
                MyRouter.pushPageReplacement(context, const ReadingHomePage());
              },
              icon: Icon(
                Icons.arrow_back,
                color: Palette.white,
              )),
        ),
        body: SfPdfViewer.file(
          File(widget.path),
          onTextSelectionChanged: (PdfTextSelectionChangedDetails details) {
            if (details.selectedText == null && _overlayEntry != null) {
              _overlayEntry?.remove();
              _overlayEntry = null;
            } else if (details.selectedText != null && _overlayEntry == null) {
              WordCreatingUIProvider.tmpFlashCard.question =
                  details.selectedText ?? '';
              TextSelectorProvider.selectedText = details.selectedText!;
              _showContextMenu(context, details);
            }
          },
          controller: _pdfViewerController,
          enableTextSelection: true,
        ));
  }
}
