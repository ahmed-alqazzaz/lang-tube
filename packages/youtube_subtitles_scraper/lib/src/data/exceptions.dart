import 'package:flutter/foundation.dart';

@immutable
class SubtitlesScraperException implements Exception {
  const SubtitlesScraperException();
}

class SubtitlesScraperBlockedRequestException
    extends SubtitlesScraperException {
  const SubtitlesScraperBlockedRequestException();
}

class SubtitlesScraperUnknownException extends SubtitlesScraperException {
  const SubtitlesScraperUnknownException();
}

class SubtitlesScraperNetworkException extends SubtitlesScraperException {
  const SubtitlesScraperNetworkException();
}

class SubtitlesScraperNoCaptionsFoundException
    extends SubtitlesScraperException {
  const SubtitlesScraperNoCaptionsFoundException();
}
