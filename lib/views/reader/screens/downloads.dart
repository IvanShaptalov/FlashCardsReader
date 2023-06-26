import 'dart:io';

import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/views/reader/download_pdf.dart';
import 'package:flashcards_reader/views/menu/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:flashcards_reader/views/config/view_config.dart';

import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;

class Downloads extends StatefulWidget {
  const Downloads({super.key});

  @override
  DownloadsState createState() => DownloadsState();
}

class DownloadsState extends State<Downloads> {
  String? directory;
  List file = [];

  @override
  void initState() {
    super.initState();
    _listofFiles();
  }

  _listofFiles() async {
    directory = (await getExternalStorageDirectory())!.path;
    debugPrintIt(directory);
    setState(() {
      file = io.Directory(directory!).listSync();
      // print(file);
    });
  }

  deleteFile(File file) {
    file.deleteSync();
  }

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      title: const Text(
        'Downloads',
        style: FontConfigs.pageNameTextStyle,
      ),
      backgroundColor: Palette.scaffold,
      iconTheme: const IconThemeData(color: Palette.darkblue),
    );
    return Scaffold(
      drawer: Drawer(
        child: SideMenu(appBar.preferredSize.height),
      ),
      appBar: appBar,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: file.length,
              itemBuilder: (BuildContext context, int index) {
                String path = file[index].path;
                String pathDir = path
                    .replaceAll(
                        "/storage/emulated/0/Android/data/com.samwit.reader_1/files/",
                        "")
                    .replaceAll(".pdf", "");
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (DismissDirection direction) {
                    deleteFile(File(path));
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("$pathDir deleted")));
                  },
                  background: Container(
                    color: Colors.red,
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          Text(
                            "Delete",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                            textAlign: TextAlign.left,
                          )
                        ],
                      ),
                    ),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    child: const Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          Text(
                            "Delete",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            width: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DownloadPDF(path, pathDir)));
                    },
                    child: ListTile(
                      title: Text(pathDir),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
