import 'dart:io';
import 'package:flashcards_reader/bloc/providers/book_pagination_provider.dart';
import 'package:flashcards_reader/bloc/providers/word_collection_provider.dart';
import 'package:flashcards_reader/constants.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flashcards_reader/views/flashcards/new_word/base_new_word_widget.dart';
import 'package:flashcards_reader/views/guide_wrapper.dart';
import 'package:flashcards_reader/views/menu/adaptive_context_selection_menu.dart';
import 'package:flashcards_reader/views/overlay_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ViewPDF extends StatefulWidget {
  final String name;
  final String path;
  const ViewPDF(this.name, this.path, {super.key});

  @override
  ViewPDFState createState() => ViewPDFState();
}

class ViewPDFState extends State<ViewPDF> {
  PdfViewerController? _pdfViewerController;

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    super.initState();
  }

  OverlayEntry? _overlayEntry;

  void _showContextMenu(
      BuildContext context, PdfTextSelectionChangedDetails details) {
    final OverlayState _overlayState = Overlay.of(context);
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
                      print('Text copied to clipboard: ' +
                          details.selectedText.toString());
                      _pdfViewerController?.clearSelection();
                    },
                    icon: const Icon(Icons.copy)),
                IconButton(
                    onPressed: () {
                      if (GuideProvider.isTutorial) {
                        OverlayNotificationProvider.showOverlayNotification(
                            'wait to translate, then tap save word button',
                            duration: const Duration(seconds: 5));
                      }
                      BaseNewWordWidgetService.wordFormController
                          .setUp(WordCreatingUIProvider.tmpFlashCard);

                      FlashReaderAdaptiveContextSelectionMenu
                          .showUpdateFlashCardMenu(context);
                      _pdfViewerController?.clearSelection();
                    },
                    icon: const Icon(Icons.translate)),
                IconButton(
                    onPressed: () {
                      _pdfViewerController?.clearSelection();

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
    _overlayState.insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.name),
        ),
        body: SelectionArea(
          contextMenuBuilder: (
            BuildContext context,
            SelectableRegionState selectableRegionState,
          ) =>
              FlashReaderAdaptiveContextSelectionMenu(
                  selectableRegionState: selectableRegionState,
                  addNoteCallback: () {}),
          onSelectionChanged: (value) {},
          child: SfPdfViewer.file(
            File(widget.path),
            onTextSelectionChanged: (PdfTextSelectionChangedDetails details) {
              if (details.selectedText == null && _overlayEntry != null) {
                _overlayEntry?.remove();
                _overlayEntry = null;
              } else if (details.selectedText != null &&
                  _overlayEntry == null) {
                WordCreatingUIProvider.tmpFlashCard.question =
                    details.selectedText!;
                TextSelectorProvider.selectedText = details.selectedText!;
                _showContextMenu(context, details);
              }
            },
            controller: _pdfViewerController,
            enableTextSelection: true,
          ),
        ));
  }
}
