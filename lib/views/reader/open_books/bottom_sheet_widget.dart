import 'package:flashcards_reader/bloc/book_listing_bloc/book_listing_bloc.dart';
import 'package:flashcards_reader/model/entities/reader/book_model.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flashcards_reader/views/reader/tabs/settings_book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomSheetWidget extends StatefulWidget {
  final Function(TextStyle) onClickedConfirm;
  final Function onClickedClose;
  final BookModel book;
  final SettingsControllerViewText settingsController;
  const BottomSheetWidget(
      {Key? key,
      required this.onClickedClose,
      required this.onClickedConfirm,
      required this.book,
      required this.settingsController})
      : super(key: key);

  @override
  BottomSheetWidgetState createState() => BottomSheetWidgetState();
}

class BottomSheetWidgetState extends State<BottomSheetWidget> {
  double _fontSize = 16;
  bool isSwitched = false;
  String _dropDownValue = 'Roboto';

  getSetting() {
    _fontSize = widget.book.settings.fontSize.toDouble();
    isSwitched = false;
    _dropDownValue = widget.book.settings.fontFamily;
  }

  @override
  void initState() {
    _dropDownValue = widget.book.settings.fontFamily;
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
                Icons.settings,
                size: 22,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "Settings",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )
            ],
          ),
          Divider(
            thickness: 1,
            color: Palette.grey800,
            height: 35,
          ),
          const Text(
            "Font",
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: DropdownButton<String>(
                isExpanded: true,
                iconSize: 16,
                value: _dropDownValue,
                onChanged: (String? newValue) {
                  setState(() {
                    _dropDownValue = newValue!;
                  });
                },
                items: <String>{
                  'Roboto',
                  'Gideon_Roman',
                  'Noto_Serif',
                  'Redressed'
                }.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                      value: value, child: _builditemText(value));
                }).toList()),
          ),
          const Text(
            "Font size",
            textAlign: TextAlign.center,
          ),
          Slider(
            value: _fontSize,
            onChanged: (newRating) {
              setState(() {
                _fontSize = newRating;
              });
            },
            min: 12,
            max: 32,
            divisions: 20,
            label: '${_fontSize.floor()}',
          ),
          // Divider(
          //   thickness: 1,
          //   color: Colors.grey[800],
          //   height: 20,
          // ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 20),
          //   child: Row(
          //     children: [
          //       const Text('Dark theme'),
          //       const Spacer(),
          //       Switch(
          //         value: isSwitched,
          //         onChanged: (value) {
          //           setState(() {
          //             isSwitched = value;
          //             widget.settingsController.updateThemeMode(
          //                 widget.settingsController.themeMode == ThemeMode.light
          //                     ? ThemeMode.dark
          //                     : ThemeMode.light);
          //           });
          //         },
          //         activeTrackColor: const Color(0xFF6741FF),
          //         activeColor: Theme.of(context).colorScheme.primary,
          //       ),
          //     ],
          //   ),
          // ),
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
              _buildEvelatedButton(Icons.save, "Save", Palette.green600, () {
                widget.onClickedConfirm(TextStyle(
                    fontSize: _fontSize,
                    fontWeight: FontWeight.normal,
                    fontFamily: _dropDownValue));
                widget.book.settings.fontFamily =
                    _dropDownValue.replaceAll(' ', '_');
                debugPrintIt('saved: ${widget.book.settings.fontFamily}');
                widget.book.settings.fontSize = _fontSize.toInt();
                BlocProvider.of<BookBloc>(context)
                    .add(UpdateBookEvent(bookModel: widget.book));
              }),
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
