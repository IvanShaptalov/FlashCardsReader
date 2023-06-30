import 'package:flashcards_reader/views/reader/tabs/have_read.dart';
import 'package:flashcards_reader/views/reader/tabs/reading.dart';
import 'package:flashcards_reader/views/reader/tabs/favourites.dart';
import 'package:flashcards_reader/views/reader/tabs/to_read.dart';
import 'package:flashcards_reader/views/reader/tabs/all_books.dart';
import 'package:flashcards_reader/views/reader/tabs/authors.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flashcards_reader/views/menu/side_menu.dart';
import 'package:flashcards_reader/views/parent_screen.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ReadingHomePage extends ParentStatefulWidget {
  ReadingHomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ParentState<ReadingHomePage> {
  final _kTabs = <Tab>[
    const Tab(
      text: Reading.tabTitle,
      icon: Reading.icon,
    ),
    const Tab(
      text: Favourites.title,
      icon: Favourites.icon,
    ),
    const Tab(
      text: ToRead.title,
      icon: ToRead.icon,
    ),
    const Tab(
      text: HaveRead.title,
      icon: HaveRead.icon,
    ),
    const Tab(
      text: AllBooks.title,
      icon: AllBooks.icon,
    ),
    const Tab(
      text: Authors.title,
      icon: Authors.icon,
    ),
  ];

  final _kTabPages = <Widget>[
    const Reading(),
    const Favourites(),
    const ToRead(),
    const HaveRead(),
    const AllBooks(),
    const Authors(),
  ];

  @override
  Widget build(BuildContext context) {
    var appbar = AppBar(
      elevation: 0,
      title: const Text(
        Reading.booksTitle,
        style: FontConfigs.pageNameTextStyle,
      ),
      bottom: TabBar(
        indicatorColor: Palette.darkblue,
        indicatorWeight: 2.5,
        isScrollable: true,
        physics: const BouncingScrollPhysics(),
        labelColor: Palette.darkblue,
        labelStyle: const TextStyle(fontSize: 18),
        tabs: _kTabs,
      ),
    );
    widget.page = DefaultTabController(
      length: _kTabs.length,
      child: Scaffold(
        drawer: Drawer(
          child: SideMenu(appbar.preferredSize.height),
        ),
        appBar: appbar,
        body: TabBarView(
          physics: const BouncingScrollPhysics(),
          children: _kTabPages,
        ),
      ),
    );
    return super.build(context);
  }
}
