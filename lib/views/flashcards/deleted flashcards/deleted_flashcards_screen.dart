import 'package:flashcards_reader/bloc/flashcards_bloc/flashcards_bloc.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/bloc/flashcards_provider/flashcard_collection_provider.dart';
import 'package:flashcards_reader/views/flashcards/deleted%20flashcards/deleted_flashcard_collection_widget.dart';
import 'package:flashcards_reader/views/menu/drawer_menu.dart';
import 'package:flashcards_reader/views/view_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class DeletedFlashCardScreen extends StatefulWidget {
  const DeletedFlashCardScreen({super.key});

  @override
  State<DeletedFlashCardScreen> createState() => _DeletedFlashCardScreenState();
}

class _DeletedFlashCardScreenState extends State<DeletedFlashCardScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FlashCardBloc(),
      child: DeletedFlashCardView(),
    );
  }
}

// ignore: must_be_immutable
class DeletedFlashCardView extends StatefulWidget {
  DeletedFlashCardView({super.key});
  Duration cardAppearDuration = const Duration(milliseconds: 375);
  // List<FlashCardCollection> flashCardCollection =
  //     FlashCardCollectionProvider.getFlashCards(isDeleted: true);

  @override
  State<DeletedFlashCardView> createState() => _DeletedFlashCardViewState();
}

class _DeletedFlashCardViewState extends State<DeletedFlashCardView> {
  int columnCount = 2;
  double appBarHeight = 0;

  double getCardForm(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.portrait ? 0.65 : 1;

  int calculateColumnCount(BuildContext context) {
    double screenWidth = SizeConfig.getMediaWidth(context);
    if (screenWidth > 1000) {
      return SizeConfig.getMediaWidth(context) ~/ 200;
    } else if (screenWidth > 600) {
      return 3;
    } else if (screenWidth >= 380) {
      return 2;
    }
    return 1;
  }

  double calculateCrossSpacing(BuildContext context) {
    double screenWidth = SizeConfig.getMediaWidth(context);
    if (screenWidth > 1000) {
      return SizeConfig.getMediaWidth(context) / 20;
    } else if (screenWidth > 600) {
      return 40;
    } else if (screenWidth >= 380) {
      return 25;
    }
    return 15;
  }

  List<Widget> bottomNavigationBarItems(
      List<FlashCardCollection> flashCardCollection) {
    return [
      if (flashCardCollection.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.delete_forever),
          onPressed: () {
            // delete all from trash
            context.read<FlashCardBloc>().add(DeleteAllTrashEvent());
            context
                .read<FlashCardBloc>()
                .add(GetFlashCardsEvent(isDeleted: true));
          },
        ),
    ];
  }

  AppBar getAppBar(List<FlashCardCollection> flashCardCollection) {
    return AppBar(
      title: Text('Deleted flashcards: ${flashCardCollection.length}'),
    );
  }

  Widget? getDrawer() {
    if (FlashCardCollectionProvider.isMergeModeStarted) {
      return null;
    } else {
      return MenuDrawer(appBarHeight);
    }
  }

  @override
  Widget build(BuildContext context) {
    // creating bloc builder for flashcards
    return BlocBuilder<FlashCardBloc, FlashcardsState>(
      builder: (context, state) {
        var flashCardCollection = state.copyWith(fromTrash: true).flashCards;

        columnCount = calculateColumnCount(context);
        var appBar = getAppBar(flashCardCollection);
        appBarHeight = appBar.preferredSize.height;
        return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: appBar,
            body: flashCardCollection.isEmpty
                ? const Center(child: Text('Bin is empty'))
                : AnimationLimiter(
                    child: GridView.count(
                        mainAxisSpacing:
                            SizeConfig.getMediaHeight(context, p: 0.04),
                        crossAxisSpacing: calculateCrossSpacing(context),
                        crossAxisCount: columnCount,
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                SizeConfig.getMediaWidth(context, p: 0.05)),
                        childAspectRatio: getCardForm(context),
                        children:
                            List.generate(flashCardCollection.length, (index) {
                          /// ====================================================================[FlashCardCollectionWidget]
                          // add flashcards
                          return Transform.scale(
                            scale: columnCount == 1 ? 0.9 : 1,
                            child: AnimationConfiguration.staggeredGrid(
                              position: index,
                              duration: widget.cardAppearDuration,
                              columnCount: columnCount,
                              child: SlideAnimation(
                                child: FadeInAnimation(
                                    child: DeletedFlashCardCollectionWidget(
                                        flashCardCollection[index])),
                              ),
                            ),
                          );
                        })),
                  ),
            drawer: getDrawer(),
            bottomNavigationBar: BottomAppBar(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                  /// icon buttons, analog of bottom navigation bar with flashcards, merge if merge mode is on and quiz
                  children: bottomNavigationBarItems(flashCardCollection)),
            ));
      },
    );
  }
}
