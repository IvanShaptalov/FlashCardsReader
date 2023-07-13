// import 'dart:io';
// import 'package:flashcards_reader/model/entities/reader/book_model.dart';
// import 'package:flashcards_reader/model/entities/reader/open_book.dart';
// import 'package:flutter/material.dart';

// class BookCover extends StatefulWidget {
//   const BookCover({super.key, required this.model});
//   final BookModel model;

//   @override
//   State<BookCover> createState() => _BookCoverState();
// }

// class _BookCoverState extends State<BookCover> {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => OpenBook(
//                     widget.model.hashCode,
//                     widget.model.title ?? '',
//                     widget.model.author ?? '',
//                     '',
//                     widget.model.path ?? '',
//                     widget.model.cover ?? '',
//                     widget.model.textSnippet ?? '')));
//       },
//       child: Container(
//         height: 150,
//         margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20), color: Palette.white),
//         child: Row(
//           children: [
//             Hero(
//               tag: widget.model.hashCode,
//               child: Container(
//                 height: MediaQuery.of(context).size.height,
//                 width: MediaQuery.of(context).size.width * 0.23,
//                 margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
//                 decoration: BoxDecoration(
//                     image: File(widget.model.cover ?? '').existsSync()
//                         ? DecorationImage(
//                             image: FileImage(File(widget.model.cover!)),
//                             fit: BoxFit.fill)
//                         : null,
//                     borderRadius: BorderRadius.circular(5)),
//               ),
//             ),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   color: Palette.white,
//                   width: MediaQuery.of(context).size.width * 0.65,
//                   margin: const EdgeInsets.fromLTRB(0, 10, 10, 5),
//                   child: Text(
//                     widget.model.title ?? 'no title',
//                     style: const TextStyle(
//                       fontSize: 15.5,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   height: MediaQuery.of(context).size.height * 0.06,
//                   width: MediaQuery.of(context).size.width * 0.67,
//                   margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
//                   child: Text(
//                     widget.model.author ?? '',
//                     style: const TextStyle(fontSize: 12),
//                   ),
//                 )
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
