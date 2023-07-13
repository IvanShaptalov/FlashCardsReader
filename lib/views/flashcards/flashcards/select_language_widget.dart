import 'package:flashcards_reader/bloc/providers/word_collection_provider.dart';
import 'package:flashcards_reader/bloc/translator_bloc/translator_bloc.dart';
import 'package:flashcards_reader/constants.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class SelectLanguageDropdown extends StatefulWidget {
  SelectLanguageDropdown({required this.langDestination, super.key}) {
    // set start value
    if (langDestination == 'from') {
      startValue = FlashCardProvider.fc.questionLanguage;
    } else {
      startValue = FlashCardProvider.fc.answerLanguage;
    }
  }

  /// [landDestination], from or to
  String langDestination;
  String startValue = 'Automatic';

  @override
  State<SelectLanguageDropdown> createState() => _SelectLanguageDropdownState();
}

class _SelectLanguageDropdownState extends State<SelectLanguageDropdown> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.getMediaWidth(context, p: 0.3),
      child: Column(
        children: [
          DropdownButton<String>(
            dropdownColor: Palette.amber50,
            value: widget.startValue,
            isExpanded: true,
            style: FontConfigs.h3TextStyleBlack,
            underline: Container(
              height: 2,
              color: Palette.green300Primary,
            ),
            onChanged: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                widget.startValue = value!;
                if (widget.langDestination == 'from') {
                  FlashCardProvider.fc.questionLanguage = value;
                } else {
                  FlashCardProvider.fc.answerLanguage = value;
                }
              });
              BlocProvider.of<TranslatorBloc>(context).add(TranslateEvent(
                  text: WordCreatingUIProvider.tmpFlashCard.question,
                  fromLan: FlashCardProvider.fc.questionLanguage,
                  toLan: FlashCardProvider.fc.answerLanguage));
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
      ),
    );
  }
}
