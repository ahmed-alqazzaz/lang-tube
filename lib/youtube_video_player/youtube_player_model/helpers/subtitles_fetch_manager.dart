import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../subtitles_player/providers/subtitles_fetch_provider.dart';
import '../../../subtitles_player/utils/subtitles_scraper/data/data_classes.dart';
import '../../../subtitles_player/utils/subtitles_scraper/subtitles_scraper.dart';

@immutable
class YoutubePlayerSubtitlesFetchManager {
  factory YoutubePlayerSubtitlesFetchManager({
    required AutoDisposeChangeNotifierProviderRef ref,
    required String mainLanguage,
    required String translatedLanguage,
    required String videoId,
    required void Function(SubtitlesBundle) onFetched,
  }) {
    final subtitlesFetchProvider = subtitlesFetchProviderFamily((
      videoId: videoId,
      mainLanguage: mainLanguage,
      translatedLanguage: translatedLanguage,
    ));
    return YoutubePlayerSubtitlesFetchManager._(
      ref.listen(subtitlesFetchProvider, (_, model) {
        model.when(
          data: (data) => onFetched(data),
          error: (error, stackTrace) {
            if (error is SubtitlesScraperException) {
              _subtitlesScraperExceptionHandler(error);
            } else {
              log(error.toString());
              throw error;
            }
          },
          loading: () {
            log('loading');
          },
        );
      }, fireImmediately: true),
    );
  }
  const YoutubePlayerSubtitlesFetchManager._(this._providerSubcription);
  final ProviderSubscription<AsyncValue<SubtitlesBundle>> _providerSubcription;

  static void _subtitlesScraperExceptionHandler(
      SubtitlesScraperException exception) {
    if (exception is SubtitlesScraperNoCaptionsFoundExceptions) {
    } else if (exception is SubtitlesScraperBlockedRequestException) {
    } else if (exception is SubtitlesScraperNetworkException) {}
  }

  void dispose() {
    _providerSubcription.close();
    subtitlesFetchProviderKeepAliveLink?.close();
  }
}
