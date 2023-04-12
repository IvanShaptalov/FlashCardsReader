import 'package:flashcards_reader/model/entities/reader/settings.dart';

class ReadEntity {
  /// nativeMetadata provided by the document.
  /// Content in metadata is not guaranteed to be present.
  /// Provided content:
  /// authours
  /// title
  /// description
  /// language
  Map<String, dynamic> nativeMetaData = {};

  /// customMetadata provided:
  /// isFavorite
  /// isReading
  /// isInRecycleBin
  /// replacedAuthor
  Map<String, dynamic> customMetaData = {};

  /// The settings of the read entity.
  /// for example: font size, font color, background color, etc.
  EntitySettings settings = EntitySettings();

  
}
