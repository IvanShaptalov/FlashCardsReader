import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

class Privacy extends StatefulWidget {
  const Privacy({super.key});

  @override
  PrivacyState createState() => PrivacyState();
}

class PrivacyState extends State<Privacy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.scaffold,
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
              fontSize: 23,
              color: Palette.darkblue,
              fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Palette.darkblue),
      ),
      body: const SingleChildScrollView(
        child: Text('unimplemented'),
      ),
    );
  }
}
