import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flashcards_reader/model/entities/reader/book_model.dart';
import 'package:flashcards_reader/model/entities/reader/book_parser/open_books/view_pdf.dart';
import 'package:flashcards_reader/model/entities/reader/book_parser/open_books/view_txt.dart';
import 'package:flutter/material.dart';
import 'package:flashcards_reader/views/config/view_config.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';

class OpenBook extends StatefulWidget {
  final BookModel book;
  const OpenBook({required this.book, super.key});

  @override
  OpenBookState createState() =>
      // ignore: no_logic_in_create_state
      OpenBookState();
}

class OpenBookState extends State<OpenBook> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.book.titleOrEmpty,
          style: FontConfigs.pageNameTextStyle,
        ),
        actions: const [Offstage()],
        backgroundColor: Palette.scaffold,
        elevation: 0,
        iconTheme: const IconThemeData(color: Palette.darkblue),
      ),
      body: Stack(children: [
        Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: File(widget.book.coverOrEmpty).existsSync()
                    ? DecorationImage(
                        image: FileImage(File(widget.book.coverOrEmpty)),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            Palette.darkblue.withOpacity(0.8),
                            BlendMode.multiply))
                    : DecorationImage(
                        image: const AssetImage('assets/images/empty.png'),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            Palette.darkblue.withOpacity(0.8),
                            BlendMode.multiply)))),
        Center(
          child: Column(
            children: [
              Hero(
                tag: widget.book.id(),
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 45, 0, 0),
                  height: 340,
                  width: 250,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(
                              widget.book.coverOrEmpty),
                          fit: BoxFit.fill)),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  widget.book.titleOrEmpty,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                // color: Colors.red,
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: const Text(
                  'book',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontSize: 15,
                  ),
                ),
              )
            ],
          ),
        ),
        SlidingUpPanel(
          minHeight: 80,
          backdropEnabled: true,
          panel: Column(
            children: [
              Container(
                height: 20,
                // color: Colors.red,
                margin: const EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    Container(
                      width: 15,
                      color: Colors.grey,
                      height: 5,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Container(
                      height: 5,
                      color: Colors.grey,
                      width: 30,
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 35),
                child: const Text(
                  'Description :',
                  style: TextStyle(fontSize: 22, color: Palette.darkblue),
                ),
              ),
              Container(
                height: 270,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child:
                    ListView(physics: const BouncingScrollPhysics(), children: [
                  Text(
                    widget.book.descriptionOrEmpty,
                    style: const TextStyle(fontSize: 15),
                    textAlign: TextAlign.justify,
                  ),
                ]),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                style: ButtonStyle(
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(20)),
                    backgroundColor:
                        MaterialStateProperty.all(Palette.lightblue),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)))),
                onPressed: () {
                  switch (widget.book.file.extension) {
                    case '.txt':
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ViewText(textBook: widget.book)));
                      break;
                    case '.pdf':
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewPDF(
                                  widget.book.titleOrEmpty,
                                  widget.book.file.pathOrEmpty)));
                      break;
                    case '.epub':
                      break;
                    case '.fb2':
                      break;
                    default:
                  }
                },
                child: const Text(
                  "Read Book",
                  style: TextStyle(fontSize: 21, color: Colors.white),
                ),
              )
            ],
          ),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        /* downloading
            ? Container(
                decoration: const BoxDecoration(color: Colors.black54),
                child: Center(
                  child: Container(
                    height: 200,
                    width: 300,
                    decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          const SizedBox(
                            height: 70,
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 8,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            height: 30,
                            child: Center(
                              child: Text(
                                'Downloading File $progressString',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            :  */
        const Offstage()
      ]),
    );
  }
}
