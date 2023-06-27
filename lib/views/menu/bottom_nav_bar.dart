import 'package:flashcards_reader/bloc/flashcards_bloc/flashcards_bloc.dart';
import 'package:flashcards_reader/bloc/translator_bloc/translator_bloc.dart';
import 'package:flashcards_reader/model/entities/reader/reading.dart';
import 'package:flashcards_reader/views/flashcards/flashcards/flashcards_screen.dart';
import 'package:flashcards_reader/views/flashcards/quiz/quiz_menu.dart';
import 'package:flashcards_reader/views/reader/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum BottomNavPages {
  homePage,
  quiz,
  flashcards,
}

class BottomNavBar extends StatefulWidget {
  static const homePageIndex = 0;
  static const quizPageIndex = 1;
  static const flashCardsPageIndex = 2;
  const BottomNavBar({super.key});

  static int basePageIndex = 0;

  static void setPageIndex(BottomNavPages page) {
    switch (page) {
      case BottomNavPages.homePage:
        basePageIndex = homePageIndex;
        break;
      case BottomNavPages.quiz:
        basePageIndex = quizPageIndex;
        break;
      case BottomNavPages.flashcards:
        basePageIndex = flashCardsPageIndex;
        break;
    }
  }

  @override
  BottomNavBarState createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FlashCardBloc(),
      child: BlocProvider(
        create: (_) => TranslatorBloc(),
        child: const BottomNavBarView(),
      ),
    );
  }
}

class BottomNavBarView extends StatefulWidget {
  const BottomNavBarView({super.key});

  @override
  BottomNavBarStateView createState() => BottomNavBarStateView();
}

class BottomNavBarStateView extends State<BottomNavBarView> {
  final HomePage homePage = const HomePage();
  // final Search search = const Search();
  final QuizMenu quiz = const QuizMenu();
  final FlashCardScreen flashcards = const FlashCardScreen();

  Widget _showPage = const HomePage();

  @override
  void initState() {
    setState(() {
      _showPage = _pageChooser(BottomNavBar.basePageIndex);
    });
    super.initState();
  }

  Widget _pageChooser(int page) {
    switch (page) {
      case BottomNavBar.homePageIndex:
        return homePage;
      case BottomNavBar.quizPageIndex:
        return quiz;
      case BottomNavBar.flashCardsPageIndex:
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
    return BlocBuilder<FlashCardBloc, FlashcardsState>(
        builder: (context, state) {
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
          currentIndex: BottomNavBar.basePageIndex,
          onTap: (int tapped) {
            BottomNavBar.basePageIndex = tapped;

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
    });
  }
}
