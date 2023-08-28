// ignore_for_file: lines_longer_than_80_chars

import 'package:flashcards_reader/bloc/providers/book_interaction_provider.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flutter/material.dart';

class BottomSheetWidget extends StatefulWidget {
  final Function(TextStyle) onClickedConfirm;
  final Function onClickedClose;
  const BottomSheetWidget(
      {Key? key, required this.onClickedClose, required this.onClickedConfirm})
      : super(key: key);

  @override
  BottomSheetWidgetState createState() => BottomSheetWidgetState();
}

class BottomSheetWidgetState extends State<BottomSheetWidget> {
  double _fontSize = 16;
  bool isSwitched = false;
  String _dropDownValue = 'Roboto';

  double oldFontSize = 1;

  getSetting() {
    _fontSize = BookPaginationProvider.book.settings.fontSize.toDouble();
    oldFontSize = _fontSize;
    isSwitched = false;
    _dropDownValue = BookPaginationProvider.book.settings.fontFamily;
  }

  @override
  void initState() {
    _dropDownValue = BookPaginationProvider.book.settings.fontFamily;
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
                BookPaginationProvider.updatePageFont(
                  newFontFamily: _dropDownValue.replaceAll(' ', '_'),
                  newFontSize: _fontSize,
                  context: context,
                  pageSize: SizeConfig.size(context),
                );
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
