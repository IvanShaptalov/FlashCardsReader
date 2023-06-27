import 'package:flashcards_reader/model/entities/reader/reading.dart';
import 'package:flashcards_reader/views/flashcards/flashcards/flashcards_screen.dart';
import 'package:flashcards_reader/views/flashcards/quiz/quiz_menu.dart';
import 'package:flashcards_reader/views/reader/screens/homepage.dart';
import 'package:flashcards_reader/views/reader/screens/search.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  BottomNavBarState createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar> {
  int pageIndex = 0;
  final HomePage homePage = const HomePage();
  // final Search search = const Search();
  final QuizMenu quiz = const QuizMenu();
  final FlashCardScreen flashcards = const FlashCardScreen();

  Widget _showPage = const HomePage();

  Widget _pageChooser(int page) {
    switch (page) {
      case 0:
        return homePage;
      case 1:
        // return search;
        return quiz;
      case 2:
        return flashcards;
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
            icon: Reading.icon,
            label: Reading.title,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz),
            label: 'Quiz',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.web_stories_outlined),
            label: 'FlashCards',
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
