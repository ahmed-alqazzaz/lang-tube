import 'dart:io';

import 'package:lang_tube/video_recommendations.dart/data/jsonifiers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_scraper/youtube_scraper.dart';

import '../../data/video_recommendations.dart';

class RecommendationsStorageManager {
  RecommendationsStorageManager({required this.clicker});
  final VideoClicker clicker;

  Future<void> saveRecommendations({
    required List<VideoRecommendations> recommendationsList,
  }) async =>
      await File(await _recommendationsStoragePath).writeAsString(
        recommendationsList.toJson(),
      );

  Future<Iterable<VideoRecommendations>> retrieveRecommendations() async {
    final recommendationsFile = File(await _recommendationsStoragePath);
    return recommendationsFile.existsSync()
        ? VideoRecommendationsListJsonifier.fromJson(
            source: recommendationsFile.readAsStringSync(),
            clicker: clicker,
          )
        : const Iterable.empty();
  }

  Future<String> get _recommendationsStoragePath async =>
      await getApplicationDocumentsDirectory().then(
        (dir) => '${dir.path}/recommendations.json',
      );
}
