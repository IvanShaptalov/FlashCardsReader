import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
import 'package:flashcards_reader/views/config/view_config.dart';

// import 'package:url_launcher/url_launcher.dart';
// import 'package:url_launcher/url_launcher.dart';

class Terms extends StatefulWidget {
  const Terms({super.key});

  @override
  TermsState createState() => TermsState();
}

class TermsState extends State<Terms> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Terms And Condition',
          style: TextStyle(
            fontSize: 23,
            color: Palette.darkblue,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Palette.scaffold,
        iconTheme: const IconThemeData(
          color: Palette.darkblue,
        ),
      ),
      body: const SingleChildScrollView(
        child: Text('unimplemented'),
      ),
    );
  }
}
