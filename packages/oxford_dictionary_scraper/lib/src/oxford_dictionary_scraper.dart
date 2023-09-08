import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:flutter/foundation.dart';
import 'data/data.dart';
import 'exceptions.dart';
import 'helpers/oxford_dictionary_api_client.dart';
import 'helpers/oxford_dictionary_soup_parser.dart';

@immutable
class OxfordDictionaryScraper {
  OxfordDictionaryScraper({
    required String userAgent,
  }) : client = OxfordDictionaryApiClient(userAgent: userAgent);

  final OxfordDictionaryApiClient client;
  final soupParser = const OxfordDictionarySoupParser();

  Future<List<Lexicon>> search(List<String> words) async {
    // search each one of the possible lemmas
    // and filter out null values
    final results = await Future.wait(
      _searchLemmas(words),
    ).then(
      (results) => results.whereType<Lexicon>().toList(),
    );

    return (results.isEmpty) ? throw const WordUnavailableException() : results;
  }

  Iterable<Future<Lexicon?>> _searchLemmas(List<String> lemmas) sync* {
    for (final lemma in lemmas) {
      yield client.fetchWord(lemma).then(
        (response) {
          final sp = response != null ? BeautifulSoup(response) : null;
          if (sp != null) {
            return soupParser.extractLexicon(sp);
          }
          return null;
        },
      );
    }
  }
}
