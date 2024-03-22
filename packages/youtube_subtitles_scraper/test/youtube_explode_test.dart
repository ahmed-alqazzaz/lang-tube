import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:languages/languages.dart';
import 'package:youtube_subtitles_scraper/src/youtube_explode_manager.dart';
import 'package:youtube_subtitles_scraper/youtube_subtitles_scraper.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> main() async {
  final yt = YoutubeExplodeManager(cacheManager: MockCacheManager());
  final subs = await yt.fetchAllCaptions(youtubeVideoId: '8WQ3LUvVP6g');
  print(subs);
  for (var x in subs.map((e) => e.uri.toString())) {
    print(x);
  }
  return;
}

class MockCacheManager extends CacheManager {
  @override
  Future<void> cacheSourceCaptions(SourceCaptions sourceCaptions) async {}

  @override
  Future<void> cacheCaptions(ScrapedCaptions subtitles) async {}

  @override
  Future<void> clearSources({String? videoId, bool? isAutoGenerated}) async {}

  @override
  Future<void> clearSubtitlesCache() async {}

  @override
  Future<Iterable<SourceCaptions>> retrieveSources(
      {String? videoId,
      String? language,
      bool sortByFirstCacheDate = true}) async {
    return [];
  }

  @override
  Future<Iterable<ScrapedCaptions>> retrieveSubtitles(
      {String? videoId,
      String? language,
      bool sortByFirstCacheDate = true}) async {
    return [];
  }
}

class MockApiClient extends SubtitlesScraperApiClient {
  @override
  Future<T> fetchUrl<T>(Uri url,
          {void Function(int p1, int p2)? onReceiveProgress}) async =>
      (await Dio().getUri<T>(url)).data!;
}
