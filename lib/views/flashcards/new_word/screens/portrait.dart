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

class PortraitNewWord extends BaseScreenNewWord {
  Function callback;
  Function loadTranslate;

  PortraitNewWord({required this.callback, required this.loadTranslate});

  Widget addWordWidget(BuildContext context) {
    return Container(
        height: SizeConfig.getMediaHeight(context, p: 0.35),
        width: SizeConfig.getMediaWidth(context, p: 1),
        decoration: BoxDecoration(
          color: ConfigFastAddWordView.menuColor,

          // rounded full border
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
        ),
        child: BaseNewWordWidgetService.addWordMenu(
            context: context, callback: callback, oldWord: oldWord));
  }

  Widget loadScreen() {
    debugPrintIt('screen loaded ');
    return BlocBuilder<FlashCardBloc, FlashcardsState>(
        builder: (context, state) {
      BaseNewWordWidgetService.wordFormController
          .setUp(WordCreatingUIProvider.tmpFlashCard);
      var flashCardCollection = state.copyWith(fromTrash: false).flashCards;
      FastCardListProvider.putSelectedCardToFirstPosition(flashCardCollection);
      var appbar = getAppBar(flashCardCollection);
      appBarHeight = appbar.preferredSize.height;
      BaseNewWordWidgetService.wordFormController
          .setUp(WordCreatingUIProvider.tmpFlashCard);

      debugPrintIt('selected collection:  ${FlashCardProvider.fc}');
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: appbar,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: addWordWidget(context),
            ),
            AnimationLimiter(
              child: SizedBox(
                height: SizeConfig.getMediaHeight(context, p: 0.35),
                width: SizeConfig.getMediaWidth(context, p: 1),
                child: ListView.builder(
                    controller: FastCardListProvider.scrollController,
                    scrollDirection: Axis.horizontal,
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
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FastAddWordFCcWidget(
                                    flashCardCollection.isEmpty
                                        ? FlashCardProvider.fc
                                        : flashCardCollection[index],
                                    callback,
                                    design: ScreenIdentifier.indentify(context),
                                  ))),
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
        drawer: getDrawer(),
        bottomNavigationBar: null,
      );
    });
  }
}
