import 'dart:io';
import 'dart:isolate';

import 'package:flashcards_reader/constants.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
part 'book_model.g.dart';

@HiveType(typeId: 4)
class BookStatus {
  @HiveField(0)
  bool readingPrivate = false;
  @HiveField(1)
  bool readPrivate = false;
  @HiveField(2)
  bool toRead = false;
  @HiveField(3)
  bool favourite = false;
  @HiveField(4)
  bool inTrash = false;
  @HiveField(5)
  int onPage = 0;

  @override
  String toString() {
    return '''reading: $readingPrivate readPrivate: $readPrivate toRead: $toRead 
    favourite $favourite inTrash :$inTrash page: $onPage''';
  }

  @override
  bool operator ==(Object other) =>
      other is BookStatus &&
      other.runtimeType == runtimeType &&
      other.hashCode == hashCode;

  @override
  int get hashCode => toString().hashCode;

  /// one from two: already read or reading
  set reading(bool reading) {
    readingPrivate = reading;
    readPrivate = !reading;
  }

  /// one from two: already read or reading
  set haveRead(bool read) {
    readPrivate = read;
    readingPrivate = !read;
  }

  bool get haveRead => readPrivate;
  bool get reading => readingPrivate;

  BookStatus({
    required this.readPrivate,
    required this.readingPrivate,
    required this.toRead,
    required this.favourite,
    required this.onPage,
    required this.inTrash,
  });

  factory BookStatus.falseStatus() {
    return BookStatus(
        readPrivate: false,
        readingPrivate: false,
        toRead: false,
        favourite: false,
        onPage: 0,
        inTrash: false);
  }

  factory BookStatus.fromJson(Map<String, dynamic> json) {
    return BookStatus(
      readingPrivate: json['reading'],
      readPrivate: json['read'],
      toRead: json['wantToRead'],
      favourite: json['favourite'],
      onPage: json['onPage'],
      inTrash: json['inTrash'],
    );
  }

  Map<String, dynamic> toJson() => {
        'reading': readingPrivate,
        'read': readPrivate,
        'wantToRead': toRead,
        'favourite': favourite,
        'onPage': onPage,
        'inTrash': inTrash,
      };
}

@HiveType(typeId: 6)
class BookFileMeta {
  @HiveField(0)
  String path;

  /// extension
  @HiveField(1)
  String ext;
  @HiveField(2)
  int size;
  @HiveField(3)
  String lastModified;

  BookFileMeta({
    required this.path,
    required this.ext,
    required this.size,
    required this.lastModified,
  });

  factory BookFileMeta.fromJson(Map<String, dynamic> json) {
    return BookFileMeta(
      path: json['path'],
      ext: json['extension'],
      size: json['size'],
      lastModified: json['lastModified'],
    );
  }

  Map<String, dynamic> toJson() => {
        'path': path,
        'extension': ext,
        'size': size,
        'lastModified': lastModified,
      };
}

@HiveType(typeId: 7)
class BookModel {
  @HiveField(0)
  String title;
  @HiveField(1)
  String author;
  @HiveField(2)
  String description;
  @HiveField(3)
  String coverPath;
  @HiveField(4)
  String language;
  @HiveField(5)
  int pageCount;
  @HiveField(6)
  String textSnippet;

  bool get isBinded =>
      File(fileMeta.path).existsSync() || fileMeta.path.contains('asset');
  @HiveField(7)
  BookStatus status;

  @HiveField(8)
  BookFileMeta fileMeta;
  @HiveField(9)
  DateTime lastAccess = DateTime.now();
  @HiveField(10)
  String? flashCardId;

  int id() => "$title $description $author ${fileMeta.path}".hashCode;

  BookModel({
    required this.title,
    required this.author,
    required this.description,
    required this.coverPath,
    required this.language,
    required this.pageCount,
    required this.textSnippet,
    this.flashCardId,
    required this.status,
    required this.fileMeta,
    required this.lastAccess,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
        title: json['title'],
        author: json['author'],
        description: json['description'],
        language: json['language'],
        pageCount: json['pageCount'],
        textSnippet: json['textSnippet'],
        coverPath: json['coverPath'],
        status: BookStatus.fromJson(json['status']),
        fileMeta: BookFileMeta.fromJson(json['file']),
        flashCardId: json['flashCardId'],
        lastAccess: DateTime.parse(json['lastAccess']));
  }

  Future<File> getFileFromAssets(String path) async {
    final byteData = await rootBundle.load(path);

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.create(recursive: true);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  Future<String> getAllTextAsync() async {
    if (fileMeta.path.toLowerCase().contains('asset')) {
      var file = await getFileFromAssets(fileMeta.path);
      if (file.existsSync()) {
        return file.readAsString();
      }
    }

    var result = await Isolate.run(getText);
    debugPrintIt('а оно то давно уже загрузилось))');
    debugPrintIt(result);
    return result;
  }

  Future<String> getText() async {
    var result = (await getFile()).readAsString();
    return result;
  }

  Future<File> getFile() async {
    if (File(fileMeta.path).existsSync()) {
      return File(fileMeta.path);
    }
    return File(fileMeta.path)..writeAsString('book not found');
  }

  static BookModel asset() {
    return BookModel(
        title: 'Live once',
        author: 'Everyone',
        description: 'Die hard',
        coverPath: 'assets/book/quotes_skin.png',
        language: 'en',
        pageCount: 1,
        textSnippet: 'We need much less than we think we need',
        status: BookStatus.falseStatus(),
        fileMeta: BookFileMeta(
            ext: textExt,
            path: 'assets/book/quotes.txt',
            size: 0,
            lastModified: DateTime.now().toIso8601String()),
        lastAccess: DateTime.now());
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'author': author,
        'description': description,
        'language': language,
        'pageCount': pageCount,
        'textSnippet': textSnippet,
        'isBinded': isBinded,
        'status': status.toJson(),
        'file': fileMeta.toJson(),
        'lastAccess': lastAccess.toIso8601String(),
        'flashCardId': flashCardId,
      };

  static List<BookModel> sortedByDate(List<BookModel> listBook) {
    List<BookModel> flist = listBook.toList();
    flist.sort((a, b) => b.lastAccess.compareTo(a.lastAccess));
    return flist;
  }

  @override
  String toString() {
    return '''BookModel{title: $title, author: $author, description: $description, cover: $coverPath, language: $language, pageCount: $pageCount, textSnippet: $textSnippet, path: ${fileMeta.path}, isBinded: $isBinded''';
  }

  @override
  bool operator ==(Object other) =>
      other is BookModel && other.hashCode == hashCode;

  @override
  int get hashCode => toString().hashCode;
}
