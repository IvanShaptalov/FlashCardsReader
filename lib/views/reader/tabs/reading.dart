import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flashcards_reader/views/reader/tabs/favourites.dart';
import 'package:flashcards_reader/views/reader/tabs/have_read.dart';
import 'package:flashcards_reader/views/reader/tabs/to_read.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flashcards_reader/model/entities/reader/open_book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

enum DotsMenu { share, trash, edit }

class Reading extends StatefulWidget {
  const Reading({super.key});
  static const icon = Icon(Icons.book_sharp);
  static const String booksTitle = 'Books';
  static const String tabTitle = 'Reading';

  @override
  ReadingState createState() => ReadingState();
}

class ReadingState extends State<Reading> {
  final String url = 'https://samwitadhikary.github.io/jsons/algods.json';
  List? data;

  DotsMenu selectedMenu = DotsMenu.share;

  @override
  void initState() {
    super.initState();
    fetchAlgo();
  }

  fetchAlgo() async {
    var response = await http.get(Uri.parse(url));
    if (!mounted) return;
    setState(() {
      var convertJson = json.decode(response.body);
      data = convertJson['algo'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: data != null
          ? ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: data?.length,
              itemBuilder: (BuildContext context, int index) {
                final myAlgo = data?[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OpenBook(
                                  myAlgo['id'],
                                  myAlgo['name'],
                                  myAlgo['author'],
                                  myAlgo['tagline'],
                                  myAlgo['url'],
                                  myAlgo['image'],
                                  myAlgo['desc'],
                                )));
                  },
                  child: Container(
                      height: 160,
                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white),
                      child: Row(
                        children: [
                          Hero(
                            tag: myAlgo['id'],
                            child: Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width * 0.23,
                              margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                      myAlgo['image'],
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                color: Colors.white,
                                width: MediaQuery.of(context).size.width * 0.65,
                                margin: const EdgeInsets.fromLTRB(0, 10, 10, 5),
                                child: Text(
                                  myAlgo['name'],
                                  style: const TextStyle(
                                    fontSize: 15.5,
                                  ),
                                ),
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                width: MediaQuery.of(context).size.width * 0.67,
                                margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Text(
                                  myAlgo['author'],
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                              SizedBox(
                                width:
                                    SizeConfig.getMediaWidth(context, p: 0.67),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    GestureDetector(
                                      child: Favourites.icon,
                                      onTap: () {},
                                    ),
                                    GestureDetector(
                                      child: ToRead.icon,
                                      onTap: () {},
                                    ),
                                    GestureDetector(
                                      child: HaveRead.icon,
                                      onTap: () {},
                                    ),
                                    PopupMenuButton<DotsMenu>(
                                      initialValue: selectedMenu,
                                      // Callback that sets the selected popup menu item.
                                      onSelected: (DotsMenu item) {
                                        setState(() {});
                                      },
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry<DotsMenu>>[
                                        const PopupMenuItem<DotsMenu>(
                                          value: DotsMenu.share,
                                          child: Text('Share file'),
                                        ),
                                        const PopupMenuItem<DotsMenu>(
                                          value: DotsMenu.trash,
                                          child: Text('Move to trash'),
                                        ),
                                        const PopupMenuItem<DotsMenu>(
                                          value: DotsMenu.edit,
                                          child: Text('Edit'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      )),
                );
              },
            )
          : const Center(
              child: SpinKitWave(
                color: Palette.cardBlue,
              ),
            ),
    );
  }
}
