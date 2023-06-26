import 'package:flashcards_reader/views/reader/screens/homepage.dart';
import 'package:flashcards_reader/views/reader/screens/info.dart';
import 'package:flashcards_reader/views/reader/screens/search.dart';
import 'package:flutter/material.dart';
import 'package:flashcards_reader/views/reader/screens/downloads.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  BottomNavBarState createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar> {
  int pageIndex = 0;
  final HomePage homePage = const HomePage();
  final Search search = const Search();
  final Info info = const Info();
  final Downloads downloads = const Downloads();

  Widget _showPage = const HomePage();

  Widget _pageChooser(int page) {
    switch (page) {
      case 0:
        return homePage;
      case 1:
        return search;
      case 2:
        return downloads;
      default:
        return const Center(
          child: Text(
            'No Page To Show',
            style: TextStyle(fontSize: 30),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.download_sharp),
            label: 'Downloads',
          ),
        ],
        currentIndex: pageIndex,
        onTap: (int tapped) {
          pageIndex = tapped;

          setState(() {
            _showPage = _pageChooser(tapped);
          });
        },
        selectedItemColor: Colors.amber[800],
        // letIndexChange: (index) => true,
      ),
      body: Container(
        child: _showPage,
      ),
    );
  }
}
