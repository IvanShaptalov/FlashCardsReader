import 'package:flashcards_reader/model/entities/reader/book_model.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flutter/material.dart';

class ViewText extends StatefulWidget {
  const ViewText({Key? key, required this.textBook}) : super(key: key);
  final BookModel textBook;
  @override
  ViewTextState createState() => ViewTextState();
}

class ViewTextState extends State<ViewText> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.textBook.titleOrEmpty,
            style: FontConfigs.pageNameTextStyle,
          ),
          backgroundColor: Palette.scaffold,
          elevation: 0,
          iconTheme: const IconThemeData(color: Palette.darkblue),
          actions: <Widget>[],
        ),
        body: PageView(
          children: [Text('here')],
        ));
  }
}
