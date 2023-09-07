import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flashcards_reader/views/menu/side_menu.dart';
import 'package:flashcards_reader/views/parent_screen.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FeedBackPage extends ParentStatefulWidget {
  FeedBackPage({super.key});

  @override
  ParentState<FeedBackPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ParentState<FeedBackPage> {
  double appBarHeight = 0;

  @override
  Widget build(BuildContext context, {Widget? page}) {
    /// ===============================================[Create page]======
    var appBar = AppBar(
      title: const Text('Feedback & Support'),
    );
    appBarHeight = appBar.preferredSize.height;
    bindPage(Scaffold(
      backgroundColor: Palette.lightGreen,
      appBar: appBar,
      body: Center(
          child: SizedBox(
              height: SizeConfig.getMediaHeight(context),
              child: const Placeholder())),
      drawer: SideMenu(appBarHeight),
    ));

    /// =======================================[Select design via context]==

    return super.build(context);
  }
}
