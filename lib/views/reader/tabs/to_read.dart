import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flashcards_reader/model/entities/reader/open_book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class ToRead extends StatefulWidget {
  const ToRead({super.key});
  static const icon = Icon(Icons.history);
  static const String title = 'To Read';

  @override
  ToReadState createState() => ToReadState();
}

class ToReadState extends State<ToRead> {
  final String url = 'https://samwitadhikary.github.io/jsons/c.json';
  List? data;

  @override
  void initState() {
    super.initState();
    fetchCprog();
  }

  fetchCprog() async {
    var response = await http.get(Uri.parse(url));
    if (!mounted) return;
    setState(() {
      var convertJson = json.decode(response.body);
      data = convertJson['cprog'];
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
                final myCprog = data![index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OpenBook(
                                myCprog['id'],
                                myCprog['name'],
                                myCprog['author'],
                                myCprog['tagline'],
                                myCprog['url'],
                                myCprog['image'],
                                myCprog['desc'])));
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
                          tag: myCprog['id'],
                          child: Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width * 0.23,
                            margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                        myCprog['image']),
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
                                myCprog['name'],
                                style: const TextStyle(
                                  fontSize: 15.5,
                                ),
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.06,
                              width: MediaQuery.of(context).size.width * 0.67,
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Text(
                                myCprog['author'],
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
