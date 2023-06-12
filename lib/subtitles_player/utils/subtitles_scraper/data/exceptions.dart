import 'package:flutter/material.dart';

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

class SubtitlesScraperNoCaptionsFoundExceptions
    extends SubtitlesScraperException {
  const SubtitlesScraperNoCaptionsFoundExceptions();
}
