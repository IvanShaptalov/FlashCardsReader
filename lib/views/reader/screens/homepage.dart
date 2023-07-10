import 'package:flashcards_reader/bloc/book_listing_bloc/book_listing_bloc.dart';
import 'package:flashcards_reader/views/reader/tabs/book_catalog.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flashcards_reader/views/menu/side_menu.dart';
import 'package:flashcards_reader/views/parent_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReadingHomePage extends StatefulWidget {
  const ReadingHomePage({Key? key}) : super(key: key);

  @override
  _ReadingHomePageState createState() => _ReadingHomePageState();
}

class _ReadingHomePageState extends State<ReadingHomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookBloc(),
      child: ReadingHomePageView(),
    );
  }
}

// ignore: must_be_immutable
class ReadingHomePageView extends ParentStatefulWidget {
  ReadingHomePageView({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ParentState<ReadingHomePageView> {
  final _kTabs = <Tab>[
    const Tab(
      text: BookCatalog.tabTitle,
      icon: BookCatalog.icon,
    ),
    const Tab(
      text: 'Favourites',
      icon: Icon(Icons.star_outline),
    ),
    const Tab(text: 'To Read', icon: Icon(Icons.history)),
    const Tab(
      text: 'Have Read',
      icon: Icon(Icons.library_add_check_outlined),
    ),
    const Tab(
      icon: Icon(Icons.library_books_rounded),
      text: 'All Books',
    ),
    const Tab(
      icon: Icon(Icons.delete_outline_rounded),
      text: 'Trash',
    ),
  ];

  final _kTabPages = <Widget>[
    const BookCatalog(
      bookStatus: BookStatus.reading,
    ),
    const BookCatalog(
      bookStatus: BookStatus.favourites,
    ),
    const BookCatalog(
      bookStatus: BookStatus.toRead,
    ),
    const BookCatalog(
      bookStatus: BookStatus.haveRead,
    ),
    const BookCatalog(
      bookStatus: BookStatus.allBooks,
    ),
    const BookCatalog(
      bookStatus: BookStatus.inTrash,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookBloc, BookState>(builder: (context, state) {
      var appbar = AppBar(
        elevation: 0,
        title: const Text(
          BookCatalog.booksTitle,
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
    });
  }
}
