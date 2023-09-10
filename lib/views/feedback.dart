import 'package:flashcards_reader/firebase/firebase.dart';
import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flashcards_reader/views/menu/side_menu.dart';
import 'package:flashcards_reader/views/overlay_notification.dart';
import 'package:flashcards_reader/views/parent_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class FeedBackPage extends ParentStatefulWidget {
  FeedBackPage({super.key});

  @override
  ParentState<FeedBackPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ParentState<FeedBackPage> {
  double appBarHeight = 0;

  @override
  Widget build(BuildContext context, {Widget? page}) {
    /// ===============================================[Create page]======
    var appBar = AppBar(
      title: const Text('Feedback & Support'),
    );
    appBarHeight = appBar.preferredSize.height;
    bindPage(Scaffold(
      backgroundColor: Palette.lightGreen,
      appBar: appBar,
      body: Center(
          child: SizedBox(
              height: SizeConfig.getMediaHeight(context),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        FireBaseAnalyticsService.feedBackTap();
                        String email =
                            Uri.encodeComponent("withoutwater792@gmail.com");
                        String subject =
                            Uri.encodeComponent("FlashReader Issue");
                        String body = Uri.encodeComponent("Hi!\n");
                        debugPrint(subject); //output: Hello%20Flutter
                        Uri mail = Uri.parse(
                            "mailto:$email?subject=$subject&body=$body");
                        if (await launchUrl(mail)) {
                          //email app opened
                        } else {
                          OverlayNotificationProvider.showOverlayNotification(
                              'something went wrong');
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Palette.green300Primary),
                            color: Palette.green300Primary,
                            borderRadius: BorderRadius.circular(15)),
                        child: SizedBox(
                          width: SizeConfig.getMediaWidth(context, p: 0.6),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'send mail',
                                  style: FontConfigs.h2TextStyle,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Icon(
                                  Icons.mail_outline,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ))),
      drawer: SideMenu(appBarHeight),
    ));

    /// =======================================[Select design via context]==

    return super.build(context);
  }
}
