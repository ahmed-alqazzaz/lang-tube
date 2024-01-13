import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:subtitles_player/subtitles_player.dart';

void main() {
  // Create a test subtitle list
  const List<Subtitle> testSubtitles = [
    Subtitle(
        start: Duration(seconds: 1),
        end: Duration(seconds: 3),
        text: "Subtitle 1"),
    Subtitle(
        start: Duration(seconds: 5),
        end: Duration(seconds: 6),
        text: "Subtitle 2"),
    Subtitle(
      start: Duration(seconds: 8),
      end: Duration(seconds: 10),
      text: "Subtitle 3",
    ),
  ];
  group('SubtitlePlayer Tests', () {
    test(
        'SubtitlePlayer updates the state correctly based on playback position',
        () {
      // Create a ValueNotifier for the playback position
      final playbackPosition = ValueNotifier<Duration>(Duration.zero);

      // Create the SubtitlePlayer with the test subtitle list and the playback position ValueNotifier
      final subtitlePlayer = SubtitlesPlayer(
        subtitles: testSubtitles,
        playbackPosition: playbackPosition,
      );

      // Set up a listener to track the state changes in the SubtitlePlayer
      final List<Subtitle?> updatedSubtitles = [];
      subtitlePlayer.addListener((subtitle) {
        updatedSubtitles.add(subtitle);
      });

      // Simulate playback positions at different times
      playbackPosition.value = const Duration(seconds: 2);
      playbackPosition.value = const Duration(seconds: 5);
      playbackPosition.value = const Duration(seconds: 8);

      // Make sure the updatedSubtitles list contains the expected subtitles at the respective playback positions
      expect(updatedSubtitles[1],
          testSubtitles[0]); // Playback position: 2 seconds
      expect(updatedSubtitles[2],
          testSubtitles[1]); // Playback position: 5 seconds
      expect(updatedSubtitles[3],
          testSubtitles[2]); // Playback position: 8 seconds

      // Clean up the listener after the test is done
      subtitlePlayer.dispose();
    });

    test(
        'SubtitlePlayer returns null for playback position before the first subtitle',
        () {
      // Create a ValueNotifier for the playback position
      final playbackPosition =
          ValueNotifier<Duration>(const Duration(seconds: 0));

      // Create the SubtitlePlayer with the test subtitle list and the playback position ValueNotifier
      final subtitlePlayer = SubtitlesPlayer(
        subtitles: testSubtitles,
        playbackPosition: playbackPosition,
      );

      // Set up a listener to track the state changes in the SubtitlePlayer
      final List<Subtitle?> updatedSubtitles = [];
      subtitlePlayer.addListener((subtitle) {
        updatedSubtitles.add(subtitle);
      });

      // Simulate playback position before the first subtitle (0 seconds)
      playbackPosition.value = Duration.zero;

      // Make sure the SubtitlePlayer returns null for a playback position before the first subtitle
      expect(updatedSubtitles.length, 1);
      expect(updatedSubtitles[0], null);

      // Clean up the listener after the test is done
      subtitlePlayer.dispose();
    });
  });
}
