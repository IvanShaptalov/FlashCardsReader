import 'package:flashcards_reader/bloc/flashcards_bloc/flashcards_bloc.dart';
import 'package:flashcards_reader/bloc/translator_bloc/translator_bloc.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/views/flashcards/flashcards/add_flashcard_widget.dart';
import 'package:flashcards_reader/bloc/providers/word_collection_provider.dart';
import 'package:flashcards_reader/views/flashcards/new_word/add_word_collection_widget.dart';
import 'package:flashcards_reader/views/flashcards/new_word/screens/base_new_word_screen.dart';
import 'package:flashcards_reader/views/flashcards/tts_widget.dart';
import 'package:flashcards_reader/views/view_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class PortraitSmallNewWord extends BaseScreenNewWord {
  Function callback;
  Function loadTranslate;
  bool isPressed;

  PortraitSmallNewWord(super.widget,
      {required this.isPressed,
      required this.callback,
      required this.loadTranslate});

  Widget addWordWidget(BuildContext context) {
    return Transform.scale(
      scale: 0.8,
      child: Container(
          height: SizeConfig.getMediaHeight(context, p: 0.35),
          width: SizeConfig.getMediaWidth(context, p: 1),
          decoration: BoxDecoration(
            color: ConfigFashAddWordView.menuColor,

            // rounded full border
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  clearFieldButton(context: context),
                  Expanded(
                    child: BlocProvider(
                      create: (context) => TranslatorBloc(),
                      child: TextField(
                        controller: widget.wordFormContoller.questionController,
                        decoration: InputDecoration(
                          labelText: 'Add Word',
                          labelStyle: FontConfigs.h3TextStyle,
                        ),
                        onChanged: (text) {
                          delayTranslate(text, context);
                        },
                        onSubmitted: (value) {
                          saveCollectionFromWord(
                              onSubmitted: true,
                              callback: callback,
                              context: context,
                              widget: widget);
                          BlocProvider.of<TranslatorBloc>(context)
                              .add(ClearTranslateEvent());
                        },
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        TextToSpeechWrapper.onPressed(
                            WordCreatingUIProvider.tmpFlashCard.question,
                            WordCreatingUIProvider
                                .tmpFlashCard.questionLanguage);
                      },
                      icon: const Icon(Icons.volume_up_outlined)),
                ],
              ),
              translateListenerWidget(
                  context: context, isPressed: isPressed, callback: callback),
              addWordsButton(context: context, callback: callback),
            ],
          )),
    );
  }

  Widget loadScreen() {
    return BlocBuilder<FlashCardBloc, FlashcardsState>(
        builder: (context, state) {
      var flashCardCollection = state.copyWith(fromTrash: false).flashCards;
      putSelectedCardToFirstPosition(flashCardCollection);
      var appbar = getAppBar(flashCardCollection);
      appBarHeight = appbar.preferredSize.height;
      widget.wordFormContoller
          .setUp(WordCreatingUIProvider.tmpFlashCard, context);

      debugPrintIt('selected collection:  ${FlashCardCreatingUIProvider.fc}');
      return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: appbar,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              addWordWidget(context),
              AnimationLimiter(
                child: SizedBox(
                  height: SizeConfig.getMediaHeight(context, p: 0.41),
                  width: SizeConfig.getMediaWidth(context, p: 1),
                  child: ListView.builder(
                      controller: widget.scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: flashCardCollection.isEmpty
                          ? 1
                          : flashCardCollection.length,
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: widget.cardAppearDuration,
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FastAddWordFCcWidget(
                                      flashCardCollection.isEmpty
                                          ? FlashCardCreatingUIProvider.fc
                                          : flashCardCollection[index],
                                      widget.callback,
                                      design:
                                          DesignIdentifier.identifyScreenDesign(
                                              context),
                                      backToListStart: backToStartCallback,
                                    ))),
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
          drawer: getDrawer(),
          bottomNavigationBar: BottomAppBar(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                /// icon buttons, analog of bottom navigation bar with flashcards, merge if merge mode is on and quiz
                children: bottomNavigationBarItems(context, widget)),
          ));
    });
  }
}
