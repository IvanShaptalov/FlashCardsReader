import 'package:flashcards_reader/bloc/flashcards_bloc/flashcards_bloc.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/bloc/providers/word_collection_provider.dart';
import 'package:flashcards_reader/views/flashcards/new_word/add_word_collection_widget.dart';
import 'package:flashcards_reader/views/flashcards/new_word/base_new_word_widget.dart';
import 'package:flashcards_reader/views/flashcards/new_word/screens/base_new_word_screen.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class LandscapeNewWord extends BaseScreenNewWord {
  Function callback;
  Function loadTranslate;

  LandscapeNewWord({required this.callback, required this.loadTranslate});

  Widget addWordWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Transform.scale(
        scale: 0.9,
        child: Container(
            height: SizeConfig.getMediaHeight(context, p: 0.6),
            width: SizeConfig.getMediaWidth(context, p: 0.5),
            decoration: BoxDecoration(
              color: Palette.green200,

              // rounded full border
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(
                color: Palette.grey,
                width: 1,
              ),
            ),
            child: BaseNewWordWidgetService.addWordMenu(
                context: context, callback: callback)),
      ),
    );
  }

  Widget loadScreen() {
    return BlocBuilder<FlashCardBloc, FlashcardsState>(
        builder: (context, state) {
      var flashCardCollection = state.copyWith(fromTrash: false).flashCards;
      FastCardListProvider.putSelectedCardToFirstPosition(flashCardCollection);
      var appbar = getAppBar(flashCardCollection);
      appBarHeight = appbar.preferredSize.height;

      BaseNewWordWidgetService.wordFormController
          .setUp(WordCreatingUIProvider.tmpFlashCard);
      debugPrintIt('selected collection:  ${FlashCardProvider.fc}');
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: appbar,
        body: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  addWordWidget(context),
                ],
              ),
              const SizedBox.shrink(),
              Column(
                children: [
                  AnimationLimiter(
                    child: SizedBox(
                      height: SizeConfig.getMediaHeight(context, p: 0.65),
                      width: SizeConfig.getMediaWidth(context, p: 0.25),
                      child: ListView.builder(
                          controller: FastCardListProvider.scrollController,
                          scrollDirection: Axis.vertical,
                          itemCount: flashCardCollection.isEmpty
                              ? 1
                              : flashCardCollection.length,
                          itemBuilder: (context, index) {
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: DurationConfig.cardAppearDuration,
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                    child: Transform.scale(
                                  scale: 0.9,
                                  child: FastAddWordFCcWidget(
                                    flashCardCollection.isEmpty
                                        ? FlashCardProvider.fc
                                        : flashCardCollection[index],
                                    callback,
                                    design: ScreenIdentifier.indentify(context),
                                  ),
                                )),
                              ),
                            );
                          }),
                    ),
                  ),
                ],
              ),
              const SizedBox.shrink(),
            ],
          ),
        ),
        drawer: getDrawer(),
        bottomNavigationBar: null,
      );
    });
  }
}
