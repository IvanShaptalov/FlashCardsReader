// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flashcards_reader/views/config/view_config.dart';

class DownloadPDF extends StatefulWidget {
  final String path;
  final String pathdir;
  const DownloadPDF(this.path, this.pathdir, {super.key});

  @override
  // ignore: no_logic_in_create_state
  DownloadPDFState createState() => DownloadPDFState(path, pathdir);
}

class DownloadPDFState extends State<DownloadPDF> {
  final String path;
  final String pathdir;
  DownloadPDFState(this.path, this.pathdir);

  @override
  Widget build(BuildContext context) {
    final Completer<PDFViewController> _pdfViewController =
        Completer<PDFViewController>();
    // ignore: close_sinks
    final StreamController<String> _pageCountController =
        StreamController<String>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          pathdir,
          style: FontConfigs.pageNameTextStyle,
        ),
        backgroundColor: Palette.white,
        iconTheme: IconThemeData(color: Palette.blueGrey),
        actions: <Widget>[
          StreamBuilder<String>(
            stream: _pageCountController.stream,
            builder: (_, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                return Center(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(10, 10, 16, 10),
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                        // color: Palette.red
                        ),
                    child: Text(
                      snapshot.data!,
                      style: TextStyle(
                          color: Palette.blueGrey,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          )
        ],
      ),
      body: Container(
        child: PDF(
          enableSwipe: true,
          fitPolicy: FitPolicy.BOTH,
          swipeHorizontal: true,
          fitEachPage: true,
          onPageChanged: (int? current, int? total) =>
              _pageCountController.add('${current! + 1} - $total'),
          onViewCreated: (PDFViewController pdfViewController) async {
            _pdfViewController.complete(pdfViewController);
            final int? currentPage = await pdfViewController.getCurrentPage();
            final int? pageCount = await pdfViewController.getPageCount();
            _pageCountController.add('${currentPage! + 1} - $pageCount');
          },
          preventLinkNavigation: true,
        ).fromPath(path),
      ),
      floatingActionButton: FutureBuilder<PDFViewController>(
        future: _pdfViewController.future,
        builder: (_, AsyncSnapshot<PDFViewController> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                FloatingActionButton(
                  heroTag: '-',
                  backgroundColor: Palette.white,
                  hoverColor: Palette.blueGrey,
                  onPressed: () async {
                    final PDFViewController pdfController = snapshot.data!;
                    final int currentPage =
                        (await pdfController.getCurrentPage())! - 1;
                    if (currentPage >= 0) {
                      await pdfController.setPage(currentPage);
                    }
                  },
                  child: Text(
                    '<',
                    style: TextStyle(
                        color: Palette.blueGrey,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                FloatingActionButton(
                  heroTag: '+',
                  backgroundColor: Palette.white,
                  onPressed: () async {
                    final PDFViewController pdfController = snapshot.data!;
                    final int currentPage =
                        (await pdfController.getCurrentPage())! + 1;
                    final int? numberOfPages =
                        await pdfController.getPageCount();
                    if (numberOfPages! > currentPage) {
                      await pdfController.setPage(currentPage);
                    }
                  },
                  child: Text(
                    '>',
                    style: TextStyle(
                        color: Palette.blueGrey,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
