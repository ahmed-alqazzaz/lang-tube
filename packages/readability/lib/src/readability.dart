// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:collection';
import 'models/readability_score.dart';
import 'rust_bridge/api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:languages/languages.dart';
part 'readability_impl.dart';

abstract class Readability {
  Readability._();
  static final HashMap<Language, Readability> _instances = HashMap();

  static Future<Readability> getInstance(Language language) async {
    if (!_instances.containsKey(language)) {
      final instance = _ReadabilityImpl(
        cacheDirectory: await _cacheDirectory,
        language: language,
      );
      // calculating text for the first time takes longer due to model initialization
      await instance.calculateTextReadability(_initializationText);
      _instances[language] = instance;
    }
    return _instances[language]!;
  }

  Future<ReadabilityScore> calculateTextReadability(String text);
  Future<int> countSyllables(String text);
  static Future<String?> get _cacheDirectory async {
    return await getApplicationDocumentsDirectory()
        .then((dir) => "${dir.path}\readability");
  }

  static const String _initializationText = "test";
}
