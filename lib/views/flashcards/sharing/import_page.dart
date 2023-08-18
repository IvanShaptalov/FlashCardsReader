import 'package:flashcards_reader/bloc/flashcards_bloc/flashcards_bloc.dart';
import 'package:flashcards_reader/bloc/providers/sharing_provider.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/views/flashcards/sharing/import_examples.dart';
import 'package:flashcards_reader/views/menu/side_menu.dart';
import 'package:flashcards_reader/views/parent_screen.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SharingPage extends StatefulWidget {
  const SharingPage({super.key});

  @override
  State<SharingPage> createState() => _SharingPageState();
}

class _SharingPageState extends State<SharingPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FlashCardBloc(),
      child: SharingPageView(),
    );
  }
}

// ignore: must_be_immutable
class SharingPageView extends ParentStatefulWidget {
  SharingPageView({super.key});
  final String title = 'Import Page';

  @override
  ParentState<SharingPageView> createState() => _SharingPageViewState();
}

class _SharingPageViewState extends ParentState<SharingPageView> {
  double appBarHeight = 0;

  @override
  Widget build(BuildContext context, {Widget? page}) {
    /// ===============================================[Create page]==========
    return BlocBuilder<FlashCardBloc, FlashcardsState>(
        builder: (context, state) {
      var appBar = AppBar(
        title: Text(
          widget.title,
          style: FontConfigs.pageNameTextStyle,
        ),
      );
      appBarHeight = appBar.preferredSize.height;
      bindPage(Scaffold(
        appBar: appBar,
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: SizeConfig.getMediaHeight(context, p: 0.6),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                        height: SizeConfig.getMediaHeight(context, p: 0.1)),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              SizeConfig.getMediaWidth(context, p: 0.1)),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(importExample,
                              style: FontConfigs.h2TextStyle)),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () async {
                    debugPrintIt('select directory');
                    List<FlashCardCollection> collections =
                        await SharingProvider.importCollections(context);
                    if (collections.isNotEmpty) {
                      for (FlashCardCollection collection in collections) {
                        // ignore: use_build_context_synchronously
                        BlocProvider.of<FlashCardBloc>(context).add(
                            UpdateFlashCardEvent(
                                flashCardCollection: collection));
                      }
                    }
                  },
                  child: Container(
                    height: SizeConfig.getMediaHeight(context,
                        p: [ScreenDesign.landscape, ScreenDesign.landscapeSmall]
                                .contains(ScreenIdentifier.indentify(context))
                            ? 0.1
                            : 0.07),
                    width: SizeConfig.getMediaWidth(context,
                        p: [ScreenDesign.landscape, ScreenDesign.landscapeSmall]
                                .contains(ScreenIdentifier.indentify(context))
                            ? 0.3
                            : 0.8),
                    decoration: BoxDecoration(
                      color: Palette.amber50,

                      // rounded full border
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add_circle_outline_outlined),
                        SizedBox(
                          width: SizeConfig.getMediaWidth(context, p: 0.01),
                        ),
                        Text(
                          'import flashcards',
                          style: FontConfigs.h1TextStyle,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.getMediaHeight(context, p: 0.1)),
              ],
            ),
          ],
        )),
        drawer: SideMenu(appBarHeight),
      ));

      /// ====================[Select design via context]==================

      return super.build(context);
    });
  }
}
