import 'package:flashcards_reader/model/IO/local_manager.dart';
import 'package:flashcards_reader/model/entities/reader/book_scanner.dart';
import 'package:flashcards_reader/model/entities/tts/core.dart';
import 'package:flashcards_reader/util/checker.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flashcards_reader/views/guide_wrapper.dart';
import 'package:flashcards_reader/views/help_page/help_page.dart';
import 'package:flutter/material.dart';
import 'package:intro/intro.dart';
import 'package:overlay_support/overlay_support.dart';

import 'database/core/core.dart';

void initTts() async {
  TextToSpeechService.initTtsEngineAsync().then((value) {
    debugPrintIt('tts engine inited: $value');
    // if not inited, try again
    if (!value) {
      debugPrintIt('tts not inited, try again');
      initTts();
    }
  });
}

Future<bool> initAsync() async {
  bool ioInit = await LocalManager.initAsync();
  bool dbInit = await DataBase.initAsync();

  BookScanner.init();
  debugPrintIt('db inited: $dbInit');

  initTts();

  // start checking internet connection
  debugPrintIt('start checking internet connection');
  Checker.startChecking();
  return dbInit && ioInit;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool inited = await initAsync();
  debugPrint('inited: $inited');
  assert(inited, true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: Intro(
        controller: GuideProvider.introController,
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.green,
            // ignore: deprecated_member_use
            androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
            iconTheme: IconThemeData(color: Palette.grey800),
            scaffoldBackgroundColor: Palette.grey200,
          ),
          home: HelpPage(),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
