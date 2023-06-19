import 'package:flashcards_reader/views/menu/drawer_menu.dart';
import 'package:flashcards_reader/views/parent_screen.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ImportPage extends ParentStatefulWidget {
  ImportPage({super.key});
  final String title = 'Import Page';

  @override
  ParentState<ImportPage> createState() => _SharingPageState();
}

class _SharingPageState extends ParentState<ImportPage> {
  double appBarHeight = 0;

  @override
  Widget build(BuildContext context, {Widget? page}) {
    /// ===============================================[Create page]===============================
    var appBar = AppBar(
      title: Text(widget.title),
    );
    appBarHeight = appBar.preferredSize.height;
    widget.portraitPage = Scaffold(
      appBar: appBar,
      body: const Center(
          child: Column(
        children: [Text('Import Page')],
      )),
      drawer: MenuDrawer(appBarHeight),
    );

    // for now, when 4 desings not implemented, we use only one design
    bindAllPages(widget.portraitPage);

    /// ===============================================[Select design via context]===============================

    return super.build(context);
  }
}
