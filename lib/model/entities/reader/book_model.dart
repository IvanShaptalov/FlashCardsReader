import 'package:flashcards_reader/util/enums.dart';
import 'package:hive/hive.dart';
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

@HiveType(typeId: 5)
class BookSettings {
  @HiveField(0)
  BookThemes theme = BookThemes.light;

  BookSettings({
    required this.theme,
  });

  factory BookSettings.fromJson(Map<String, dynamic> json) {
    return BookSettings(
      theme: json['theme'],
    );
  }

  Map<String, dynamic> toJson() => {
        'theme': theme,
      };
}

@HiveType(typeId: 6)
class BookFile {
  @HiveField(0)
  String? path;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? extension;
  @HiveField(3)
  int? size;
  @HiveField(4)
  String? lastModified;

  BookFile({
    this.path,
    this.name,
    this.extension,
    this.size,
    this.lastModified,
  });

  factory BookFile.fromJson(Map<String, dynamic> json) {
    return BookFile(
      path: json['path'],
      name: json['name'],
      extension: json['extension'],
      size: json['size'],
      lastModified: json['lastModified'],
    );
  }

  Map<String, dynamic> toJson() => {
        'path': path,
        'name': name,
        'extension': extension,
        'size': size,
        'lastModified': lastModified,
      };
}

@HiveType(typeId: 7)
class BookModel {
  @HiveField(0)
  String? title;
  @HiveField(1)
  String? author;
  @HiveField(2)
  String? description;
  @HiveField(3)
  String? cover;
  @HiveField(4)
  String? language;
  @HiveField(5)
  int? pageCount;
  @HiveField(6)
  String? textSnippet;
  @HiveField(7)
  String? path;
  @HiveField(8)
  bool? isBinded;
  @HiveField(9)
  BookStatus status;
  @HiveField(10)
  BookSettings settings;
  @HiveField(11)
  BookFile file;
  @HiveField(12)
  DateTime lastAccess = DateTime.now();

  int id() => "${title ?? ''}$description${author ?? ''}".hashCode;

  BookModel({
    this.title,
    this.author,
    this.description,
    this.cover,
    this.language,
    this.pageCount,
    this.textSnippet,
    this.path,
    this.isBinded,
    required this.status,
    required this.settings,
    required this.file,
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
        path: json['path'],
        isBinded: json['isBinded'],
        status: BookStatus.fromJson(json['status']),
        settings: BookSettings.fromJson(json['settings']),
        file: BookFile.fromJson(json['file']),
        lastAccess: DateTime.parse(json['lastAccess']));
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'author': author,
        'description': description,
        'language': language,
        'pageCount': pageCount,
        'textSnippet': textSnippet,
        'path': path,
        'isBinded': isBinded,
        'status': status.toJson(),
        'settings': settings.toJson(),
        'file': file.toJson(),
        'lastAccess': lastAccess.toIso8601String(),
      };

  static List<BookModel> sortedByDate(List<BookModel> listBook) {
    List<BookModel> flist = listBook.toList();
    flist.sort((a, b) => b.lastAccess.compareTo(a.lastAccess));
    return flist;
  }

  @override
  String toString() {
    return 'BookModel{title: $title, author: $author, description: $description, cover: $cover, language: $language, pageCount: $pageCount, textSnippet: $textSnippet, path: $path, isBinded: $isBinded}';
  }
}
