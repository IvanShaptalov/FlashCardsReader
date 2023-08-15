import 'package:flashcards_reader/bloc/flashcards_bloc/flashcards_bloc.dart';
import 'package:flashcards_reader/bloc/providers/word_collection_provider.dart';
import 'package:flashcards_reader/bloc/translator_bloc/translator_bloc.dart';
import 'package:flashcards_reader/model/entities/reader/book_model.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flashcards_reader/views/menu/adaptive_context_selection_menu.dart';
import 'package:flashcards_reader/views/reader/tabs/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class TextBookProvider extends StatefulWidget {
  const TextBookProvider(
      {super.key, required this.book, this.isTutorial = false});
  final BookModel book;
  final bool isTutorial;

  @override
  State<TextBookProvider> createState() => _TextBookProviderState();
}

class _TextBookProviderState extends State<TextBookProvider> {
  Future<String>? textFuture;
  int pages = 0;
  // TODO merge book settings (2 classes exists now)
  BookSettings bookSettings = BookSettings();

  @override
  void initState() {
    textFuture = widget.book.getAllTextAsync();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FlashCardBloc(),
      child: BlocProvider(
        create: (_) => TranslatorBloc(),
        child: ViewTextBook(
          book: widget.book,
          bookText: textFuture,

          isTutorial: widget.isTutorial,
          // bookSettings: bookSettings,
        ),
      ),
    );
  }
}

class ViewTextBook extends StatefulWidget {
  final Future<String>? bookText;

  final BookModel book;

  final bool isTutorial;

  const ViewTextBook({
    Key? key,
    required this.book,
    required this.bookText,
    required this.isTutorial,
    /*  required this.settingsController */
  }) : super(key: key);
  // final SettingsController settingsController;

  @override
  State<ViewTextBook> createState() => _ViewTextBookState();
}

class _ViewTextBookState extends State<ViewTextBook> {
  bool show = false;
  TextStyle font = const TextStyle(
      fontSize: 16, fontWeight: FontWeight.normal, fontFamily: 'Roboto');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scrollbar(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              actions: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        show == true ? show = false : show = true;
                      });
                    },
                    icon: const Icon(Icons.more_vert)),
                const SizedBox(
                  width: 12,
                ),
              ],
              floating: true,
              elevation: 0,
              backgroundColor: Theme.of(context).colorScheme.primary,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.book.title.toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(widget.book.author.toString(),
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Roboto')),
                ],
              ),
            ),
            _buildContent(context),
          ],
        ),
      ),
      // bottomSheet: show == true
      //     ? BottomSheet(
      //         enableDrag: false,
      //         builder: (context) => BottomSheetWidget(
      //           settingsController: widget.settingsController,
      //           settings: {
      //             'size': font.fontSize,
      //             'theme': widget.settingsController.themeMode == ThemeMode.dark
      //                 ? true
      //                 : false,
      //             'font_name': font.fontFamily,
      //           },
      //           onClickedClose: () => setState(() {
      //             show = false;
      //           }),
      //           onClickedConfirm: (value) => setState(() {
      //             font = value;
      //             show = false;
      //           }),
      //         ),
      //         onClosing: () {},
      //       )
      //     : null,
    );
  }

  Widget _buildContent(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: FutureBuilder(
              future: widget.bookText,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  return SelectionArea(
                      contextMenuBuilder: (
                        BuildContext context,
                        SelectableRegionState selectableRegionState,
                      ) =>
                          FlashReaderAdaptiveContextSelectionMenu(
                              selectableRegionState: selectableRegionState,
                              isTutorial: widget.isTutorial),
                      onSelectionChanged: (value) {
                        if (value != null) {
                          WordCreatingUIProvider.tmpFlashCard.question =
                              value.plainText;
                        }
                      },
                      child: Text(
                        snapshot.data,
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.justify,
                        style: font,
                      ));
                } else {
                  return SpinKitWave(
                    color: Palette.green300Primary,
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
