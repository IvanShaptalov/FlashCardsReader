import 'package:flashcards_reader/bloc/book_listing_bloc/book_listing_bloc.dart';
import 'package:flashcards_reader/model/entities/reader/book_model.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomSheetNotes extends StatefulWidget {
  final Function onClickedClose;
  final BookModel book;
  const BottomSheetNotes({
    Key? key,
    required this.onClickedClose,
    required this.book,
  }) : super(key: key);

  @override
  BottomSheetNotesState createState() => BottomSheetNotesState();
}

class BottomSheetNotesState extends State<BottomSheetNotes> {
  getSetting() {}

  @override
  void initState() {
    super.initState();
    getSetting();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.notes,
                size: 22,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "Notes",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )
            ],
          ),
          SizedBox(
              height: SizeConfig.getMediaHeight(context, p: 0.4),
              child: ListView.builder(
                itemCount: widget.book.bookNotes.lenght,
                itemBuilder: (BuildContext context, int index) {
                  String upperKey =
                      widget.book.bookNotes.notes.keys.toList()[index];
                  String upperValue =
                      widget.book.bookNotes.notes.values.toList()[index];
                  String noteText = upperValue;
                  return Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text('" $upperKey "',
                              maxLines: 10, style: FontConfigs.h1TextStyle),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: SizeConfig.getMediaWidth(context, p: 0.7),
                              child: TextFormField(
                                initialValue: upperValue,
                                onChanged: (value) {
                                  noteText = value;
                                },
                                onFieldSubmitted: (value) {
                                  setState(() {
                                    widget.book.bookNotes.notes.update(
                                        upperKey, (value) => value = noteText);
                                    BlocProvider.of<BookBloc>(context).add(
                                        UpdateBookEvent(
                                            bookModel: widget.book));
                                  });
                                  debugPrintIt('value updated to -> $noteText');
                                },
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                widget.book.bookNotes.notes.removeWhere(
                                    (key, value) =>
                                        key == upperKey && value == upperValue);
                                BlocProvider.of<BookBloc>(context).add(
                                    UpdateBookEvent(bookModel: widget.book));
                              });
                            },
                            icon: Icon(
                              Icons.delete_forever,
                              color: Palette.grey800,
                            ),
                          )
                        ],
                      ),
                    ],
                  );
                },
              )),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildEvelatedButton(Icons.cancel, "Close", Palette.grey800,
                  () => widget.onClickedClose()),
              const SizedBox(
                width: 15,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildEvelatedButton(
          IconData icon, String text, Color color, Function action) =>
      SizedBox(
        height: 40,
        width: 150,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: color,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          onPressed: () => action(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );

  Widget _builditemText(String value) {
    var nValue = value.replaceAll('_', ' ');
    return Text(
      nValue,
      style: TextStyle(fontFamily: value),
    );
  }
}
