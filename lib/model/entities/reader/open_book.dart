import 'dart:io';

import 'package:flashcards_reader/bloc/book_listing_bloc/book_listing_bloc.dart';
import 'package:flashcards_reader/bloc/flashcards_bloc/flashcards_bloc.dart';
import 'package:flashcards_reader/bloc/providers/word_collection_provider.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/model/entities/reader/book_model.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/views/parent_screen.dart';
import 'package:flashcards_reader/views/reader/open_books/view_pdf.dart';
import 'package:flashcards_reader/views/reader/open_books/view_text.dart';
import 'package:flashcards_reader/views/flashcards/new_word/add_word_collection_widget.dart';
import 'package:flashcards_reader/views/flashcards/new_word/screens/base_new_word_screen.dart';
import 'package:flutter/material.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';

// ignore: must_be_immutable
class OpenBook extends ParentStatefulWidget {
  final BookModel book;
  final BuildContext upperContext;

  OpenBook({required this.book, super.key, required this.upperContext});

  @override
  OpenBookState createState() => OpenBookState();
}

class OpenBookState extends ParentState<OpenBook> {
  List<FlashCardCollection>? collection;
  void callback() {
    setState(() {});
  }

  @override
  void initState() {
    // get collection
    collection = BlocProvider.of<FlashCardBloc>(widget.upperContext)
        .state
        .copyWith(fromTrash: false)
        .flashCards;

    /// get selected flashcard
    FlashCardCollection? selected = FlashCardProvider.fc;
    if (collection != null &&
        collection!.isNotEmpty &&
        selected.compareWithoutId(flashExample())) {
      selected = collection!.first;
      FlashCardProvider.fc = selected;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // reorder cards
    if (!FastCardListProvider.putSelectedCardToFirstPositionBookMenu(
        collection ?? [], widget.book)) {
      debugPrintIt('book doesn`t have flashcard id yet, select and save first');
      var selectedFlash =
          FastCardListProvider.putSelectedCardToFirstPosition(collection ?? []);
      // save flashcard
      widget.upperContext.read<BookBloc>().add(UpdateBookEvent(
          bookModel: widget.book..flashCardId = selectedFlash.id));
    }

    bindPage(Scaffold(
      appBar: AppBar(
        title: Text(
          widget.book.title,
          style: FontConfigs.pageNameTextStyle,
        ),
        actions: const [Offstage()],
        backgroundColor: Palette.green300Primary,
        elevation: 0,
        iconTheme: IconThemeData(color: Palette.blueGrey),
      ),
      body: Stack(children: [
        Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: File(widget.book.coverPath).existsSync()
                    ? DecorationImage(
                        image: FileImage(File(widget.book.coverPath)),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            Palette.darkBlue.withOpacity(0.9),
                            BlendMode.multiply))
                    : DecorationImage(
                        image: const AssetImage('assets/images/empty.png'),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            Palette.darkBlue.withOpacity(0.9),
                            BlendMode.multiply)))),
        Center(
          child: Column(
            children: [
              Hero(
                tag: widget.book.id(),
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 45, 0, 0),
                  height: 340,
                  width: 250,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/empty.png'),
                          fit: BoxFit.fill)),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  widget.book.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Palette.white),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: const Text(
                  'book',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Palette.white,
                    fontStyle: FontStyle.italic,
                    fontSize: 15,
                  ),
                ),
              )
            ],
          ),
        ),
        SlidingUpPanel(
          color: Palette.green300Primary,
          minHeight: 80,
          backdropEnabled: true,
          panel: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: 20,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 2,
                    ),
                    Container(
                      height: 5,
                      width: SizeConfig.getMediaWidth(context, p: 0.3),
                      decoration: BoxDecoration(
                          color: Palette.grey,
                          borderRadius: BorderRadius.circular(15)),
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Text(
                  'Collection to save words',
                  style: FontConfigs.h1TextStyle.copyWith(
                      fontWeight: FontWeight.bold, color: Palette.white),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                color: Palette.grey300,
                child: AnimationLimiter(
                  child: SizedBox(
                    height: SizeConfig.getMediaHeight(context, p: 0.3),
                    width: SizeConfig.getMediaWidth(context, p: 1),
                    child: ListView.builder(
                        controller: FastCardListProvider.scrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: collection!.isEmpty ? 1 : collection!.length,
                        itemBuilder: (context, index) {
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 400),
                            child: Transform.scale(
                              scale: 0.9,
                              child: FastAddWordFCcWidget(
                                collection!.isEmpty
                                    ? FlashCardProvider.fc
                                    : collection![index],
                                callback,
                                design: ScreenIdentifier.indentify(context),
                                book: widget.book,
                                bookContext: widget.upperContext,
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(25)),
                    backgroundColor: MaterialStateProperty.all(Palette.amber50),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)))),
                onPressed: () {
                  // check that flashcard selected
                  if (collection != null &&
                      widget.book.flashCardId != null &&
                      collection!
                          .map((e) => e.id)
                          .contains(widget.book.flashCardId)) {
                    widget.book.flashCardId = FlashCardProvider.fc.id;
                  }
                  switch (widget.book.file.extension) {
                    case '.txt':
                      // check that collection has selected flashCard

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TextBookProvider(
                                    book: widget.book,
                                  )));

                      break;
                    case '.pdf':
                    
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewPDF(
                                  widget.book.title, widget.book.path)));
                      break;
                    case '.epub':
                      break;
                    case '.fb2':
                      break;
                    default:
                  }
                },
                child: Text("Read Book", style: FontConfigs.h1TextStyle),
              )
            ],
          ),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        const Offstage()
      ]),
    ));
    return super.build(context);
  }
}
