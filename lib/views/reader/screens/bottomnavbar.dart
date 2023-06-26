import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flashcards_reader/views/reader/screens/homepage.dart';
import 'package:flashcards_reader/views/reader/screens/info.dart';
import 'package:flashcards_reader/views/reader/screens/search.dart';
import 'package:flutter/material.dart';
import 'package:flashcards_reader/views/reader/screens/downloads.dart';

import 'package:flashcards_reader/views/config/view_config.dart';


class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int pageIndex = 0;
  final HomePage homePage = HomePage();
  final Search search = Search();
  final Info info = Info();
  final Downloads downloads = Downloads();

  Widget _showPage = HomePage();

  Widget _pageChooser(int page) {
    switch (page) {
      case 0:
        return homePage;
      case 1:
        return search;
      case 2:
        return downloads;
      case 3:
        return info;
      default:
        return new Container(
          child: Center(
            child: Text(
              'No Page To Show',
              style: TextStyle(fontSize: 30),
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        index: pageIndex,
        height: 55.0,
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.search, size: 30),
          Icon(
            Icons.download_sharp,
            size: 30,
          ),
          Icon(Icons.info_outline, size: 30),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Palette.scaffold,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 300),
        onTap: (int tapped) {
          setState(() {
            _showPage = _pageChooser(tapped);
          });
        },
        // letIndexChange: (index) => true,
      ),
      body: Container(
        child: _showPage,
      ),
    );
  }
}
