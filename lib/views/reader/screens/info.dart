import 'package:flashcards_reader/views/reader/privacy.dart';
import 'package:flashcards_reader/views/reader/terms.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flashcards_reader/views/reader/side_menu.dart';
import 'package:flashcards_reader/views/config/view_config.dart';

import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class Info extends StatefulWidget {
  const Info({super.key});

  @override
  InfoState createState() => InfoState();
}

class InfoState extends State<Info> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(
        child: SideMenu(),
      ),
      appBar: AppBar(
        backgroundColor: Palette.scaffold,
        iconTheme: const IconThemeData(color: Palette.darkblue),
        title: const Text(
          'Info',
          style: TextStyle(
              fontSize: 23,
              color: Palette.darkblue,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: [
            ListTile(
              title: const Text(
                'GitHub',
                style: TextStyle(
                  fontSize: 18,
                  color: Palette.darkblue,
                ),
              ),
              leading: const Icon(
                MdiIcons.github,
                size: 30,
              ),
              onTap: () async {
                const url = 'https://github.com/SamwitAdhikary';
                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url));
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
            const Divider(),
            ListTile(
              title: const Text(
                'Terms and Condition',
                style: TextStyle(
                  fontSize: 18,
                  color: Palette.darkblue,
                ),
              ),
              leading: const Icon(
                MdiIcons.pen,
                size: 30,
              ),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const Terms()));
              },
            ),
            const Divider(),
            ListTile(
              title: const Text(
                'Privacy Policy',
                style: TextStyle(
                  fontSize: 18,
                  color: Palette.darkblue,
                ),
              ),
              leading: const Icon(
                MdiIcons.note,
                size: 30,
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Privacy()));
              },
            ),
            const Divider(),
            ListTile(
              title: const Text(
                'Share this app',
                style: TextStyle(
                  fontSize: 18,
                  color: Palette.darkblue,
                ),
              ),
              leading: const Icon(
                Icons.share,
                size: 30,
              ),
              onTap: () => Share.share(
                  'Hey check out this awesome app. \n bit.ly/NoteItBookApps'),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
