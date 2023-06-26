import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flashcards_reader/model/entities/reader/algo_screen.dart';
import 'package:flashcards_reader/model/entities/reader/app_dev_screen.dart';
import 'package:flashcards_reader/model/entities/reader/cpp_screen.dart';
import 'package:flashcards_reader/model/entities/reader/cprog_screen.dart';
import 'package:flashcards_reader/model/entities/reader/dsai_screen.dart';
import 'package:flashcards_reader/model/entities/reader/hacking.dart';
import 'package:flashcards_reader/model/entities/reader/java_screen.dart';
import 'package:flashcards_reader/model/entities/reader/js_script.dart';
import 'package:flashcards_reader/model/entities/reader/linux_screen.dart';
import 'package:flashcards_reader/model/entities/reader/machine_screen.dart';
import 'package:flashcards_reader/model/entities/reader/networking.dart';
import 'package:flashcards_reader/model/entities/reader/other_screen.dart';
import 'package:flashcards_reader/model/entities/reader/python_screen.dart';
import 'package:flashcards_reader/model/entities/reader/react.dart';
import 'package:flashcards_reader/model/entities/reader/unix_screen.dart';
import 'package:flashcards_reader/model/entities/reader/web_dev_screen.dart';
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
      text: 'Algorithms',
    ),
    const Tab(
      text: 'Python',
    ),
    const Tab(
      text: 'C++',
    ),
    const Tab(
      text: 'C',
    ),
    const Tab(
      text: 'Web Development',
    ),
    const Tab(
      text: 'Data Science & AI',
    ),
    const Tab(
      text: 'Linux',
    ),
    const Tab(
      text: 'App Development',
    ),
    const Tab(
      text: 'Java',
    ),
    const Tab(
      text: 'JavaScript',
    ),
    const Tab(
      text: 'Machine Learning',
    ),
    const Tab(
      text: 'Unix',
    ),
    const Tab(
      text: 'Networking',
    ),
    const Tab(
      text: 'React',
    ),
    const Tab(
      text: 'Hacking',
    ),
    const Tab(
      text: 'Others',
    ),
  ];

  final _kTabPages = <Widget>[
    const AlgoScreen(),
    const PythonScreen(),
    const CppScreen(),
    const CProgScreen(),
    const WebScreen(),
    const DsaiScreen(),
    const LinuxScreen(),
    const AppDevScreen(),
    const JavaScreen(),
    const JavaScriptScreen(),
    const MachineLearningScreen(),
    const UnixScreen(),
    const NetworkingScreen(),
    const ReactScreen(),
    const HackingScreen(),
    const OtherScreen(),
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
