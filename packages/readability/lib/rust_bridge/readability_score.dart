import 'dart:convert';

import 'api.dart';

class ReadbilityScore {
  final double lixIndex;
  final double rixIndex;
  final double fleschReadingEase;
  final double automatedReadabilityIndex;
  final double colemanLiauIndex;

  const ReadbilityScore({
    required this.lixIndex,
    required this.rixIndex,
    required this.fleschReadingEase,
    required this.automatedReadabilityIndex,
    required this.colemanLiauIndex,
  });

  Future<bool> compareTo({required ReadbilityScore other, dynamic hint}) =>
      rustApi.compareToMethodReadbilityScore(
        that: this,
        other: other,
      );

  @override
  String toString() {
    return 'ReadbilityScore(lixIndex: $lixIndex, rixIndex: $rixIndex, fleschReadingEase: $fleschReadingEase, automatedReadabilityIndex: $automatedReadabilityIndex, colemanLiauIndex: $colemanLiauIndex)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'lixIndex': lixIndex,
      'rixIndex': rixIndex,
      'fleschReadingEase': fleschReadingEase,
      'automatedReadabilityIndex': automatedReadabilityIndex,
      'colemanLiauIndex': colemanLiauIndex,
    };
  }

  String toJson() => json.encode(toMap());

  factory ReadbilityScore.fromMap(Map<String, dynamic> map) {
    return ReadbilityScore(
      lixIndex: map['lixIndex'] as double,
      rixIndex: map['rixIndex'] as double,
      fleschReadingEase: map['fleschReadingEase'] as double,
      automatedReadabilityIndex: map['automatedReadabilityIndex'] as double,
      colemanLiauIndex: map['colemanLiauIndex'] as double,
    );
  }

  factory ReadbilityScore.fromJson(String source) =>
      ReadbilityScore.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant ReadbilityScore other) {
    if (identical(this, other)) return true;

    return other.lixIndex == lixIndex &&
        other.rixIndex == rixIndex &&
        other.fleschReadingEase == fleschReadingEase &&
        other.automatedReadabilityIndex == automatedReadabilityIndex &&
        other.colemanLiauIndex == colemanLiauIndex;
  }

  @override
  int get hashCode {
    return lixIndex.hashCode ^
        rixIndex.hashCode ^
        fleschReadingEase.hashCode ^
        automatedReadabilityIndex.hashCode ^
        colemanLiauIndex.hashCode;
  }
}
