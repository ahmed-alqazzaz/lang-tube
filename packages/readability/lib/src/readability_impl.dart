part of 'readability.dart';

class _ReadabilityImpl extends Readability {
  final Language language;
  final String? cacheDirectory;
  _ReadabilityImpl({
    required this.language,
    required this.cacheDirectory,
  }) : super._();

  @override
  Future<ReadabilityScore> calculateScore(String text) async {
    return ReadabilityScore.fromJson(
      await rustApi.calculateTextComplexity(
        text: text,
        language: language.code,
        cacheDir: cacheDirectory,
      ),
    );
  }

  @override
  Future<int> calculateSyllables(String text) async =>
      await rustApi.countSyllables(text: text);
}
