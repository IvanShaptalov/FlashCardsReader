import 'package:flashcards_reader/util/regex_util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('REGEX test', () {
    test('Create paragraph and remove break lines', () async {
      String text =
          """some text then break line\nnew text, not broken\n\nnew paragraph""";

      String correctText = """
some text then break line new text, not broken\n\n  new paragraph""";

      String result = regexFixParagraph(text);

      expect(result, correctText);
    });
  });
}
