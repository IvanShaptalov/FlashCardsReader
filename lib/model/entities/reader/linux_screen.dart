import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flashcards_reader/views/reader/open_book.dart';
import 'package:http/http.dart' as http;
import 'package:flashcards_reader/views/config/view_config.dart';


class LinuxScreen extends StatefulWidget {
  const LinuxScreen({super.key});

  @override
  LinuxScreenState createState() => LinuxScreenState();
}

class LinuxScreenState extends State<LinuxScreen>{
  final String url = 'https://samwitadhikary.github.io/jsons/linux.json';
  List? data;

  @override
  void initState() {
    super.initState();
    fetchLinux();
  }

  fetchLinux() async {
    var response = await http.get(Uri.parse(url));
    if (!mounted) return;
    setState(() {
      var convertJson = json.decode(response.body);
      data = convertJson['linux'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: data != null
          ? ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: data!.length,
              itemBuilder: (BuildContext context, int index) {
                final myLinux = data![index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OpenBook(
                                myLinux['id'],
                                myLinux['name'],
                                myLinux['author'],
                                myLinux['tagline'],
                                myLinux['url'],
                                myLinux['image'],
                                myLinux['desc'])));
                  },
                  child: Container(
                    height: 150,
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    child: Row(
                      children: [
                        Hero(
                          tag: myLinux['id'],
                          child: Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width * 0.23,
                            margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                        myLinux['image']),
                                    fit: BoxFit.fill),
                                borderRadius: BorderRadius.circular(5)),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              color: Colors.white,
                              width: MediaQuery.of(context).size.width * 0.65,
                              margin: const EdgeInsets.fromLTRB(0, 10, 10, 5),
                              child: Text(
                                myLinux['name'],
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
                                myLinux['author'],
                                style: const TextStyle(fontSize: 12),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
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
