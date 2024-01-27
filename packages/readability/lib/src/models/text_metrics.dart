// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TextMetrics {
  double wordsCount;
  double sentencesCount;
  double longWordsCount;
  double longWordsPercentage;
  double charsCount;
  double avgSylCount;
  double sentenceAvgWordcount;
  double polysyllableCount;

  TextMetrics({
    required this.wordsCount,
    required this.sentencesCount,
    required this.longWordsCount,
    required this.longWordsPercentage,
    required this.charsCount,
    required this.avgSylCount,
    required this.sentenceAvgWordcount,
    required this.polysyllableCount,
  });

  TextMetrics copyWith({
    double? wordsCount,
    double? sentencesCount,
    double? longWordsCount,
    double? longWordsPercentage,
    double? charsCount,
    double? avgSylCount,
    double? sentenceAvgWordcount,
    double? polysyllableCount,
  }) {
    return TextMetrics(
      wordsCount: wordsCount ?? this.wordsCount,
      sentencesCount: sentencesCount ?? this.sentencesCount,
      longWordsCount: longWordsCount ?? this.longWordsCount,
      longWordsPercentage: longWordsPercentage ?? this.longWordsPercentage,
      charsCount: charsCount ?? this.charsCount,
      avgSylCount: avgSylCount ?? this.avgSylCount,
      sentenceAvgWordcount: sentenceAvgWordcount ?? this.sentenceAvgWordcount,
      polysyllableCount: polysyllableCount ?? this.polysyllableCount,
    );
  }

  factory TextMetrics.fromMap(Map<String, dynamic> map) => TextMetrics(
        wordsCount: map['words_count'] as double,
        sentencesCount: map['sentences_count'] as double,
        longWordsCount: map['long_words_count'] as double,
        longWordsPercentage: map['long_words_percentage'] as double,
        charsCount: map['chars_count'] as double,
        avgSylCount: map['avg_syl_count'] as double,
        sentenceAvgWordcount: map['sentence_avg_wordcount'] as double,
        polysyllableCount: map['polysyllable_count'] as double,
      );

  Map<String, dynamic> toMap() {
    return {
      'words_count': wordsCount,
      'sentences_count': sentencesCount,
      'long_words_count': longWordsCount,
      'long_words_percentage': longWordsPercentage,
      'chars_count': charsCount,
      'avg_syl_count': avgSylCount,
      'sentence_avg_wordcount': sentenceAvgWordcount,
      'polysyllable_count': polysyllableCount,
    };
  }

  String toJson() => json.encode(toMap());

  factory TextMetrics.fromJson(String source) =>
      TextMetrics.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TextMetrics(wordsCount: $wordsCount, sentencesCount: $sentencesCount, longWordsCount: $longWordsCount, longWordsPercentage: $longWordsPercentage, charsCount: $charsCount, avgSylCount: $avgSylCount, sentenceAvgWordcount: $sentenceAvgWordcount, polysyllableCount: $polysyllableCount)';
  }

  @override
  bool operator ==(covariant TextMetrics other) {
    if (identical(this, other)) return true;

    return other.wordsCount == wordsCount &&
        other.sentencesCount == sentencesCount &&
        other.longWordsCount == longWordsCount &&
        other.longWordsPercentage == longWordsPercentage &&
        other.charsCount == charsCount &&
        other.avgSylCount == avgSylCount &&
        other.sentenceAvgWordcount == sentenceAvgWordcount &&
        other.polysyllableCount == polysyllableCount;
  }

  @override
  int get hashCode {
    return wordsCount.hashCode ^
        sentencesCount.hashCode ^
        longWordsCount.hashCode ^
        longWordsPercentage.hashCode ^
        charsCount.hashCode ^
        avgSylCount.hashCode ^
        sentenceAvgWordcount.hashCode ^
        polysyllableCount.hashCode;
  }
}
