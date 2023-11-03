import 'package:flutter_test/flutter_test.dart';
import 'package:lang_tube/models/video_recommendations/jsonifiers.dart';
import 'package:collection/collection.dart';
import 'package:lang_tube/video_recommendations.dart/recommendations_manager/storage_manager.dart';

import 'mock_video_recommendations.dart';

// Import the necessary classes and extensions here
// ...

void main() {
  group('VideoRecommendationsListJsonifier', () {
    test('Serialization and Deserialization should maintain order', () async {
      final mockStoargeManager = RecommendationsStorageManager(clicker: (_) {});
      const deepEquality = DeepCollectionEquality();
      await mockStoargeManager.saveRecommendations(
        recommendationsList: videoRecommendationsList,
      );
      final savedRecommendations =
          await mockStoargeManager.retrieveRecommendations();

      // Compare the original stored recommendations
      expect(
        deepEquality.equals(savedRecommendations, videoRecommendationsList),
        isTrue,
      );
    });
  });
}
