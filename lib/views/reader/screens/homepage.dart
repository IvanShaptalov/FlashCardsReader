import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flashcards_reader/model/entities/reader/algo_screen.dart';
import 'package:flashcards_reader/model/entities/reader/app_dev_screen.dart';
import 'package:flashcards_reader/model/entities/reader/cppScreen.dart';
import 'package:flashcards_reader/model/entities/reader/cprogScreen.dart';
import 'package:flashcards_reader/model/entities/reader/dsaiScreen.dart';
import 'package:flashcards_reader/model/entities/reader/hacking.dart';
import 'package:flashcards_reader/model/entities/reader/javaScreen.dart';
import 'package:flashcards_reader/model/entities/reader/jsScript.dart';
import 'package:flashcards_reader/model/entities/reader/linuxScreen.dart';
import 'package:flashcards_reader/model/entities/reader/machineScreen.dart';
import 'package:flashcards_reader/model/entities/reader/networking.dart';
import 'package:flashcards_reader/model/entities/reader/otherScreen.dart';
import 'package:flashcards_reader/model/entities/reader/pythonScreen.dart';
import 'package:flashcards_reader/model/entities/reader/react.dart';
import 'package:flashcards_reader/model/entities/reader/unixScreen.dart';
import 'package:flashcards_reader/model/entities/reader/webdevScreen.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flashcards_reader/views/reader/offline.dart';
import 'package:flashcards_reader/views/reader/sidemenu.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool connection = true;
  Connectivity? connectivity;

  StreamSubscription<ConnectivityResult>? subscription;

  @override
  void initState() {
    super.initState();
    connectivity = Connectivity();
    subscription =
        connectivity!.onConnectivityChanged.listen((ConnectivityResult result) {
      print(result);
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
    Tab(
      text: 'Algorithms',
    ),
    Tab(
      text: 'Python',
    ),
    Tab(
      text: 'C++',
    ),
    Tab(
      text: 'C',
    ),
    Tab(
      text: 'Web Development',
    ),
    Tab(
      text: 'Data Science & AI',
    ),
    Tab(
      text: 'Linux',
    ),
    Tab(
      text: 'App Development',
    ),
    Tab(
      text: 'Java',
    ),
    Tab(
      text: 'JavaScript',
    ),
    Tab(
      text: 'Machine Learning',
    ),
    Tab(
      text: 'Unix',
    ),
    Tab(
      text: 'Networking',
    ),
    Tab(
      text: 'React',
    ),
    Tab(
      text: 'Hacking',
    ),
    Tab(
      text: 'Others',
    ),
  ];

  final _kTabPages = <Widget>[
    AlgoScreen(),
    PythonScreen(),
    CppScreen(),
    CProgScreen(),
    WebScreen(),
    DsaiScreen(),
    LinuxScreen(),
    AppDevScreen(),
    JavaScreen(),
    JavaScriptScreen(),
    MachineLearningScreen(),
    UnixScreen(),
    NetworkingScreen(),
    ReactScreen(),
    HackingScreen(),
    OtherScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DefaultTabController(
        length: _kTabs.length,
        child: Scaffold(
          drawer: Drawer(
            child: SideMenu(),
          ),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Palette.scaffold,
            title: Text(
              'Note It',
              style: TextStyle(
                  color: Palette.darkblue,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.6),
            ),
            iconTheme: IconThemeData(color: Palette.darkblue),
            bottom: TabBar(
              indicatorColor: Palette.darkblue,
              indicatorWeight: 2.5,
              isScrollable: true,
              physics: BouncingScrollPhysics(),
              labelColor: Palette.darkblue,
              labelStyle: TextStyle(fontSize: 18),
              tabs: _kTabs,
            ),
          ),
          body: connection
              ? Center(
                  child: Offline(),
                )
              : TabBarView(
                  physics: BouncingScrollPhysics(),
                  children: _kTabPages,
                ),
        ),
      ),
    );
  }
}
