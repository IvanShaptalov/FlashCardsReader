import 'package:flashcards_reader/views/menu/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class ReadingMainScreen extends StatefulWidget {
  const ReadingMainScreen({super.key});

  @override
  ReadingMainScreenState createState() => ReadingMainScreenState();
}

class ReadingMainScreenState extends State<ReadingMainScreen> {
  @override
  Widget build(BuildContext context) {
    BottomNavBar.setPageIndex(BottomNavPages.homePage);
    return BottomNavBar();
  }
}
