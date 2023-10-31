import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:languages/languages.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_subtitles_scraper/src/data/models/source_captions.dart';
import 'package:youtube_subtitles_scraper/youtube_subtitles_scraper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'test_subtitles/kurtzgesagt/video2.dart' as kurzgesagt_video2;

Future<void> main() async {
  final scraper = YoutubeSubtitlesScraper(
    cacheManager: MockCacheManager(),
    apiClient: MockApiClient(),
  );

  var url =
      'https://www.youtube.com/api/timedtext?v=2QcZSVu3CCY&ei=NFI9Zc_rBZSwxgL5gbq4CQ&caps=asr&opi=112496729&xoaf=4&hl=en&ip=0.0.0.0&ipbits=0&expire=1698542756&sparams=ip%2Cipbits%2Cexpire%2Cv%2Cei%2Ccaps%2Copi%2Cxoaf&signature=7808F6C02051065D153899D936946F4F5F19DAD3.0BF667A5E2CE79EDAC6938A9F0B469B3FF3B77CD&key=yt8&kind=asr&lang=en&fmt=srv1'; // replace with your URL

  var url1 =
      "https://www.youtube.com/api/timedtext?v=2QcZSVu3CCY&ei=uPE_ZaeLKP-qxN8PmuSNwA8&caps=asr&opi=112496729&xoaf=4&hl=en&ip=0.0.0.0&ipbits=0&expire=1698714664&sparams=ip%2Cipbits%2Cexpire%2Cv%2Cei%2Ccaps%2Copi%2Cxoaf&signature=07DB3B08095D92971C733D4C667B06A77A0D36A1.9FD35E57B50222785B36AECB234AAFCC52D526F5&key=yt8&kind=asr&lang=en&fmt=srv1";
  print(SourceCaptions(
          uri: Uri.parse(url), videoId: "videoId", isAutoGenerated: true)
      .isExpired);
  print(SourceCaptions(
          uri: Uri.parse(url1), videoId: "videoId", isAutoGenerated: true)
      .isExpired);
// Fetch caption tracks – these are objects containing info like
// base url for the caption track and language code.

  final timer = Stopwatch()..start();
  await Future.wait([
    for (var i = 0; i < 15; i++)
      YoutubeExplode()
          .videos
          .closedCaptions
          .getManifest('2QcZSVu3CCY', formats: [ClosedCaptionFormat.srv1])
  ]);
  print('lasted ${timer.elapsedMilliseconds}');
  final x = await YoutubeExplode()
      .videos
      .closedCaptions
      .getManifest('2QcZSVu3CCY', formats: [ClosedCaptionFormat.srv1]).then(
    (manifest) {
      return manifest.tracks.where(
        (caption) =>
            caption.language.name.toLowerCase().contains(Language.english.name),
      );
    },
  );
  print(x.map((e) => e.url.toString()));
//   print(x.first.autoTranslate(Language.arabic.name).url.toString());
//   final timer = Stopwatch()..start();
//   await YoutubeExplode().videos.closedCaptions.getSubTitles(x.first);
  group('scraping kurzesagt: ${kurzgesagt_video2.topic}', () {
    List<ScrapedSubtitles>? englishSubtitles;
    List<ScrapedSubtitles>? arabicSubtitles;
    setUp(() async {
      englishSubtitles = await scraper.scrapeSubtitles(
        youtubeVideoId: 'uoJwt9l-XhQ',
        language: Language.english,
      );
      arabicSubtitles = await scraper.scrapeSubtitles(
        youtubeVideoId: 'uoJwt9l-XhQ',
        language: Language.english,
        translatedLanguage: Language.arabic,
      );
    });
    test('scrapes english subtitles successfully', () async {
      expect(englishSubtitles, kurzgesagt_video2.englishSubtitles);
    });
    // test('scrapes auto generated arabic subtitles successfully ', () async {
    //   expect(arabicSubtitles?.first.subtitles,
    //       kurzgesagt_video2.arabicSubtitle.subtitles);
    // });
  });
}

class MockCacheManager extends CacheManager {
  @override
  Future<void> cacheSubtitles({
    required String subtitles,
    required String videoId,
    required String language,
    required bool isSubtitlesAutoGenerated,
  }) async {}

  @override
  Future<Iterable<ScrapedSubtitles>?> retrieveSubtitles(
      {required String videoId, required String language}) async {
    return null;
  }

  @override
  Future<void> clearSubtitlesCache() async {}

  @override
  Future<void> cacheSources(
      {required String videoId,
      required List<SourceCaptions> sourceCaptions}) async {}

  @override
  Future<void> clearSourcesById({required String videoId}) async {}

  @override
  Future<Iterable<SourceCaptions>?> retrieveSources(
      {required String videoId}) async {
    return null;
  }

  @override
  Future<Iterable<SourceCaptions>?> retrieveAllSources() async {
    return null;
  }
}

class MockApiClient extends SubtitlesScraperApiClient {
  @override
  Future<T> fetchUrl<T>(Uri url,
          {void Function(int p1, int p2)? onReceiveProgress}) async =>
      (await Dio().getUri<T>(url)).data!;
}
