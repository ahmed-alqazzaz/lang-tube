import 'dart:convert';


class ReadabilityScore {
  final double lixIndex;
  final double rixIndex;
  final double fleschReadingEase;
  final double automatedReadabilityIndex;
  final double colemanLiauIndex;

  const ReadabilityScore({
    required this.lixIndex,
    required this.rixIndex,
    required this.fleschReadingEase,
    required this.automatedReadabilityIndex,
    required this.colemanLiauIndex,
  });

  bool compareTo({required ReadabilityScore other, dynamic hint}) {
    final thisScores = _toList();
    final otherScores = other._toList();

    int count = 0;
    for (int i = 0; i < thisScores.length; i++) {
      if (thisScores[i] < otherScores[i]) {
        count += 1;
      }
    }
    return count > thisScores.length / 2;
  }

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
  List<double> _toList() => [
        lixIndex,
        rixIndex,
        fleschReadingEase,
        automatedReadabilityIndex,
        colemanLiauIndex
      ];

  factory ReadabilityScore.fromMap(Map<String, dynamic> map) {
    return ReadabilityScore(
      lixIndex: map['lixIndex'] as double,
      rixIndex: map['rixIndex'] as double,
      fleschReadingEase: map['fleschReadingEase'] as double,
      automatedReadabilityIndex: map['automatedReadabilityIndex'] as double,
      colemanLiauIndex: map['colemanLiauIndex'] as double,
    );
  }

  factory ReadabilityScore.fromJson(String source) =>
      ReadabilityScore.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant ReadabilityScore other) {
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
