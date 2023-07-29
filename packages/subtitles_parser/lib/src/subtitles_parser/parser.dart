import '../data/subtitle.dart';
import 'helpers.dart';

List<Subtitle> parseSubtitles(String rawSubtitles) {
  return santitizeDurations(
    rawSubtitles
        .replaceFirst('<?xml version="1.0" encoding="utf-8" ?><transcript>', '')
        .replaceFirst('</transcript>', '')
        .split('</text>')
        .where((line) => line.trim().isNotEmpty)
        .map(convertRawLineToSubtitle)
        .toList(),
  ).toList();
}
