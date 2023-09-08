import 'package:flutter_test/flutter_test.dart';

import 'package:oxford_dictionary_scraper/src/oxford_dictionary_scraper.dart';

Future<void> main() async {
  final scraper = OxfordDictionaryScraper(
      userAgent:
          'Mozilla/5.0 (Linux; Android 10; LM-Q720) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.85 Mobile Safari/537.36');
  final x = await scraper.search(['go']);
  print(x.first.main!.senses.first.definition.main);
}
