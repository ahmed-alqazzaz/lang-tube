import 'dart:convert';

import 'package:readability/src/models/text_metrics.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class ReadabilityScore {
  final TextMetrics rawMetrics;
  final double lixIndex;
  final double rixIndex;
  final double fleschKincaidGrade;
  final double automatedReadabilityIndex;
  final double colemanLiauIndex;
  final double gunningFoxIndex;
  final double smogIndex;

  const ReadabilityScore({
    required this.rawMetrics,
    required this.lixIndex,
    required this.rixIndex,
    required this.fleschKincaidGrade,
    required this.automatedReadabilityIndex,
    required this.colemanLiauIndex,
    required this.gunningFoxIndex,
    required this.smogIndex,
  });

  bool compareTo({required ReadabilityScore other, dynamic hint}) {
    final thisScores = toList();
    final otherScores = other.toList();

    int count = 0;
    for (int i = 0; i < thisScores.length; i++) {
      if (thisScores[i] < otherScores[i]) {
        count += 1;
      }
    }
    return count > thisScores.length / 2;
  }

  List<double> toList() => [
        lixIndex,
        rixIndex,
        fleschKincaidGrade,
        automatedReadabilityIndex,
        colemanLiauIndex,
        gunningFoxIndex,
        smogIndex,
      ];

  @override
  String toString() {
    return 'ReadabilityScore(rawMetrics: $rawMetrics, lixIndex: $lixIndex, rixIndex: $rixIndex, fleschKincaidGrade: $fleschKincaidGrade, automatedReadabilityIndex: $automatedReadabilityIndex, colemanLiauIndex: $colemanLiauIndex, gunningFoxIndex: $gunningFoxIndex, smogIndex: $smogIndex)';
  }

  @override
  bool operator ==(covariant ReadabilityScore other) {
    if (identical(this, other)) return true;

    return other.rawMetrics == rawMetrics &&
        other.lixIndex == lixIndex &&
        other.rixIndex == rixIndex &&
        other.fleschKincaidGrade == fleschKincaidGrade &&
        other.automatedReadabilityIndex == automatedReadabilityIndex &&
        other.colemanLiauIndex == colemanLiauIndex &&
        other.gunningFoxIndex == gunningFoxIndex &&
        other.smogIndex == smogIndex;
  }

  @override
  int get hashCode {
    return rawMetrics.hashCode ^
        lixIndex.hashCode ^
        rixIndex.hashCode ^
        fleschKincaidGrade.hashCode ^
        automatedReadabilityIndex.hashCode ^
        colemanLiauIndex.hashCode ^
        gunningFoxIndex.hashCode ^
        smogIndex.hashCode;
  }

  factory ReadabilityScore.fromMap(Map<String, dynamic> map) {
    return ReadabilityScore(
      rawMetrics: TextMetrics.fromMap(map),
      lixIndex: map['lix_index'],
      rixIndex: map['rix_index'],
      fleschKincaidGrade: map['flesch_kincaid_grade'],
      automatedReadabilityIndex: map['automated_readability_index'],
      colemanLiauIndex: map['coleman_liau_index'],
      gunningFoxIndex: map['gunning_fox_index'],
      smogIndex: map['smog_index'],
    );
  }

  factory ReadabilityScore.fromJson(String source) =>
      ReadabilityScore.fromMap(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return {
      'rawMetrics': rawMetrics.toMap(),
      'lix_index': lixIndex,
      'rix_index': rixIndex,
      'flesch_kincaid_grade': fleschKincaidGrade,
      'automated_readability_index': automatedReadabilityIndex,
      'coleman_liau_index': colemanLiauIndex,
      'gunning_fox_index': gunningFoxIndex,
      'smog_index': smogIndex,
    };
  }

  String toJson() {
    return json.encode(toMap());
  }
}
