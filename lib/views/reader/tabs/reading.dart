import 'dart:io';

import 'package:flashcards_reader/bloc/book_listing_bloc/book_listing_bloc.dart';
import 'package:flashcards_reader/model/entities/reader/book_model.dart';
import 'package:flashcards_reader/views/reader/tabs/favourites.dart';
import 'package:flashcards_reader/views/reader/tabs/have_read.dart';
import 'package:flashcards_reader/views/reader/tabs/to_read.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flashcards_reader/model/entities/reader/open_book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
  List<BookModel>? data;

  DotsMenu selectedMenu = DotsMenu.share;

  @override
  void initState() {
    super.initState();
    data = BlocProvider.of<BookBloc>(context).state.books;
    print('data: $data');
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
                final book = data![index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OpenBook(
                                book.id(),
                                book.title ?? 'no title',
                                book.author ?? 'no author',
                                'tagline',
                                book.file.path ?? '',
                                book.cover ?? 'assets/images/empty.png',
                                book.textSnippet ?? '')));
                  },
                  child: Container(
                      height: SizeConfig.getMediaHeight(context, p: 0.25),
                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white),
                      child: Row(
                        children: [
                          Hero(
                            tag: book.id(),
                            child: Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width * 0.25,
                              margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              decoration: BoxDecoration(
                                  image: book.cover != null &&
                                          File(book.cover ?? '').existsSync()
                                      ? DecorationImage(
                                          image: FileImage(File(book.cover!)),
                                          fit: BoxFit.fill,
                                        )
                                      : const DecorationImage(
                                          image: AssetImage(
                                              'assets/images/empty.png'),
                                          fit: BoxFit.fill),
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
                                  book.title ?? 'no title',
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
                                  book.author ?? 'no author',
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


// return Container(
//       child: data != null
//           ? ListView.builder(
//               shrinkWrap: true,
//               physics: const BouncingScrollPhysics(),
//               itemCount: data!.length,
//               itemBuilder: (BuildContext context, int index) {
//                 final book = data![index];
//                 return GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => OpenBook(
//                                 book.id(),
//                                 book.title ?? 'no title',
//                                 book.author ?? 'no author',
//                                 'tagline',
//                                 book.file.path ?? '',
//                                 book.cover ?? '',
//                                 book.textSnippet ?? '')));
//                   },
//                   child: Container(
//                     height: 150,
//                     margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20),
//                         color: Colors.white),
//                     child: Row(
//                       children: [
//                         Hero(
//                           tag: book.id(),
//                           child: Container(
//                             height: MediaQuery.of(context).size.height,
//                             width: MediaQuery.of(context).size.width * 0.23,
//                             margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
//                             decoration: BoxDecoration(
//                                 image: DecorationImage(
//                                     image: FileImage(File(book.file.path!)),
//                                     fit: BoxFit.fill),
//                                 borderRadius: BorderRadius.circular(5)),
//                           ),
//                         ),
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Container(
//                               color: Colors.white,
//                               width: MediaQuery.of(context).size.width * 0.65,
//                               margin: const EdgeInsets.fromLTRB(0, 10, 10, 5),
//                               child: Text(
//                                 book.title ?? 'no title',
//                                 style: const TextStyle(
//                                   fontSize: 15.5,
//                                 ),
//                               ),
//                             ),
//                             Container(
//                               height: MediaQuery.of(context).size.height * 0.06,
//                               width: MediaQuery.of(context).size.width * 0.67,
//                               margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
//                               child: Text(
//                                 book.author ?? 'no author',
//                                 style: const TextStyle(fontSize: 12),
//                               ),
//                             )
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             )
//           : const Center(
//               child: SpinKitWave(
//                 color: Palette.cardBlue,
//               ),
//             ),
//     );