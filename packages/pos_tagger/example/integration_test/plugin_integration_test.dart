import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:pos_tagger/pos_tagger.dart';

Future<void> main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final PosTagger tagger = await PosTagger.acquireEnglishModel();

  group('POS Tagger tests', () {
    testWidgets('Test sentence 1', (WidgetTester tester) async {
      final List<PosTagEntry> tags = await tagger.posTag("hello world");
      final List<PosTagEntry> tagss =
          await tagger.posTag("I like to run in the park.");
      print("1: " + tagss.toString());
      final List<PosTagEntry> tagsss =
          await tagger.posTag("This is a run of five consecutive numbers");
      print("2: " + tagsss.toString());
      // Check that the tags list is not empty
      expect(tags, isNotEmpty);

      // Check that the first word is "hello" and its tag is an interjection
      expect(tags[0].word, equals("hello"));
      expect(tags[0].tag, equals(PosTag.interjection));

      // Check that the second word is "world" and its tag is a noun
      expect(tags[1].word, equals("world"));
      expect(tags[1].tag, equals(PosTag.noun));
    });

    testWidgets('Test sentence 2', (WidgetTester tester) async {
      final List<PosTagEntry> tags = await tagger.posTag("I am running");

      // Check that the tags list is not empty
      expect(tags, isNotEmpty);

      // Check that the first word is "I" and its tag is a personal pronoun
      expect(tags[0].word, equals("I"));
      expect(tags[0].tag, equals(PosTag.personalPronoun));

      // Check that the second word is "am" and its tag is a verb
      expect(tags[1].word, equals("am"));
      expect(tags[1].tag, equals(PosTag.verbNonThirdPersonSingularPresent));

      // Check that the third word is "running" and its tag is a verb gerund
      expect(tags[2].word, equals("running"));
      expect(tags[2].tag, equals(PosTag.verbGerund));
    });

    testWidgets('Test complex sentence', (WidgetTester tester) async {
      final List<PosTagEntry> tags = await tagger
          .posTag("Despite the heavy rains the game continued as scheduled.");
      print(tags);
      // Check that the tags list is not empty
      expect(tags, isNotEmpty);

      // Check the words and their tags
      expect(tags[0].word, equals("Despite"));
      expect(tags[0].tag, equals(PosTag.preposition));

      expect(tags[1].word, equals("the"));
      expect(tags[1].tag, equals(PosTag.determiner));

      expect(tags[2].word, equals("heavy"));
      expect(tags[2].tag, equals(PosTag.adjective));

      expect(tags[3].word, equals("rains"));
      expect(tags[3].tag, equals(PosTag.pluralNoun));

      expect(tags[4].word, equals("the"));
      expect(tags[4].tag, equals(PosTag.determiner));

      expect(tags[5].word, equals("game"));
      expect(tags[5].tag, equals(PosTag.noun));

      expect(tags[6].word, equals("continued"));
      expect(tags[6].tag, equals(PosTag.verbPastTense));

      expect(tags[7].word, equals("as"));
      expect(tags[7].tag, equals(PosTag.adverb));

      expect(tags[8].word, equals("scheduled"));
      expect(tags[8].tag, equals(PosTag.verbPastTense));
    });
  });
}
