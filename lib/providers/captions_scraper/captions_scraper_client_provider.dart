import 'package:dio_api_client/dio_api_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_subtitles_scraper/youtube_subtitles_scraper.dart';

import '../shared/user_agent_provider.dart';

final captionsScraperApiClientProvider =
    FutureProvider<SubtitlesScraperApiClient>(
  (ref) async => ScraperApiClient(
    userAgent:
        await ref.watch(userAgentProvider.future).then((value) => value.device),
  ),
);

@immutable
final class ScraperApiClient extends SubtitlesScraperApiClient {
  ScraperApiClient({required String userAgent})
      : _client = DioApiClient(
          userAgent: userAgent,
          useCache: false,
        );
  final DioApiClient _client;
  @override
  Future<T> fetchUrl<T>(Uri url,
          {void Function(int, int)? onReceiveProgress}) async =>
      (await _client.fetchUri<T>(
        url,
        onReceiveProgress: onReceiveProgress,
      ))!;
}
