// import 'dart:developer';

// import 'package:dio_api_client/dio_api_client.dart';
// import 'package:flutter/material.dart';
// import 'package:user_agent/user_agent.dart';
// import 'package:youtube_subtitles_scraper/youtube_subtitles_scraper.dart';

// @immutable
// final class ScraperApiClient extends SubtitlesScraperApiClient {
//   ScraperApiClient()
//       : _client = DioApiClient(
//           userAgent: UserAgent.instance.userAgent,
//           useCache: false,
//         );
//   final DioApiClient _client;
//   @override
//   Future<T> fetchUrl<T>(Uri url,
//       {void Function(int, int)? onReceiveProgress}) async {
//     final response = await _client.fetchUri<T>(
//       url,
//       onReceiveProgress: onReceiveProgress,
//     );
//     return response.data!;
//   }
// }
