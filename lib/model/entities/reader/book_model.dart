import 'dart:io';
import 'dart:isolate';

import 'package:flashcards_reader/constants.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
part 'book_model.g.dart';

@HiveType(typeId: 4)
class BookSettings {
  @HiveField(0)
  int fontSize;
  @HiveField(1)
  String fontColor;
  @HiveField(2)
  double lineHeight;
  @HiveField(3)
  double wordSpacing;
  @HiveField(4)
  double letterSpacing;
  @HiveField(5)
  String fontFamily;
  @HiveField(6)
  String backgroundColor;
  @HiveField(7)
  int currentPage;
  @HiveField(8)
  int pagesCount;

  @override
  String toString() {
    return '$fontSize, current Page: $currentPage, pagesCount: $pagesCount';
  }

  @override
  bool operator ==(Object other) =>
      other is BookSettings &&
      other.runtimeType == runtimeType &&
      other.hashCode == hashCode;

  @override
  int get hashCode => toString().hashCode;

  BookSettings({
    required this.fontSize,
    required this.fontColor,
    required this.lineHeight,
    required this.wordSpacing,
    required this.letterSpacing,
    required this.fontFamily,
    required this.backgroundColor,
    required this.currentPage,
    required this.pagesCount,
  });

  factory BookSettings.asset() {
    return BookSettings(
        fontSize: 14,
        fontColor: '#000000',
        lineHeight: 1.0,
        wordSpacing: 1.0,
        letterSpacing: 0.2,
        fontFamily: 'Roboto',
        backgroundColor: '#ffffff',
        currentPage: 0,
        pagesCount: 2);
  }

  factory BookSettings.fromJson(Map<String, dynamic> json) {
    return BookSettings(
      fontSize: json['fontSize'],
      fontColor: json['fontColor'],
      lineHeight: json['lineHeight'],
      wordSpacing: json['wordSpacing'],
      letterSpacing: json['letterSpacing'],
      fontFamily: json['fontFamily'],
      backgroundColor: json['backgroundColor'],
      currentPage: json['currentPage'],
      pagesCount: json['pagesCount'],
    );
  }

  Map<String, dynamic> toJson() => {
        'fontSize': fontSize,
        'fontColor': fontColor,
        'lineHeight': lineHeight,
        'wordSpacing': wordSpacing,
        'letterSpacing': letterSpacing,
        'fontFamily': fontFamily,
        'backgroundColor': backgroundColor,
        'currentPage': currentPage,
        'pagesCount': pagesCount,
      };
}

@HiveType(typeId: 5)
class PDFSettings {
  @HiveField(0)
  int scaling = 1;
  @HiveField(1)
  int currentPage = 0;

  @override
  String toString() {
    return 'scaling $scaling x, current Page: $currentPage';
  }

  @override
  bool operator ==(Object other) =>
      other is PDFSettings &&
      other.runtimeType == runtimeType &&
      other.hashCode == hashCode;

  @override
  int get hashCode => toString().hashCode;

  PDFSettings({required this.scaling, required this.currentPage});

  factory PDFSettings.asset() {
    return PDFSettings(scaling: 1, currentPage: 0);
  }

  factory PDFSettings.fromJson(Map<String, dynamic> json) {
    return PDFSettings(
      scaling: json['scaling'],
      currentPage: json['currentPage'],
    );
  }

  Map<String, dynamic> toJson() => {
        'currentPage': currentPage,
        'scaling': scaling,
      };
}

@HiveType(typeId: 6)
class BookNotes {
  // first note, second comment to it
  @HiveField(0)
  Map<String, dynamic> notes;

  int get lenght => notes.length;

  @override
  String toString() {
    return 'notes $notes\n, count: ${notes.length}';
  }

  @override
  bool operator ==(Object other) =>
      other is BookNotes &&
      other.runtimeType == runtimeType &&
      other.hashCode == hashCode;

  @override
  int get hashCode => toString().hashCode;

  BookNotes({required this.notes});

  factory BookNotes.asset() {
    return BookNotes(
        notes: {'note': 'comment to note', 'note 2': 'comment to note 2'});
  }

