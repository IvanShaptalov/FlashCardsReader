import 'package:flashcards_reader/util/enums.dart';
import 'package:hive/hive.dart';
part 'book_model.g.dart';


@HiveType(typeId: 4)
class BookStatus {
  @HiveField(0)
  bool reading = false;
  @HiveField(1)
  bool read = false;
  @HiveField(2)
  bool wantToRead = false;
  @HiveField(3)
  bool favourite = false;
  @HiveField(4)
  int onPage = 0;
}

@HiveType(typeId: 5)
class BookSettings {
  @HiveField(0)
  BookThemes theme = BookThemes.light;
}

@HiveType(typeId: 6)
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
    );
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
      };
}
