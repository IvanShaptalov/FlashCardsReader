import 'package:flashcards_reader/views/reader/privacy.dart';
import 'package:flashcards_reader/views/reader/terms.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flashcards_reader/views/config/view_config.dart';

import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  SideMenuState createState() => SideMenuState();
}

class SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Palette.scaffold,
        child: ListView(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.15,
              padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: const Text(
                'Hello Programmers!!!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text(
                'GitHub',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              contentPadding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              trailing: const Icon(MdiIcons.github),
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
                'Terms And Condition',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              contentPadding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              trailing: const Icon(MdiIcons.pen),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Terms(),
                    ));
              },
            ),
            const Divider(),
            ListTile(
              title: const Text(
                'Privacy Policy',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              contentPadding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              trailing: const Icon(MdiIcons.note),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Privacy(),
                    ));
              },
            ),
            const Divider(),
            ListTile(
              title: const Text(
                'Share This App',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              contentPadding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              trailing: const Icon(Icons.share),
              onTap: () => Share.share(
                  'Hey check out this awesome app. \n bit.ly/NoteItBookApps'),
            ),
            const Divider(),
          ],
        ));
  }
}
