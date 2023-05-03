import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/util/constants.dart';
import 'package:flashcards_reader/views/view_config.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SelectLanguageDropdown extends StatefulWidget {
  SelectLanguageDropdown(
      {required this.flashCardCollection,
      required this.langDestination,
      super.key}) {
    // set start value
    if (langDestination == 'from') {
      startValue = flashCardCollection.questionLanguage;
    } else {
      startValue = flashCardCollection.answerLanguage;
    }
  }

  FlashCardCollection flashCardCollection;

  /// [landDestination], from or to
  String langDestination;
  String startValue = 'Automatic';

  @override
  State<SelectLanguageDropdown> createState() => _SelectLanguageDropdownState();
}

class _SelectLanguageDropdownState extends State<SelectLanguageDropdown> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton<String>(
          dropdownColor: ConfigViewUpdateMenu.dropDownColor,
          value: widget.startValue,
          icon: Icon(
            Icons.arrow_drop_down,
            color: ConfigViewUpdateMenu.iconColor,
          ),
          elevation: 16,
          style: FontConfigs.h3TextStyleBlack,
          underline: Container(
            height: 2,
            color: ConfigViewUpdateMenu.dropDownColorUndlerline,
          ),
          onChanged: (String? value) {
            // This is called when the user selects an item.
            setState(() {
              widget.startValue = value!;
              if (widget.langDestination == 'from') {
                widget.flashCardCollection.questionLanguage = value;
              } else {
                widget.flashCardCollection.answerLanguage = value;
              }
            });
          },
          items: supportedLangs.values
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }

}