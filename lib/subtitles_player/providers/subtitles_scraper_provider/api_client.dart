import 'dart:developer';

import 'package:dio_api_client/dio_api_client.dart';
import 'package:flutter/material.dart';
import 'package:user_agent/user_agent.dart';
import 'package:youtube_subtitles_scraper/youtube_subtitles_scraper.dart';
import 'data/exceptions.dart';

@immutable
final class ScraperApiClient extends SubtitlesScraperApiClient {
  ScraperApiClient()
      : _client = DioApiClient(
          userAgent: UserAgentManager().userAgent,
          useCache: false,
        );
  final DioApiClient _client;
  @override
  Future<T> fetchUrl<T>(Uri url) async {
    try {
      final response = await _client.fetchUri<T>(
        url,
        onReceiveProgress: (p0, p1) {
          log('$p0, $p1');
        },
      );
      if (response.statusCode != 200) {
        throw const SubtitlesScraperBlockedRequestException();
      }
      return response.data!;
    } on DioException catch (e) {
      if (e.error == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const SubtitlesScraperNetworkException();
      } else if (e.error == DioExceptionType.badResponse) {
        throw const SubtitlesScraperBlockedRequestException();
      } else {
        throw const SubtitlesScraperUnknownException();
      }
    }
  }
}
