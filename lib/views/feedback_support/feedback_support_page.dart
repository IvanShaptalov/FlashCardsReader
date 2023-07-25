import 'package:flashcards_reader/bloc/book_listing_bloc/book_listing_bloc.dart';
import 'package:flashcards_reader/model/entities/reader/book_scanner.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flashcards_reader/views/menu/side_menu.dart';
import 'package:flashcards_reader/views/overlay_notification.dart';
import 'package:flashcards_reader/views/parent_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class FeedbackSupportPage extends ParentStatefulWidget {
  FeedbackSupportPage({super.key});

  @override
  ParentState<FeedbackSupportPage> createState() => _FeedbackSupportPageState();
}

class _FeedbackSupportPageState extends ParentState<FeedbackSupportPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => BookBloc(), child: FeedbackSupportPageView());
  }
}

// ignore: must_be_immutable
class FeedbackSupportPageView extends ParentStatefulWidget {
  FeedbackSupportPageView({super.key});

  @override
  ParentState<FeedbackSupportPageView> createState() => _MyHomePageState();
}

class _MyHomePageState extends ParentState<FeedbackSupportPageView> {
  double appBarHeight = 0;

  @override
  void initState() {
    // BookScanner.manageExternalStoragePermission.addListener()
    super.initState();
  }

  @override
  Widget build(BuildContext context, {Widget? page}) {
    /// ===============================================[Create page]===============================
    var appBar = AppBar(
      title: const Text('Feedback & Support'),
    );
    double lineHeight = SizeConfig.getMediaHeight(context, p: 0.1);
    appBarHeight = appBar.preferredSize.height;
    bindPage(Scaffold(
      appBar: appBar,
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: lineHeight,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Books found: ${BlocProvider.of<BookBloc>(context).state.books.length}',
                  style: FontConfigs.h2TextStyleBlack,
                ),
              ),
            ),
            const Divider(),
            SizedBox(
              height: lineHeight,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: ValueListenableBuilder(
                      valueListenable:
                          BookScanner.manageExternalStoragePermission,
                      builder: (BuildContext context, bool isGranted,
                          Widget? child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${!isGranted ? "Tap to grant \n'Read Storage' permission" : "'Read Storage' permission granted"} ',
                              style: FontConfigs.h2TextStyleBlack,
                            ),
                            isGranted
                                ? IconButton(
                                    icon: Icon(Icons.check,
                                        color: Palette.green300Primary),
                                    onPressed: () {
                                      OverlayNotificationProvider
                                          .showOverlayNotification(
                                              'permission already granted');
                                      setState(() {});
                                    })
                                : IconButton(
                                    icon: Icon(Icons.ads_click,
                                        color: Palette.deepPurple),
                                    onPressed: () async {
                                      await BookScanner.getFilePermission();
                                      setState(() {});
                                    },
                                  )
                          ],
                        );
                      })),
            ),
            const Divider(),
            SizedBox(
              height: lineHeight,
              child: ValueListenableBuilder(
                  valueListenable: BookScanner.manageExternalStoragePermission,
                  builder:
                      (BuildContext context, bool isGranted, Widget? child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            isGranted
                                ? 'scan now to find books'
                                : 'grant permission to scan',
                            style: FontConfigs.h1TextStyle,
                          ),
                        ),
                        isGranted
                            ? IconButton(
                                onPressed: () {
                                  BookScanner.scan();
                                },
                                icon: const Icon(
                                  Icons.find_replace_outlined,
                                ))
                            : IconButton(
                                onPressed: () {
                                  OverlayNotificationProvider
                                      .showOverlayNotification(
                                          'grant permission to scan');
                                },
                                icon: Icon(
                                  Icons.warning,
                                  color: Palette.teal,
                                )),
                      ],
                    );
                  }),
            )
            
          ],
        ),
      )),
      drawer: SideMenu(appBarHeight),
    ));

    /// ===============================================[Select design via context]===============================

    return super.build(context);
  }
}
