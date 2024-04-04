import 'dart:io';

import 'package:colourful_print/colourful_print.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lang_tube/models/miscellaneous/lang_config.dart';
import 'package:lang_tube/providers/captions_cache/captions_cache_dir_provider.dart';
import 'package:lang_tube/providers/shared/language_config_provider.dart';
import 'package:lang_tube/providers/captions_scraper/captions_scraper_provider.dart';
import 'package:lang_tube/providers/user_agent_provider.dart';
import 'package:user_agent/user_agent.dart';
import 'package:youtube_subtitles_scraper/youtube_subtitles_scraper.dart';

void main() {
  test('captionsScraperProvider test', () async {
    WidgetsFlutterBinding.ensureInitialized();
    final container = ProviderContainer(overrides: [
      userAgentProvider
          .overrideWith((ref) => const UserAgent.withRandomAgents()),
      languageConfigProvider.overrideWith(() => MockLanguageConfigProvider()),
      captionsCacheDirProvider
          .overrideWith((ref) => '${Directory.current.path}/.db_cache/')
    ]);
    final langConfigProvider = container.read(languageConfigProvider.notifier);
    await langConfigProvider.build();
    langConfigProvider.setTargetLanguage(Language.german);
    langConfigProvider.setTranslationLanguage(Language.english);
    final captionsScraper =
        await container.read(captionsScraperProvider.future);
    final bundle = await captionsScraper.fetchSubtitlesBundle(
        youtubeVideoId: 'XbAe95Bn5z0');
    printRed(bundle.first.translatedSubtitles.subtitles.toString());
    // Perform your tests on captionsScraperProvider
    // For example, if captionsScraperProvider has a method called `scrape`, you could do:
    // final result = await captionsScraperProvider.scrape('some_video_id');
    // expect(result, isNotNull); // or any other assertions based on your expectations

    container.dispose();
  });
}

class MockLanguageConfigProvider extends LanguageConfigNotifier {
  @override
  Future<LanguageConfig> build() async {
    return const LanguageConfig(
      targetLanguage: null,
      translationLanguage: null,
    );
  }
}
