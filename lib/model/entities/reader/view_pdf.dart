import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
// import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:flashcards_reader/views/config/view_config.dart';

class ViewPDF extends StatefulWidget {
  final String name;
  final String url;
  const ViewPDF(this.name, this.url, {super.key});

  @override
  // ignore: no_logic_in_create_state
  ViewPDFState createState() => ViewPDFState(name, url);
}

class ViewPDFState extends State<ViewPDF> {
  final String name;
  final String url;
  ViewPDFState(this.name, this.url);

  final Completer<PDFViewController> _pdfViewController =
      Completer<PDFViewController>();
  final StreamController<String> _pageCountController =
      StreamController<String>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          name,
          style: FontConfigs.pageNameTextStyle,
        ),
        backgroundColor: Palette.scaffold,
        elevation: 0,
        iconTheme: const IconThemeData(color: Palette.darkblue),
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
                        // color: Colors.red
                        ),
                    child: Text(
                      snapshot.data!,
                      style: const TextStyle(
                          color: Palette.darkblue,
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
      body: PDF(
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
      ).cachedFromUrl(url,
          placeholder: (progress) => Center(
                child: SizedBox(
                    height: 100,
                    width: 100,
                    child: /* LiquidCircularProgressIndicator(
                    borderWidth: 5.0,
                    borderColor: Palette.scaffold,
                    value: progress / 100,
                    valueColor: const AlwaysStoppedAnimation(Colors.pink),
                    backgroundColor: Palette.scaffold,
                    direction: Axis.vertical,
                    center: Text(
                      '$progress',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                   */
                        Text('$progress')),
              ),
          errorWidget: (error) => const Center(
                child: Text('Loading Error....\nCheck Internet Connection'),
              )),
      floatingActionButton: FutureBuilder<PDFViewController>(
        future: _pdfViewController.future,
        builder: (_, AsyncSnapshot<PDFViewController> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FloatingActionButton(
                  heroTag: '-',
                  backgroundColor: Colors.white,
                  hoverColor: Palette.darkblue,
                  onPressed: () async {
                    final PDFViewController pdfController = snapshot.data!;
                    final int currentPage =
                        (await pdfController.getCurrentPage())! - 1;
                    if (currentPage >= 0) {
                      await pdfController.setPage(currentPage);
                    }
                  },
                  child: const Text(
                    '<',
                    style: TextStyle(
                        color: Palette.darkblue,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                FloatingActionButton(
                  heroTag: '+',
                  backgroundColor: Colors.white,
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
                  child: const Text(
                    '>',
                    style: TextStyle(
                        color: Palette.darkblue,
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
