import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flashcards_reader/model/entities/reader/reading.dart';
import 'package:flashcards_reader/model/entities/reader/favourites.dart';
import 'package:flashcards_reader/model/entities/reader/to_read.dart';
import 'package:flashcards_reader/model/entities/reader/all_books.dart';
import 'package:flashcards_reader/model/entities/reader/authors.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flashcards_reader/views/menu/side_menu.dart';
import 'package:flashcards_reader/views/reader/offline.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  bool connection = true;
  Connectivity? connectivity;

  StreamSubscription<ConnectivityResult>? subscription;

  @override
  void initState() {
    super.initState();
    connectivity = Connectivity();
    subscription =
        connectivity!.onConnectivityChanged.listen((ConnectivityResult result) {
      debugPrintIt(result);
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        setState(() {
          connection = false;
        });
      }
    });
  }

  @override
  void dispose() {
    subscription!.cancel();
    super.dispose();
  }

  final _kTabs = <Tab>[
    const Tab(
      text: Reading.title,
      icon: Reading.icon,
    ),
    const Tab(
      text: AllBooks.title,
      icon: AllBooks.icon,
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
      text: Authors.title,
      icon: Authors.icon,
    ),
  ];

  final _kTabPages = <Widget>[
    const Reading(),
    const AllBooks(),
    const Favourites(),
    const ToRead(),
    const Authors(),
  ];

  @override
  Widget build(BuildContext context) {
    var appbar = AppBar(
      elevation: 0,
      title: const Text(
        'Reading',
        style: FontConfigs.pageNameTextStyle,
      ),
      iconTheme: const IconThemeData(color: Palette.darkblue),
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
    return DefaultTabController(
      length: _kTabs.length,
      child: Scaffold(
        drawer: Drawer(
          child: SideMenu(appbar.preferredSize.height),
        ),
        appBar: appbar,
        body: connection
            ? const Center(
                child: Offline(),
              )
            : TabBarView(
                physics: const BouncingScrollPhysics(),
                children: _kTabPages,
              ),
      ),
    );
  }
}
