import 'package:flashcards_reader/bloc/providers/word_collection_provider.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Json test', () {
    test('', () async {});

    test('test to json', () async {
      FlashCardCollection collection = flashExample();

      String cJson = collection.toJson();

      FlashCardCollection newCollection = FlashCardCollection.fromJson(cJson);

      expect(collection.hashCode, newCollection.hashCode);
      expect(collection == newCollection, true);
    });
  });
}
