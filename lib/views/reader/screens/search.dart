// import 'dart:convert';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flashcards_reader/views/menu/side_menu.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flashcards_reader/model/entities/reader/open_book.dart';
// import 'package:flashcards_reader/views/config/view_config.dart';

// import 'package:http/http.dart' as http;

// class Search extends StatefulWidget {
//   const Search({super.key});

//   @override
//   SearchState createState() => SearchState();
// }

// class SearchState extends State<Search> {
//   List? books;
//   List? displayforbook;
//   final String url = 'https://samwitadhikary.github.io/jsons/book.json';

//   @override
//   void initState() {
//     super.initState();
//     fetchBook();
//   }

//   fetchBook() async {
//     var response = await http.get(Uri.parse(url));
//     if (!mounted) return;
//     setState(() {
//       var convertJson = json.decode(response.body);
//       books = convertJson['books'];
//       displayforbook = books;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     var appbar = AppBar(
//       title: const Text(
//         'Explore',
//         style: FontConfigs.pageNameTextStyle,
//       ),
//       backgroundColor: Palette.scaffold,
//       iconTheme: const IconThemeData(color: Palette.darkblue),
//     );
//     return Scaffold(
//         drawer: Drawer(
//           child: SideMenu(appbar.preferredSize.height),
//         ),
//         appBar: appbar,
//         body: Column(
//           children: <Widget>[
//             TextField(
//               decoration: const InputDecoration(
//                   contentPadding: EdgeInsets.all(10.0),
//                   hintText: 'Search for title or author'),
//               onChanged: (string) {
//                 //
//                 setState(() {
//                   displayforbook = books!
//                       .where((u) => (u['name']
//                               .toLowerCase()
//                               .contains(string.toLowerCase()) ||
//                           u['author']
//                               .toLowerCase()
//                               .contains(string.toLowerCase())))
//                       .toList();
//                 });
//               },
//             ),
//             const SizedBox(
//               height: 5,
//             ),
//             Expanded(
//               child: books != null
//                   ? ListView.builder(
//                       physics: const BouncingScrollPhysics(),
//                       itemCount: displayforbook!.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         var mybook = displayforbook![index];
//                         return GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => OpenBook(
//                                         mybook['id'],
//                                         mybook['name'],
//                                         mybook['author'],
//                                         mybook['tagline'],
//                                         mybook['url'],
//                                         mybook['image'],
//                                         mybook['desc'])));
//                           },
//                           child: Container(
//                             height: 150,
//                             margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(20),
//                                 color: Palette.white),
//                             child: Row(
//                               children: [
//                                 Hero(
//                                   tag: mybook['id'],
//                                   child: Container(
//                                     height: MediaQuery.of(context).size.height,
//                                     width: MediaQuery.of(context).size.width *
//                                         0.25,
//                                     margin: const EdgeInsets.fromLTRB(
//                                         10, 10, 10, 10),
//                                     decoration: BoxDecoration(
//                                         image: DecorationImage(
//                                             image: CachedNetworkImageProvider(
//                                                 mybook['image']),
//                                             fit: BoxFit.fill),
//                                         borderRadius: BorderRadius.circular(5)),
//                                   ),
//                                 ),
//                                 Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Container(
//                                       color: Palette.white,
//                                       width: MediaQuery.of(context).size.width *
//                                           0.65,
//                                       margin: const EdgeInsets.fromLTRB(
//                                           0, 10, 10, 5),
//                                       child: Text(
//                                         mybook['name'],
//                                         style: const TextStyle(
//                                           fontSize: 15.5,
//                                         ),
//                                       ),
//                                     ),
//                                     Container(
//                                       height:
//                                           MediaQuery.of(context).size.height *
//                                               0.06,
//                                       width: MediaQuery.of(context).size.width *
//                                           0.67,
//                                       margin: const EdgeInsets.fromLTRB(
//                                           0, 0, 0, 10),
//                                       child: Text(
//                                         mybook['author'],
//                                         style: const TextStyle(fontSize: 12),
//                                       ),
//                                     )
//                                   ],
//                                 )
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     )
//                   : const Center(
//                       child: SpinKitWave(
//                         color: Palette.cardBlue,
//                       ),
//                     ),
//             )
//           ],
//         ));
//   }
// }
