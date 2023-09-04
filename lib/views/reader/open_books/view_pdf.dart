import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        child: TextButton(
          child: Text('Copy', style: TextStyle(fontSize: 17)),
          onPressed: () {
            Clipboard.setData(
                ClipboardData(text: details.selectedText ?? 'not selected'));
            _pdfViewerController?.clearSelection();
          },
        ),
      ),
    );
    _overlayState.insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Syncfusion Flutter PdfViewer'),
      ),
      body: SfPdfViewer.file(
        File(widget.path),
        onTextSelectionChanged: (PdfTextSelectionChangedDetails details) {
          if (details.selectedText == null && _overlayEntry != null) {
            _overlayEntry?.remove();
            _overlayEntry = null;
          } else if (details.selectedText != null && _overlayEntry == null) {
            _showContextMenu(context, details);
          }
        },
        controller: _pdfViewerController,
      ),
    );
  }
}
