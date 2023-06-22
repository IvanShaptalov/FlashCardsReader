import 'package:flashcards_reader/bloc/providers/word_collection_provider.dart';
import 'package:flashcards_reader/model/IO/sharing_flashcards.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Json test', () {
    test('test to/from json', () async {
      FlashCardCollection collection = flashExample();
      collection.flashCardSet.add(FlashCard.fixture()
        ..answer = 'відповідь'
        ..question = 'question');

      String cJson = collection.toJson();

      FlashCardCollection newCollection = FlashCardCollection.fromJson(cJson);

      expect(collection.hashCode, newCollection.hashCode);
      expect(collection == newCollection, true);
    });

    test('json sharing flashcards', () async {
      List<FlashCardCollection> collection = [flashExample()];
      collection.first.flashCardSet.add(FlashCard.fixture()
        ..answer = 'відповідь'
        ..question = 'question');

      JsonShare share = JsonShare();
      share.collections = collection;

      String result = share.export();

      expect(result, isNotEmpty);

      share.jsonEntity = result;
      List<FlashCardCollection> newCollection = share.import();

      expect(newCollection, collection);
    });
  });

  group('Text test', () {
    test('Text sharing flashcards', () async {
      List<FlashCardCollection> collection = [flashExample()];
      collection.first.flashCardSet.add(FlashCard.fixture()
        ..answer = 'відповідь'
        ..question = 'question');

      TextShare share = TextShare();
      share.collections = collection;

      String result = share.export();
      debugPrintIt(result);
      expect(result, isNotEmpty);

      share.textEntity = result;
      List<FlashCardCollection> newCollection = share.import();

      // manual sharing can t be same by id because some fields are not shared,
      // point is to check if collections are same by content
      expect(newCollection.length, collection.length);
      expect(newCollection.first.flashCardSet.length,
          collection.first.flashCardSet.length);
    });
  });
}
