import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
part 'enums.g.dart';

Uuid uuid = const Uuid();

@HiveType(typeId: 3)
enum BookThemes {
  @HiveField(0)
  darkSoft,
  @HiveField(1)
  dark,
  @HiveField(2)
  light,
  @HiveField(3)
  lightSoft,
  @HiveField(4)
  grey,
  @HiveField(5)
  sepia,
  @HiveField(6)
  sepiaSoft
}

enum QuizMode {
  all,
  simple,
  hard,
  newest,
  oldest,
  random,
  learned,
}