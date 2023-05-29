import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lang_tube/youtube_video_player/utils/subtitles_player/utils/subtitles_scraper/data/exceptions.dart';
import 'package:path_provider/path_provider.dart';

@immutable
class SubtitlesCacheManager {
  const SubtitlesCacheManager._(this._cacheDirectory);
  final Directory _cacheDirectory;

  static Future<SubtitlesCacheManager> open() async =>
      SubtitlesCacheManager._(await getTemporaryDirectory());

  Future<void> cacheSubtitles(
      {required String subtitlesString, required String fileName}) async {
    final file = File('${_cacheDirectory.path}$fileName.txt');
    if (file.existsSync()) {
      throw SubtitlesFileIsAlreadyCache();
    }
    await file.writeAsString(subtitlesString);
  }

  Future<String?> retrieveSubtitlesIfExists(String fileName) async {
    final file = File('${_cacheDirectory.path}$fileName.txt');
    if (file.existsSync()) {
      return await file.readAsString();
    }
    return null;
  }
}
