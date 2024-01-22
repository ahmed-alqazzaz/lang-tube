// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'bridge.dart';

// class ReadabilityScore {
//   final TextMetrics rawMetrics;
//   final double lixIndex;
//   final double rixIndex;
//   final double fleschKincaidGrade;
//   final double automatedReadabilityIndex;
//   final double colemanLiauIndex;
//   final double gunningFoxIndex;
//   final double smogIndex;

//   const ReadabilityScore({
//     required this.rawMetrics,
//     required this.lixIndex,
//     required this.rixIndex,
//     required this.fleschKincaidGrade,
//     required this.automatedReadabilityIndex,
//     required this.colemanLiauIndex,
//     required this.gunningFoxIndex,
//     required this.smogIndex,
//   });

//   bool compareTo({required ReadabilityScore other, dynamic hint}) {
//     final thisScores = toList();
//     final otherScores = other.toList();

//     int count = 0;
//     for (int i = 0; i < thisScores.length; i++) {
//       if (thisScores[i] < otherScores[i]) {
//         count += 1;
//       }
//     }
//     return count > thisScores.length / 2;
//   }

//   List<double> toList() => [
//         lixIndex,
//         rixIndex,
//         fleschKincaidGrade,
//         automatedReadabilityIndex,
//         colemanLiauIndex,
//         gunningFoxIndex,
//         smogIndex,
//       ];

//   @override
//   String toString() {
//     return 'ReadabilityScore(rawMetrics: $rawMetrics, lixIndex: $lixIndex, rixIndex: $rixIndex, fleschKincaidGrade: $fleschKincaidGrade, automatedReadabilityIndex: $automatedReadabilityIndex, colemanLiauIndex: $colemanLiauIndex, gunningFoxIndex: $gunningFoxIndex, smogIndex: $smogIndex)';
//   }

//   @override
//   bool operator ==(covariant ReadabilityScore other) {
//     if (identical(this, other)) return true;

//     return other.rawMetrics == rawMetrics &&
//         other.lixIndex == lixIndex &&
//         other.rixIndex == rixIndex &&
//         other.fleschKincaidGrade == fleschKincaidGrade &&
//         other.automatedReadabilityIndex == automatedReadabilityIndex &&
//         other.colemanLiauIndex == colemanLiauIndex &&
//         other.gunningFoxIndex == gunningFoxIndex &&
//         other.smogIndex == smogIndex;
//   }

//   @override
//   int get hashCode {
//     return rawMetrics.hashCode ^
//         lixIndex.hashCode ^
//         rixIndex.hashCode ^
//         fleschKincaidGrade.hashCode ^
//         automatedReadabilityIndex.hashCode ^
//         colemanLiauIndex.hashCode ^
//         gunningFoxIndex.hashCode ^
//         smogIndex.hashCode;
//   }
// }