  factory BookNotes.fromJson(Map<String, dynamic> json) {
    var notesFromJson = json['notes'];
    var notes = Map<String, dynamic>.from(notesFromJson);
    return BookNotes(
      notes: notes,
    );
  }

  Map<String, dynamic> toJson() => {
        'notes': notes,
      };
}

@HiveType(typeId: 7)
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

@HiveType(typeId: 8)
class BookFileMeta {
  @HiveField(0)
  String path;

  /// extension
  @HiveField(1)
  String ext;
  @HiveField(2)
  int size;
  @HiveField(3)
  DateTime lastModified;

  BookFileMeta({
    required this.path,
    required this.ext,
    required this.size,
    required this.lastModified,
  });

  factory BookFileMeta.asset() {
    return BookFileMeta(
        path: 'assets/book/quotes.txt',
        ext: textExt,
        size: 1,
        lastModified: DateTime.now());
  }

  factory BookFileMeta.fromJson(Map<String, dynamic> json) {
    return BookFileMeta(
      path: json['path'],
      ext: json['extension'],
      size: json['size'],
      lastModified: DateTime.parse(json['lastModified']),
    );
  }

  Map<String, dynamic> toJson() => {
        'path': path,
        'extension': ext,
        'size': size,
        'lastModified': lastModified.toIso8601String(),
      };

  @override
  String toString() {
    return 'path $path , Extension: $ext';
  }

  @override
  bool operator ==(Object other) =>
      other is BookFileMeta &&
      other.runtimeType == runtimeType &&
      other.hashCode == hashCode;

  @override
  int get hashCode => toString().hashCode;
}

@HiveType(typeId: 9)
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
  @HiveField(11)
  BookSettings settings;
  @HiveField(12)
  PDFSettings pdfSettings;
  @HiveField(13)
  BookNotes bookNotes;

  int id() => "$title $description $author ${fileMeta.path}".hashCode;

  BookModel(
      {required this.title,
      required this.author,
      required this.description,
      required this.coverPath,
      required this.language,
      this.flashCardId,
      required this.status,
      required this.fileMeta,
      required this.lastAccess,
      required this.settings,
      required this.pdfSettings,
      required this.bookNotes});

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
        title: json['title'],
        author: json['author'],
        description: json['description'],
        language: json['language'],
        coverPath: json['coverPath'],
        status: BookStatus.fromJson(json['status']),
        fileMeta: BookFileMeta.fromJson(json['file']),
        flashCardId: json['flashCardId'],
        lastAccess: DateTime.parse(json['lastAccess']),
        pdfSettings: PDFSettings.fromJson(json['pdfSettings']),
        settings: BookSettings.fromJson(json['bookSettings']),
        bookNotes: BookNotes.fromJson(json['bookNotes']));
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
        status: BookStatus.falseStatus(),
        fileMeta: BookFileMeta.asset(),
        lastAccess: DateTime.now(),
        settings: BookSettings.asset(),
        pdfSettings: PDFSettings.asset(),
        bookNotes: BookNotes.asset());
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'author': author,
        'description': description,
        'language': language,
        'coverPath': coverPath,
        'isBinded': isBinded,
        'status': status.toJson(),
        'file': fileMeta.toJson(),
        'lastAccess': lastAccess.toIso8601String(),
        'flashCardId': flashCardId,
        'bookSettings': settings.toJson(),
        'pdfSettings': pdfSettings.toJson(),
        'bookNotes': bookNotes.toJson(),
      };

  static List<BookModel> sortedByDate(List<BookModel> listBook) {
    List<BookModel> flist = listBook.toList();
    flist.sort((a, b) => b.lastAccess.compareTo(a.lastAccess));
    return flist;
  }

  @override
  String toString() {
    return '''BookModel{title: $title, author: $author, description: $description, cover: $coverPath, language: $language, path: ${fileMeta.path}, isBinded: $isBinded''';
  }

  @override
  bool operator ==(Object other) =>
      other is BookModel && other.hashCode == hashCode;

  @override
  int get hashCode => toString().hashCode;
}
