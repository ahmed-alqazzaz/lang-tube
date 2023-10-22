import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:youtube_scraper/youtube_scraper.dart';

class YoutubeScraperCookiesStorageManager extends CookiesStorageManager {
  @override
  Future<String?> retrieveCookies() async {
    final file = File(await _cookiesStoargePath);
    if (file.existsSync()) {
      return file.readAsString();
    }
    return null;
  }

  @override
  Future<void> saveCookies({required String cookies}) async =>
      await File(await _cookiesStoargePath).writeAsString(cookies);

  Future<String> get _cookiesStoargePath async =>
      await getApplicationDocumentsDirectory().then(
        (dir) => '${dir.path}/cookies.json',
      );
}
