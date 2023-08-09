import 'package:dio/dio.dart';
import 'package:languages/languages.dart';
import 'package:youtube_subtitles_scraper/youtube_subtitles_scraper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'test_subtitles/kurtzgesagt/video2.dart' as kurzgesagt_video2;

Future<void> main() async {
  final scraper = YoutubeSubtitlesScraper(
    cacheManager: MockCacheManager(),
    apiClient: MockApiClient(),
  );

  group('scraping kurzesagt: ${kurzgesagt_video2.topic}', () {
    List<ScrapedSubtitles>? englishSubtitles;
    List<ScrapedSubtitles>? arabicSubtitles;
    setUp(() async {
      englishSubtitles = await scraper.scrapeSubtitles(
        youtubeVideoId: 'uoJwt9l-XhQ',
        language: Language.english(),
      );
      arabicSubtitles = await scraper.scrapeSubtitles(
        youtubeVideoId: 'uoJwt9l-XhQ',
        language: Language.english(),
        translatedLanguage: Language.arabic(),
      );
    });
    test('scrapes english subtitles successfully', () async {
      expect(englishSubtitles, kurzgesagt_video2.englishSubtitles);
    });
    test('scrapes auto generated arabic subtitles successfully ', () async {
      expect(arabicSubtitles.first, kurzgesagt_video2.arabicSubtitle);
    });
  });
}

class MockCacheManager extends CacheManager {
  @override
  Future<void> cacheSubtitles(
      {required String subtitles,
      required String videoId,
      required String language,
      required bool isSubtitlesAutoGenerated}) async {}
}

class MockApiClient extends SubtitlesScraperApiClient {
  @override
  Future<T> fetchUrl<T>(Uri url) async => (await Dio().getUri<T>(url)).data!;
}
